# FUSESAFE initial geometry agreement

## Status

These are provisional educational modelling specifications.

The coordinate convention, reinforcement width and corner rule have been confirmed with Member 2.

The panel dimensions have been sent to Member 2.

Successful geometry construction and final export exclusion must be verified.

These choices are not validated aircraft design dimensions.

## Coordinate and dimension convention

The final global coordinate convention has been confirmed by Member 2:

- Global X: axial direction, along the aircraft nose to tail, spanning X = 0 to 1600 mm.
- Global +Y: radially outward at the panel's circumferential centreline.
- Global Z: circumferential tangent direction at the panel's circumferential centreline.
- The shell curvature lies in the global YZ cross-sectional plane.

Important clarification:

Radial and circumferential tangent directions vary around the curved panel. Global Y and Z are not globally constant local radial and circumferential directions everywhere on the shell.

The earlier convention of X axial, Y circumferential and Z radial is superseded.

No geometry rotation is planned. Both Case A and Case B use this final orientation.

The surface-normal line is radial, but Case A's actual outward versus inward Mechanical shell face-normal orientation has not yet been independently verified. The pressure sign must not be selected until this is checked.

Window width: measured axially along X.

Window height: measured as circumferential arc length.

Geometry, MATLAB and automation must use this final coordinate convention consistently.

## Initial panel

Axial length: 1600 mm.

Circumferential arc length: 1600 mm.

Baseline shell midsurface radius: 2000 mm.

The opening is centred axially and circumferentially.

Baseline total panel angle:

1600 / 2000 = 0.8 radians, approximately 45.84 degrees.

When radius changes, preserve the 1600 mm circumferential arc length and recalculate the angle.

## Window opening

Baseline width: 400 mm, axial.

Baseline height: 400 mm, circumferential arc length.

Corner-radius rule:

r_corner = 0.10 * min(window_width, window_height)

Baseline opening corner radius: 40 mm.

The proportion remains fixed when window dimensions change.

## Reinforcement band

Fixed band width: 50 mm.

Construct the band using a constant outward offset around the opening on the developed shell surface.

Baseline outer bounding dimensions: 500 by 500 mm.

Baseline outer corner radius: 90 mm.

Band width is fixed for the initial thickness-search study. It is not an optimized or validated reinforcement width.

## Thickness

Baseline skin thickness: 2 mm.

Trial ADDED reinforcement thickness: 2 mm.

Baseline TOTAL band thickness: 4 mm.

Total band thickness = skin thickness + added thickness.

At zero added thickness, retain the skin and opening. Do not create a zero-thickness shell body.

## Shell modelling

Use a shell midsurface representation initially.

Shell offsets and thickness implementation require review.

Do not claim the initial model represents the eccentricity of a real one-sided doubler unless this is explicitly modelled.

## Boundary clearance

At baseline, the outer band boundary is 550 mm from each panel edge in the developed surface layout.

This clearance has not been validated.

A later panel-size sensitivity check must assess whether the chosen boundaries affect the window-region results.

## Pending work

- Member 2 constructs and verifies the geometry.
- Check parameter updates and named selections.
- Agree shell offsets and thickness assignments.
- Define and review loads and supports.
- Verify Case A's Mechanical shell orientation and pressure sign.
- Validate the intact-shell reference.
- Check mesh convergence and panel-size sensitivity.

## Temporary construction geometry and export requirement

Member 2 confirmed that `B_Developed_Band_Source` is temporary flat construction geometry used to wrap the opening and reinforcement-band boundaries.

It is not intended to be part of the final structural model.

Before exporting the structural geometry:

1. Complete wrapping and verify the curved opening and reinforcement-band boundaries.
2. Remove or explicitly exclude `B_Developed_Band_Source` from the final structural geometry.
3. Verify that only the intended curved structural shell remains.
4. Inspect the exported geometry in ANSYS Mechanical.
5. Confirm that the temporary source geometry is absent and cannot receive structural loads.

Hiding the construction geometry alone does not establish that it is excluded from export.

Geometry construction and export exclusion remain pending verification.
