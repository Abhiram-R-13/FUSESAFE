# FUSESAFE – Current Limitations and Verification Register

**Status:** Updated through Day 6.  
**Purpose:** Record the current modelling assumptions, excluded physical effects and unresolved verification requirements.

## 1. Purpose and Model Scope

FUSESAFE is an educational finite-element study of a curved cylindrical fuselage panel containing a rounded rectangular window opening and an idealized reinforcement band.

The project investigates structural stress, deformation and reinforcement thickness under specified static loading conditions.

It does not model a complete aircraft.

The numerical results are preliminary engineering assessments and do not establish aircraft structural safety, airworthiness or certification.

## 2. Material Limitations

The current ANSYS Engineering Data material is:

`AA2024_T3_Bare_Provisional`

Current material inputs:

| Property | Value | Unit |
|---|---:|---|
| Young's modulus | 73100 | MPa |
| Poisson's ratio | 0.33 | Dimensionless |
| Tensile yield strength | 290 | MPa |
| Density | 2780 | kg/m³ |

The material is modelled using a homogeneous, isotropic approximation.

The 290 MPa yield-strength value is the team's current provisional modelling input. It has not been established as a certified minimum yield strength for the exact sheet specification.

An older supplier reference lists 345 MPa as a typical yield-strength value. This is retained as historical reference data and is not the current ANSYS input.

The current material model does not establish:
- Anisotropic or direction-dependent material behaviour.
- Plastic deformation and post-yield response.
- Certified sheet-specific design allowables.
- Temperature-dependent material properties.
- Effects of manufacturing history or material direction.

## 3. Structural Analysis Limitations

The investigated models use static structural analysis.

The material behaviour is represented using elastic properties. The Day 5 coupled analysis enabled Large Deformation, but this does not establish plastic material behaviour.

The current studies do not establish:
- Fatigue life under repeated pressure cycles.
- Crack initiation or crack propagation.
- Fracture toughness or damage tolerance.
- Impact or dynamic response.
- Local or global buckling resistance.
- Corrosion resistance.
- Residual-stress effects.
- Manufacturing imperfections.

A converged static stress result alone cannot establish complete aircraft fuselage structural performance.

## 4. Case A – Intact Reference Panel

The analytical reference represents a thin, closed cylindrical shell without a window.

For the nominal baseline:

- Pressure: 0.055 MPa.
- Radius: 2000 mm.
- Skin thickness: 2 mm.

Analytical reference stresses:

- Hoop stress: 55 MPa.
- Axial stress: 27.5 MPa.
- Nominal von-Mises stress: approximately 47.63 MPa.

These are theoretical far-field membrane stresses.

They are not predictions of the peak stress around a window opening.

The analytical calculation does not independently validate the actual curved-panel boundary conditions.

A corresponding intact curved-panel FEA comparison under a mechanically consistent load and support arrangement remains a required validation activity.

## 5. Case B – Reinforced Window Panel

The structural model contains a rounded rectangular opening and an idealized reinforcement band.

The reinforcement is represented as a continuous shell region with assigned local thickness.

The model assumes idealized load transfer between the reinforcement and surrounding skin.

It does not explicitly represent:
- Rivets.
- Adhesive bonding.
- Fasteners.
- Physical doubler attachment details.
- Local separation or slip between reinforcement and skin.

The opening-edge loading is represented through a SURF156 boundary-load group in the implemented model.

The original derivation of this opening-edge load remains unavailable. Its physical basis and potential interaction with the other pressure-related loads require further verification.

Maximum stress and deformation results must be interpreted in the context of the specific model, mesh, loads, supports and material assumptions.

## 6. Loading and Boundary-Condition Limitations

The implemented structural models use:
- Shell pressure.
- Five SURF156 boundary-load groups.
- Three displacement support groups.

The nominal support constraints used in the structural studies are:

| Support | Constraints |
|---|---|
| A | UX = UY = UZ = 0 |
| B | UY = UZ = 0 |
| C | UY = 0 |

These are idealized constraints and have not been demonstrated to represent the complete surrounding aircraft structure.

The initial loading proposal uses closed-cylinder membrane theory to establish reference hoop and axial actions.

However, the original calculation source for all five implemented SURF156 load groups has not been recovered.

Reconstructed resultants suggest a relationship with the baseline pressure, but their complete physical derivation, pressure scaling and possible double counting remain unresolved.

Pressure-scaled cases must therefore be identified as exploratory rather than fully validated pressure-load models.

A preliminary analytical free-body calculation is available, but it does not establish equilibrium of the actual ANSYS model.

The following checks remain necessary:
- Actual shell normal directions.
- Pressure sign and physical direction.
- Correct traction directions on curved boundaries.
- Reaction-force equilibrium.
- Moment equilibrium.
- Physical adequacy of support constraints.
- Correctness of load scopes and named selections.

## 7. Geometry and Shell Modelling Limitations

The nominal geometry is:

- Panel axial length: 1600 mm.
- Developed circumferential length: 1600 mm.
- Shell midsurface radius: 2000 mm.
- Window: 400 × 400 mm.
- Inner corner radius: 40 mm.
- Reinforcement band width: 50 mm.
- Outer corner radius: 90 mm.
- Nominal skin thickness: 2 mm.
- Nominal total band thickness: 4 mm.

The shell model uses a midsurface representation.

The idealized reinforcement does not necessarily reproduce the eccentricity and attachment behaviour of a physical one-sided doubler.

The Day 5 coupled case used:

- Skin thickness: 1.5 mm.
- Total B_Band thickness: 4 mm.
- Added reinforcement thickness: 2.5 mm.
- Skin offset: Middle.
- Band membrane offset: −1.25 mm.

This offset was calculated under the assumption that the skin and band share the same reference surface and normal direction. The actual shell normals and physical face alignment still require independent verification in the exact coupled model.

The 1.5 mm skin thickness is outside Member 2's earlier 1.8–3.0 mm geometry and mesh validation range.

The six Day 5 geometry variations received geometry and mesh validation evidence, but their structural responses were not established by those geometry checks.

## 8. Numerical Verification Limitations

The original structural mesh retained in the Day 5 coupled study contained:

- 84623 nodes.
- 28135 SHELL281 elements.
- 964 SURF156 elements.
- 29099 total elements.

The geometry automation baseline supplied by Member 2 has a different mesh.

Mesh convergence has not been established.

Not every geometry archive has been restore-tested.

The following verification items remain open:
- Mesh refinement comparison.
- Element quality assessment for the final selected structural model.
- Geometry and named-selection verification after restoration.
- Skin–band interface connectivity.
- Shell section and thickness verification.
- Reaction equilibrium.
- Sensitivity to panel size and boundary distance.

### Solver warnings

The Day 5 coupled case converged in seven substeps with zero solver errors and three warnings.

Reported warnings included:
1. Inactive element shape checking.
2. Material 4 lacking MP/TB data for energy reporting.
3. Zero reference moment in the convergence check.

Solver warnings must be recorded and assessed rather than treated as evidence of model validation.

Solver convergence establishes that a numerical solution was obtained for the specified model and inputs. It does not establish that those inputs represent the physical system correctly.

## 9. Day 5 Coupled Case Limitation

The separate coupled case combined:

- Shell pressure: 0.070 MPa.
- Skin thickness: 1.5 mm.
- Total B_Band thickness: 4 mm.

Reported results:

- Maximum von-Mises stress: 591.07 MPa.
- Maximum total deformation: 14.90 mm.
- Solver status: converged, zero errors and three warnings.

The five pressure-scaled SURF156 groups were retained from the exploratory pressure-consistent project.

Because the original load derivation remains unavailable and shell-normal alignment has not been independently verified, this is an exploratory coupled structural result.

It is not proof of a validated design response.

## 10. Remote Skin Assessment Limitation

The Day 5 coupled model included a separate skin-only von-Mises stress evaluation.

The maximum stress over the selected skin region was 290.8 MPa.

Four selected remote skin locations were probed:

| Probe | Stress |
|---|---:|
| 1 | 82.973 MPa |
| 2 | 81.821 MPa |
| 3 | 74.302 MPa |
| 4 | 78.801 MPa |

All four sampled values were below the provisional 145 MPa allowable stress for a required FoS of 2.

These are point measurements and do not establish the maximum stress over the complete remote skin region.

An exhaustive remote-region assessment remains outstanding.

## 11. Fatigue, Fracture and Damage Tolerance

The current FUSESAFE analysis does not evaluate:

- Fatigue life under repeated cabin pressurization.
- Crack initiation at window corners.
- Crack propagation.
- Fracture toughness.
- Damage tolerance.
- Residual strength after crack formation.
- Inspection intervals or repair requirements.

The project does not currently establish crack growth or damage-tolerance performance.

A static yield-based screening result cannot replace these assessments.

## 12. Buckling and Stability

The current studies do not establish:

- Local skin buckling.
- Panel buckling.
- Global structural instability.
- Post-buckling response.
- Imperfection-sensitive buckling resistance.

These require separate stability analyses and appropriate loading, boundary conditions and imperfection assumptions.

## 13. Window, Glazing and Attachment Limitations

The complete physical aircraft window assembly is not represented.

The model does not explicitly include:
- Glazing.
- Window-frame stiffness.
- Seals.
- Pressure transfer through glazing.
- Frame-to-fuselage attachment.
- Fastener or adhesive load transfer.
- Local joint failure.

The opening-edge SURF156 load is an idealized boundary action whose original derivation remains unresolved.

The current results cannot establish the structural performance of a complete aircraft window assembly.

## 14. Corrosion, Manufacturing and Environmental Effects

The current analyses do not evaluate:

- Corrosion or material degradation.
- Manufacturing tolerances.
- Geometric imperfections.
- Residual stresses.
- Forming or machining effects.
- Material defects.
- Temperature-dependent response.
- Environmental degradation.
- Production variability.

The idealized geometry and material model do not capture these physical effects.

## 15. MATLAB and Optimization Limitations

Member 3 verified that the MATLAB application changes allowable stress and acceptance status when Required FoS is changed.

Member 4 verified that backend reassessment reuses existing structural results without modifying pressure, geometry, material, supports or the five SURF156 load groups.

Member 4 also completed a P1 + P4 integration test using an actual ANSYS solve.

That integration test is not the final selected optimization run.

The complete optimization sweep and its final verified selected candidate remain pending.

The following deliverables are still required for final optimization review:
- Final selected run ID.
- Optimization_Report.txt.
- structural_assessment.csv.
- Corresponding ANSYS project or archive.
- Solver results and supporting screenshots.
- Verified reinforcement-only mass and optimization evidence.

No final lightest feasible reinforcement design should be claimed until the optimization sweep is completed and verified.

## 16. Overall Conclusion

The FUSESAFE project has progressed from initial modelling assumptions to multiple structural sensitivity studies, geometry and mesh reviews, coupled-case analysis and MATLAB/backend verification.

The current work provides an educational basis for investigating pressure-loaded curved panels with reinforced window openings.

However, the following major limitations remain:

1. Provisional material strength and absence of certified sheet-specific allowables.
2. Unconfirmed derivation of the five SURF156 boundary-load groups.
3. Unverified shell normals and physical face alignment.
4. Incomplete reaction-force and moment equilibrium verification.
5. Incomplete intact-panel FEA validation.
6. Absence of demonstrated mesh convergence.
7. Unverified full-field remote skin stress.
8. Excluded fatigue, fracture, buckling, corrosion, manufacturing and attachment effects.
9. Incomplete final optimization sweep and selected-candidate verification.

A successful static solver run does not establish that the loading, material, geometry or boundary conditions are physically valid.

FUSESAFE remains an educational structural assessment tool and does not establish aircraft structural safety, airworthiness or certification.

---

**Status:** Updated through Day 6.  
**Important:** The final selected optimization run and its supporting evidence are still pending from Member 4.
