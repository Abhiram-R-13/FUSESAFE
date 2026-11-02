# FUSESAFE — Geometry Parameters and Verification Status

Updated: 3 November 2026.

## 1. Project scope

FUSESAFE is an educational structural-analysis project studying
a curved cylindrical fuselage panel and the effects of a window
opening with surrounding reinforcement.

Two geometry cases are maintained separately:

- Case A: intact curved panel.
- Case B: curved panel with a centred rounded rectangular opening
  and reinforcement band.

Geometry and mesh verification do not establish structural
validation or real aircraft safety.

## 2. Software and local workspace

Current Member 2 work uses:

- Ansys Workbench 2025 R1.
- Ansys Discovery Enterprise 2025 R1.
- Ansys Mechanical Enterprise 2025 R1.

Case A retains its earlier DesignModeler geometry history.
Earlier Case B construction history is retained in the R05 lineage.
The newer parametric Case B geometry uses Discovery history and
a custom wrapping script.

Current local work folder:

C:\Users\abhir\FUSESAFE_Work

Earlier paths and software descriptions in historical records
refer to previous working environments.

## 3. Model lineages and intended use

### Case A benchmark

Current mesh benchmark:

FUSESAFE_M2_A_MeshTrial_R02.wbpz

This is the intact-panel benchmark for loading verification and
restraint-location sensitivity work.

Do not substitute A_Intact or R01 for the R02 benchmark.

### Original Case B R05

Geometry source selected for Day 3 convergence preparation:

FUSESAFE_M2_B_MeshTrial_R05.wbpz

A separate previously verified archive is also retained:

FUSESAFE_M2_B_R05_Verified.wbpz

Original R05 sizing:

- Global element size: 0.040 m.
- B_Band element size: 0.010 m.
- Nodes: 9583.
- Elements: 3125.
- Element types: 2991 Quad8 and 134 Tri6.

Original R05 remains unchanged and separate from the new
convergence models.

### Parametric Case B

Baseline archive:

FUSESAFE_M2_Parametric_Mesh_R01_Final.wbpz

This separate project was used for independent width, height
and radius regeneration tests.

Its baseline mesh has 9764 nodes and 3188 elements.
It must not be confused with the original R05 mesh.

### Day 3 convergence models

Three separate projects were derived from restored R05 geometry.

See:

[Case B convergence models](Case_B/Day3_Convergence/README.md)

### Day 3 geometry tests

Independent parameter tests and baseline restoration are documented in:

[Geometry regeneration tests](Case_B/Day3_Geometry_Tests/README.md)

## 4. Coordinates and panel dimensions

Global X is the cylinder axis and panel axial direction.

The baseline panel is centred circumferentially about global +Y.

Baseline midsurface mapping, with coordinates in metres:

r(x, theta) = (x, 2 cos(theta), 2 sin(theta))

Baseline ranges:

- x: 0 to 1.6 m.
- theta: -0.4 to +0.4 radians.

At the circumferential centreline:

- Radial outward direction: +Y.
- Circumferential tangent: along Z.

Away from the centreline, radial and tangential directions vary.

| Quantity | Baseline |
|---|---:|
| Axial length | 1.600 m |
| Developed circumferential span | 1.600 m |
| Shell reference-surface radius | 2.000 m |
| Skin thickness | 0.002 m |
| Opening axial width | 0.400 m |
| Opening developed circumferential height | 0.400 m |
| Inner corner radius | 0.040 m |
| Band developed width | 0.050 m |
| Outer developed bounding width | 0.500 m |
| Outer developed bounding height | 0.500 m |
| Outer corner radius | 0.090 m |
| Total band thickness | 0.004 m |

Opening height refers to developed circumferential length,
not its planar projection.

The opening is centred axially and circumferentially.

For radius R and developed panel span L, the total angular span is:

theta_total = L / R

At baseline:

theta_total = 1.6 / 2 = 0.8 radians

This is approximately 45.84 degrees total.

Dimensions are educational development assumptions.

## 5. Parametric geometry mappings

These mappings belong to the newer parametric Case B project.
They are not established as editable parameters in the separate
R05-derived convergence projects.

| History identifier / label | Meaning | Baseline |
|---|---|---:|
| B2_D1 / D1 | Opening axial width | 400 mm |
| B2_D2 / D2 | Opening developed circumferential height | 400 mm |
| B18 radius literals | Fuselage radius | 2 m |

D1 and D2 were independently edited and regenerated.

Radius is currently controlled by two literals in the B18 custom
script. It is not exposed as a Workbench input parameter.

Both expressions must use the same radius R in metres:

- Vector.Create(0, R, 0.8)
- Point.Create(1.6, R, 0)

The baseline uses R = 2.0.
The radius test used R = 2.1.

Other axial and developed-span dimensions were retained.

### Corner-radius limitation

The baseline inner corner radius is 40 mm.

The width and height tests retained this value. An automatic rule
such as 0.10 × min(width, height) has not been implemented or
demonstrated.

The separate recorded corner-round operations must remain intact.

### History handling

Keep Discovery History Tracking open during geometry edits.

Accept changes using the inner custom-script editor close control,
then regenerate through History Tracking's Continue control.

Do not confuse the custom editor's Debug triangle with History
Tracking's Continue control.

Edits to a standalone Discovery file do not automatically update
the Workbench-linked internal SYS geometry.

## 6. Geometry and named selections

Case A contains one intact surface face.

Case B contains one connected surface body with:

- One skin face.
- One reinforcement-band face.
- A removed centre opening.
- Eight shared CAD edges between skin and band.

### Case A named selections

| Name | Scope |
|---|---|
| A_Skin | One face |
| A_AxialEnds | Two curved edges at constant X |
| A_CircumferentialSides | Two straight edges parallel to X |

### Case B named selections

| Name | Scope |
|---|---|
| B_Skin | One skin face |
| B_Band | One band face |
| B_OpeningEdge | Eight inner-hole edges |
| B_AxialEnds | Two curved outer edges at constant X |
| B_CircumferentialSides | Two straight outer edges parallel to X |

Named selections were checked during parameter tests and mesh
preparation.

Scoping Wizard reported no current missing references in the
three convergence models.

## 7. Shell thickness and offsets

Verified Case B assignments:

| Region | Thickness | Offset type | Membrane offset |
|---|---:|---|---:|
| B_Skin | 0.002 m | Middle | — |
| B_Band | 0.004 m | User Defined | -0.001 m |

Both assignments are unsuppressed and scoped through the
corresponding named selections.

The body-level thickness is Manual, 0.002 m, Middle.

Body stiffness is Membrane and Bending.

The band represents 0.004 m total thickness, including the
0.002 m skin contribution.

With verified outward normals, the intended physical bounds are:

- Skin: -0.001 m to +0.001 m relative to the reference surface.
- Band: -0.001 m to +0.003 m relative to the reference surface.

The offset values were verified in Mechanical. Final structural
decks must retain the intended section definitions.

## 8. Material

Material assigned in the inspected R05-derived convergence models:

FUSESAFE_2024_T3_PROVISIONAL

Recorded preliminary properties:

| Property | Value |
|---|---:|
| Young's modulus | 7.31 × 10^10 Pa |
| Poisson's ratio | 0.33 |
| Density | 2780 kg/m³ |
| Tensile yield strength | 3.45 × 10^8 Pa |

These are provisional educational properties, not certified
sheet-specific design allowables.

Material identity was preserved during convergence preparation.
This does not establish final material approval or confirm the
assignment in any separately solved project.

The material assignment in the separate parametric project must
be confirmed before structural setup.

Material source documentation was previously identified as:

validation/material_selection.md

Its current branch and merge status are not verified here.

The stated factor of safety is 2. It is an evaluation criterion;
it is not an instruction to double the benchmark loads.

## 9. Independent geometry regeneration tests

| Case | Width (m) | Height (m) | Radius (m) | Nodes | Elements |
|---|---:|---:|---:|---:|---:|
| Parametric baseline | 0.400 | 0.400 | 2.000 | 9764 | 3188 |
| Width test | 0.410 | 0.400 | 2.000 | 9710 | 3170 |
| Height test | 0.400 | 0.410 | 2.000 | 9241 | 3019 |
| Radius test | 0.400 | 0.400 | 2.100 | 9603 | 3139 |
| Final restored baseline | 0.400 | 0.400 | 2.000 | 9764 | 3188 |

All three changed cases regenerated and remeshed successfully.

Named selections and thickness assignments were checked after
updates and baseline restoration.

### Shared interface verification

| Case | Complete quadratic sides | Shared nodes |
|---|---:|---:|
| Original parametric baseline | 179 | 358 |
| Width test | 182 | 364 |
| Height test | 177 | 354 |
| Radius test | 174 | 348 |

The tests found zero overlapping skin/band elements.
Each matched interface side included its two corner nodes and
midside node, with one skin and one band element.

Final restored-baseline mesh counts and quality matched the
original baseline. A new connectivity export was not run after
that final restoration.

Radius-test quality:

- Minimum: 0.70163.
- Average: 0.97052.
- Maximum: 0.99996.

Baseline quality:

- Minimum: 0.68406.
- Average: 0.97183.
- Maximum: 0.99993.

Width- and height-test quality minima were not recorded.

## 10. Case B convergence meshes

The original R05 40/10 mm configuration remains separate.

| Level | Global size (m) | Band size (m) | Nodes | Elements | Quad8 | Tri6 |
|---|---:|---:|---:|---:|---:|---:|
| Coarse | 0.040 | 0.020 | 6299 | 2033 | 1977 | 56 |
| Medium | 0.020 | 0.010 | 21419 | 7045 | 6855 | 190 |
| Fine | 0.010 | 0.005 | 84466 | 27974 | 27554 | 420 |

These are configured sizing inputs, not measurements of every
element. Band sizing uses Soft behavior.

The medium mesh is a new refinement of R05 and is the agreed
baseline for the three-level structural comparison.

### Connectivity

| Level | Complete shared quadratic sides | Shared nodes |
|---|---:|---:|
| Coarse | 91 | 182 |
| Medium | 179 | 358 |
| Fine | 351 | 702 |

All three reported:

- Zero overlapping skin/band elements.
- Zero bad interface sides.
- Zero shared nodes missing complete sides.

### Element quality

| Level | Minimum | Average | Maximum |
|---|---:|---:|---:|
| Coarse | 0.63293 | 0.98004 | 0.99999 |
| Medium | 0.58277 | 0.98065 | 0.99999 |
| Fine | 0.71360 | 0.97951 | 0.99999 |

### Open sizing warning

Medium and fine display a warning that some local face element
sizes exceed the global maximum size.

The intended global and B_Band inputs were verified.
The warning's cause remains unresolved.

Connectivity checks and quality statistics do not resolve this
warning. It must remain documented for structural review.

License-response and possible lost-scoping warnings also appear
in message history. Scoping Wizard found no current missing
references.

Separate archives, connectivity reports and opening screenshots
were prepared and uploaded. Restoration of the three new
convergence archives has not yet been tested.

## 11. Case A loading benchmark

The agreed Case A verification benchmark uses loads referenced
to the 2 m shell midsurface:

| Quantity | Value |
|---|---:|
| Outward pressure | 55000 Pa |
| Axial membrane resultant Nx | 55000 N/m |
| Circumferential membrane resultant Ntheta | 110000 N/m |

Theoretical thin-cylinder membrane stress references for
0.002 m thickness:

- Hoop stress: 55 MPa.
- Axial stress: 27.5 MPa.
- Von Mises stress: approximately 47.63 MPa.

These are theoretical references, not verified simulation results.

Pressure direction and edge-traction directions must follow the
actual shell geometry.

SHELL281 pressure-face conventions must be checked against the
actual solved deck. A face label alone does not establish the
intended physical loading.

Do not mix this midsurface benchmark with a physical inner-radius
loading convention without updating the analytical and MATLAB
reference calculations consistently.

The exported R02 mesh dataset did not itself contain applied loads.

## 12. Supports and structural validation

The original Case A R02 model must remain unchanged during
restraint-location sensitivity comparisons.

Alternative support-node coordinates and a 3-2-1 translational
constraint arrangement were prepared separately.

The alternative configuration passed a rank-6 rigid-body
constraint check. This is not proof of full shell stability,
correct equilibrium or acceptable stresses.

Member 1 reported an initial Case A solve.
Completed solved result files were not supplied to this workflow,
so its numerical results have not been independently verified here.

Member 4 is preparing MATLAB comparison structures and awaiting
the two solved result sets.

Case A results remain preliminary pending:

- Solver stability and warning review.
- Actual applied-load verification.
- Force and moment equilibrium.
- Reaction checks.
- Restraint-location sensitivity.
- Stress and displacement comparisons.

Case B convergence meshes are prepared, but structural solves
and result-convergence assessment remain pending.

## 13. Handoff and ownership

- Preserve Case A and Case B as separate model lineages.
- Preserve original R05 separately from convergence refinements.
- Keep the parametric geometry-test project separate from R05.
- Use separate projects for coarse, medium and fine meshes.
- Avoid simultaneous editing of the same binary Ansys project.
- Member 1 received the convergence-mesh handoff.
- Parameter mappings are documented for Member 4.
- Agree binary-project ownership before shared editing.

## 14. Remaining checks

- Restore-test the new convergence and geometry-test archives
  into separate locations.
- Investigate the unresolved medium/fine sizing warning.
- Confirm final material and section assignments in solved decks.
- Complete structural stability, equilibrium and sensitivity checks.
- Complete the structural mesh-convergence comparison.
- Confirm parameter integration with Member 4.
- Coordinate branch integration with the team.

Keep earlier archives and verification records as historical
evidence. Do not treat mesh preparation as completed structural
validation.
