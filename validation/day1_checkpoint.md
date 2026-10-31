# FUSESAFE Member 1 Day 1 checkpoint

## Completed and tested
- Created fea-validation branch.
- Executed and uploaded baseline_stress_check.m.
- Verified analytical reference results:
  hoop stress = 55 MPa;
  axial stress = 27.5 MPa;
  nominal von Mises stress = approximately 47.63 MPa.
- Executed and uploaded allowable_stress_check.m.
- Verified preliminary stress threshold = 172.5 MPa.
- Entered the provisional material in Ansys Engineering Data.
- Created a Workbench archive and reopened it successfully.
- Checked that all four material properties survived restoration.
- Uploaded the archive and downloaded a backup to my own computer.

## Documentation completed
- day1_notes.txt
- material_selection.md
- assumptions.md
- theory.md
- geometry_agreement.md
- loading_proposal.md

## Software agreement
The team reports using Ansys 2025 R1 Enterprise.
Member 4 confirmed the required software tools are available.

## Provisional material
Name: FUSESAFE_2024_T3_PROVISIONAL
Alloy: Aluminium 2024-T3
Young's modulus: 73100 MPa
Poisson's ratio: 0.33
Density: 2780 kg/m3
Tensile yield strength: 345 MPa

Properties remain preliminary.
Applicable sheet-specific design strength is not yet confirmed.

## Initial geometry agreement
Axial panel length: 1600 mm.
Circumferential panel arc length: 1600 mm.
Baseline midsurface radius: 2000 mm.
Opening centred in the panel.

Window width: axial; baseline 400 mm.
Window height: circumferential arc length; baseline 400 mm.
Opening corner radius: 0.10 * min(width, height).
Baseline opening corner radius: 40 mm.

Fixed reinforcement-band width: 50 mm.
Baseline skin thickness: 2 mm.
Trial added thickness: 2 mm.
Total baseline band thickness: 4 mm.

These are provisional development dimensions.

## Loading proposal
Baseline outward pressure: 55 kPa.
Reference axial edge tension intensity: 55 N/mm.
Reference circumferential edge tension intensity: 110 N/mm.

Directions, distribution and equilibrium require implementation checks.
Exact minimal rigid body constraints remain undecided.

## Handoff
Sent material update and geometry/loading information to the team.
Requested separate intact-panel and window-panel geometry cases
from Member 2.

## Not completed
- Material assignment to geometry.
- Implemented and reviewed loads/supports.
- Structural solve.
- Mesh convergence or boundary-distance validation.
- Verified reinforcement result.
- MATLAB-to-Ansys automation test.
- Confirmed review/merge of this branch into main.

## Next action
Receive Member 2's geometry screenshot/files.
Review geometry, shell regions, units and boundary identification.
Start with the intact-panel reference before interpreting
the window model.
