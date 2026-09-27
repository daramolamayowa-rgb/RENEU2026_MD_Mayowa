#!/usr/bin/env python3
"""
prep_lmp.py - rewrite the in.lmp that fftool produced into a full, staged
simulation protocol.

fftool writes a skeleton with the minimisation commented out and a single short
run. This script keeps everything fftool generated above the run section (pair
coefficients, SHAKE, kspace) untouched and replaces the tail with:

    minimise -> NVT relaxation -> NPT equilibration -> NPT production + trajectory

Usage:
    python3 prep_lmp.py in.lmp [--quick] [--temp 300] [--label stage1]
"""
import sys, re, argparse

ap = argparse.ArgumentParser()
ap.add_argument("infile")
ap.add_argument("--quick", action="store_true",
                help="very short run to test the pipeline (not a result)")
ap.add_argument("--temp", type=float, default=300.0)
ap.add_argument("--press", type=float, default=1.0)
ap.add_argument("--label", default="run")
ap.add_argument("--cutoff", type=float, default=10.0,
                help="real-space cutoff in A. Must stay well below the smallest "
                     "processor sub-domain the NPT box will ever reach.")
a = ap.parse_args()

if a.quick:
    NVT, EQ, PROD, DUMPEV, THERMO = 2000, 3000, 5000, 250, 500
else:
    NVT, EQ, PROD, DUMPEV, THERMO = 20000, 100000, 200000, 500, 1000
RESTART = max(1000, (EQ + PROD) // 12)

txt = open(a.infile).read()
lines = txt.splitlines()

# keep everything fftool wrote up to (and including) the neighbor/SHAKE block
keep, dumpmod = [], None
oldcut = None
for ln in lines:
    # 1. shrink the real-space cutoff. fftool defaults to 12 A, which leaves the
    #    ghost region (cutoff + skin = 14 A) almost equal to a processor
    #    sub-domain once NPT has compressed a ~29 A box under 2 MPI ranks. That
    #    is what produces "Out of range atoms - cannot compute PPPM" partway
    #    through an otherwise healthy run. PPPM makes up the accuracy in k-space.
    if ln.startswith("pair_style"):
        nums = re.findall(r"\d+\.\d+", ln)
        if nums:
            oldcut = nums[0]
            ln = re.sub(r"\d+\.\d+", f"{a.cutoff:.1f}", ln)
    # 2. state the re-neighbouring criteria explicitly instead of relying on
    #    whatever the installed LAMMPS defaults to.
    if ln.lstrip("# ").startswith("neigh_modify"):
        ln = "neigh_modify delay 0 every 1 check yes"
    if ln.startswith("dump_modify"):
        dumpmod = ln
    if ln.startswith(("timestep", "variable TK", "variable PBAR", "velocity",
                      "fix TPSTAT", "thermo", "dump ", "dump_modify", "run ",
                      "write_data", "# restart", "restart ", "# uncomment",
                      "#variable", "#run", "#print", "#change_box", "#unfix",
                      "#fix TSTAT")):
        continue
    keep.append(ln)
while keep and not keep[-1].strip():
    keep.pop()

if dumpmod is None:
    sys.exit("ERROR: no dump_modify line found in " + a.infile +
             " - was this file written by fftool?")

protocol = f"""
# ---------------------------------------------------------------------------
# RENEU 2026 simulation protocol ({a.label}{', QUICK PIPELINE TEST' if a.quick else ''})
# 1 minimise  2 NVT relaxation  3 NPT equilibration  4 NPT production
# ---------------------------------------------------------------------------
timestep 1.0

variable TK      equal {a.temp}
variable PBAR    equal {a.press}
variable NVTRUN  equal {NVT}
variable EQRUN   equal {EQ}
variable PRODRUN equal {PROD}

variable dens equal density
variable vol  equal vol

thermo {THERMO}
thermo_style custom step temp press vol v_dens pe etotal

# --- 1. energy minimisation ------------------------------------------------
print "RENEU >>> stage 1 of 4: energy minimisation"
minimize 1.0e-4 1.0e-6 10000 100000
reset_timestep 0

# --- 2. NVT relaxation (lets the packed box relax before the barostat) ------
print "RENEU >>> stage 2 of 4: NVT relaxation"
velocity all create ${{TK}} 12345 mom yes rot yes dist gaussian
fix NVTRELAX all nvt temp ${{TK}} ${{TK}} 100
run ${{NVTRUN}}
unfix NVTRELAX

# --- 3. NPT equilibration (this is where the density finds its own value) ---
# restart files are written every {RESTART} steps. If the run stops for any
# reason you can pick up from the last one instead of starting over:
#     read_restart rst_a.lmp      (or rst_b.lmp, whichever is newer)
print "RENEU >>> stage 3 of 4: NPT equilibration - watch the density column"
restart {RESTART} rst_a.lmp rst_b.lmp
fix NPTEQ all npt temp ${{TK}} ${{TK}} 100 iso ${{PBAR}} ${{PBAR}} 1000
run ${{EQRUN}}
unfix NPTEQ
write_data data.after_equilibration.lmp

# --- 4. NPT production - this is the trajectory you analyse ----------------
print "RENEU >>> stage 4 of 4: NPT production"
reset_timestep 0
fix NPTPROD all npt temp ${{TK}} ${{TK}} 100 iso ${{PBAR}} ${{PBAR}} 1000
fix DENSAVG all ave/time 10 100 1000 v_dens v_vol file density.dat

dump TRAJ all custom {DUMPEV} dump.lammpstrj id mol type element q xu yu zu
{dumpmod}

run ${{PRODRUN}}

write_data data.final.lmp
print "RENEU >>> finished. trajectory = dump.lammpstrj, density log = density.dat"
"""

open(a.infile, "w").write("\n".join(keep) + "\n" + protocol)
ps = (NVT + EQ + PROD) / 1000.0
print(f"  in.lmp rewritten: minimise + {NVT/1000:.0f} ps NVT + {EQ/1000:.0f} ps NPT eq "
      f"+ {PROD/1000:.0f} ps NPT production ({ps:.0f} ps total, "
      f"{PROD//DUMPEV} trajectory frames)")
if oldcut and float(oldcut) != a.cutoff:
    print(f"  real-space cutoff set to {a.cutoff:.1f} A (fftool wrote {oldcut}), "
          f"restart files every {RESTART} steps")
