# Analysis summary - M4 ethanolammonium acetate stage 3a

Stage 3. 321 production frames analysed (first 80 of 401 discarded).

**Table 1. Equilibrated density from the NPT production run.**

| quantity | value |
|---|---|
| mean density | 1.0455 g/cm3 |
| standard deviation | 0.0086 g/cm3 |

**Table 2. First-shell structure from the radial distribution functions.**

| atom pair | first peak / A | g at peak | first minimum / A | first-shell CN | plan check |
|---|---|---|---|---|---|
| O(water) ... O(carboxylate) | 2.68 | 2.82 | 3.18 | 0.04 |  |
| O(water) ... O(water) | 2.78 | 2.76 | 3.33 | 4.61 |  |
| metal ion ... O(carboxylate) | 6.93 | 1.53 | 6.97 | 0.32 |  |
| metal ion ... O(water) | 2.48 | 12.57 | 3.58 | 9.00 | as expected (metal-O first peak 2.2-2.7) |

**Table 3. Hydrogen-bond population (H...acceptor < 2.5 A, D-H...A angle > 130.0 deg).**

| quantity | value |
|---|---|
| donor D-H groups in the box | 1000 |
| mean hydrogen bonds per frame | 935.9 +/- 8.4 |
| mean hydrogen bonds per donor | 0.936 |

> Stage 3 reading order: first confirm the metal-O(water) row (expect a peak near 2.4-2.5 A and a coordination number near 8-9). Only if that holds does the metal-O(carboxylate) row mean anything. A carboxylate that has not entered the first shell shows up as a peak beyond about 5 A with a coordination number near zero, which usually means the run is too short rather than that the anion does not coordinate.

**Figure titles.** One PNG per pair is written next to this file:
- Radial distribution function and running coordination number, O(water) ... O(carboxylate).
- Radial distribution function and running coordination number, O(water) ... O(water).
- Radial distribution function and running coordination number, metal ion ... O(carboxylate).
- Radial distribution function and running coordination number, metal ion ... O(water).

Raw numbers behind every figure are in the rdf_*.csv files, so any value you quote can be traced to a file (research plan Section 5.2).
