# FUSESAFE Member 2 — Day6 Geometry/Mesh Handoff

ANSYS version: 2025 R1.
Scope: geometry and mesh packaging plus parameter-update demonstration.
Nominal demonstration geometry approved by Member 1; approval relayed on 9 November 2026,
Provisional AA 2024-T3 working properties are agreed and supplied separately in ../Case_B/material_R01/. This Day6 archive retains its original Structural Steel material. AMS4037S verification, material certification, loads, supports, and final analysis specification remain pending.
No structural solve was performed during this Day6 workflow.

## Files
- FUSESAFE_M2_Day6_FinalModel_R01.wbpz: preserved nominal revision.
- FUSESAFE_M2_Day6_Demo_W400_H550.wbpz: separate demonstration copy, ending at W400/H550.
- Ten PNG screenshots: nominal parameters/geometry/band/mesh and width/height demonstrations.

Source and handoff location:
C:\Users\abhir\FUSESAFE_Work\Day6_Handoff

## Nominal geometry
Opening width 400 mm; height 400 mm.
Cylinder midsurface radius 2000 mm.
Panel axial and developed circumferential lengths: 1600 mm each.
Opening corner radius: 40 mm; reinforcement band width: 50 mm.
Skin thickness: 2 mm; total band thickness: 4 mm.
P1 = width; P2 = height; P4 = skin thickness.
P3 = P4 + 0.002 [m], representing total band thickness.

## Observed mesh statistics
Nominal: 9845 nodes, 3217 shells; 3065 Quad8, 152 Tri6.
Width demonstration W500/H400: 10214 nodes, 3334 shells;
3176 Quad8, 158 Tri6.
Height demonstration W400/H550: 10507 nodes, 3431 shells;
3265 Quad8, 166 Tri6.

Both demonstration meshes generated with No Messages visible.
The height-demo counts differ from the Day5 H550 mesh.
Day6 connectivity and mesh-quality audits were not performed.
Day5 validation does not establish validation of the changed Day6 mesh.

## Open an archive
1. In Workbench 2025 R1, select File > Open and choose the WBPZ.
2. When prompted, restore into a new, separate destination folder.
3. Open Model to inspect geometry and the saved mesh.
4. Preserve the supplied archive and original Day3/Day5 projects.
The Day6 archives have been created; restoration has not yet been checked.

## Rebuild a demonstration
1. Work from a separate copy of the nominal project.
2. Open Parameter Set and edit P1/P2.
   Width case: P1=500 mm, P2=400 mm.
   Height case: P1=400 mm, P2=550 mm.
3. Keep P4=0.002 m and P3=P4+0.002 [m].
4. Return to Project; right-click Geometry > Update.
5. Open Model; accept re-reading updated geometry if prompted.
6. Right-click Mesh > Generate Mesh; inspect and save.
Do not use Update All Design Points or Solve for this demonstration.

## Material and verification status
Structural Steel is inherited as geometry/mesh validation material only;
it is not the approved final structural material.
Member4 reported successful restoration and matching mesh/section/material
records for the Day5 nominal automation archive. This is verification
reported by Member4, not a Day6 archive restoration check.

## Presentation explanation
The nominal geometry/mesh revision is preserved separately.
Width and height were changed through independent Workbench parameters.
Geometry was rebuilt and meshes regenerated in a demonstration copy.
Band total thickness remains linked to skin thickness plus 2 mm.
This demonstrates geometry/mesh updating, not structural performance.
