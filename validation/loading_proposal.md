# FUSESAFE initial loading and support proposal

Status: PROPOSED. Not implemented or validated.

## Purpose
Represent a small patch of a pressurized closed cylindrical shell
using pressure and mechanically consistent boundary actions.

Do not fix all four edges and assume the result represents
an unrestricted fuselage.

## Coordinates
X: axial, nose to tail.
Circumferential: around the fuselage.
Radial: outward normal.

Window width is axial.
Window height is circumferential arc length.

## Pressure
Baseline internal-minus-external pressure: 55 kPa.
Equivalent pressure: 0.055 MPa = 0.055 N/mm^2.

Apply the pressure once to the retained shell surface.
Verify the shell normal and pressure sign so loading acts outward.

## Proposed boundary loading
Use the membrane actions transmitted by the surrounding shell.

Circumferential membrane force per unit edge length:
N_circumferential = p * R
Baseline value: 110 N/mm.

Axial membrane force per unit edge length:
N_axial = p * R / 2
Baseline value: 55 N/mm.

At the two axial ends, apply opposing outward axial tractions.

At the two circumferential boundaries, apply outward
circumferential tangent tractions using each edge's actual
orientation.

These edge actions represent the removed surrounding shell.
Their consistency with the applied pressure must be checked
using a free-body diagram and reaction equilibrium.

N/mm values are line-load intensities, not pressure values.
If entered through another Ansys load type, conversion and
distribution must be derived and checked.

## Supports
Use only the constraints needed to remove rigid body motion.

The exact constrained nodes and degrees of freedom will be
selected after geometry and mesh are available.

Do not introduce blanket clamping or use weak springs as
a substitute for a reviewed support definition.

## Required first validation case
First analyse an intact curved panel without the opening
and without added reinforcement.

Use the same radius, skin thickness, loading philosophy
and boundary treatment as the later window model.

Reference nominal stresses:
Hoop stress: 55 MPa.
Axial stress: 27.5 MPa.
Von Mises stress: approximately 47.63 MPa.

Inspect far-field membrane stresses, deformation and equilibrium.
Do not expect a contour alone to establish validity.

After reviewing this reference case, introduce the opening
and reinforcement and repeat the checks.

## Window idealization
The initial model excludes glazing and its pressure-load transfer.

The opening boundary is free unless a separately reviewed
window/frame loading model is introduced.

This is an idealized structural study, not a complete
pressurized aircraft window assembly.

## Pending implementation checks
- Actual shell normals and edge directions.
- Ansys load type and unit conversion.
- Named selections.
- Minimal rigid body constraints.
- Intact-reference comparison.
- Mesh convergence.
- Panel-size and boundary-distance sensitivity.

Required FoS changes acceptance, not applied pressure.
