% FUSESAFE MATLAB-ANSYS Connection Test

%% 1. Identify the folder containing this script

workDir = fileparts(mfilename('fullpath'));

%% 2. Generate a unique run ID

runID = char(datetime('now', ...
    'Format', 'yyyyMMdd_HHmmss_SSS'));

%% 3. Define a known test input

inputValue = 12.5;

%% 4. Create request table

request = table(string(runID), inputValue, ...
    'VariableNames', {'run_id', 'input_value'});

%% 5. Write request to CSV

requestFile = fullfile(workDir, 'request.csv');

writetable(request, requestFile);

%% 6. Display confirmation

fprintf('Request created successfully.\n');
fprintf('Run ID: %s\n', runID);
fprintf('Input value: %.2f\n', inputValue);
fprintf('File: %s\n', requestFile);