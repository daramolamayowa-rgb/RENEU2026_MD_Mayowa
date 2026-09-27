# Force-field notes: what is standard CL&P and what is not

Achinivu Lab, RENEU 2026. Read this before you present any number from a system
marked "charge-rebalanced" or "new bonded terms" in MY_SYSTEMS.md.

The file `forcefield/reneu.ff` is the CL&P force field (`paduagroup/clandp`,
version 2026/04/16) with a clearly marked addition block at the end of each
section. Nothing above the addition block was edited. If you diff `reneu.ff`
against the original `il.ff` you will find only insertions.

---

## 1. Why anything had to be added at all

CL&P assigns partial charges to whole chemical fragments, and the fragments are
parameterised assuming particular terminating groups. When you build an ion by
joining two fragments that were never joined in the original parameterisation,
the charges do not always sum to a whole number. This is not a bug in CL&P and it
is not a mistake you made: it is the documented consequence of splicing, and
Section 8 of the research plan tells you to expect it.

Six of the fourteen ions in the library are affected. Here is exactly how far off
each one was before anything was done.

**Table 1. Ions whose raw CL&P fragment charges do not close, and the residual
that had to be distributed.**

| Ion | Formal charge | Sum of raw CL&P fragment charges | Residual |
|---|---|---|---|
| ethanolammonium | +1 | +0.89 | +0.11 |
| diethanolammonium | +1 | +0.86 | +0.14 |
| choline | +1 | +0.83 | +0.17 |
| formate | -1 | -0.84 | -0.16 |
| glycolate | -1 | -0.94 | -0.06 |
| lactate | -1 | -0.98 | -0.02 |

The +0.89 for ethanolammonium is the same number quoted in Section 8 of the
research plan, which is a useful check that this bundle and the plan are
describing the same thing.

Every other ion in the library closes exactly on raw CL&P types, including all
the alkylammonium cations, acetate, octanoate, decanoate and triethylammonium.
Those were not touched.

---

## 2. The rule used to close the charge

One rule, applied identically to all six ions:

> The residual is divided equally over the **heavy atoms of the bond that joins
> the two parent fragments**. Hydrogens keep their standard class charge.
> Chemically equivalent atoms keep identical charges. Lennard-Jones parameters
> and atom classes are copied unchanged from the parent type, so every bonded
> term that applied to the parent still applies.

Worked example, ethanolammonium. The two fragments are an ethylammonium head and
an ethanol tail, joined by the C1N-CTO bond. The residual is +0.11, so each of
those two carbons gains +0.055. That produces two new type names, `C1NE` and
`CTOE`, which differ from `C1N` and `CTO` only in charge.

Formate is the one case where the join has a single heavy atom, because the other
partner is a hydrogen. There the whole residual goes on the carboxylate carbon
(`CO2F`, +0.540) and the hydrogen keeps the standard OPLS `HC` charge of +0.06.
Putting half the residual on the hydrogen would have given it a negative charge,
which is not chemically sensible for a formyl hydrogen.

**Table 2. Types added to reneu.ff, with the parent type each was copied from.**

| New type | Parent | Charge | Used in |
|---|---|---|---|
| C1NE | C1N | +0.255 | ethanolammonium |
| CTOE | CTO | +0.200 | ethanolammonium |
| C1ND | C1N | +0.235 | diethanolammonium |
| CTOD | CTO | +0.180 | diethanolammonium |
| C1C | C1 | -0.085 | choline |
| CTOC | CTO | +0.230 | choline |
| HCF | HC | +0.060 | formate |
| CO2F | CO2 | +0.540 | formate |
| CTOG | CTO | +0.115 | glycolate |
| CO2G | CO2 | +0.670 | glycolate |
| CTOL | CTO | +0.135 | lactate |
| CO2L | CO2 | +0.690 | lactate |

---

## 3. What these charges are, and are not

They are **closure charges**. They were obtained by arithmetic on published CL&P
fragment charges so that the ion carries its correct formal charge. They were
**not** fitted to quantum-chemical electrostatic potentials, and they are not
published parameters. No one has validated them against experiment.

What follows from that, practically:

- Results from build-ready systems (M1, M2, M6, R1, R2, and the geometry-only
  systems M3 and R3) rest entirely on published CL&P parameters.
- Results from the six rebalanced systems carry an extra approximation. You should
  say so in one sentence on the relevant slide. Something like: "the ethanolammonium
  cation required a +0.11 charge closure on the two carbons at the fragment join,
  following Section 8 of the research plan" is enough.
- If two systems disagree and one of them is rebalanced, the charge closure is a
  candidate explanation you have to consider before claiming a chemical effect.

---

## 4. Bonded terms that had to be added

Formate needs a hydrogen bonded directly to a carboxylate carbon, a connectivity
that does not occur anywhere in CL&P, so three terms were missing. Each was taken
from the equivalent OPLS-AA class **already present in il.ff**, not invented:

**Table 3. Bonded terms added, and the term each was copied from.**

| Term | Value | Copied from |
|---|---|---|
| bond HC-CO | cons 1.090 A, 2845.0 kJ/mol/A2 | the HC-CT bond in il.ff |
| angle HC-CO-O2 | harm 109.5 deg, 292.9 kJ/mol/rad2 | the HC-CT-CO angle in il.ff |
| improper HC-O2-CO-O2 | opls 0, 87.864, 0, 0 | the CT-O2-CO-O2 carbonyl improper in il.ff |

Two more terms were needed for the alpha-hydroxy anions (lactate, glycolate),
where a hydroxyl sits on the carbon next to the carboxylate:

| Term | Value | Copied from |
|---|---|---|
| angle OH-CT-CO | harm 109.5 deg, 418.4 kJ/mol/rad2 | the CT-CT-OH angle in il.ff |
| dihedral HO-OH-CT-CO | opls 0, 0, 1.8828, 0 | the HC-CT-OH-HO dihedral in il.ff |

These are transfers within the same OPLS-AA atom classes, which is the assumption
OPLS is built on. It is still an assumption, and R5, R6 and R7 should say so.

---

## 5. How the molecules themselves were built

No z-matrix in `molecules/` was written by hand. Hand-written z-matrices were what
produced the collinear-atom crashes earlier in this project. Instead, for every
ion:

1. a 3D structure was generated from SMILES and relaxed with MMFF94 (Open Babel);
2. CL&P atom types were assigned from the **molecular graph**, not from atom order,
   so the typing cannot silently shift if the atom ordering changes;
3. internal coordinates were measured from the relaxed structure and written out
   as a z-matrix;
4. every file was then run through fftool and required to report an exact integer
   charge with zero geometry warnings before it was allowed into the bundle.

All thirteen ions pass step 4. You can repeat that check yourself at any time:

```bash
cd ~/RENEU2026_MD/<your name>/molecules
python3 ~/pilmd_tools/fftool/fftool 1 butylammonium.zmat --box 40
```

The charge column must read exactly +1.0000 or -1.0000, and there must be no
warnings.

---

## 6. Software versions this was built and tested against

- CL&P force field, `paduagroup/clandp`, version dated 2026/04/16
- fftool, `paduagroup/fftool`, commit d89546c (1 April 2026)
- PACKMOL 20.x
- LAMMPS 7 Feb 2024
- Open Babel 3.x
- Python 3.12 with numpy and matplotlib

If your LAMMPS or fftool is much newer and something breaks, say which version you
have when you report it. fftool changed its command-line flags in January 2026,
which broke the earlier guides; the scripts in this bundle use the current long
flags (`--box`, `--tol`, `--lmp`) only.
