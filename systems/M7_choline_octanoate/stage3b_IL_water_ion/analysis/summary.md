# Analysis summary - M7 choline octanoate stage 3b

Stage 3. 321 production frames analysed (first 80 of 401 discarded).

**Table 1. Equilibrated density from the NPT production run.**

| quantity | value |
|---|---|
| mean density | 1.0053 g/cm3 |
| standard deviation | 0.0064 g/cm3 |

> Note: this cation has no acidic N-H. The N...O window in Section 9 of the research plan assumes one, so no plan check is applied to the N...O row; the hydroxyl O-H is the donor here.

**Table 2. First-shell structure from the radial distribution functions.**

| atom pair | first peak / A | g at peak | first minimum / A | first-shell CN | plan check |
|---|---|---|---|---|---|
| O-H(cation) ... O(carboxylate) | 1.73 | 8.83 | 2.43 | 0.51 | as expected (O-H...O first peak 1.5-2.2) |
| N(cation) ... O(carboxylate) | 4.18 | 2.71 | 4.22 | 0.96 |  |
| N(cation) ... C(carboxylate) | 4.83 | 3.26 | 6.43 | 2.95 |  |
| O(water) ... O(carboxylate) | 2.68 | 7.79 | 3.28 | 1.08 |  |
| O(water) ... N(cation) | 4.53 | 3.33 | 6.33 | 2.74 |  |
| O(water) ... O(water) | 2.73 | 6.33 | 3.48 | 2.20 |  |
| metal ion ... O(carboxylate) | 2.38 | 88.34 | 2.98 | 7.01 |  |
| metal ion ... O(water) | 2.48 | 12.45 | 3.53 | 2.00 | as expected (metal-O first peak 2.2-2.7) |

**Table 3. Hydrogen-bond population (H...acceptor < 2.5 A, D-H...A angle > 130.0 deg).**

| quantity | value |
|---|---|
| donor D-H groups in the box | 432 |
| mean hydrogen bonds per frame | 416.9 +/- 4.4 |
| mean hydrogen bonds per donor | 0.965 |

> Stage 3 reading order: first confirm the metal-O(water) row (expect a peak near 2.4-2.5 A and a coordination number near 8-9). Only if that holds does the metal-O(carboxylate) row mean anything. A carboxylate that has not entered the first shell shows up as a peak beyond about 5 A with a coordination number near zero, which usually means the run is too short rather than that the anion does not coordinate.

**Figure titles.** One PNG per pair is written next to this file:
- Radial distribution function and running coordination number, O-H(cation) ... O(carboxylate).
- Radial distribution function and running coordination number, N(cation) ... O(carboxylate).
- Radial distribution function and running coordination number, N(cation) ... C(carboxylate).
- Radial distribution function and running coordination number, O(water) ... O(carboxylate).
- Radial distribution function and running coordination number, O(water) ... N(cation).
- Radial distribution function and running coordination number, O(water) ... O(water).
- Radial distribution function and running coordination number, metal ion ... O(carboxylate).
- Radial distribution function and running coordination number, metal ion ... O(water).

Raw numbers behind every figure are in the rdf_*.csv files, so any value you quote can be traced to a file (research plan Section 5.2).
