# FUSESAFE – Day 5 Final Results and Limitations

## 1. Objective

Day 5 focused on evaluating the structural response of the FUSESAFE curved fuselage panel under changed pressure, skin thickness and required Factor of Safety (FoS), reviewing geometry variations, investigating a coupled demanding case and checking stress levels in the remote skin.

This report consolidates the completed studies and identifies the remaining technical limitations.

## 2. Pressure Sensitivity Study – Task 1

Three original pressure-only cases were investigated. In these cases, shell pressure was changed while the five baseline SURF156 boundary-load groups were held fixed.

| Shell pressure | Solver outcome | Result interpretation |
|---|---|---|
| 0.040 MPa | Failed to converge | No valid final stress or deformation result |
| 0.055 MPa | Converged | Baseline structural result |
| 0.070 MPa | Failed to converge | No valid final stress or deformation result |

The converged baseline at 0.055 MPa produced:

- Maximum von-Mises stress: 464.23 MPa
- Maximum total deformation: 13.157 mm

Separate exploratory pressure-consistent cases were also investigated using scaled SURF156 boundary loads.

| Pressure | Solver outcome | Maximum stress | Maximum deformation |
|---|---|---:|---:|
| 0.040 MPa | Converged | 365.13 MPa | 11.297 mm |
| 0.070 MPa | Converged | 556.25 MPa | 14.70 mm |

These exploratory cases must be distinguished from the original pressure-only cases. The original derivation of the five SURF156 loads is still unavailable, so the pressure scaling remains an assumption rather than a fully validated load derivation.

## 3. Skin Thickness Sensitivity Study – Task 2

The skin thickness was varied while retaining the nominal pressure of 0.055 MPa and the existing structural setup.

| Skin thickness | Maximum von-Mises stress | Maximum total deformation |
|---|---:|---:|
| 1.5 mm | 487.68 MPa | 13.508 mm |
| 2.0 mm | 464.23 MPa | 13.157 mm |
| 2.5 mm | 445.20 MPa | 12.804 mm |

The results show that increasing skin thickness reduced both maximum stress and maximum deformation in the investigated cases.

The 1.5 mm and 2.5 mm models converged successfully, with seven substeps and zero solver errors. Three warnings were reported in each case.

## 4. Required FoS Sensitivity Verification – Tasks 3 and 4

The MATLAB application and backend were checked to establish that changing the required FoS affects the allowable-stress threshold and acceptance status rather than the underlying structural loading.

The provisional yield strength used was 290 MPa.

The allowable stress is calculated as:

Allowable stress = Yield strength / Required FoS

| Required FoS | Yield strength | Allowable stress | FEA maximum stress | Applied pressure | Status |
|---|---:|---:|---:|---:|---|
| 1.5 | 290 MPa | 193.333 MPa | 464.229 MPa | 0.055 MPa | FAIL |
| 2.0 | 290 MPa | 145.000 MPa | 464.229 MPa | 0.055 MPa | FAIL |
| 2.5 | 290 MPa | 116.000 MPa | 464.229 MPa | 0.055 MPa | FAIL |

### MATLAB App verification – Member 3

Member 3 confirmed that:
- Required FoS input is accepted over the 1.5–2.5 range.
- Allowable stress updates dynamically.
- The pressure field remains at 55 kPa.
- The maximum FEA stress remains unchanged.
- Acceptance status correctly remains FAIL for all three cases.

Three UI screenshots were captured for the FoS values of 1.5, 2.0 and 2.5.

### Backend verification – Member 4

Member 4 confirmed that:
- Changing Required FoS does not modify pressure.
- It does not modify geometry, material, supports or the five SURF156 load groups.
- Existing structural results are reused without launching ANSYS again.
- The ANSYS safety guard was not triggered during the FoS reassessment.
- A separate `structural_assessment.csv` was implemented to record solver status and structural acceptance without changing the existing results and optimization-history CSV formats.

A limitation is that all three baseline cases fail. These tests verify the acceptance logic but do not demonstrate selection of a different feasible thickness.

## 5. Geometry Variation Review – Task 5

Member 2 supplied six recommended geometry alternatives for later structural sensitivity studies.

| Case | Window width (mm) | Window height (mm) | Panel radius (mm) |
|---|---:|---:|---:|
| Nominal baseline | 400 | 400 | 2000 |
| Width low | 250 | 400 | 2000 |
| Width high | 500 | 400 | 2000 |
| Height low | 400 | 300 | 2000 |
| Height high | 400 | 550 | 2000 |
| Radius low | 400 | 400 | 1500 |
| Radius high | 400 | 400 | 2500 |

Fixed geometry parameters:
- Inner corner radius: 40 mm
- Reinforcement band width: 50 mm
- Outer band corner radius: 90 mm
- Panel axial length: 1600 mm
- Developed circumferential length: 1600 mm
- Nominal skin thickness: 2 mm
- Nominal total B_Band thickness: 4 mm

According to Member 2's handoff, all six selected endpoint exports passed the reported section and connectivity audits.

The W500/H400/R2000 case must use the Hard10mm archive. Earlier W500 Review and NoDefeat exports were identified as diagnostic files with an interface irregularity and must not be used as passing simulation sources.

The regenerated nominal automation mesh contained:
- 9,845 nodes
- 3,217 shell elements
- 3,065 Quad8 elements
- 152 Tri6 elements
- Minimum element quality: 0.61901
- Average element quality: 0.97054
- Maximum element quality: 0.99993

This regenerated mesh differs from the original structural baseline mesh. Restoration comparison of the nominal archive against its matching DAT export was still pending in the handoff.

No structural simulations were performed for these six geometry variants as part of Task 5.

## 6. Coupled Demanding Case – Task 6

A separate coupled structural case was created and solved.

| Parameter | Value |
|---|---:|
| Shell pressure | 0.070 MPa |
| Skin thickness | 1.5 mm |
| Total B_Band thickness | 4.0 mm |
| Added reinforcement thickness | 2.5 mm |
| Skin offset | Middle |
| Band membrane offset | −1.25 mm |
| Geometry | Nominal baseline |
| Mesh | Existing structural mesh retained |

The band offset was calculated for the intended Bottom-face alignment under the stated common-reference-surface and common-normal convention:

d_band = (1.5 − 4.0) / 2 = −1.25 mm

The five pressure-scaled SURF156 load groups used were:

| Load group | Applied components |
|---|---|
| Hoop upper | Y = −54.491, Z = +128.89 N/mm |
| Hoop lower | Y = −54.491, Z = −128.89 N/mm |
| Axial start | X = −69.930 N/mm |
| Axial end | X = +69.930 N/mm |
| Opening edge | Y = +7.2393 N/mm |

The original structural mesh was retained:
- 84,623 nodes
- 28,135 SHELL281 elements
- 964 SURF156 elements
- 29,099 total elements

### Coupled case results

| Result | Value |
|---|---:|
| Maximum von-Mises stress | 591.07 MPa |
| Average von-Mises stress | 95.469 MPa |
| Minimum von-Mises stress | 14.044 MPa |
| Maximum total deformation | 14.90 mm |
| Average total deformation | 1.807 mm |

Solver status:
- Seven substeps completed.
- Final solution time: 1.0.
- Solver errors: 0.
- Solver warnings: 3.

The warnings concerned inactive element shape checking, material 4 lacking MP/TB data for energy reporting, and a zero reference moment in the convergence check.

The project was archived separately as:

`FUSESAFE_D5_Task6_Coupled_070MPa_1p5mm_Completed.wbpz`

The coupled case is exploratory because the original SURF156 load derivation remains unconfirmed and the actual shell normal directions have not been independently established.

## 7. Remote Skin Stress Review – Task 7

A separate Equivalent (von-Mises) Stress result was scoped to the `B_Skin` named selection, with Position set to Top/Bottom.

Skin-only result:

| Measurement | Value |
|---|---:|
| Maximum skin stress | 290.8 MPa |
| Average skin stress | 85.523 MPa |
| Minimum skin stress | 14.044 MPa |

The maximum skin stress marker appeared near the window opening region.

Four selected remote skin locations were probed:

| Probe | Node ID | Stress |
|---|---:|---:|
| 1 | 4376 | 82.973 MPa |
| 2 | 22372 | 81.821 MPa |
| 3 | 72906 | 74.302 MPa |
| 4 | Not displayed | 78.801 MPa |

Fourth probe coordinates:
- X = 1043.192472 mm
- Y = 1920.420791 mm
- Z = −566.547045 mm

The highest of the four sampled remote-point stresses was 82.973 MPa.

All four readings were below the provisional allowable stress of 145 MPa. However, these are point samples and do not establish the maximum stress over the entire remote skin region.

Evidence screenshot:

`D5_Task7_RemoteSkin_Probe_Readings.png`

## 8. Supported Findings

The Day 5 studies support the following limited findings:

1. The baseline 0.055 MPa structural model converged and produced a maximum stress of 464.23 MPa and maximum deformation of 13.157 mm.
2. In the investigated 0.055 MPa thickness cases, increasing skin thickness from 1.5 mm to 2.5 mm reduced maximum stress and deformation.
3. The MATLAB App and backend FoS reassessment use Required FoS as an acceptance threshold and do not change the underlying structural loads.
4. Member 2's geometry handoff reports passing section and connectivity audits for the six selected geometry endpoint exports.
5. The separate 0.070 MPa and 1.5 mm coupled case converged numerically.
6. Four sampled remote skin locations in the coupled case were below the provisional 145 MPa allowable stress.

These findings apply only to the tested configurations and assumptions.

## 9. Unresolved Limitations and Required Verification

### Material properties
The 290 MPa yield strength is provisional and must be confirmed against the final approved material specification, temper, product form and thickness. Material records have shown a discrepancy, so a definitive material allowable must not be claimed.

### SURF156 load derivation
The original calculation sheet or source script for the five SURF156 load groups remains unavailable. Reconstructed resultants suggest a connection to baseline pressure, but the exact scaling basis and potential double counting have not been confirmed. Pressure-scaled cases remain exploratory.

### Shell normal directions and offset
The −1.25 mm band offset follows Member 2's stated common-reference-surface and common-normal convention for Bottom-face alignment. Actual shell normals and physical face alignment still require independent verification in the exact coupled model.

### Geometry and mesh
The six geometry endpoint exports passed the reported geometry and connectivity audits, but not every archive was restore-tested. The nominal regenerated geometry mesh differs from the original structural baseline mesh. Mesh convergence has not been demonstrated.

### Thickness range
The 1.5 mm skin used in the coupled case is outside the 1.8–3.0 mm range covered by Member 2's Day 5 geometry and mesh validation. It is therefore a separate exploratory structural case.

### Pressure-only nonconvergence
The original 0.040 MPa and 0.070 MPa pressure-only cases failed to converge. Their failure causes remain inconclusive; no valid final stress or deformation results should be reported for those runs.

### Remote skin assessment
Only four remote skin points were probed. A full-field remote-region maximum has not been established.

### Structural safety
Numerical convergence does not establish structural safety. The current studies are educational static analyses and are not certification or proof of aircraft structural safety.

## 10. Evidence References

Detailed task-level records are maintained separately:

- `DAY5_TASK5_GEOMETRY_REVIEW.md`
- `DAY5_TASK6_COUPLED_CASE_REVIEW.md`
- `DAY5_TASK7_REMOTE_SKIN_REVIEW.md`

Additional supporting evidence:
- Pressure and skin thickness ANSYS result screenshots and archives.
- Member 3 MATLAB App FoS screenshots (to be uploaded).
- Member 4 backend verification and `structural_assessment.csv`.
- Coupled case archive and solver output.
- Remote skin probe screenshot.

## 11. Final Day 5 Conclusion

Day 5 pressure, thickness, FoS, geometry review, coupled-case and remote-skin assessment activities have been completed and documented.

The main numerical studies converged where reported, and the MATLAB App/backend FoS acceptance behaviour was verified by Members 3 and 4.

The remaining limitations—particularly material-property confirmation, original SURF156 load derivation, shell-normal verification, archive restoration and mesh convergence—must remain visible in any subsequent report or design interpretation.

**Day 5 evidence consolidation completed. The results are limited to the tested educational analysis cases and do not establish aircraft structural safety.**
