# Case B — Day 3 Geometry Regeneration Tests

Independent opening-width, opening-height and fuselage-radius
changes were regenerated and remeshed. The baseline was restored
after testing.

These tests use the parametric geometry project. They are separate
from the R05-based Day 3 convergence meshes.

## Test cases

| Case | Width (m) | Height (m) | Radius (m) | Nodes | Elements |
|---|---:|---:|---:|---:|---:|
| Baseline | 0.400 | 0.400 | 2.000 | 9764 | 3188 |
| Width change | 0.410 | 0.400 | 2.000 | 9710 | 3170 |
| Height change | 0.400 | 0.410 | 2.000 | 9241 | 3019 |
| Radius change | 0.400 | 0.400 | 2.100 | 9603 | 3139 |
| Restored baseline | 0.400 | 0.400 | 2.000 | 9764 | 3188 |

Width and height cases were verified during the preceding
parametric-model work. The radius case was completed during Day 3.

All three changed cases regenerated and remeshed successfully.

## Parameter mappings

| Parameter | Meaning | Baseline |
|---|---|---|
| B2_D1 / D1 | Opening axial width | 400 mm |
| B2_D2 / D2 | Opening developed circumferential height | 400 mm |
| B18 radius literals | Fuselage radius | 2 m |

Radius is currently defined in the B18 custom script, rather than
exposed as a Workbench input parameter.

Both expressions must use the same radius R in metres:

- Vector.Create(0, R, 0.8)
- Point.Create(1.6, R, 0)

Keep History Tracking open during edits. Accept the inner script
editor, then regenerate using History Tracking's Continue control.

## Preserved geometry and assignments

- One connected surface body with separate skin and band faces.
- Eight shared CAD edges at the skin–band interface.
- Skin thickness: 0.002 m, Middle offset.
- Band thickness: 0.004 m, User Defined membrane offset -0.001 m.
- Both thickness assignments unsuppressed.
- Quadratic shell mesh; global size 0.04 m and band size 0.01 m.
- Named selections checked after updates and baseline restoration.

Named-selection scopes:

| Named selection | Scope |
|---|---|
| B_Skin | One skin face |
| B_Band | One reinforcement-band face |
| B_OpeningEdge | Eight inner-hole edges |
| B_CircumferentialSides | Two straight outer edges parallel to X |
| B_AxialEnds | Two curved outer edges at constant X |

## Connectivity verification

| Case | Complete shared quadratic sides | Shared nodes |
|---|---:|---:|
| Baseline before tests | 179 | 358 |
| Width change | 182 | 364 |
| Height change | 177 | 354 |
| Radius change | 174 | 348 |

Each test found zero overlapping skin/band elements.
Matched interface sides contained all three quadratic side nodes,
with one skin element and one band element per side.

## Radius case details

- Radius: 2.1 m.
- Opening width and height: 0.4 m each.
- Skin: 7136 nodes and 2298 elements.
- Band: 2815 nodes and 841 elements.
- Union: 9603 nodes and 3139 elements.
- Element types: 2987 Quad8 and 152 Tri6.
- Shared interface: 174 complete quadratic sides and 348 nodes.
- Zero bad interface sides.
- Zero shared nodes missing complete sides.
- Mechanical showed zero errors and zero warnings after meshing.
- Geometry report confirmed one body, two faces, eight shared
  edges and twelve boundary edges.
- Sampled CAD normals remained outward.

The geometry checker retained its 2 m reference and reported a
0.1 m radial difference for the 2.1 m case. This is the intended
radius change, not an error relative to the test radius.

## Element quality

| Case | Minimum | Average | Maximum |
|---|---:|---:|---:|
| Baseline | 0.68406 | 0.97183 | 0.99993 |
| Radius change | 0.70163 | 0.97052 | 0.99996 |

Width- and height-variant quality minima were not recorded.

## Baseline restoration

B18 was restored to a radius of 2 m, with D1 and D2 at 400 mm.
Geometry was regenerated, Workbench Geometry updated, Model
refreshed and the mesh regenerated.

The restored mesh reproduced the original counts:

- 9764 nodes.
- 3188 elements.
- 3046 Quad8 and 142 Tri6.
- 3288 corner nodes and 6476 midside nodes.

The operator confirmed that named-selection scopes, thickness
assignments and baseline quality matched the earlier baseline.

A new connectivity export was not run after the final restoration;
the original baseline connectivity evidence is recorded separately.

## Files

- FUSESAFE_M2_Parametric_Radius2100_Verified.wbpz
  — saved radius-test project archive.
- FUSESAFE_M2_Day3_Baseline_Restored.wbpz
  — saved restored-baseline project archive.
- M2_Radius_2100_Mesh_check.json
  — radius-case mesh membership and connectivity report.

## Limitations

These are geometry-regeneration and mesh-verification tests.
No structural solve or structural convergence assessment was
performed on this parametric project.

The two new archives have not yet been restore-tested.
Earlier failed history operations and their fixes are documented
in the preceding parametric-model verification record.
