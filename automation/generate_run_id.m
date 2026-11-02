clc;
clear;

% Generate unique run ID
runID = ['RUN_' datestr(now, 'yyyymmdd_HHMMSS')];

% Project paths
projectRoot = 'S:\FUSESAFE_Automation_Test\FUSESAFE_Automation';
runFolder = fullfile(projectRoot, 'Runs', runID);

% Create run folder
mkdir(runFolder);

% Display result
fprintf('RUN ID: %s\n', runID);
fprintf('RUN FOLDER: %s\n', runFolder);

fprintf('\nRUN FOLDER CREATION: PASSED\n');