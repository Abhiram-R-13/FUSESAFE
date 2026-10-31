# FUSESAFE — Geometry Parameters

## 1. Project Description

FUSESAFE is an educational aircraft fuselage structural analysis project.

The geometry consists of a curved cylindrical fuselage skin panel containing a centred rounded rectangular window opening and a separate surrounding reinforcement region.

The objective is to investigate how additional reinforcement thickness affects structural stress and deformation.

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
- Discovery Explore and LiveGX Refine are unavailable because the GPU is not CUDA-compatible.
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

The panel is centred around the YZ-plane orientation at its circumferential midpoint.

Window width is measured along X (axial).

Window height is measured along the circumferential surface arc.

## 4. Provisional Panel Dimensions

| Parameter | Value |
|---|---:|
| Axial panel length | 1600 mm |
| Circumferential arc length | 1600 mm |
| Shell midsurface radius | 2000 mm |
| Window width | 400 mm |
| Window height | 400 mm |
| Window position | Centred axially and circumferentially |

These are development assumptions, not validated aircraft dimensions.

Member 1 will investigate boundary-distance sensitivity later.

## 5. Circumferential Angle

The total panel circumferential angle is calculated from:

theta = Arc length / Radius

For the baseline geometry:

theta = 1600 / 2000 = 0.8 radians

theta = 0.8 × 180 / pi

Baseline total angle = 45.84 degrees (approximately).

The panel extends approximately 22.92 degrees on either side of its circumferential centre.

If the radius changes, preserve the 1600 mm circumferential arc length and recalculate:

theta (degrees) = (1600 / Radius) × (180 / pi)

## 6. Window Geometry

| Parameter | Value |
|---|---:|
| Width (axial) | 400 mm |
| Height (circumferential) | 400 mm |
| Position | Panel centre |
| Corner-radius rule | 0.10 × min(width, height) |
| Baseline inner corner radius | 40 mm |

Window corner radius calculation:

r = 0.10 × min(400, 400)

r = 40 mm

The opening width and height must remain independent, adjustable parameters.

## 7. Reinforcement Geometry

| Parameter | Value |
|---|---:|
| Reinforcement-band width | 50 mm |
| Inner opening dimensions | 400 × 400 mm |
| Outer bounding dimensions | 500 × 500 mm |
| Inner corner radius | 40 mm |
| Outer corner radius | 90 mm |

The reinforcement band surrounds the opening with a constant 50 mm surface offset.

The reinforcement region must be geometrically distinguishable from the surrounding skin region.

The initial model should use separate face regions on the shell midsurface, allowing different shell thickness assignments later.

## 8. Thickness Specifications

| Parameter | Value |
|---|---:|
| Baseline skin thickness | 2 mm |
| Initial added reinforcement thickness | 2 mm |
| Total reinforcement-region thickness | 4 mm |

Calculation:

Total reinforcement thickness = Skin thickness + Added thickness

Total reinforcement thickness = 2 + 2 = 4 mm

The initial geometry will use a shell midsurface representation.

Thickness assignments and shell offsets must be coordinated before structural analysis.

## 9. Geometry Construction Requirements

The initial model must contain:

1. A curved cylindrical shell midsurface.
2. A centred rounded rectangular window opening.
3. A separate 50 mm-wide reinforcement face region.
4. A
