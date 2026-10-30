
# FUSESAFE — Geometry Parameters

## 1. Project Description

FUSESAFE is an educational aircraft fuselage structural analysis project.

The geometry consists of a curved fuselage skin panel with a rounded rectangular window opening and an additional reinforcement region surrounding the opening.

The objective is to study how reinforcement thickness affects structural stress and deformation.

## 2. Software Environment

- ANSYS Version: 2026 R1 Student
- Geometry Editor: ANSYS Discovery
- Geometry Status: Not started

## 3. Baseline Parameters

| Parameter | Value | Unit |
|---|---:|---|
| Window width | 400 | mm |
| Window height | 400 | mm |
| Fuselage radius | 2000 | mm |
| Skin thickness | 2 | mm |
| Pressure difference | 55 | kPa |
| Required Factor of Safety | 2 | - |
| Added reinforcement thickness | 2 | mm |
| Total reinforced thickness | 4 | mm |

## 4. Pending Geometry Decisions

| Parameter | Status |
|---|---|
| Panel axial length | Not decided |
| Panel circumferential span/angle | Not decided |
| Window corner radius | Not decided |
| Reinforcement band width | Not decided |
| Material alloy | Awaiting Member 1 |

## 5. Coordinate Convention — Proposed

- Global X: Axial direction.
- Global Y and Z: Cross-sectional plane.
- Radial direction: Outward from fuselage centre.
- Circumferential direction: Around fuselage circumference.

Local directions at panel centre:
- Local X: Axial tangent.
- Local Y: Circumferential tangent.
- Local Z: Radial outward normal.

Awaiting team confirmation.

## 6. Geometry Development Log

- ANSYS Workbench successfully opened.
- ANSYS Discovery successfully launched.
- Geometry construction not yet started.
- No mesh or FEA results established.

## 7. Important Note

All baseline values are provisional educational development values. They do not represent verified aircraft design specifications.
## 5. Coordinate Convention — TEAM APPROVED

- Global X: Fuselage longitudinal axis.
- Global Y: Circumferential tangent at panel centre.
- Global Z: Radial outward direction at panel centre.

- Fuselage centreline: Along X.
- Fuselage cross-section: YZ plane.
- Panel centre: Located at +Z.
- Window plane: Approximately local XY tangent plane.
- Coordinate system: Right-handed.

Status: Approved by Member 1.
