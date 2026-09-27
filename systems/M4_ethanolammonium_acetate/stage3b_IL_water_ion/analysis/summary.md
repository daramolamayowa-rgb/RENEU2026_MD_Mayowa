# Analysis summary - M4 ethanolammonium acetate stage 3b

Stage 3. 321 production frames analysed (first 80 of 401 discarded).

**Table 1. Equilibrated density from the NPT production run.**

| quantity | value |
|---|---|
| mean density | 1.1613 g/cm3 |
| standard deviation | 0.0153 g/cm3 |

**Table 2. First-shell structure from the radial distribution functions.**

| atom pair | first peak / A | g at peak | first minimum / A | first-shell CN | plan check |
|---|---|---|---|---|---|
| N-H(cation) ... O(carboxylate) | 1.68 | 5.55 | 2.38 | 0.59 | as expected (N-H...O first peak 1.6-2.2) |
| O-H(cation) ... O(carboxylate) | 1.77 | 3.89 | 2.48 | 0.58 | as expected (O-H...O first peak 1.5-2.2) |
| N(cation) ... O(carboxylate) | 2.68 | 7.38 | 3.33 | 1.91 | as expected (N...O first minimum 3.0-4.5) |
| N(cation) ... C(carboxylate) | 3.48 | 5.14 | 4.18 | 1.73 |  |
| O(water) ... O(carboxylate) | 2.68 | 3.51 | 3.23 | 0.93 |  |
| O(water) ... N(cation) | 2.78 | 2.34 | 3.23 | 0.37 |  |
| O(water) ... O(water) | 2.73 | 3.66 | 3.28 | 2.39 |  |
| metal ion ... O(carboxylate) | 2.38 | 41.38 | 2.93 | 6.00 |  |
| metal ion ... O(water) | 2.43 | 10.87 | 3.62 | 3.00 | as expected (metal-O first peak 2.2-2.7) |

**Table 3. Hydrogen-bond population (H...acceptor < 2.5 A, D-H...A angle > 130.0 deg).**

| quantity | value |
|---|---|
| donor D-H groups in the box | 1176 |
| mean hydrogen bonds per frame | 1156.1 +/- 8.7 |
| mean hydrogen bonds per donor | 0.983 |

> Stage 3 reading order: first confirm the metal-O(water) row (expect a peak near 2.4-2.5 A and a coordination number near 8-9). Only if that holds does the metal-O(carboxylate) row mean anything. A carboxylate that has not entered the first shell shows up as a peak beyond about 5 A with a coordination number near zero, which usually means the run is too short rather than that the anion does not coordinate.

**Figure titles.** One PNG per pair is written next to this file:
- Radial distribution function and running coordination number, N-H(cation) ... O(carboxylate).
- Radial distribution function and running coordination number, O-H(cation) ... O(carboxylate).
- Radial distribution function and running coordination number, N(cation) ... O(carboxylate).
- Radial distribution function and running coordination number, N(cation) ... C(carboxylate).
- Radial distribution function and running coordination number, O(water) ... O(carboxylate).
- Radial distribution function and running coordination number, O(water) ... N(cation).
- Radial distribution function and running coordination number, O(water) ... O(water).
- Radial distribution function and running coordination number, metal ion ... O(carboxylate).
- Radial distribution function and running coordination number, metal ion ... O(water).

Raw numbers behind every figure are in the rdf_*.csv files, so any value you quote can be traced to a file (research plan Section 5.2).
