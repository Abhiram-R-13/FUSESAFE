# FUSESAFE — Geometry Parameters and Modelling Plan

## 1. Project Description

FUSESAFE is an educational aircraft fuselage structural analysis project.

The project studies a curved cylindrical fuselage panel under proposed pressure loading. It investigates how a rounded rectangular window opening and surrounding reinforcement affect structural stress and deformation.

Two separate geometry cases are required:

1. Intact curved panel: reference model without an opening or added reinforcement.
2. Window panel: curved panel with a centred rounded rectangular opening and surrounding reinforcement band.

The intact model must remain separate and must not be overwritten by the window model.

This educational model does not establish real aircraft structural safety or certification.

## 2. Software Environment

| Component | Version | Status |
|---|---|---|
| ANSYS Workbench | 2025 R1 | Opened successfully |
| ANSYS Discovery Enterprise | 2025 R1 | Opened successfully |
| ANSYS Mechanical Enterprise | 2025 R1 | Opened successfully |
| MATLAB | To be verified | Pending |

Hardware:
- GPU: AMD Radeon(TM) 680M.
- Discovery reports that Explore and LiveGX Refine are unavailable because the GPU is not CUDA-compatible.
- Discovery reports that a full installation is required for solving.
- Mechanical has opened, but meshing and solver execution remain unverified.

## 3. Coordinate System

The team-approved global coordinate convention is:

| Axis | Direction | Meaning |
|---|---|---|
| X | Axial | Nose-to-tail direction |
| Y | Circumferential | Tangential direction at panel centre |
| Z | Radial | Outward from fuselage centre |

The cylindrical shell axis is along global X.

The window width is measured along X.

The window height is measured along the circumferential surface arc.

## 4. Shared Panel Dimensions

These are provisional development assumptions, not validated aircraft dimensions.

| Parameter | Baseline value |
|---|---:|
| Axial panel length | 1600 mm |
| Circumferential arc length | 1600 mm |
| Shell midsurface radius | 2000 mm |
| Skin thickness | 2 mm |
| Pressure difference | 55 kPa |

The opening is centred axially and circumferentially in the window model.

### Circumferential angle

The total circumferential angle is:

theta = Arc length / Radius

At the baseline radius:

theta = 1600 / 2000 = 0.8 radians

theta = 0.8 × 180 / pi

Baseline total angle = approximately 45.84 degrees.

The panel extends approximately 22.92 degrees on either side of its circumferential centre.

If radius changes, preserve the 1600 mm arc length and recalculate:

theta (degrees) = (1600 / Radius) × (180 / pi)

## 5. Geometry Case 1 — Intact Curved Panel

### Purpose

This is the reference geometry for checking Member 1's proposed loading method before introducing the window opening.

### Specifications

| Parameter | Value |
|---|---:|
| Axial length | 1600 mm |
| Circumferential arc length | 1600 mm |
| Midsurface radius | 2000 mm |
| Skin thickness | 2 mm |
| Window opening | None |
| Added reinforcement | None |

### Required identifiable regions

1. Axial end 1.
2. Axial end 2.
3. Circumferential side edge 1.
4. Circumferential side edge 2.
5. Skin surface.

### Requirements

- Create a curved cylindrical shell midsurface.
- Preserve the specified axial length and circumferential arc length.
- Keep all four boundary edges identifiable.
- Save this as a separate intact reference model.
- Do not introduce an opening or reinforcement.
- Do not apply arbitrary fixed supports or loads during geometry construction.

## 6. Geometry Case 2 — Window Panel

### Purpose

This model investigates the effect of a window opening and additional reinforcement on the curved shell.

### Window specifications

| Parameter | Value |
|---|---:|
| Window width (axial) | 400 mm |
| Window height (circumferential) | 400 mm |
| Window position | Panel centre |
| Corner-radius rule | 0.10 × min(width, height) |
| Baseline inner corner radius | 40 mm |

The window width and height must be independent adjustable parameters.

### Reinforcement specifications

| Parameter | Value |
|---|---:|
| Band width | 50 mm |
| Outer bounding width | 500 mm |
| Outer bounding height | 500 mm |
| Inner corner radius | 40 mm |
| Outer corner radius | 90 mm |
| Added thickness | 2 mm |
| Skin thickness | 2 mm |
| Total band thickness | 4 mm |

The reinforcement band must surround the opening with a constant 50 mm surface offset.

### Required identifiable regions

1. Axial end 1.
2. Axial end 2.
3. Circumferential side edge 1.
4. Circumferential side edge 2.
5. Skin surface.
6. Reinforcement-band surface.
7. Window opening edge.

### Requirements

- Use the same panel dimensions and radius as the intact reference.
- Create a centred rounded rectangular opening.
- Create a separate reinforcement face region.
- Keep the surrounding skin face region separate.
- Ensure the opening edge remains identifiable.
- Ensure the reinforcement band remains identifiable.
- Do not overwrite the intact reference geometry.

## 7. Shell Representation and Thickness

Both initial geometry cases will use shell midsurface representations.

For the window model:

- Skin thickness: 2 mm.
- Added reinforcement thickness: 2 mm.
- Total reinforcement-region thickness: 4 mm.

Thickness assignments and shell offsets must be coordinated before structural analysis.

The geometry must contain separate identifiable face regions so that different shell thicknesses can be assigned later.

## 8. Proposed Loading Information

Status: PROPOSED — not implemented or validated.

Member 1 proposes the following baseline loading:

| Loading quantity | Proposed value |
|---|---:|
| Outward pressure | 55 kPa |
| Axial edge tension intensity | 55 N/mm |
| Circumferential edge tension intensity | 110 N/mm |

Pressure conversion:

55 kPa = 0.055 MPa = 0.055 N/mm².

The proposed membrane actions are:

N_circumferential = p × R = 110 N/mm.

N_axial = p × R / 2 = 55 N/mm.

Pressure is to be applied once to the retained shell surface, with shell normal and pressure sign checked.

Edge tension directions must follow the actual orientation of each boundary.

Line-load intensities must not be confused with pressure values.

A free-body diagram and reaction-equilibrium check are required.

No loads are to be implemented until Member 1 reviews the geometry and mesh.

## 9. Supports and Boundary Conditions

- Do not fix all four edges.
- Do not introduce arbitrary fixed supports.
- Use only constraints required to remove rigid body motion.
- Select the exact constrained nodes and degrees of freedom after geometry and mesh inspection.
- Do not use weak springs as a substitute for a reviewed support definition.

## 10. Intact Reference Validation

Member 1 has supplied the following theoretical reference values:

| Quantity | Reference value |
|---|---:|
| Hoop stress | 55 MPa |
| Axial stress | 27.5 MPa |
| Von Mises stress | Approximately 47.63 MPa |

These values are theoretical thin-walled closed-cylinder membrane references, not Ansys simulation results.

The intact reference model must be checked for:

- Far-field membrane stresses.
- Deformation.
- Load orientation.
- Reaction equilibrium.
- Mesh convergence.
- Boundary-distance sensitivity.

Only after reviewing the intact reference should the window and reinforcement model proceed to structural validation.

## 11. Intended Modelling Workflow

1. Construct the intact curved panel.
2. Save it as a separate reference geometry.
3. Verify dimensions and identifiable boundaries.
4. Construct the window panel as a separate geometry.
5. Verify the opening and reinforcement regions.
6. Transfer geometry into ANSYS Mechanical.
7. Coordinate shell thickness assignments and offsets.
8. Generate and inspect the mesh.
9. Obtain Member 1's approved supports and loading implementation.
10. Validate the intact reference case.
11. Introduce the window and reinforcement analysis.
12. Connect the validated workflow to MATLAB for reinforcement-thickness testing.

## 12. Current Progress

### Verified
- ANSYS Workbench 2025 R1 opens.
- ANSYS Discovery Enterprise 2025 R1 opens.
- ANSYS Mechanical Enterprise 2025 R1 opens.
- Metric modelling units configured in Discovery.
- Team coordinate conventions agreed.
- Provisional panel dimensions received.
- Window and reinforcement dimensions received.
- Member 1's initial loading and support proposal reviewed.

### Pending
- Intact curved panel geometry.
- Window panel geometry.
- Separate skin and reinforcement face regions.
- Named or identifiable boundary regions.
- Geometry regeneration test.
- Shell thickness and offset assignments.
- Mesh generation and verification.
- Approved support and loading implementation.
- Intact reference FEA validation.
- Window model FEA validation.
- MATLAB–ANSYS integration.

## 13. Important Project Notes

- Use ANSYS 2025 R1.
- Preserve the existing FUSESAFE repository and geometry branch.
- Keep the intact and window geometry cases separate.
- Treat panel dimensions as provisional development assumptions.
- Keep the loading approach marked PROPOSED until validated.
- Do not report geometry, meshing or FEA as completed until verified in the actual software.
- A passing numerical stress result does not prove real aircraft safety.
## 14. Material Selection — Aluminium 2024-T3

### Selected preliminary material

The initial educational model uses Aluminium 2024-T3.

Ansys Engineering Data material name:

`FUSESAFE_2024_T3_PROVISIONAL`

### Preliminary material properties

| Property | Value |
|---|---:|
| Young's modulus | 73,100 MPa |
| Young's modulus (SI) | 7.31 × 10^10 Pa |
| Poisson's ratio | 0.33 |
| Density | 2,780 kg/m³ |
| Tensile yield strength | 345 MPa |
| Tensile yield strength (SI) | 3.45 × 10^8 Pa |

### Material status

- Material properties entered and saved in ANSYS Engineering Data by Member 1.
- Material has not yet been assigned to geometry.
- No structural analysis has been solved using this material.
- Member 2 must coordinate with Member 1 before assigning material and shell thicknesses.

### Limitations

These are provisional properties for the initial educational model.

Some values are published typical material properties and are not sheet-specific design allowables.

They must not be treated as certified aircraft design properties or used to establish real aircraft safety.

### Factor of Safety

The required factor of safety is 2.

It is an acceptance criterion for evaluating the analysis results. Do not multiply the applied pressure or proposed edge loads by the factor of safety.

### Source

Material source and limitations are documented in:

`validation/material_selection.md`

This file is currently on the `fea-validation` branch. Its merge into `main` has not yet been confirmed.

