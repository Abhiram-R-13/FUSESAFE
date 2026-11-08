# Case B — Provisional AA 2024-T3 Material Revision R01

ANSYS version: 2025 R1.
Archive: FUSESAFE_M2_CaseB_AA2024T3_Provisional_R01.wbpz
Source: separate copy of FUSESAFE_M2_Day6_FinalModel_R01.
Original Day5/Day6 archives were preserved.

## Material update
AA2024_T3_Bare_Provisional is assigned to the single shell body
covering both skin and reinforcement-band regions.

Working properties confirmed by the team:
- Young's modulus: 73.1 GPa (7.31E10 Pa).
- Poisson's ratio: 0.33.
- Density: 2780 kg/m³.
- Tensile yield strength: 290 MPa (2.9E8 Pa), provisional.

Elastic properties and density were carried forward from the team's
FUSESAFE_2024_T3_PROVISIONAL material definition.
The team reports consistency with typical ASM/MatWeb references;
those references were not independently verified in this update.

Material records must be distinguished:
- Day6 source: Structural Steel, 250 MPa yield, directly observed.
- Earlier provisional AA 2024-T3: 345 MPa yield, reported by team.
- This revision: provisional AA 2024-T3, 290 MPa tensile yield.

Latest AMS4037S verification and actual material certification
remain pending. This is an idealized educational material model.

## Acceptance criterion
Required yield-based factor of safety: 2.0.
Provisional equivalent-stress threshold: 145 MPa.
This criterion addresses yielding only.
Buckling, attachment/load transfer, and fatigue are outside it.
No structural results or safety factors were calculated in this update.

## Geometry and mesh
Material-only update; no geometry or thickness edits were made.
Skin thickness: 2 mm.
Current reinforced-region total thickness: 4 mm (2 mm added).
Existing mesh GUI counts:
9845 nodes, 3217 shells: 3065 Quad8 and 152 Tri6.
Matching counts do not constitute a new connectivity audit.
Mesh was not regenerated during this material update.

## Thickness convention for later optimization
Total reinforced-region candidates: 2, 3, 4, 7 mm.
Corresponding added thickness: 0, 1, 2, 5 mm.
Do not add skin thickness twice.
Current P3=P4+0.002 [m] retains fixed 2 mm added thickness.
Variable added-thickness parameterization was not implemented here.

## Open and inspect
1. In Workbench 2025 R1, use File > Open and choose the WBPZ.
2. Restore into a new separate destination folder.
3. Inspect Engineering Data and the shell body's material assignment.
4. Confirm saved mesh counts and thickness assignments.
Archive restored and checked by Member 2 on 9 November 2026 in a separate folder. GUI inspection confirmed the four working material properties, shell-body material assignment, skin 2 mm with Middle offset, band total 4 mm with -1 mm user-defined offset, and 9845 nodes / 3217 shells (3065 Quad8, 152 Tri6). No mesh regeneration, connectivity audit, or solve was performed during this restoration check.
No loads/supports were changed and no structural solve was performed.
Structural setup requires separate team confirmation.

## Evidence
- CaseB_R01_AA2024T3_Properties.png
- CaseB_R01_AA2024T3_Assignment.png
- CaseB_R01_MeshCounts.png
- CaseB_R01_ProvisionalYield290.png
