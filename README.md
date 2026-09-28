# Programmable Protic Ionic Liquid–Metal-Organic Framework (PIL-MOF) Moieties for Critical Element Extraction: A Molecular Dynamics (MD) Study

Molecular dynamics workflow, parameter structures, analysis scripts, and validation resources for investigating how protic ionic liquid (PIL) molecular architecture influences the coordination environment of critical element ion, with Nd³⁺ as a representative trivalent ion in mixed PIL/water solvent systems. 

This repository archives original research assets compiled during the **RENEU Summer Research Program**.

---

## Research Core

### Primary Objective
> **How do the molecular structure and coordination behavior of protic ionic liquids influence their suitability for the selective extraction of critical-element ions?**

### Key Computational Insights
* **First-Shell Dynamics:** Observed Nd³⁺ first-shell coordination numbers (CN) ranging stably between **8.33–9.01** across the sampled trajectories.
* **Anionic Chelation:** PIL carboxylate species dominate the primary shell, contributing **44.4% to 88.0%** of total coordination.
* **Competitive Solvation:** Introducing explicit water systematically reduced the primary PIL donor coordination by **24.6% to 48.8%**.
* **Cation Tuning:** Modifying the anion structure at a fixed cation shifted individual anionic contributions by **11.1 to 54.7 percentage points**, a structural variation found to be highly dependent on the localized cation conformation.

*Note: These insights represent preliminary MD observations derived from Stage 3b simulations optimized with localized ion configurations.*

---

## Repository Blueprint

```text
RENEU2026_MD_Mayowa/
│
├── 00_READ_ME_FIRST.md      # Fast-track operational workflow documentation
├── GUIDE_Mayowa.md         # Step-by-step developer notes for running simulations
├── MY_SYSTEMS.md           # Structural breakdown of the 7 studied chemical systems
├── .gitignore              # Active filter blocking large trajectories (*.lammpstrj, *.xtc)
│
├── forcefield/             # Validated parameterization & topological force-field assets
├── molecules/              # Independent molecular topology models (.zmat / packmol geometry)
├── reference/              # Comparative literature baselines, external data arrays, and benchmarks
├── scripts/                # Analysis pipeline (RDF profiles, CN integrations, H-bonding metrics)
└── systems/                # Organized workflow stages across pure and binary phases
```

---

## Software & Dependency Stack

This workspace is verified and optimized for execution in an **Ubuntu/Linux** terminal environment utilizing the following dependencies:
* **LAMMPS** (Large-scale Atomic/Molecular Massively Parallel Simulator)
* **PACKMOL** (Initial packed system generation setup)
* **fftool** / **CL&P Force Field** (System topology parametrization)
* **OVITO** (Visual trajectory monitoring and analysis spatial rendering)
* **Python 3.x** (Data post-processing, `g(r)` radial distribution file analytics)

---

## Computational Methodology Layout

The simulation matrix progresses systematically through distinct benchmarking levels to isolate structural drivers:

```text
  [Stage 1: Pure PIL Equilibration]
                 ↓
      (Extract RDF & Shell Metrics)
                 ↓
  [Stage 2: PIL + Explicit Water Systems]
                 ↓
    (Analyze H-Bond & Solvent Shielding)
                 ↓
  [Stage 3a: Aquated Ion Validation (Nd³⁺ + H₂O)]
                 ↓
   (Calibrate Baseline Coordination Baselines)
                 ↓
  [Stage 3b: Mixed Solvent Coordination (Nd³⁺ + PIL + H₂O)]
                 ↓
  Final Running Coordination Matrix Analysis
```

---

## Open Access & Terms

* **Original Research Artifacts:** All customized Python utility scripts, Markdown schema, and spatial organization logic are authored by **Alex Acquah**.
* **Third-Party Materials:** Force field libraries, empirical literature values, and foundational parameterization packages remain explicitly attributed to their original authors. 
* **Data Reproducibility Statement:** Large-scale coordinates, checkpoint frames (`*.restart`), and binary trajectory data arrays (`*.lammpstrj`, `*.xtc`) are omitted via `.gitignore` to maintain a streamlined structural template.

---
*For details regarding the physical parameters, operational steps, or system constraints, refer to `GUIDE_Mayowa.md` and `00_READ_ME_FIRST.md` directly inside the root workspace folder.*
