# Mayowa - my seven systems

Achinivu Lab, RENEU 2026. These are entries from the ionic-liquid library in Section 4 of the research plan. Your set is the cation series.

**Table 1. Systems assigned to Mayowa.**

| ID | Library entry | Cation | Anion | Target element(s) | Substrate the element sits in | Ion pairs | Water (Stage 2) | Status |
|---|---|---|---|---|---|---|---|---|
| M1 | 1 | butylammonium | octanoate | Nd(III), Dy(III) | Spent NdFeB hard-disk and motor magnets | 55 | 220 | build-ready |
| M2 | 2 | propylammonium | octanoate | La(III), Ce(III) | NdFeB magnet swarf | 59 | 236 | build-ready |
| M3 | 9 | hexylammonium | octanoate | Dy(III) vs La(III) selectivity | Mixed rare-earth magnet feed | 48 | 192 | geometry built for this bundle |
| M4 | 5 | ethanolammonium | acetate | Nd(III), Pr(III) | Fluorescent-lamp phosphor dust | 98 | 392 | charge-rebalanced |
| M5 | 8 | diethanolammonium | acetate | Nd(III), multidentate | NdFeB magnet leachate | 72 | 288 | charge-rebalanced |
| M6 | 11 | triethylammonium | acetate | Li(I) | LFP black-mass leachate | 74 | 296 | build-ready |
| M7 | 12 | choline | octanoate | Ni(II), Co(II) | NMC black mass | 48 | 192 | charge-rebalanced |

**Table 2. Donor motif expected to template the first shell.**

| ID | Cation / anion | Donor atoms | Formula mass of the ion pair (g/mol) |
|---|---|---|---|
| M1 | butylammonium / octanoate | N-H, carboxylate O-O | 217.35 |
| M2 | propylammonium / octanoate | N-H, carboxylate O-O | 203.33 |
| M3 | hexylammonium / octanoate | N-H, long-chain O-donor | 245.41 |
| M4 | ethanolammonium / acetate | N-H and O-H, carboxylate | 121.14 |
| M5 | diethanolammonium / acetate | two O-H plus N-H | 165.19 |
| M6 | triethylammonium / acetate | single N-H, carboxylate | 161.24 |
| M7 | choline / octanoate | quaternary N with O-H, O-donor | 247.38 |

## What the three status values mean

- **build-ready**: the atom types come straight from CL&P and the ion already adds up to a whole-number charge. Nothing was invented.
- **geometry built for this bundle**: the atom types are standard CL&P, but no published coordinate file existed for this chain length, so the geometry was generated and relaxed for this project.
- **charge-rebalanced**: joining two CL&P fragments left a small residual charge, which was closed by the documented rule in `shared/FORCE_FIELD_NOTES.md`. You must mention this on any slide that reports a result from these systems.

## Run order suggested

Start with **M1_butylammonium_octanoate**, because it is build-ready and it is one of the systems you share with Rosemary, so you have something to compare against early. Then work down the table.
