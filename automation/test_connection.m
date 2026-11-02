clc;
clear;

% Identify the folder containing this script
workDir = fileparts(mfilename('fullpath'));

% Generate a unique run ID
runID = char(datetime('now', ...
    'Format', 'yyyyMMdd_HHmmss_SSS'));

% Define a known test input
inputValue = 12.5;

% Create request table
request = table(string(runID), inputValue, ...
    'VariableNames', {'run_id', 'input_value'});

% Write request to CSV
requestFile = fullfile(workDir, 'request.csv');

writetable(request, requestFile);

% Display confirmation
fprintf('Request created successfully.\n');
fprintf('Run ID: %s\n', runID);
fprintf('Input value: %.2f\n', inputValue);
fprintf('File: %s\n', requestFile);