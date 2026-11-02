# Case B — Day 3 Mesh Convergence Models

Three mesh levels prepared from the restored
FUSESAFE_M2_B_MeshTrial_R05.wbpz geometry.

The original R05 configuration (40 mm global / 10 mm band)
remains unchanged and separate.

The medium mesh is a new refinement of R05, not the original
R05 baseline. Structural solves and result-convergence assessment
are pending.

## Mesh settings and counts

| Level | Global size (m) | B_Band size (m) | Nodes | Elements | Quad8 | Tri6 |
|---|---:|---:|---:|---:|---:|---:|
| Coarse | 0.040 | 0.020 | 6299 | 2033 | 1977 | 56 |
| Medium | 0.020 | 0.010 | 21419 | 7045 | 6855 | 190 |
| Fine | 0.010 | 0.005 | 84466 | 27974 | 27554 | 420 |

Sizes above are the configured sizing inputs, not measured
dimensions of every element. Band sizing uses Soft behavior.

## Skin–band connectivity

| Level | Skin nodes / elements | Band nodes / elements | Shared nodes | Complete shared quadratic sides |
|---|---:|---:|---:|---:|
| Coarse | 5560 / 1778 | 921 / 255 | 182 | 91 |
| Medium | 18890 / 6182 | 2887 / 863 | 358 | 179 |
| Fine | 74423 / 24575 | 10745 / 3399 | 702 | 351 |

All three connectivity checks reported:

- Zero overlapping skin/band elements.
- Zero bad interface sides.
- Zero shared nodes missing complete quadratic sides.
- One skin element and one band element per matched interface side.

Connectivity was checked using complete three-node quadratic
element sides, including midside nodes.

## Element quality

| Level | Minimum | Average | Maximum |
|---|---:|---:|---:|
| Coarse | 0.63293 | 0.98004 | 0.99999 |
| Medium | 0.58277 | 0.98065 | 0.99999 |
| Fine | 0.71360 | 0.97951 | 0.99999 |

## Preserved model settings

Only global and band mesh sizing inputs were intentionally changed
between convergence levels.

- Geometry and window dimensions retained from R05.
- Material: FUSESAFE_2024_T3_PROVISIONAL.
- Skin thickness: 0.002 m, Middle offset.
- Band thickness: 0.004 m, User Defined membrane offset -0.001 m.
- Body stiffness: Membrane and Bending.
- Quadratic element order and Quad Dominant sheet meshing retained.
- Existing named selections retained.
- Shared skin–band mesh connectivity verified separately at each level.

Material identity is recorded as saved; this does not establish
final material approval for structural analysis.

## Warnings and limitations

Medium and fine projects display:

> Some local face element sizes are larger than the global maximum
> size. This can cause bad quality elements.

The configured global/band inputs were verified as 0.020/0.010 m
for medium and 0.010/0.005 m for fine. The warning's cause remains
unresolved. Connectivity checks and quality statistics do not
resolve this warning.

A possible lost-scoping warning also remains in message history.
Scoping Wizard reported no current missing references across the
coarse, medium and fine models.

A license-manager delayed-response warning was also displayed.
The coarse mesh displayed the scoping and license warnings;
medium and fine additionally displayed the sizing warning.

These are mesh-preparation models. Structural stability, loading,
reaction equilibrium and stress/displacement convergence have not
been established by these checks.

Archives were created by the operator; restoration of the three
new archives has not yet been tested.

## Deliverables

### Coarse

- FUSESAFE_M2_B_Day3_Coarse.wbpz
- M2_B_Day3_Coarse_Mesh_check.txt
- FUSESAFE_M2_B_Day3_Coarse_Opening.png

### Medium

- FUSESAFE_M2_B_Day3_Medium.wbpz
- M2_B_Day3_Medium_Mesh_check.txt
- FUSESAFE_M2_B_Day3_Medium_Opening.png

### Fine

- FUSESAFE_M2_B_Day3_Fine.wbpz
- M2_B_Day3_Fine_Mesh_check.txt
- FUSESAFE_M2_B_Day3_Fine_Opening.png

## Next step

Member 1 will use these levels for structural mesh-convergence
comparison, with medium as the comparison baseline. Original R05
remains available separately for ongoing Day 2 structural work.
