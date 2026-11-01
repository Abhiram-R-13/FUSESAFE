# FUSESAFE baseline mechanics

## Purpose

These calculations provide an analytical reference for checking the structural model.

They describe a thin, closed cylindrical shell without a window, away from ends and other disturbances.

They do not predict the peak stress around the window opening.

## Symbols and units

p = internal minus external pressure, in MPa  
R = cylinder radius, in mm  
t = skin thickness, in mm

Stress calculated using these units is in MPa.

1 MPa = 1000 kPa  
1 MPa = 1 N/mm^2

## Baseline inputs

p = 55 kPa = 0.055 MPa  
R = 2000 mm  
t = 2 mm

The reference uses the original skin thickness, not the reinforced local thickness.

## Thin shell check

R / t = 2000 / 2 = 1000

The skin is thin relative to the radius. This supports using thin-shell theory for the nominal intact-cylinder reference.

## Hoop stress

Hoop stress acts around the cylinder circumference.

hoop stress = p * R / t  
            = 0.055 * 2000 / 2  
            = 55 MPa

## Axial stress

Axial stress acts along the cylinder length.

For the closed-end cylinder reference:

axial stress = p * R / (2 * t)  
             = 0.055 * 2000 / (2 * 2)  
             = 27.5 MPa

## Nominal von Mises stress

For plane stress with zero in-plane shear:

von Mises stress =  
sqrt(hoop^2 + axial^2 - hoop * axial)

Substituting:

von Mises stress =  
sqrt(55^2 + 27.5^2 - 55 * 27.5)

Baseline nominal von Mises stress = approximately 47.63 MPa.

This is an analytical far-field reference value, not a predicted peak stress near a structural discontinuity.

## Preliminary stress threshold

Using the provisional typical yield strength of 345 MPa:

preliminary allowable stress = yield strength / required FoS  
                            = 345 / 2  
                            = 172.5 MPa

The yield value is not a sheet-specific design allowable. Therefore, this threshold is a provisional educational screening value, not a certified aircraft structural allowable.

## Later FEA comparison

Once a defensible window model is solved:

calculated FoS = selected yield strength / usable FEA stress

The stress extraction method and model validity must be reviewed before using this calculation to judge a candidate.

No window FEA result or passing reinforcement design is established by the analytical calculations above.

## Loading and boundary conditions

An open curved panel is not automatically equivalent to a closed pressurized cylinder.

The final loading and support method remains unresolved.

We must first demonstrate that the chosen method reproduces the intended intact-shell behaviour before interpreting window stresses.

## Existing calculation files

baseline_stress_check.m:  
Executed successfully; gives 55 MPa hoop, 27.5 MPa axial and approximately 47.63 MPa nominal von Mises stress.

allowable_stress_check.m:  
Executed successfully; gives the provisional 172.5 MPa threshold.
