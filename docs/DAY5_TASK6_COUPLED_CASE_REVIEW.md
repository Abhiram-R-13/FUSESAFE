# Day 5 – Task 6: Coupled Demanding Case Review

## 1. Objective

Investigate the combined effect of higher shell pressure and reduced skin thickness using a separate ANSYS structural analysis project.

## 2. Coupled Case Configuration

| Parameter | Value |
|---|---:|
| Shell pressure | 0.070 MPa |
| Skin thickness | 1.5 mm |
| Total B_Band thickness | 4.0 mm |
| Added reinforcement thickness | 2.5 mm |
| Skin offset | Middle |
| Band offset | −1.25 mm |
| Geometry | Nominal baseline |
| Mesh | Existing structural mesh retained |

The band offset was calculated using:

\[
d_{\mathrm{band}}=\frac{t_{\mathrm{skin}}-t_{\mathrm{band}}}{2}
=\frac{1.5-4.0}{2}=-1.25\ \mathrm{mm}
\]

The intended alignment is Bottom face to Bottom face, subject to verification of the actual shell normal directions.

## 3. Boundary Loads

The case used the exploratory pressure-scaled boundary-load values from the 0.070 MPa pressure-consistent project.

| SURF156 load group | Components |
|---|---|
| Hoop upper | Y = −54.491, Z = +128.89 N/mm |
| Hoop lower | Y = −54.491, Z = −128.89 N/mm |
| Axial start | X = −69.930 N/mm |
| Axial end | X = +69.930 N/mm |
| Opening edge | Y = +7.2393 N/mm |

The shell pressure was applied as 0.070 MPa.

The original derivation of the five SURF156 load groups remains unavailable. Their pressure scaling is therefore treated as an exploratory assumption, not a fully validated load derivation.

## 4. Mesh Information

The existing structural mesh was retained.

| Mesh metric | Value |
|---|---:|
| Nodes | 84,623 |
| SHELL281 elements | 28,135 |
| SURF156 elements | 964 |
| Total elements | 29,099 |

No mesh regeneration was performed for this coupled case.

## 5. Structural Results

| Result | Value |
|---|---:|
| Maximum equivalent von-Mises stress | 591.07 MPa |
| Average equivalent stress | 95.469 MPa |
| Minimum equivalent stress | 14.044 MPa |
| Maximum total deformation | 14.90 mm |
| Average total deformation | 1.807 mm |

The maximum stress region is located near the window reinforcement area.

## 6. Solver Status

- Analysis type: Static Structural
- Large deformation: Enabled
- Completed substeps: 7
- Final solution time: 1.0
- Solver errors: 0
- Solver warnings: 3

Reported warnings:
1. Element shape checking was inactive.
2. Material 4 lacked MP/TB property data for energy reporting.
3. The reference moment value was zero for the convergence check.

The solver completed successfully, but the warnings remain part of the result limitations.

## 7. Preliminary Strength Screening

Using the provisional yield strength of 290 MPa:

\[
FoS_{\mathrm{screen}}=\frac{290}{591.07}\approx0.491
\]

For a target FoS of 2:

\[
\sigma_{\mathrm{allowable}}=\frac{290}{2}=145\ \mathrm{MPa}
\]

The calculated maximum stress exceeds this provisional allowable stress.

This is only a preliminary screening calculation. The material strength has not been independently confirmed for the final material specification.

## 8. Limitations

1. The original calculation basis for the five SURF156 loads remains unconfirmed.
2. Pressure scaling of those loads is exploratory.
3. Actual shell normal directions and physical Bottom-face alignment require independent verification.
4. The 1.5 mm skin thickness is outside Member 2's earlier 1.8–3.0 mm geometry and mesh validation range.
5. Mesh convergence has not been established.
6. Numerical solver convergence does not establish structural safety.

## 9. Archive

The coupled analysis was saved separately as:

`FUSESAFE_D5_Task6_Coupled_070MPa_1p5mm_Completed.wbpz`

The original pressure and skin-thickness study projects were kept unchanged.

## 10. Conclusion

The combined 0.070 MPa pressure and 1.5 mm skin case converged successfully in ANSYS with zero solver errors.

The maximum equivalent stress was 591.07 MPa, and the maximum total deformation was 14.90 mm.

The case is classified as an exploratory coupled structural analysis because the original SURF156 load derivation, shell-normal alignment and mesh convergence remain unresolved.

**Day 5 Task 6: Coupled demanding case review completed.**
