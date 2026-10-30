# FUSESAFE initial geometry agreement

## Status
These are provisional educational modelling specifications.

The coordinate convention, reinforcement width and corner rule
have been confirmed with Member 2.

The panel dimensions have been sent to Member 2.
Successful geometry construction has not yet been demonstrated.

These choices are not validated aircraft design dimensions.

## Coordinate and dimension convention
X direction: axial, along aircraft nose to tail.

Window width: measured axially.
Window height: measured as circumferential arc length.

Radial direction: outward normal to the curved shell.

This convention replaces the earlier unfinalized width/height
convention. Geometry, MATLAB and automation must use this
updated convention consistently.

## Initial panel
Axial length: 1600 mm.
Circumferential arc length: 1600 mm.
Baseline shell midsurface radius: 2000 mm.

The opening is centred axially and circumferentially.

Baseline total panel angle:
1600 / 2000 = 0.8 radians, approximately 45.84 degrees.

When radius changes, preserve the 1600 mm circumferential
arc length and recalculate the angle.

## Window opening
Baseline width: 400 mm, axial.
Baseline height: 400 mm, circumferential arc length.

Corner-radius rule:
r_corner = 0.10 * min(window_width, window_height)

Baseline opening corner radius: 40 mm.

The proportion remains fixed when window dimensions change.

## Reinforcement band
Fixed band width: 50 mm.

Construct the band using a constant outward offset around the
opening on the developed shell surface.

Baseline outer bounding dimensions: 500 by 500 mm.
Baseline outer corner radius: 90 mm.

Band width is fixed for the initial thickness-search study.
It is not an optimized or validated reinforcement width.

## Thickness
Baseline skin thickness: 2 mm.
Trial ADDED reinforcement thickness: 2 mm.
Baseline TOTAL band thickness: 4 mm.

Total band thickness = skin thickness + added thickness.

At zero added thickness, retain the skin and opening.
Do not create a zero-thickness shell body.

## Shell modelling
Use a shell midsurface representation initially.

Shell offsets and thickness implementation require review.
Do not claim the initial model represents the eccentricity
of a real one-sided doubler unless this is explicitly modelled.

## Boundary clearance
At baseline, the outer band boundary is 550 mm from each
panel edge in the developed surface layout.

This clearance has not been validated.

A later panel-size sensitivity check must assess whether
the chosen boundaries affect the window-region results.

## Pending work
- Member 2 constructs and verifies the geometry.
- Check parameter updates and named selections.
- Agree shell offsets and thickness assignments.
- Define and review loads and supports.
- Validate the intact-shell reference.
- Check mesh convergence and panel-size sensitivity.
