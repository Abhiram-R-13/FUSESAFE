# FUSESAFE – Current Modelling Assumptions and Verification Status

## 1. Model Scope

FUSESAFE analyses a curved cylindrical fuselage panel containing a rounded rectangular window opening and an idealized reinforcement band.

The project uses static structural finite-element analysis for educational engineering assessment.

It does not model a complete aircraft and does not establish aircraft certification or structural safety.

## 2. Geometry and Coordinate Convention

The final coordinate convention, confirmed by Member 2, is:

- Global X: longitudinal/axial direction.
- Global +Y: radially outward at the panel circumferential centreline.
- Global Z: circumferential tangent at the panel centreline.
- Curvature lies in the global YZ cross-sectional plane.

Local radial and circumferential tangent directions vary around the curved panel.

Nominal geometry:

| Parameter | Value |
|---|---:|
| Panel axial length | 1600 mm |
| Developed circumferential length | 1600 mm |
| Shell midsurface radius | 2000 mm |
| Window width | 400 mm |
| Window height | 400 mm |
| Inner corner radius | 40 mm |
| Reinforcement band width | 50 mm |
| Outer corner radius | 90 mm |

For the six approved Day 5 geometry comparisons, the inner and outer corner radii remain fixed at 40 mm and 90 mm respectively.

The panel angle for the nominal geometry is:

Angle = 1600 / 2000 = 0.8 rad ≈ 45.84°.

These are educational modelling dimensions, not validated aircraft design dimensions.

## 3. Shell Representation and Thickness

The structural model uses shell midsurface representation.

Nominal configuration:

- Skin thickness: 2 mm.
- Total B_Band thickness: 4 mm.
- Added reinforcement thickness: 2 mm.
- Skin offset: Middle.
- Nominal band membrane offset: −1 mm.

The coupled Day 5 exploratory case used:

- Skin thickness: 1.5 mm.
- Total B_Band thickness: 4 mm.
- Added reinforcement thickness: 2.5 mm.
- Skin offset: Middle.
- Band membrane offset: −1.25 mm.

The −1.25 mm offset follows the intended Bottom-face alignment calculation under the assumption that the skin and band share the same reference surface and normal direction.

Actual shell normal directions and physical-face alignment still require independent verification.

The reinforcement is represented as an idealized continuous band with perfect load transfer. Rivets, adhesive and physical attachment details are not explicitly modelled.

## 4. Material Properties

Current ANSYS Engineering Data material:

`AA2024_T3_Bare_Provisional`

| Property | Value |
|---|---:|
| Young's modulus | 73100 MPa |
| Poisson's ratio | 0.33 |
| Provisional yield strength | 290 MPa |
| Density | 2780 kg/m³ |
| Bulk modulus | 71667 MPa |
| Shear modulus | 27481 MPa |

The model uses a homogeneous, isotropic material approximation with elastic material properties.

The 290 MPa yield-strength value is the current team-selected provisional modelling input.

An earlier supplier reference lists 345 MPa as a typical yield strength. This historical value is not the current ANSYS input.

Neither value has been established as a certified minimum design allowable for the exact sheet specification.

Stress exceeding the provisional yield threshold indicates failure of the screening criterion. The linear-elastic model does not reliably predict permanent plastic deformation.

## 5. Static Loading

The structural model uses static analysis with internal-minus-external pressure.

The nominal pressure is:

p = 55 kPa = 0.055 MPa = 0.055 N/mm².

The ANSYS structural studies use shell pressure and five SURF156 boundary-load groups:

1. Hoop upper.
2. Hoop lower.
3. Axial start.
4. Axial end.
5. Opening edge.

The original derivation of these five boundary-load groups has not been recovered.

Reconstructed resultants suggest a relationship with the baseline pressure, but their complete physical derivation, pressure scaling and potential double counting remain unresolved.

The Day 5 pressure-scaled cases are therefore exploratory and must not be treated as fully validated pressure-load models.

Changing Required FoS changes only the allowable-stress threshold and acceptance status. It does not change applied pressure or the underlying structural load configuration.

## 6. Supports and Boundary Conditions

The structural model uses three displacement support groups:

| Support | Constraints |
|---|---|
| A | UX = UY = UZ = 0 |
| B | UY = UZ = 0 |
| C | UY = 0 |

These constraints were used in the investigated structural models.

Their physical representation and adequacy for the intended fuselage-panel behaviour still require further validation through equilibrium and boundary-condition sensitivity checks.

## 7. Deformation and Analysis Behaviour

Static Structural analysis is used.

Large Deformation was enabled in the Day 5 coupled 0.070 MPa and 1.5 mm skin case.

The displacement and rotation assumptions must be considered when interpreting results.

The current material model does not establish post-yield plastic response.

## 8. Analytical Reference

The intact thin closed-cylinder calculation uses:

- Pressure: 0.055 MPa.
- Radius: 2000 mm.
- Skin thickness: 2 mm.

Calculated reference values:

- Hoop stress: 55 MPa.
- Axial stress: 27.5 MPa.
- Nominal von-Mises stress: approximately 47.63 MPa.

These are analytical far-field values for an intact closed cylindrical shell without a window.

They are not peak window-region FEA predictions.

The corresponding intact-reference FEA validation remains a separate verification requirement.

## 9. Mesh and Structural Verification

The original structural mesh used in the Day 5 coupled case contained:

- 84623 nodes.
- 28135 SHELL281 elements.
- 964 SURF156 elements.
- 29099 total elements.

Mesh convergence has not been established.

The nominal geometry automation mesh supplied by Member 2 differs from the original structural mesh.

Not every geometry archive has been restore-tested.

The 1.5 mm skin thickness used in the coupled case is outside the 1.8–3.0 mm range covered by Member 2's earlier Day 5 geometry and mesh validation.

## 10. Excluded Physical Effects

The current educational model does not fully evaluate:

- Fatigue and pressure-cycle effects.
- Crack initiation and propagation.
- Fracture mechanics and damage tolerance.
- Local or global buckling.
- Corrosion.
- Manufacturing imperfections and residual stresses.
- Rivet, adhesive and fastener behaviour.
- Complete glazing and window-frame pressure transfer.
- Full aircraft structural interactions.
- Temperature-dependent material behaviour.

These limitations must be considered when interpreting structural results.

## 11. Remaining Verification Requirements

The following items remain unresolved:

1. Confirm the exact material specification and applicable sheet-specific design allowables.
2. Recover or independently establish the original derivation of the five SURF156 loads.
3. Verify shell normals and actual pressure direction.
4. Check skin–band physical-face alignment in the final structural model.
5. Evaluate reaction-force and moment equilibrium.
6. Compare the intact-panel FEA with analytical reference stresses.
7. Establish mesh convergence.
8. Assess sensitivity to panel dimensions and boundary distance.
9. Validate archive restoration and final geometry connectivity.
10. Verify that the implemented loading and supports represent the intended physical system.

## 12. Interpretation of Results

Numerical convergence establishes that the solver obtained a solution for the specified model and load configuration.

It does not establish that the loading, material data, supports or physical assumptions are correct.

The FUSESAFE results are preliminary educational structural assessments. They are not proof of aircraft structural safety or certification.
