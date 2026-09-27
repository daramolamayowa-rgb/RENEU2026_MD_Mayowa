# Metal-ion parameters for Stage 3

Achinivu Lab, RENEU 2026. Read this before you present anything from Stage 3.

---

## 1. Why this file exists

CL&P does not contain lanthanide ions. It was built for organic cations and
anions, and no one has parameterised Nd(III), Dy(III), La(III) or the rest inside
it. Section 8 of the research plan says this plainly and requires that any ion
parameter be sourced from the published literature and then validated before its
results are trusted.

So Stage 3 sits on a different footing from Stages 1 and 2. Stages 1 and 2 use
one internally consistent published force field. Stage 3 bolts an ion from a
second source onto it.

---

## 2. What is in nd.ff

**Table 1. The only ion supplied in this bundle.**

| Quantity | Value | Source |
|---|---|---|
| ion | Nd(III) | representative trivalent ion, research plan Section 6.2 step 13 |
| charge | +3.00 | formal charge |
| sigma | 2.9952 A | Li, Song and Merz, *J. Phys. Chem. B* 2015, **119**, 883-895, IOD set for SPC/E water. doi:10.1021/jp505875v |
| epsilon | 0.52569 kJ/mol | same source, converted from kcal/mol |

Two things about this you need to know and state.

**First, verify the numbers.** The sigma and epsilon above were carried forward
from the earlier build of this project rather than re-read from the paper during
this build. Before Stage 3 results go on a slide, open the paper, find the IOD
parameter set for SPC/E water, and confirm both numbers and the conversion from
R_min/2 and kcal/mol. If they differ, the file is wrong and must be corrected.
This takes ten minutes and it is exactly the kind of check Section 5.2 of the
research plan is about.

**Second, the combining rule differs.** CL&P mixes sigma **geometrically**, and
that is what fftool sets in the LAMMPS input. The Li-Merz sets were fitted using
**Lorentz-Berthelot arithmetic** mixing. For a single ion the numerical difference
is small, but it is a genuine approximation and it belongs in your methods slide
in one sentence.

---

## 3. The validation you must run first

Stage 3a exists for this and only this. It puts one Nd(III) in water with just
enough anions to balance the charge, and asks whether the ion reproduces its known
hydration structure.

**Table 2. The validation target and what the test build produced.**

| Quantity | Expected | Test build, 10 ps quick run |
|---|---|---|
| Nd-O(water) first peak | 2.4 to 2.5 A | 2.48 A |
| Nd-O(water) first-shell coordination number | 8 to 9 | 9.0 |

If your own 3a run lands in those windows, the parameters are behaving and you may
go on to 3b. If it does not, stop and tell Alex. A coordination number of 6 or 12
means something is wrong with the parameters, the units, or the mixing rule, and
nothing computed after that point is interpretable.

---

## 4. Your system's real target element is probably not neodymium

Each of the fourteen library entries targets a specific element, listed in
MY_SYSTEMS.md. Stage 3 uses Nd(III) for all of them because the research plan
names it as the representative trivalent ion and because it is the one ion whose
parameters this bundle can supply with a traceable source.

If you want to simulate your system's actual target element, you must source its
parameters yourself. Do not guess them and do not scale Nd's.

**Table 3. Ions the library's fourteen entries actually target.**

| Charge | Elements appearing in the library | Where the 12-6 parameters live |
|---|---|---|
| 3+ | La, Ce, Pr, Nd, Tb, Dy, Sc, Y | Li, Song and Merz 2015, JPCB 119, 883, trivalent IOD set for SPC/E |
| 2+ | Co, Ni, Mn | Li, Roberts, Chakravorty and Merz 2013, JCTC 9, 2733, divalent set |
| 1+ | Li | Li and Merz 2015, JCTC 11, 1645, monovalent set |

Those three papers are the standard sources for this parameter family. Check the
water model each set was fitted for: you want the set fitted for **SPC/E**,
because that is the water in `spce.ff`. A set fitted for TIP3P is a different set
of numbers.

## 5. How to add an ion once you have its parameters

Copy `forcefield/nd.ff` to a new file, for example `dy.ff`, and edit three things:
the type name, the mass, and the sigma and epsilon. Convert sigma and epsilon into
CL&P units, which are angstrom and kJ/mol. Then copy `molecules/nd.zmat` to
`dy.zmat`, change the atom type name and the force-field file name on the last
line, and set `ION=dy` in that system's `system.cfg`.

Then run Stage 3a again for the new ion, because the validation is per ion, not
per project. A parameter set that reproduces Nd-O does not tell you anything about
whether the Dy set is right.

---

## 6. The honest sentence for your slide

Whatever you find in Stage 3, this belongs under it:

> Nd(III) parameters are literature 12-6 values fitted for SPC/E water and
> combined with CL&P under geometric mixing, which differs from the arithmetic
> mixing used in the original fit. A single ion in a single box gives no error
> bar. These results are preliminary.

That sentence costs you nothing and it is the difference between a result and a
claim you cannot defend.
