# FUSESAFE Member 2 — Day 4 reinforcement input verification

Verification record prepared 4 November 2026. Ansys Workbench/Mechanical 2025 R1. These are input-verification cases, not solved structural results.

## Full export comparison — PASS

All four complete DAT files were compared line by line against Added0mm. Only lines 29418 (band SECDATA) and 29419 (band SECOFF) differ in the three positive-addition cases. All other lines are identical, including material definitions, node IDs/coordinates, element attributes/connectivity, component memberships and section assignment commands. Block SHA-256 hashes and exact differences are in mesh_comparison.json.

- 21,419 actual node records; NBLOCK header maximum ID is not the actual node count.
- 7,045 elements. EBLOCK is identical across all four cases.
- Skin assignment _CM41: 6,182 unique elements.
- Band assignment _CM43: 863 unique elements.
- Assignment intersection: 0 elements. Union: 7,045 elements, covering the exported mesh.
- Identical node components: B_BAND (2,887), B_SKIN (18,890), B_OPENINGEDGE (300), B_CIRCUMFERENTIALSIDES (326), B_AXIALENDS (326).
- Thus coordinates, connectivity, element numbering, interface connectivity and exported named-selection memberships are invariant. Shared skin/band nodes are expected; duplicate shell elements are not present between the assignment sets.
- Export equality verifies the discretized geometry. It does not constitute an independent comparison of underlying CAD history or an archive restoration test.

## Thickness cases and mass

| Added (mm) | Total band (mm) | Offset (mm) | Inner position (mm) | Outer position (mm) | Added mass (kg, approximate) |
|---|---|---|---|---|---|
| 0 | 2 | 0 | -1 | +1 | 0 |
| 1 | 3 | -0.5 | -1 | +2 | 0.23464868 |
| 2 | 4 | -1 | -1 | +3 | 0.46929736 |
| 5 | 7 | -2.5 | -1 | +6 | 1.17324340 |

Positions are along the outward shell normal relative to the unchanged reference surface. Base skin remains 2 mm, Middle offset. The zero-added band stays present with 2 mm thickness and zero offset; the opening is retained.

Material FUSESAFE_2024_T3_PROVISIONAL: density 2780 kg/m^3, E 73.1 GPa, nu 0.33, yield strength 345 MPa (provisional material). Exported density is verified in all cases.

P3 is the current B_Band single curved CAD reference-face surface area, displayed as 0.084406 m^2. This is neither projected area nor an offset outer-face area. Display precision is limited; no extra area digits are claimed. Added mass = density * reference area * added thickness. The table uses the rounded displayed area, so masses are approximate. The 2 mm original skin contribution is excluded. The band is one equivalent homogeneous shell section of total thickness, not a separate overlapping reinforcement shell or an adhesive/contact model.

## Parameters and exact offset convention

- P1: B_Band_4mm Thickness, metres, TOTAL band thickness (the object name is historical).
- P2: B_Band_4mm Membrane Offset, metres; expression `-(P1 - 0.002 [m])/2` entered in the parameter Expression property.
- P3: B_Band Surface Area, m^2, evaluated successfully through Model-cell Update.
- Scope: named selection B_Band; thickness object unsuppressed.
- Solver section 2: skin `secdata,2.e-003`, `secoff,mid`.
- Solver section 3: total band thickness and `secoff,user,OFFSET` as tabulated.

SECOFFSET USER locates the reference nodes relative to the section midplane. With outward-positive normal and offset o, section midplane relative to the reference surface is -o; inner/outer positions are -o - t/2 and -o + t/2. Substitution of o=-(t-0.002)/2 gives a common inner position -0.001 m for every case. This is analytical confirmation from the exported convention and outward-normal assumption, supported by the GUI normal-direction screenshot. The graphical thick-shell step was inconclusive; it is not claimed as a successful independent placement measurement. The source CAD surface remains the original skin reference surface; common inner surface refers to the physical shell bottom, not a newly moved CAD surface.

Official convention reference: [Ansys SECOFFSET command](https://ansyshelp.ansys.com/public/views/secured/corp/v252/en/ans_cmd/Hlp_C_SECOFFSET.html). The command convention is used to interpret the 2025 R1 exported input.

## Warnings and solve status

Observed Mechanical: 0 errors, 5 warnings after writing input:

1. Insufficient constraints to prevent rigid-body motion. This model has no approved structural supports/loads; do not treat it as solve-ready.
2. Material damping selected in the section will not be considered.
3. Some local face element sizes exceed the global maximum size; retained from the convergence baseline, cause unresolved.
4. Historical license-manager response delay.
5. Historical possible lost scoping attachments after geometry update. Prior Day3 Scoping Wizard checks had no missing references; this does not substitute for a new Day4 wizard check. Exported memberships are identical in all four cases.

An accidental Update Project/Refresh was reported. Workbench stated Setup required user input before update; no successful structural solve was indicated. Subsequent Added2mm export differs from the zero case only in the intended two lines. No maximum stress, deformation, or actual FoS is available.

## Files and archive status

The four DAT exports, comparison JSON and normal screenshot are included. The existing archive FUSESAFE_M2_B_Day4_ThicknessTests_Verified.wbpz is included unchanged. It was created after the 2 mm-added case (4 mm total); it must not be relabelled as a verified zero-added baseline archive. The legacy archive is supplementary; the four case-specific archives below are the restoration-checked deliverables.

Four case-specific archives were manually created and restored into separately named Added0/1/2/5mm_RestoreCheck projects. The user opened Mechanical for each and supplied Details screenshots on 4 November 2026. Restored band values matched: 0 added = 0.002 m / 0 m; 1 added = 0.003 m / -0.0005 m; 2 added = 0.004 m / -0.001 m; 5 added = 0.007 m / -0.0025 m. All were User Defined, scoped to B_Band, unsuppressed. Screenshots are included. No manual parameter corrections were requested during these restoration checks. This confirms successful opening and retained band properties through the guided GUI workflow; full post-restoration DAT re-export comparison and CAD regeneration were not performed.

Archives: FUSESAFE_M2_B_Day4_Added0mm_Verified.wbpz, FUSESAFE_M2_B_Day4_Added1mm_Verified.wbpz, FUSESAFE_M2_B_Day4_Added2mm_Verified.wbpz, FUSESAFE_M2_B_Day4_Added5mm_Verified.wbpz.

These are derived from the Day3 Medium R05 mesh lineage, not confirmed identical to Member1's current structural baseline. No loads or supports are defined. Analysis-setting compatibility with Member1 is unverified. These archives are ready for model handoff, NOT structural solving.

Original R05, geometry master and Day3 convergence projects were not modified by this audit. Only the supplied Day4 files were read and copied into this deliverable folder. Geometry master and convergence lineage remain separate. MATLAB setters/regeneration and automated solves remain unvalidated.

## Before structural solves

Archive creation and GUI restoration checks are complete. Obtain Member1's exact baseline filename/version, then agree and verify loads, supports, analysis settings and result extraction definitions with the structural owner. Preserve mesh and input evidence. Actual FoS and stress/deformation results require successful approved solves. Required FoS is an acceptance criterion, not a load multiplier.
