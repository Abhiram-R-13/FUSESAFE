# FUSESAFE — Aircraft Fuselage Cutout Reinforcement Optimization

**FUSESAFE** is a MATLAB App Designer GUI application developed for real-time evaluation, trade-off visualization, and decision support in reinforcing commercial aircraft fuselage cutout regions subjected to internal pressurization.

---

## 1. Project Overview

The app links structural finite element analysis (FEA) parametric sweeps with an interactive engineering interface:
* **Dynamic Safety Factor Evaluation:** Evaluates candidate reinforcement thicknesses against target Factors of Safety (FoS).
* **Trade-Off Plotting:** Renders interactive Mass vs. Thickness and Stress vs. Thickness trade-off curves.
* **FEA Visualizations:** Loads stress contours, deformation contours, and 3D geometry CAD models.
* **Automated Reporting:** Exports formatted engineering summary text reports (`Optimization_Report.txt`).

---

## 2. Material Specifications (Aluminium Alloy 2024-T3)

* **Provisional Yield Strength ($\sigma_y$):** 290 MPa
* **Young's Modulus ($E$):** 73,100 MPa
* **Poisson's Ratio ($\nu$):** 0.33
* **Density ($\rho$):** 2,780 kg/m³

---

## 3. Repository Structure

```text
FUSESAFE-Project/
│
├── FUSESAFE.mlapp                 # Primary MATLAB App Designer source
├── README.md                      # Project documentation and launch instructions
├── Optimization_Report.txt        # Sample exported engineering report
└── runs/
    └── run_001/                   # Default simulation dataset package
        ├── results.csv            # Final run summary record
        ├── optimization_history.csv # 6-candidate parametric sweep history
        ├── manifest.json          # Solver metadata & run specifications
        ├── stress_contour.png     # ANSYS von Mises stress contour (DP98)
        ├── deformation_contour.png # ANSYS total deformation contour
        └── geometry_3d.png        # 3D mesh geometry screenshot
