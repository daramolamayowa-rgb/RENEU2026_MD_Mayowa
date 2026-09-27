# Analysis summary - EXAMPLE ONLY - M1 butylammonium octanoate, quick pipeline test

Stage 1. 17 production frames analysed (first 4 of 21 discarded).

**Table 1. Equilibrated density from the NPT production run.**

| quantity | value |
|---|---|
| mean density | 0.7863 g/cm3 |
| standard deviation | 0.0166 g/cm3 |

**Table 2. First-shell structure from the radial distribution functions.**

| atom pair | first peak / A | g at peak | first minimum / A | first-shell CN | plan check |
|---|---|---|---|---|---|
| N-H(cation) ... O(carboxylate) | 1.62 | 15.87 | 2.28 | 0.99 | as expected (N-H...O first peak 1.6-2.2) |
| N(cation) ... O(carboxylate) | 2.62 | 20.94 | 3.62 | 3.60 | as expected (N...O first minimum 3.0-4.5) |
| N(cation) ... C(carboxylate) | 3.68 | 10.47 | 4.38 | 2.77 |  |

**Table 3. Hydrogen-bond population (H...acceptor < 2.5 A, D-H...A angle > 130.0 deg).**

| quantity | value |
|---|---|
| donor D-H groups in the box | 165 |
| mean hydrogen bonds per frame | 162.5 +/- 4.8 |
| mean hydrogen bonds per donor | 0.985 |

**Figure titles.** One PNG per pair is written next to this file:
- Radial distribution function and running coordination number, N-H(cation) ... O(carboxylate).
- Radial distribution function and running coordination number, N(cation) ... O(carboxylate).
- Radial distribution function and running coordination number, N(cation) ... C(carboxylate).

Raw numbers behind every figure are in the rdf_*.csv files, so any value you quote can be traced to a file (research plan Section 5.2).
