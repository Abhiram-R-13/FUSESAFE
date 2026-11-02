clc;
clear;

projectRoot = 'S:\FUSESAFE_Automation_Test\FUSESAFE_Automation';

% Read test input
inputFile = fullfile(projectRoot, 'Inputs', 'test_input.csv');
data = readtable(inputFile);

% Use the run ID created in Step 6
runID = 'RUN_20261102_030511';

% Locate run folder
runFolder = fullfile(projectRoot, 'Runs', runID);

% Save a copy of input
outputFile = fullfile(runFolder, 'input.csv');
writetable(data, outputFile);

% Verify
if isfile(outputFile)
    fprintf('INPUT SAVING: PASSED\n');
    fprintf('Saved at: %s\n', outputFile);
else
    error('Input file was not saved.');
end