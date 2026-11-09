# Day 5 – Task 5: Geometry Variation Review

## 1. Objective

Review the six recommended geometry variations provided by Member 2 for the FUSESAFE structural sensitivity study.

This task covers geometry and mesh validation evidence only. No structural loads, supports, or structural simulations were added or performed for these six geometry cases.

## 2. Geometry Variation Matrix

The nominal geometry and six recommended alternatives are listed below. Each alternative changes one parameter at a time.

| Case | Window Width (mm) | Window Height (mm) | Panel Midsurface Radius (mm) |
|---|---:|---:|---:|
| Nominal baseline | 400 | 400 | 2000 |
| Width low | 250 | 400 | 2000 |
| Width high | 500 | 400 | 2000 |
| Height low | 400 | 300 | 2000 |
| Height high | 400 | 550 | 2000 |
| Radius low | 400 | 400 | 1500 |
| Radius high | 400 | 400 | 2500 |

## 3. Parameters Held Fixed

Across the six comparisons, the following parameters remain fixed:

| Parameter | Value |
|---|---:|
| Inner window corner radius | 40 mm |
| Reinforcement band width | 50 mm |
| Outer band corner radius | 90 mm |
| Panel axial length | 1600 mm |
| Developed circumferential length | 1600 mm |
| Skin thickness | 2 mm |
| Total B_Band thickness | 4 mm |
| Material, supports and nominal shell pressure | To be kept consistent in any later structural comparison |

The total B_Band thickness is the skin thickness plus 2 mm reinforcement.

## 4. Geometry and Mesh Evidence

According to Member 2's Day 5 handoff:

- All six selected individual geometry endpoint exports passed the reported section and connectivity audits.
- The W500/H400/R2000 case must use the Hard10mm archive.
- The earlier W500 Review and NoDefeat exports have an interface irregularity and must not be used as passing simulation sources.
- The W500 Hard10mm mesh uses B_Band face sizing of 0.01 m, Hard behavior and mesh defeaturing disabled.

### Nominal Automation Baseline

Recommended matching files:

- `FUSESAFE_M2_Day5_NominalBaseline_Automation.wbpz`
- `FUSESAFE_M2_Day5_NominalBaseline_Automation.dat`

Reported configuration:
- W400/H400/R2000 mm
- Skin thickness: 2 mm
- Total B_Band thickness: 4 mm
- Material listed in handoff: Structural Steel
- Skin offset: Middle
- Band offset: User Defined, membrane offset −0.001 m

Reported regenerated mesh:

| Mesh metric | Value |
|---|---:|
| Nodes | 9,845 |
| Shell elements | 3,217 |
| Quad8 | 3,065 |
| Tri6 | 152 |
| Minimum element quality | 0.61901 |
| Average element quality | 0.97054 |
| Maximum element quality | 0.99993 |

The nominal regenerated mesh differs from the original structural baseline mesh. Restoration comparison of the nominal archive against its matching DAT file remains pending.

## 5. Individual Geometry Archive References

Each geometry case has a matching `.dat` export and `.wbpz` archive.

| Geometry | Archive filename stem |
|---|---|
| W250/H400/R2000 | `FUSESAFE_M2_Day5_W250_H400_R2000_Skin2_Band4_Review` |
| W500/H400/R2000 | `FUSESAFE_M2_Day5_W500_H400_R2000_Skin2_Band4_Hard10mm` |
| W400/H300/R2000 | `FUSESAFE_M2_Day5_W400_H300_R2000_Skin2_Band4_Review` |
| W400/H550/R2000 | `FUSESAFE_M2_Day5_W400_H550_R2000_Skin2_Band4_Review` |
| W400/H400/R1500 | `FUSESAFE_M2_Day5_W400_H400_R1500_Skin2_Band4_Review` |
| W400/H400/R2500 | `FUSESAFE_M2_Day5_W400_H400_R2500_Skin2_Band4_Review` |

## 6. Offset and Rebuild Checks

For any later geometry rebuild:

- Keep the skin offset at Middle.
- Retain the nominal band offset of −1 mm for the 2 mm skin and 4 mm total band.
- Verify skin and band normals.
- Confirm intended physical-face alignment.
- Check named selections, skin–band connectivity and shell sections.
- Regenerate the mesh for the changed geometry using a consistent meshing procedure.

## 7. Limitations and Pending Verification

1. The nominal archive still requires restoration comparison against its matching DAT file.
2. Not every archive has been restore-tested.
3. The nominal regenerated mesh differs from the original structural baseline mesh.
4. Structural response of the six geometry variations has not been established.
5. Mesh validation alone does not establish structural safety or mesh convergence.
6. Structural material, loads, supports and pressure-dependent boundary-load treatment must be verified separately before future structural comparisons.
7. Corner-radius and band-width variations are outside the six approved comparisons and require separate agreement.

## 8. Conclusion

The Day 5 geometry variation review has been documented using Member 2's geometry and mesh handoff.

The six recommended geometry alternatives and their fixed parameters have been identified. The handoff reports that the selected endpoint exports passed section and connectivity audits, with the W500 Hard10mm archive as the required exception.

No structural simulations were performed as part of this review. Archive restoration, structural sensitivity and mesh convergence remain separate verification activities.

**Task 5 scope: Geometry and mesh review only.**
