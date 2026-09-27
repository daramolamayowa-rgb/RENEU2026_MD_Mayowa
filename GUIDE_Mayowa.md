# RENEU 2026 - step-by-step simulation guide for Mayowa

Achinivu Lab (MoDSE), University of Illinois Chicago
Molecular dynamics of protic ionic liquids for critical-element recovery
Mentor: Alex Acquah

---

## 0. Read this page before you touch a terminal

You are going to run molecular dynamics simulations of 7 ionic liquids and
measure, for each one, how the ions arrange themselves around each other. That
arrangement is the thing the whole project is about: it is the "PIL-MOF moiety"
in the research plan, the templated first shell of oxygen and nitrogen donors
that a metal ion would sit in.

Your seven systems are not seven random ionic liquids. They are the cation series.
The question your half of the project answers is:

> How does the structure of the CATION control the first coordination shell, when the anion family is held fixed?

Because of that, the order you run them in matters less than the fact that you
run **all seven the same way**. If you change the box size for one system and
not the others, you cannot compare them, and the comparison is the result.

Three comparisons are built into your set:

1. chain length at fixed anion: M2 (propyl) -> M1 (butyl) -> M3 (hexyl), all octanoate
2. number of hydroxyl groups: M6/M1 (none) -> M4 (one) -> M5 (two), all acetate
3. loss of the acidic N-H: M1 and M4 (three N-H) -> M6 (one N-H) -> M7 (none, choline)

M1/R1 and M2/R2 share a cation, and M4/R4 share a cation. Those three pairs are how the two of you separate a cation effect from an anion effect at the end of the summer.

**One rule above all others.** Every number you put on a slide must be traceable
to a file on your disk. This bundle writes a CSV next to every figure for exactly
that reason. If you cannot point at the file a number came from, do not present
the number. That is Section 5.2 of the research plan and it is not negotiable.

---

## 1. Check your machine (5 minutes, do this once)

Open your Ubuntu (WSL2) terminal, go to your folder, and run:

```bash
cd ~/RENEU2026_MD_Mayowa
bash scripts/check_setup.sh
```

You will get a list with OK or MISSING next to each item. Fix every MISSING using
the command printed next to it, then run the check again. Do not go on to
section 2 until everything says OK.

If `fftool` says MISSING, this is the command that installs it:

```bash
git clone https://github.com/paduagroup/fftool ~/pilmd_tools/fftool
```

---

## 2. What is in your folder

```
RENEU2026_MD_Mayowa/
  scripts/        the programs you run. You do not edit anything in here.
  molecules/      one .zmat file per ion, with the atom types already assigned
  forcefield/     reneu.ff (the ionic liquids), spce.ff (water), nd.ff (the ion)
  systems/        one folder per system, each with a system.cfg
  results/        empty. Put your figures and slides here.
  GUIDE_Mayowa.md      this file
  reference/          force field notes, ion parameters, troubleshooting, example output
  MY_SYSTEMS.md           your seven systems and what each one is for
```

Each system folder starts with just a `system.cfg` file. Everything else appears
when you run a stage. A finished system looks like this:

```
systems/M1_butylammonium_octanoate/
  system.cfg
  stage1_pure_IL/
    fftool_charges.txt     proof the box was neutral before it ran
    simbox.xyz             the packed starting box
    data.lmp  in.lmp       what LAMMPS actually read
    log.lammps             the full run log
    density.dat            density against time
    dump.lammpstrj         the trajectory (big file)
    analysis/
      summary.md                  <- read this first
      coordination_numbers.csv
      rdf_*.csv                   <- the numbers behind each figure
      fig_rdf_*.png               <- the figures
```

---

## 3. Your first run: the ten-minute pipeline test

Do this on **one** system before you do anything else. It proves the whole chain
works on your laptop.

```bash
cd ~/RENEU2026_MD_Mayowa
bash scripts/run_stage1.sh M1_butylammonium_octanoate --quick
```

`--quick` runs a very short simulation, about ten minutes in total. It is a
**pipeline test, not a result.** You may not put anything from a `--quick` run on
a slide. Its only job is to prove nothing is broken.

While it runs you will see six steps. Here is what each one is doing and what
"working" looks like.

**[1/6] box size.** The script works out how big the cubic box has to be. It
computes this from a mass density in g/cm3, the kind of density you can look up,
and it deliberately starts the box **expanded** (0.60 g/cm3) so that packing is
easy and fast. The NPT part of the simulation then squeezes it down to whatever
density the force field actually wants. Watch for a line like
`cubic box = 32.10 A`.

**[2/6] fftool and the charge check.** This is the step that used to break the
project. Each ion must carry an exact whole-number charge, and the whole box must
add up to zero, or LAMMPS cannot compute long-range electrostatics and every
force in the run is wrong. The script prints each species and then stops the
whole pipeline if the total is not zero:

```
       55 x butylammonium        +1.0000 e   ok
       55 x octanoate            -1.0000 e   ok
    net charge of the whole box = +0.0000 e
    OK, the box is neutral.
```

If you ever see a value like `-0.9400` or a total that is not zero, stop and
message Alex. Do not try to run it anyway.

**[3/6] packmol.** Places the ions in the box without overlaps. This takes a few
minutes and prints nothing useful while it works. It has not crashed. If packmol
cannot meet its tolerance, the script automatically retries once with a box ten
per cent larger.

**[4/6] fftool --lmp.** Writes the two files LAMMPS reads: `data.lmp` (every atom,
bond, angle and charge) and `in.lmp` (the instructions). The script then rewrites
`in.lmp` into the four-part protocol below.

**[5/6] LAMMPS.** The simulation itself, in four parts:

| part | what it does | why |
|---|---|---|
| minimise | removes bad contacts left by packing | stops the run exploding on step 1 |
| NVT | warms the system at fixed volume | lets molecules relax before the barostat acts |
| NPT equilibration | fixed pressure, box free to change | **this is where the density finds its own value** |
| NPT production | same, but recording the trajectory | this is the part you analyse |

Watch the `Density` column in the output. It should start near 0.60 and climb.

**[6/6] analysis.** Runs `analyze.py` and prints a summary.

---

## 4. Is my result any good? Four checks, in order

Open `systems/M1_butylammonium_octanoate/stage1_pure_IL/analysis/summary.md`.

**Check 1: density.** A protic ionic liquid at 300 K should settle somewhere
around 0.9 to 1.1 g/cm3. Below 0.5 g/cm3 means the box never condensed and
nothing else in the file means anything. In a `--quick` run the density will
still be climbing and will read low; that is expected, and it is one of the
reasons a quick run is not a result.

**Check 2: the N-H...O peak.** For any cation with an acidic N-H, the first peak
of the N-H...O(carboxylate) g(r) should sit near 1.6 to 2.2 A. That peak is the
hydrogen bond that holds the ion pair together. `analyze.py` checks this for you
and writes "as expected" or "OUTSIDE expected" in the last column.

**Check 3: the coordination number.** The first-shell coordination number is the
average number of partner atoms inside the first minimum of g(r). For a single
N-H donor this should come out near 1: one hydrogen, one oxygen. Numbers like 20
mean the first minimum was not found properly; tell Alex and send the CSV.

**Check 4: does it look like a liquid?** Open `simbox.xyz` and the trajectory in
OVITO or VMD and look at it. A liquid looks disordered and uniformly filled. A
box with a hole in it, or one lump in a corner, is not a liquid.

A word about "OUTSIDE expected": it is not automatically a failure. In system M7
the cation is choline, which has no N-H at all, so its nitrogen genuinely sits
further from the anion. The flag means **explain it**, not **hide it**.

---

## 5. The real run

Once the quick test has passed on one system, run the same system properly, this
time without `--quick`:

```bash
bash scripts/run_stage1.sh M1_butylammonium_octanoate
```

This runs 320 ps in total and will take somewhere between forty minutes and three
hours depending on your laptop. You can leave it. When it finishes, repeat checks
1 to 4. Then work through your other six systems the same way:

```bash
bash scripts/run_stage1.sh <the next system folder name>
```

`ls systems` prints the exact folder names.

Keep a plain text file as you go with one line per system: the final density, the
N-H...O peak position, and the coordination number. That table is your first
result and it is what your second cohort presentation is built on.

---

## 6. Stage 2: add water

Solvent extraction happens with water present, so Stage 2 puts explicit SPC/E
water into the same box.

```bash
bash scripts/run_stage2.sh M1_butylammonium_octanoate
```

The interesting comparison is between Stage 1 and Stage 2 for the same system.
In the test run of M1, adding water pulled the N-H...O first-shell coordination
number down from 0.99 to 0.53, and water oxygen appeared 2.68 A from the
carboxylate. In words: water competes with the cation for the anion's oxygens.
That sentence, backed by your two numbers, is a result.

---

## 7. Stage 3: add the metal ion (stretch goal, ask before you start)

Stage 3 is marked a stretch goal in the research plan and it stays one. It runs in
two parts and the script does both:

- **3a** puts Nd(III) in water with only enough anions to balance its charge. This
  is not a result, it is a **test of the ion parameters**. The Nd-O(water) first
  peak must come out near 2.4 to 2.5 A with a coordination number near 8 to 9. In
  the test build it gave 2.48 A and 9.0, which passes.
- **3b** adds your ionic liquid to that box and asks whether the anion can get
  into the ion's first shell.

```bash
bash scripts/run_stage3.sh M1_butylammonium_octanoate
```

Two honest warnings, both of which belong on your slide if you present this:

1. The Nd(III) Lennard-Jones parameters are literature values, not CL&P values,
   and CL&P mixes them by a different rule than the one they were fitted with.
   Read `reference/ION_PARAMETERS.md` before you present anything from Stage 3.
2. There is **one** ion in the box. One ion gives you no error bar. Say
   "preliminary" and mean it.

---

## 8. What goes in your presentations

The research plan asks for three cohort presentations and one final presentation.
Here is what this bundle gives you for each.

| Presentation | What you can show |
|---|---|
| First (Part A + Stage 1 pipeline test) | your seven-system table from MY_SYSTEMS.md, the charge-check output, and one worked g(r) |
| Second (Stage 1 and 2 results) | density per system, N-H...O peak and coordination number across your series, the Stage 1 vs Stage 2 water comparison |
| Third | the trend across your three built-in comparisons, with the figures from `analysis/` |
| Final | your series plus the joint comparison with Rosemary |

Figures come out of `analysis/` as PNG at 150 dpi. Every figure has a CSV beside
it with the same numbers, so if someone asks "where did that peak come from" you
can open the file in front of them.

---

## 9. Things that will go wrong, and what they mean

Full list with fixes is in `reference/TROUBLESHOOTING.md`. The three most likely:

- **"command not found: fftool"** - run `bash scripts/check_setup.sh`.
- **The charge check stops the run.** Good. That is the script doing its job. Send
  Alex the `fftool_charges.txt` file; do not edit the .zmat files yourself.
- **LAMMPS stops with "Out of range atoms" or the energy becomes `nan`.** Almost
  always the box was too dense or the minimisation was skipped. Delete the stage
  folder and run the script again from the start rather than restarting halfway.

---

## 10. Where to ask

Send Alex: what you typed, the last twenty lines of what came back, and the name
of the system folder. Those three things are enough to diagnose almost anything.
A screenshot of an error is fine; a screenshot of a full terminal is better than
a description of it.
