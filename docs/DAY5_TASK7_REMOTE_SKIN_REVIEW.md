# Day 5 – Task 7: Remote Skin Stress Review

## 1. Objective

Investigate stress levels at selected skin locations away from the window reinforcement region using the completed Day 5 coupled structural case.

## 2. Analysis Case

| Parameter | Value |
|---|---:|
| Shell pressure | 0.070 MPa |
| Skin thickness | 1.5 mm |
| Total B_Band thickness | 4 mm |
| Band membrane offset | −1.25 mm |
| Geometry | Nominal baseline |
| Analysis | Static Structural |

The existing converged coupled-case results were used. No additional structural solve was required.

## 3. Skin Stress Result

A separate Equivalent (von-Mises) Stress result was created and scoped to the `B_Skin` named selection.

Position: Top/Bottom.

| Measurement | Result |
|---|---:|
| Maximum skin stress | 290.8 MPa |
| Average skin stress | 85.523 MPa |
| Minimum skin stress | 14.044 MPa |

The maximum stress marker appears near the window opening region.

## 4. Remote Skin Probe Readings

Four selected locations away from the window reinforcement region were probed.

| Probe | Node ID | Stress (MPa) |
|---|---:|---:|
| 1 | 4376 | 82.973 |
| 2 | 22372 | 81.821 |
| 3 | 72906 | 74.302 |
| 4 | Not displayed | 78.801 |

Fourth probe coordinates:
- X = 1043.192472 mm
- Y = 1920.420791 mm
- Z = −566.547045 mm

The highest of the four sampled remote-point stresses was 82.973 MPa.

All four sampled values are below the provisional allowable stress of 145 MPa.

## 5. Preliminary Allowable Stress Comparison

Using the provisional yield strength of 290 MPa and target FoS of 2:

\[
\sigma_{\mathrm{allowable}}=\frac{290}{2}=145\ \mathrm{MPa}
\]

The four sampled remote skin points are below this provisional allowable.

However, the maximum stress over the complete skin selection is 290.8 MPa, located near the window opening region.

## 6. Interpretation

The selected remote skin probe locations did not show stress values exceeding the provisional allowable stress.

The results support the observation that the highest stress concentration is near the window opening rather than at the four sampled remote locations.

The four probe readings are point measurements and do not establish that every element in the remote skin region is below the allowable stress.

## 7. Limitations

1. Only four remote skin locations were sampled.
2. The full-field maximum over the complete skin selection is 290.8 MPa.
3. The provisional yield strength of 290 MPa requires confirmation against the final material specification.
4. The original derivation of the five SURF156 boundary loads remains unconfirmed.
5. The coupled case is exploratory and does not establish structural safety.
6. Mesh convergence has not been established.

## 8. Evidence

Screenshot: `D5_Task7_RemoteSkin_Probe_Readings.png`

The screenshot contains the four probe values and their recorded coordinates where available.

## 9. Conclusion

Four selected remote skin locations were checked using the converged Day 5 coupled-case solution.

The measured stresses ranged from 74.302 MPa to 82.973 MPa, all below the provisional allowable stress of 145 MPa.

The evidence indicates that the sampled remote locations do not exhibit the high stress concentration seen near the window opening. This is a limited point-sampling assessment, not an exhaustive remote-skin failure assessment.

**Day 5 Task 7: Remote skin stress review documented.**
