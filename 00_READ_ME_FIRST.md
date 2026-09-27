# RENEU 2026 - molecular dynamics project for Mayowa

Achinivu Lab (MoDSE), Department of Chemical Engineering, University of Illinois
Chicago. Prepared by Alex Acquah.

This folder is yours alone. It contains everything you need: the scripts, the
force field, the molecule files, your seven systems, and the reference documents.
Nothing in it depends on Rosemary's copy, and nothing you do here can affect
Rosemary's work.

---

## Start here

1. Unpack this folder into your home directory so that it sits at
   `~/RENEU2026_MD_Mayowa`.
2. Open **`GUIDE_Mayowa.md`** and read section 0 before you type anything.
3. Then run:

```bash
cd ~/RENEU2026_MD_Mayowa
bash scripts/check_setup.sh
```

That check tells you, in one screen, whether your machine can run the project and
prints the exact install command next to anything that is missing.

---

## What is in here

```
RENEU2026_MD_Mayowa/
  GUIDE_Mayowa.md    step-by-step instructions, written to be read in order
  MY_SYSTEMS.md         your seven systems, what each targets, why it is in your set
  scripts/              the programs you run. You do not edit anything in here
  molecules/            one .zmat per ion, atom types already assigned and verified
  forcefield/           reneu.ff (ionic liquids), spce.ff (water), nd.ff (the metal ion)
  systems/              one folder per system, each holding a system.cfg
  results/              empty. Put your figures, tables and slides here
  reference/            documents you will need when you start writing slides
    FORCE_FIELD_NOTES.md   what is standard CL&P and what was added, with derivations
    ION_PARAMETERS.md      the Nd(III) parameters and the validation they require
    TROUBLESHOOTING.md     organised by the error message you actually see
    example_output/        a finished analysis folder, so you know what to expect
```

---

## The three commands

Everything runs through three scripts. Each takes the name of one of your system
folders, which you can list with `ls systems`.

```bash
bash scripts/run_stage1.sh M1_butylammonium_octanoate --quick   # 10 minute pipeline test
bash scripts/run_stage1.sh M1_butylammonium_octanoate           # the real run: pure ionic liquid
bash scripts/run_stage2.sh M1_butylammonium_octanoate           # add water
bash scripts/run_stage3.sh M1_butylammonium_octanoate           # add Nd(III). Stretch goal, ask first
```

Each script does the whole chain by itself: box sizing, fftool, a charge check
that stops the run if the box is not neutral, packmol, LAMMPS with a four-part
minimise / NVT / NPT / production protocol, and the analysis. You never run
fftool, packmol, LAMMPS or the analysis by hand.

There is also `bash scripts/run_all.sh 1` to run one stage across all seven of
your systems overnight. Use it only after a `--quick` test has passed.

---

## Your seven systems are a series, not a list

Your set is the cation series. Systems M1, M2 and M4 use the same cation as Rosemary's
R1, R2 and R4, which is how the two halves of the project join up at the end of
the summer. Everything else about your work is independent.

Because your systems are a series, run them all the same way. If you change a box
size or a run length for one system and not the others, you can no longer compare
them, and the comparison is the result.

---

## The one rule

Every number that reaches a slide must be traceable to a file on your disk. The
analysis writes a CSV next to every figure for exactly that reason. If you cannot
point at the file a number came from, do not present the number. That is Section
5.2 of the research plan.

---

## If you received this by email

Mail servers strip `.py` attachments, so every Python script also has a `.py.txt`
copy. If the `.py` files are missing, rename them back:

```bash
cd scripts
for f in *.py.txt; do mv "$f" "${f%.txt}"; done
```

Then run `bash scripts/check_setup.sh` and carry on.
