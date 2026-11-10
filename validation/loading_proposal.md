 # FUSESAFE initial loading and support proposal
**Status: Initial theoretical proposal. A modified loading and support configuration has subsequently been implemented in ANSYS; its physical validity remains under verification.**


## Purpose

Represent a small patch of a pressurized closed cylindrical shell using pressure and mechanically consistent boundary actions.

Do not fix all four edges and assume the result represents an unrestricted fuselage.

## Coordinates

The final global coordinate convention, confirmed by Member 2:

- **Global X:** longitudinal/axial direction, nose to tail, spanning X = 0 to 1600 mm.
- **Global +Y:** radially outward at the panel circumferential centreline.
- **Global +Z:** circumferential tangent at the panel centreline.
- **Curvature:** lies in the YZ cross-sectional planes.

The local radial and circumferential tangent directions vary around the curved panel. Global +Y and +Z therefore do not represent constant local radial and circumferential directions over the entire surface.

Window width is axial. Window height is circumferential arc length.

The earlier convention that treated global Y as circumferential and global Z as radial is superseded. No geometry rotation is planned.

## Pressure

Baseline internal-minus-external pressure: 55 kPa.

Equivalent pressure: 0.055 MPa = 0.055 N/mm².

Apply the pressure once to the retained shell surface.

Verify the shell face normal and pressure sign so loading acts outward. Do not assume that the intended radial direction automatically matches the Mechanical shell normal.

## Proposed boundary loading

Use the membrane actions transmitted by the surrounding shell.

Circumferential membrane force per unit edge length:

N_circumferential = p * R

Baseline value: 110 N/mm.

Axial membrane force per unit edge length:

N_axial = p * R / 2

Baseline value: 55 N/mm.

At the two axial ends, apply opposing axial membrane tractions in the global X direction.

At the two circumferential-side boundaries, apply opposing circumferential membrane tractions along the local circumferential tangent directions. These directions must be determined from the actual curved geometry.

These edge actions represent the removed surrounding shell. Their consistency with the applied pressure must be checked using a free-body diagram and reaction equilibrium.

N/mm values are line-load intensities, not pressure values.

If entered through another Ansys load type, conversion and distribution must be derived and checked.

## Supports

Use only the constraints needed to remove rigid body motion.

The exact constrained nodes and degrees of freedom will be selected after geometry and mesh are available.

Do not introduce blanket clamping or use weak springs as a substitute for a reviewed support definition.

## Required first validation case

First analyse an intact curved panel without the opening and without added reinforcement.

Use the same radius, skin thickness, loading philosophy and boundary treatment as the later window model.

Reference nominal stresses:

- Hoop stress: 55 MPa.
- Axial stress: 27.5 MPa.
- Von Mises stress: approximately 47.63 MPa.

Inspect far-field membrane stresses, deformation and equilibrium.

Do not expect a contour alone to establish validity.

After reviewing this reference case, introduce the opening and reinforcement and repeat the checks.

## Window idealization

The initial model excludes glazing and its pressure-load transfer.

The opening boundary is free unless a separately reviewed window/frame loading model is introduced.

This is an idealized structural study, not a complete pressurized aircraft window assembly.

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

Confirmed from Member 2's restored geometry:

- Global X is the longitudinal/axial direction, spanning X = 0 to 1600 mm.
- Global +Y is radially outward at the panel centreline.
- Global +Z is circumferential tangent at the panel centreline.
- Circumferential curvature lies in YZ cross-sectional planes.
- Local radial and circumferential tangent directions vary around the curved panel.
- The actual shell face-normal orientation has not yet been verified. Pressure direction must not be assigned based only on the intended radial direction.
- The two axial-end edges are curved edges at X = 0 and X = 1600 mm. These carry the proposed axial membrane actions.
- The two circumferential-side edges are straight edges parallel to X. These carry the proposed circumferential membrane actions, acting along the local circumferential tangent directions rather than along the edge.
- Edge-force directions must follow the actual geometry and be opposite on opposing boundaries.
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
---

# Implemented ANSYS Loading and Support Configuration – Day 5/6 Review

## 1. Actual Structural Loading

The implemented structural model uses:

- Shell pressure applied through APDL commands.
- Five SURF156 boundary-load groups.
- Three displacement support groups.

The original proposal described four surrounding-shell boundary actions. The implemented model additionally includes an opening-edge load group.

This is an important modelling difference. The physical justification for the opening-edge load and its interaction with the other boundary actions remains unresolved.

## 2. Baseline Loading at 0.055 MPa

The baseline model uses an internal-minus-external pressure of 0.055 MPa.

The recorded SURF156 load components are:

| Load group | Applied components |
|---|---|
| Hoop upper | Y = −42.8146, Z = +101.2661 N/mm |
| Hoop lower | Y = −42.8146, Z = −101.2661 N/mm |
| Axial start | X = −54.94501375 N/mm |
| Axial end | X = +54.94501375 N/mm |
| Opening edge | Y = +5.688014385 N/mm |

The corresponding baseline structural model converged and produced:

- Maximum von-Mises stress: 464.23 MPa.
- Maximum total deformation: 13.157 mm.

## 3. Exploratory Pressure-Scaled Loading at 0.070 MPa

The Day 5 coupled case used the following pressure-scaled SURF156 components:

| Load group | Applied components |
|---|---|
| Hoop upper | Y = −54.491, Z = +128.89 N/mm |
| Hoop lower | Y = −54.491, Z = −128.89 N/mm |
| Axial start | X = −69.930 N/mm |
| Axial end | X = +69.930 N/mm |
| Opening edge | Y = +7.2393 N/mm |

Shell pressure was applied at 0.070 MPa.

The original calculation source for these five load groups is still unavailable. Their reconstructed resultants suggest a relationship with the baseline pressure, but this does not independently establish the exact load derivation or exclude double counting.

Consequently, pressure-scaled results remain exploratory.

## 4. Implemented Support Conditions

The three displacement support groups used in the structural analysis are:

| Support | Constrained degrees of freedom |
|---|---|
| A | UX = UY = UZ = 0 |
| B | UY = UZ = 0 |
| C | UY = 0 |

These constraints are implemented in the structural models.

Their physical adequacy for representing the surrounding fuselage structure remains subject to further verification.

## 5. Pressure and Factor of Safety Independence

The MATLAB App and backend verification performed by Members 3 and 4 confirmed that changing Required FoS modifies the allowable-stress threshold and acceptance status only.

It does not modify:

- Applied shell pressure.
- The five SURF156 boundary-load groups.
- Geometry.
- Material properties.
- Supports.

The backend also reuses existing structural results for FoS reassessment without launching another ANSYS solve.

## 6. Remaining Loading Verification

The following checks remain necessary before the implemented loading approach can be considered physically validated:

1. Recover or independently establish the original derivation of all five SURF156 load groups.
2. Verify actual shell element normals and pressure direction.
3. Verify the directions and physical scopes of all boundary-load groups.
4. Establish whether the opening-edge load represents a real physical load path.
5. Check for possible double counting between pressure and boundary actions.
6. Calculate complete global force and moment resultants.
7. Compare applied loads with ANSYS support reactions.
8. Validate the intact curved-panel response against the analytical closed-cylinder reference.

## 7. Engineering Interpretation

The preliminary free-body equations in the original proposal describe an idealized intact curved cylindrical shell patch.

They provide theoretical reference resultants and are not proof that the implemented ANSYS load distribution is mechanically equivalent.

The current structural solutions demonstrate numerical behaviour for the specified implemented loads and supports. They do not independently validate the physical loading model.

**Conclusion:** The proposed loading theory and the implemented ANSYS configuration must be treated as separate records until the original load derivation, pressure direction, opening-edge load and complete equilibrium are verified.



This is a preliminary resultant-force check, not a complete proof of mechanical equilibrium.

The boundary traction directions, moment equilibrium, shell normal, load application method and support reactions must still be verified using the actual curved geometry and its free-body diagram.

These calculations do not constitute ANSYS results.
