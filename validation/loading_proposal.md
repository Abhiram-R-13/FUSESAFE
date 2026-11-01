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
## Confirmed coordinate and boundary-edge clarification

Confirmed from Member 2's restored DesignModeler geometry:

- Global X is the longitudinal/axial direction, spanning X = 0 to 1600 mm.
- Global +Y is radially outward at the panel centre.
- Circumferential curvature lies in YZ cross-sectional planes.
- The actual shell face-normal orientation has not yet been verified. Pressure direction must not be assigned based only on the intended radial direction.
- The two axial-end edges are curved edges at X = 0 and X = 1600 mm. These carry the proposed axial membrane actions.
- The two circumferential-side edges are straight edges parallel to X. These carry the proposed circumferential membrane actions.
- Edge-force directions must follow the actual edge orientation and be opposite on opposing boundaries.
- The separate flat source ring in Case B is construction geometry and must not receive structural loads.

Named selections and actual shell-normal verification remain pending.
## Preliminary free-body equilibrium check

### Baseline parameters

- Internal-minus-external pressure: p = 0.055 N/mm²
- Shell midsurface radius: R = 2000 mm
- Axial panel length: L = 1600 mm
- Circumferential arc length: s = 1600 mm
- Half circumferential angle: a = s/(2R) = 0.4 rad

### 1. Pressure resultant

For the symmetric curved cylindrical panel, the resultant of pressure in the radial-centre direction (+Y) is:

F_pressure = 2*p*R*L*sin(a)

F_pressure = 2*0.055*2000*1600*sin(0.4)

F_pressure ≈ 137075 N

### 2. Circumferential boundary actions

The circumferential membrane-force intensity is:

N_circumferential = p*R = 110 N/mm

The two circumferential-side boundary actions have a combined resultant magnitude in the -Y direction:

F_circumferential = 2*N_circumferential*L*sin(a)

F_circumferential ≈ 137075 N

### 3. Axial boundary actions

The axial membrane-force intensity is:

N_axial = p*R/2 = 55 N/mm

Each axial-end boundary action has a resultant magnitude:

F_axial = N_axial*1600 = 88000 N

The two axial-end actions act in opposite global X directions.

### 4. Preliminary force balance

For the ideal symmetric panel:

- Pressure resultant acts in +Y.
- Circumferential boundary resultant acts in -Y.
- Axial boundary actions cancel in global X.
- Symmetry gives zero net global Z force.

Therefore, the calculated global resultant forces balance.

### Limitations

This is a preliminary resultant-force check, not a complete proof of mechanical equilibrium.

The boundary traction directions, moment equilibrium, shell normal, load application method and support reactions must still be verified using the actual curved geometry and its free-body diagram.

These calculations do not constitute ANSYS results.
