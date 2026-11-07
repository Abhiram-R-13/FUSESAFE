FUSESAFE Automation — Member 4
1. Project Overview
FUSESAFE is an educational MATLAB–ANSYS automation project for analysing a curved aircraft fuselage panel with a reinforced window opening.
The objective of the automation system is to connect MATLAB with ANSYS Workbench, execute structural simulations, extract simulation results and eventually perform reinforcement thickness optimization.
Member 4 is responsible for:
•	MATLAB–ANSYS communication.
•	Automation backend development.
•	Simulation run management.
•	Input and output file management.
•	ANSYS batch execution.
•	Result extraction.
•	Optimization workflow.
•	Integration with the MATLAB application.
Important: The current implementation has demonstrated MATLAB–ANSYS communication and run preparation. Automated structural FEA execution has not yet been demonstrated.
________________________________________
2. Software Environment
Component	Version
MATLAB	R2025b
ANSYS Workbench	2025 R1
ANSYS Version	v251
ANSYS executable
S:\STUDY\PROGRAM_FILES\Ansys\Ansys folder\ANSYS Inc\v251\Framework\bin\Win64\RunWB2.exe
Active project directory
S:\solid mech project\Github\FUSESAFE
Automation directory
S:\solid mech project\Github\FUSESAFE\automation
________________________________________
3. Directory Structure
automation/
│
├── README.md
│
├── matlab/
│   ├── check_workspace.m
│   ├── compare_loading_formulations.m
│   ├── generate_run_id.m
│   ├── prepare_fusesafe_run.m
│   ├── read_test_input.m
│   └── save_run_input.m
│
├── communication_test/
│   ├── ansys_test.wbjn
│   ├── run_round_trip.m
│   ├── test_connection.m
│   ├── request.csv
│   ├── response.csv
│   └── ansys_batch.log
│
├── Inputs/
│   ├── input_template.csv
│   └── test_input.csv
│
├── Runs/
│   └── RUN_20261107_041553_440/
│       ├── input.csv
│       └── manifest.json
│
├── Logs/
│
└── Reference/
The Runs directory contains individual simulation run folders.
Each run is intended to preserve its input parameters, metadata, simulation results and other relevant outputs.
________________________________________
4. Input Data Interface
The current test input CSV contains six parameters.
Current CSV columns
window_width_mm,window_height_mm,corner_radius_mm,skin_thickness_mm,pressure_diff_kpa,required_fos
Verified test input
Parameter	Value	Unit
Window width	400	mm
Window height	300	mm
Corner radius	50	mm
Skin thickness	2	mm
Pressure difference	55	kPa
Required FoS	2	-
The input validation script checks:
•	Correct column names.
•	Exactly one complete data row.
•	No missing values.
•	All values are positive and finite.
Note: This is the current six-column test interface. The final backend interface also requires a defined YieldStrength input or material configuration. The two interfaces must be reconciled before full application integration.
________________________________________
5. Completed Development Work
Day 1 — MATLAB–ANSYS Communication
A basic communication system was developed between MATLAB and ANSYS Workbench.
The workflow:
1.	MATLAB generates a request CSV.
2.	MATLAB launches ANSYS Workbench.
3.	ANSYS executes a journal file.
4.	The journal reads the request.
5.	ANSYS performs a test calculation.
6.	ANSYS writes the response CSV.
7.	MATLAB reads and verifies the response.
Test calculation:
Input: 7.35
Expected output: 14.70
Actual output: 14.70
Recorded run:
20261103_044731_749
ANSYS exit code:
0
Result: MATLAB–ANSYS round-trip communication verified.
This test uses a simple multiplication operation. It does not perform structural FEA.
Day 2 — Automation Folder Setup
The automation directory was organized into separate folders for:
•	MATLAB scripts.
•	Communication testing.
•	Input files.
•	Simulation runs.
•	Logs.
•	Reference files.
The MATLAB scripts were updated to use the active GitHub project directory instead of the previous standalone test directory.
Day 3 — Analytical Load Verification
The loading formulation comparison script was developed to evaluate pressure loading and corresponding edge resultants.
The calculation considers:
•	Pressure forces.
•	Hoop edge forces.
•	Axial edge forces.
•	Resultant moments.
•	Combined force and moment equilibrium.
A separate numerical external-load equilibrium verification was previously completed with very small residuals.
This analytical verification is distinct from structural FEA validation.
Run Preparation — November 7, 2026
The run preparation workflow was successfully tested.
Test run ID:
RUN_20261107_041553_440
Generated directory:
automation/Runs/RUN_20261107_041553_440/
Generated files:
input.csv
manifest.json
The input snapshot was verified against the original test input.
The manifest contained:
{
  "run_id": "RUN_20261107_041553_440",
  "run_date": "2026-11-07 04:15:53",
  "input_file": "input.csv",
  "results_file": "results.csv",
  "status": "prepared",
  "yield_strength_mpa": 290
}
The provisional yield strength of 290 MPa is recorded as metadata. It has not yet been used in an actual ANSYS result calculation.
________________________________________
6. MATLAB Script Descriptions
check_workspace.m
Checks whether the required automation folders and input template exist.
Latest verification:
WORKSPACE CHECK: PASSED
read_test_input.m
Reads and validates the six test input parameters.
Latest verification:
FUSESAFE INPUT VALIDATION: PASSED
prepare_fusesafe_run.m
Performs the following operations:
•	Reads test input.
•	Validates input columns and values.
•	Generates a unique run ID.
•	Creates a new run directory.
•	Saves the input snapshot.
•	Creates a JSON manifest.
Latest verification:
FUSESAFE RUN PREPARATION: PASSED
generate_run_id.m
Generates a unique run ID and creates a corresponding directory under Runs.
save_run_input.m
Copies the test input CSV into a specified run directory.
It expects the runID variable to be available in the MATLAB workspace.
These two utility scripts are separate from prepare_fusesafe_run.m, which already performs run ID generation and input saving itself.
compare_loading_formulations.m
Compares two analytical loading formulations by calculating force and moment contributions.
run_round_trip.m
Launches ANSYS Workbench in batch mode and verifies the response generated by the communication journal.
This is a standalone communication test, not the final FEA execution workflow.
test_connection.m
Generates a test request CSV for the communication test.
________________________________________
7. Verified Test Results
Test	Result
Active project path verification	Passed
Workspace folder verification	Passed
Input template verification	Passed
Six-column input validation	Passed
Unique run ID generation	Passed
Run directory creation	Passed
Input CSV generation	Passed
Manifest generation	Passed
Manifest content verification	Passed
ANSYS process launch	Passed
MATLAB-to-ANSYS request transfer	Passed
ANSYS-to-MATLAB response transfer	Passed
Run ID verification	Passed
Arithmetic response verification	Passed
These results verify the existing communication and run-preparation infrastructure.
They do not establish successful structural simulation automation.
________________________________________
8. Material and FoS Configuration
The current provisional material yield strength is:
290 MPa
For actual simulation results, the intended factor of safety calculation is:
Actual FoS = Yield Strength / Maximum Equivalent Stress
Using the current provisional value:
Actual FoS = 290 / Maximum Stress (MPa)
The final material configuration must be confirmed before using this calculation for design acceptance.
The value must not remain hardcoded if the backend is designed to accept different materials.
________________________________________
9. Planned Backend Architecture
The intended workflow is:
MATLAB Application
        |
        v
Input Validation
        |
        v
Run ID Generation
        |
        v
Run Folder Creation
        |
        v
Input Snapshot + Manifest
        |
        v
ANSYS Workbench Batch Launch
        |
        v
Workbench Model Update
        |
        v
Mechanical Structural Solution
        |
        v
Result Extraction
        |
        v
FoS Calculation
        |
        v
Reinforcement Optimization
        |
        v
CSV + Image Generation
        |
        v
MATLAB Application Display
Planned backend function
[status, runID] = run_optimization_search(inputs)
Expected input fields:
Width
Height
CornerRadius
SkinThickness
InternalPressure
RequiredFoS
YieldStrength
This function is planned but has not yet been implemented.
________________________________________
10. Planned Output Format
results.csv
The agreed application interface is:
AddedThickness,AddedMass,MaxStress,MaxDisplacement,SolveStatus
Units:
Parameter	Unit
AddedThickness	mm
AddedMass	kg
MaxStress	MPa
MaxDisplacement	mm
SolveStatus	Text
optimization_history.csv
Iter,Thickness_mm,Mass_kg,Stress_MPa,FoS
Planned simulation images
stress.png
deformation.png
3d_geometry.png
These outputs are intended to come from genuine ANSYS structural simulations. The current synthetic application test images must not be treated as actual FEA results.
________________________________________
11. Pending Development Tasks
The remaining development work is:
1.	Complete the audit of existing MATLAB automation utilities.
2.	Reconcile the current six-column test CSV with the final seven-field backend interface.
3.	Establish the approved Workbench model and its parameterization for automation.
4.	Develop and verify a Workbench journal for structural simulation.
5.	Execute one genuine 4 mm baseline simulation through MATLAB.
6.	Compare automated results with the approved reference solution.
7.	Automate reinforcement thickness parameter updates.
8.	Extract actual stress, deformation, mass and solver status.
9.	Generate simulation output images.
10.	Implement the optimization search algorithm.
11.	Generate results and optimization history CSV files.
12.	Integrate the backend with the separate MATLAB application.
13.	Perform complete end-to-end testing.
________________________________________
12. Important Development Boundaries
The following distinctions must be maintained:
•	Communication testing is not structural simulation.
•	Run preparation is not ANSYS execution.
•	Successful ANSYS process launch is not proof of a successful Mechanical solve.
•	A completed solver run is not automatically an acceptable engineering design.
•	Synthetic application data must not be presented as genuine FEA results.
•	The approved structural model, loading and boundary conditions must be preserved during automation.
Member 4 is responsible for the automation backend and integration, while structural model development and validation remain within the appropriate team responsibilities.
________________________________________
13. Current Project Status
Completed and verified:
•	Workspace verification.
•	Input validation.
•	Run preparation.
•	Input snapshot creation.
•	Manifest generation.
•	Basic MATLAB–ANSYS communication.
•	Analytical loading comparison infrastructure.
Current major milestone:
Automate one genuine 4 mm baseline structural simulation through MATLAB and ANSYS Workbench.
This is the next major step before proceeding to the reinforcement thickness optimization system.

