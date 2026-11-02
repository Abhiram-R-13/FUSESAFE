# FUSESAFE Software Setup

## 1. Software Environment

| Software         | Version |
| ---------------- | ------- |
| MATLAB           | R2025b  |
| Ansys Workbench  | 2025 R1 |
| Operating System | Windows |

## 2. Ansys Installation

Ansys Workbench executable:

`RunWB2.exe`

Local installation path:

`S:\STUDY\PROGRAM_FILES\Ansys\ANSYS Inc\v251\Framework\bin\Win64\RunWB2.exe`

This path is specific to the machine used for initial testing.

Other team members must configure their own local installation paths.

## 3. Automation Architecture

FUSESAFE uses MATLAB to communicate with Ansys Workbench through:

* MATLAB scripts
* Ansys Workbench journal files
* CSV files

The basic communication workflow is:

1. MATLAB writes input data into `request.csv`.
2. MATLAB launches Ansys Workbench.
3. Ansys executes the journal file.
4. Ansys reads the input CSV.
5. Ansys performs the requested operation.
6. Ansys writes the output into `response.csv`.
7. MATLAB reads and verifies the returned data.

## 4. Initial Communication Test

The initial communication test uses:

* `test_connection.m`
* `run_round_trip.m`
* `ansys_test.wbjn`

The test performs a simple multiplication operation to verify data exchange.

Example:

| Input | Expected Output |
| ----: | --------------: |
|  12.5 |              25 |
|  7.25 |            14.5 |
|  6.35 |            12.7 |
|  7.35 |            14.7 |

The communication test was successfully executed in the original S: drive workspace.

Result:

`FUSESAFE AUTOMATION TEST: PASSED`

This verifies basic MATLAB–ANSYS communication. It does not demonstrate an actual structural FEA solve.

## 5. Automation Files

The `automation` folder contains:

| File                   | Purpose                                   |
| ---------------------- | ----------------------------------------- |
| test_connection.m      | Tests MATLAB–ANSYS communication          |
| run_round_trip.m       | Executes the complete numerical exchange  |
| ansys_test.wbjn        | Contains ANSYS journal instructions       |
| check_workspace.m      | Checks project workspace                  |
| read_test_input.m      | Reads and validates user inputs           |
| generate_run_id.m      | Generates unique run identifiers          |
| save_run_input.m       | Saves input data for each run             |
| prepare_fusesafe_run.m | Prepares and records a new simulation run |

## 6. Current Development Status

Completed:

* Initial MATLAB–ANSYS communication test.
* Basic input-reading and validation functions.
* Unique run ID generation.
* Run-folder creation.
* Input and manifest saving.

Pending:

* Automated structural model update.
* Automated meshing and solving.
* Actual stress and deformation extraction.
* Automatic result validation.
* Reinforcement optimisation.

## 7. Important Notes

A successful numerical communication test does not prove that automated structural analysis works.

All future structural results must come from genuine ANSYS solves and must be matched to their respective input files, model revisions and run IDs.

Installation paths and configuration must be verified on each machine before execution.
