# Analysis summary - M6 triethylammonium acetate stage 3b

Stage 3. 321 production frames analysed (first 80 of 401 discarded).

**Table 1. Equilibrated density from the NPT production run.**

| quantity | value |
|---|---|
| mean density | 1.0271 g/cm3 |
| standard deviation | 0.0055 g/cm3 |

**Table 2. First-shell structure from the radial distribution functions.**

| atom pair | first peak / A | g at peak | first minimum / A | first-shell CN | plan check |
|---|---|---|---|---|---|
| N-H(cation) ... O(carboxylate) | 1.68 | 12.89 | 2.33 | 0.95 | as expected (N-H...O first peak 1.6-2.2) |
| N(cation) ... O(carboxylate) | 2.68 | 5.42 | 3.73 | 1.23 | as expected (N...O first minimum 3.0-4.5) |
| N(cation) ... C(carboxylate) | 3.43 | 3.47 | 4.12 | 0.86 |  |
| O(water) ... O(carboxylate) | 2.68 | 5.43 | 3.28 | 1.04 |  |
| O(water) ... N(cation) | 4.62 | 1.93 | 6.72 | 3.58 |  |
| O(water) ... O(water) | 2.73 | 5.02 | 3.48 | 2.50 |  |
| metal ion ... O(carboxylate) | 2.38 | 36.49 | 3.53 | 4.00 |  |
| metal ion ... O(water) | 2.48 | 23.00 | 3.68 | 5.00 | as expected (metal-O first peak 2.2-2.7) |

**Table 3. Hydrogen-bond population (H...acceptor < 2.5 A, D-H...A angle > 130.0 deg).**

| quantity | value |
|---|---|
| donor D-H groups in the box | 666 |
| mean hydrogen bonds per frame | 662.9 +/- 5.4 |
| mean hydrogen bonds per donor | 0.995 |

> Stage 3 reading order: first confirm the metal-O(water) row (expect a peak near 2.4-2.5 A and a coordination number near 8-9). Only if that holds does the metal-O(carboxylate) row mean anything. A carboxylate that has not entered the first shell shows up as a peak beyond about 5 A with a coordination number near zero, which usually means the run is too short rather than that the anion does not coordinate.

**Figure titles.** One PNG per pair is written next to this file:
- Radial distribution function and running coordination number, N-H(cation) ... O(carboxylate).
- Radial distribution function and running coordination number, N(cation) ... O(carboxylate).
- Radial distribution function and running coordination number, N(cation) ... C(carboxylate).
- Radial distribution function and running coordination number, O(water) ... O(carboxylate).
- Radial distribution function and running coordination number, O(water) ... N(cation).
- Radial distribution function and running coordination number, O(water) ... O(water).
- Radial distribution function and running coordination number, metal ion ... O(carboxylate).
- Radial distribution function and running coordination number, metal ion ... O(water).

Raw numbers behind every figure are in the rdf_*.csv files, so any value you quote can be traced to a file (research plan Section 5.2).
