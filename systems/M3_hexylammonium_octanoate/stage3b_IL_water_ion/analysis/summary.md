# Analysis summary - M3 hexylammonium octanoate stage 3b

Stage 3. 321 production frames analysed (first 80 of 401 discarded).

**Table 1. Equilibrated density from the NPT production run.**

| quantity | value |
|---|---|
| mean density | 0.9521 g/cm3 |
| standard deviation | 0.0068 g/cm3 |

**Table 2. First-shell structure from the radial distribution functions.**

| atom pair | first peak / A | g at peak | first minimum / A | first-shell CN | plan check |
|---|---|---|---|---|---|
| N-H(cation) ... O(carboxylate) | 1.68 | 12.07 | 2.38 | 0.61 | as expected (N-H...O first peak 1.6-2.2) |
| N(cation) ... O(carboxylate) | 2.68 | 15.44 | 3.33 | 1.97 | as expected (N...O first minimum 3.0-4.5) |
| N(cation) ... C(carboxylate) | 3.53 | 9.31 | 4.22 | 1.72 |  |
| O(water) ... O(carboxylate) | 2.68 | 7.33 | 3.28 | 1.04 |  |
| O(water) ... N(cation) | 2.78 | 5.60 | 3.18 | 0.42 |  |
| O(water) ... O(water) | 2.78 | 7.38 | 4.93 | 6.55 |  |
| metal ion ... O(carboxylate) | 2.38 | 67.47 | 3.58 | 5.00 |  |
| metal ion ... O(water) | 2.48 | 26.60 | 3.23 | 4.00 | as expected (metal-O first peak 2.2-2.7) |

**Table 3. Hydrogen-bond population (H...acceptor < 2.5 A, D-H...A angle > 130.0 deg).**

| quantity | value |
|---|---|
| donor D-H groups in the box | 528 |
| mean hydrogen bonds per frame | 513.2 +/- 6.2 |
| mean hydrogen bonds per donor | 0.972 |

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
