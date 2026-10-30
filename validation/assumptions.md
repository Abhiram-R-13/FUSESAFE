# FUSESAFE initial modelling assumptions

Status: Proposed assumptions for the first educational model.
These assumptions require review as the model is developed.

## 1. Model scope
We will analyse a curved cylindrical fuselage panel containing
a rounded rectangular window opening and a reinforcement band.

We are not modelling a complete aircraft.

## 2. Shell representation
We propose shell elements to represent the thin fuselage skin.

The shell reference surface and thickness offset are not yet decided.

## 3. Material
Aluminium 2024-T3 is the provisional material choice.

The first model will approximate the material as homogeneous
and isotropic: the same properties throughout the model and
in every direction.

The currently recorded properties are preliminary values.
Suitable sheet-specific strength data still need confirmation.

## 4. Elastic behaviour
The initial analysis will assume linear elastic material behaviour.

Stress above the chosen yield threshold will indicate failure of
the screening criterion. It will not provide a reliable prediction
of permanent deformation.

## 5. Static loading
We will initially analyse a constant pressure difference.

Pressure cycling, vibration, impact and other dynamic loads
are outside this first model.

## 6. Deformation
Small-deformation analysis is proposed initially.

We must check whether the calculated displacements and rotations
justify this assumption.

## 7. Reinforcement
The initial reinforcement is an idealized continuous band.

Total local band thickness equals:
skin thickness + added reinforcement thickness.

The initial model will assume perfect load transfer between
the reinforcement region and the surrounding skin.

It will not verify rivets, adhesive or other attachment details.

## 8. Window opening
The opening has rounded corners.

Glass, seals, the complete window frame and pressure transfer
through glazing are not included initially.

This missing window load path must be considered when interpreting
the model and defining its loading.

## 9. Loads and supports
The loading and support method is NOT YET FINALIZED.

Pressure on an open curved patch does not automatically reproduce
the stress field of a closed pressurized fuselage.

Members 1 and 2 must agree and document a mechanically consistent
loading and support approach before treating results as meaningful.

## 10. Checks still required
- Unit consistency.
- Geometry connectivity and thickness assignments.
- Pressure direction and load application.
- Supports and rigid body motion.
- Reaction equilibrium.
- Intact-cylinder reference comparison.
- Mesh convergence.
- Sensitivity to panel size and boundary distance.
- Stress scope, shell face and averaging method.

## 11. Limits of the result
The initial pass condition is a static yield-based screening check.

A passing result does not establish aircraft safety or certification.

Fatigue, crack growth, damage tolerance, buckling, corrosion,
manufacturing effects and attachment strength are not evaluated
by this initial screening model.
