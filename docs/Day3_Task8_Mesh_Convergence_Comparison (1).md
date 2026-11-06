# FUSESAFE Day 3, Task 8: Mesh convergence and manual-vs-automated comparison

**Date:** 6 November 2026
**Case:** B (window + reinforcement band), R05 setup, Large Deflection ON, direct pressure on SHELL281 Face 1 (`_CM41` skin, `_CM43` band, 0.055 MPa), solver units nmm.
**Status:** Preliminary convergence evidence. This is not a formal convergence study and not a validation of an aircraft structure.

## 1. Results by mesh

Global size / band size in mm. Stress is maximum equivalent (von Mises), Top/Bottom, Averaged.

| Mesh | Global / band | Nodes | SHELL281 | Total elements | Max stress (MPa) | Max deformation (mm) |
|---|---|---:|---:|---:|---:|---:|
| Baseline R05 (manual) | 40 / 10 | 9,583 | 3,125 | n/r | 468.06 | 13.153 |
| Coarse (Member 2) | 40 / 20 | 6,299 | n/r | 2,033 | **not recorded here** | **not recorded here** |
| Medium | 20 / 10 | 21,419 | 7,045 | 7,519 | 467.50 | 13.149 |
| Fine | 10 / 5 | 84,623 | 28,135 | 29,099 | 464.23 | 13.157 |

n/r = not reported in the material available when this was written. Fill the Coarse row from the Coarse solve before committing.

## 2. Hotspot locations (global mm, X axial, Y radial, Z circumferential)

| Mesh | Max stress node | Stress location (X, Y, Z) | Max deformation node | Deformation location (X, Y, Z) |
|---|---:|---|---:|---|
| Baseline R05 | n/r | Opening corner, right side of window in the standard view | n/r | Upper edge of opening |
| Medium | 73 | 987.72, 1991.1, -188.55 | 7372 | 801.76, 1990.0, -199.67 |
| Fine | 215 | 608.29, 1991.5, -184.12 | 28600 | 800.05, 1990.0, -199.67 |

Reading, assuming the window is centred near X = 800, Z = 0 (window spans about X 600 to 1000, Z -200 to +200):
- Both stress peaks sit in an inner corner fillet (R40) on the **-Z side** of the window, but at **opposite axial corners** (X about 988 versus X about 608).
- Maximum deformation is at the same place in both meshes: the middle of the -Z window edge (X about 800, Z about -200).

## 3. Comparison

| Comparison | Stress change | Deformation change |
|---|---:|---:|
| Medium vs baseline | -0.12% | -0.03% |
| Fine vs baseline | -0.82% | +0.03% |
| Fine vs Medium | -0.70% | +0.06% |

## 4. Interpretation

- **No peak that keeps rising (Task 5).** Maximum stress decreases slightly with refinement (468.06, 467.50, 464.23 MPa) and stays within about 1% of the baseline. Deformation is essentially unchanged (13.149 to 13.157 mm).
- **Boundary influence (Task 6).** Marked as none found. Supporting evidence in the baseline plot: stress is local to the window and band, with far-field panel stress near 20 MPa (minimum 19.9 MPa). Attach the check that was done for this task.
- **Caution on the peak value.** The maximum jumps between two near-symmetric corners as the mesh changes, so a pointwise comparison of "the" peak is not like-for-like. The maximum value is comparable across meshes. The location is not.

## 5. Manual vs Member 4 automated (Task 7)

Done:
- Support nodes confirmed.
- Medium and Fine files collected and sent to Member 4.
- Member 4 maximum stress and deformation match the manual values (467.50 MPa / 13.149 mm and 464.23 MPa / 13.157 mm).
- Member 4 confirmed `ds.dat` matches the setup decks.

Confirmed 6 Nov 2026: the exported result rows are the Top/Bottom shell envelope, matching the Position setting of the manual plots. Whether they are also Averaged (not unaveraged) has not been stated.

Still open:
- Member 4 to send his own node locations and counts, then compare against section 2.
- Confirm the exports are Averaged.

## 6. Unresolved differences and open items

1. **Position setting of exported rows:** confirmed Top/Bottom. Averaged versus unaveraged still to confirm.
2. **Fine mesh differs from Member 2's Fine archive.** The solved Fine mesh has 84,623 nodes and 28,135 SHELL281; Member 2's archive reports 84,466 nodes and 27,974 elements. Medium matches (7,045 SHELL281). Cause not established, probably remeshing the LoadSource copy instead of importing his mesh.
3. **Non-shell elements.** Total elements exceed SHELL281 by 474 (Medium) and 964 (Fine). Likely edge-load carrier elements, but this is an inference and has not been checked.
4. **Solver warnings.** Manual run: 3. Medium: 3. Fine: 4, and the Fine run used out-of-core solver mode. Known warnings: element shape checking inactive, material number with no MP/TB for an element outside the shell mesh, zero reference moment convergence value. The fourth Fine warning has not been read here.
5. **Not a formal convergence study.** Baseline to Medium changes only the global size (band stays 10 mm). The Coarse, Medium and Fine meshes (40/20, 20/10, 10/5) halve both sizes each time, so they form a proper refinement series. With the Coarse stress and deformation added, the observed order and a grid convergence index can be computed.
6. **Day 2 item still open:** final assembled-load equilibrium sign-off (residual Fy about 4.697 N, about 0.0037% of the pressure force).
7. **Model limitations unchanged:** provisional material, linear elastic with no plasticity, approximate opening-edge load transfer, static analysis only.

## 7. Day 3 completion statement

Preliminary evidence: maximum stress and deformation vary by less than about 1% across the baseline, Medium and Fine meshes, with no rising peak. Manual and automated results agree, subject to the open Position-setting check.
