# Troubleshooting, by what you actually see on the screen

Achinivu Lab, RENEU 2026. Find your symptom in the left column. If it is not
here, send Alex three things: what you typed, the last twenty lines of output,
and the name of the system folder.

---

## A. Before the simulation starts

**`bash: fftool: command not found`**
The pipeline cannot find fftool. Run `bash scripts/check_setup.sh`. If it says
MISSING, install it with:
```bash
git clone https://github.com/paduagroup/fftool ~/pilmd_tools/fftool
```
The run scripts look on your PATH first, then in `~/pilmd_tools/fftool`, then in
`~/fftool`. You do not need to edit anything if you clone it to one of those.

**`fftool: error: unrecognized arguments: -b`**
You are following an old guide. fftool removed its single-letter flags in January
2026. Use `--box`, `--rho`, `--tol`, `--lmp`. The scripts in this bundle already
do.

**`atom type XXXX in something.zmat is not in any force field that was loaded`**
The last line of that .zmat names the force-field file it needs, and that file was
not found next to it. In a system folder every stage script copies the right .ff
files in for you, so this normally means you ran fftool by hand in the wrong
directory. Change into the stage folder first.

**`ERROR: no system folder called ... in .../systems`**
You mistyped the folder name. Run `ls systems` and copy the name exactly.

---

## B. The charge check stops the run

```
    net charge of the whole box = -0.0600 e
    STOP. The box is not neutral ...
```

**This is the script working, not failing.** A box that is not neutral cannot use
PPPM, and if you force it through, every electrostatic force in the run is wrong,
including all the numbers you would then present.

What to look at, in order:

1. Does each species line show exactly `+1.0000` or `-1.0000`? If one shows
   something like `-0.9400`, that ion did not close its charge. Tell Alex. Do not
   edit the .zmat or the .ff yourself.
2. Are the numbers of cations and anions equal? In Stage 1 and 2 they must be. In
   Stage 3b there are three extra anions to balance the 3+ ion; the script does
   this for you, so if that count looks wrong you changed `NPAIR` by hand.
3. Did you edit `system.cfg`? Only `NPAIR` and `NWATER` are meant to be changed,
   and changing them changes what you can compare against.

The historical version of this problem is worth knowing about, because it cost
this project two weeks. Octanoate was originally typed with `CTA` on its alpha
carbon. `CTA` is CL&P's type for the methyl carbon of **acetate**, which carries
three hydrogens. Octanoate's alpha carbon is a CH2 with two. The missing hydrogen
accounts for exactly 0.06 e, which is why the box came out at -0.06. In this
bundle the alpha carbon of every longer-chain carboxylate is `C2C`, which is the
correct type, and octanoate closes at exactly -1.0000.

---

## C. Packmol

**It has printed nothing for four minutes.**
Normal. Packmol is silent while it works. Give it up to about ten minutes for the
larger systems.

**`packmol could not meet the tolerance at this box size; retrying 10% larger`**
Normal and automatic. The script grows the box and tries again.

**`STOP. Packmol produced no simbox.xyz`**
Something is wrong with `pack.inp`, which fftool wrote. Check `packmol.log`. The
usual cause is a molecule file that fftool could not read.

**`NOTE: packmol returned its best solution rather than a clean success.`**
Usually fine, because the next step is an energy minimisation that removes the
remaining close contacts. Watch the density: if it settles sensibly, carry on.

---

## D. LAMMPS

**`ERROR: Out of range atoms - cannot compute PPPM`**
Atoms moved further in one step than the code expects, which means the system
blew up. Almost always one of three things:

1. the minimisation did not run. Check that `in.lmp` contains an uncommented
   `minimize` line. The script uncomments it for you, so if it is commented you
   are running an `in.lmp` that fftool wrote and the script never touched;
2. the box was packed too dense. Delete the stage folder and run the script again
   from the beginning, rather than restarting halfway;
3. the box is not neutral, which you would have caught in section B.

**Energy or temperature prints as `nan`**
Same causes as above. Delete the stage folder and start that stage again.

**`ERROR: Bond atoms missing`**
A molecule was torn apart, which follows from the same three causes.

**It is running but very slowly.**
Check `bash scripts/check_setup.sh` for whether `mpirun` was found. Without it
LAMMPS uses one core. These systems have roughly 1600 to 3000 atoms; on one core
expect a few hours for a full 320 ps run, on four cores well under an hour.

**The density is still climbing when the run ends.**
Expected in a `--quick` run, which is why a quick run is not a result. In a full
run, look at `density.dat`: the value should be flat over the last third. If it is
still rising, the equilibration was too short and you should say so rather than
quoting the number as an equilibrium density.

---

## E. analyze.py

**`ERROR: dump.lammpstrj not found`**
The simulation did not reach the production stage. Read the end of `log.lammps`.

**`could not convert string to float`**
Your dump file has a column the reader did not expect. Send Alex the first
fifteen lines of `dump.lammpstrj`.

**A coordination number comes out as something absurd, like 25.**
The first minimum of g(r) was not located properly, usually because the peak is
poorly resolved in a short run. Open the matching `rdf_*.csv`, plot column 2
against column 1 yourself, and read the first minimum off by eye. Report the
hand-read value and say that is what you did.

**A row says "OUTSIDE expected".**
It means explain it, not hide it. Sometimes it is real chemistry: choline (M7) has
no acidic N-H, so its nitrogen genuinely sits further from the anion than a
primary ammonium's does, and the script is comparing against a window that assumes
an N-H. Sometimes it is a short run. Deciding which is your job, and the reasoning
is exactly what the third presentation is for.

**The metal-carboxylate peak in Stage 3 is at 7 A with a coordination number near
zero.**
The anion has not entered the ion's first shell during the simulation. In a short
run this usually means the run was too short, not that the anion does not
coordinate. Do not present it as evidence of non-coordination.

---

## F. Things that look like problems but are not

- **Packmol silent for minutes.** Normal.
- **Density starting near 0.6 g/cm3.** Deliberate. The box is packed expanded on
  purpose so packing is fast and free of overlaps, and NPT compresses it.
- **`Generated N of N mixed pair_coeff terms from geometric mixing rule`.** Normal
  LAMMPS output. CL&P uses geometric mixing, which is what fftool sets.
- **Warnings about `special_bonds`.** Normal for these molecules.
- **The first frames of the trajectory looking strange.** `analyze.py` discards the
  first 20 per cent of frames by default for exactly that reason.
