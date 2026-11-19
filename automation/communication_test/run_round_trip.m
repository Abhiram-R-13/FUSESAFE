clc;
clearvars;

%% 1. IDENTIFY PROJECT DIRECTORIES

% Folder containing this MATLAB script
workDir = fileparts(mfilename('fullpath'));

% Automation directory
automationDir = fileparts(workDir);

% Main MATLAB backend directory
matlabDir = fullfile(automationDir, 'Matlab');

% Add backend to MATLAB path
assert(isfolder(matlabDir), ...
    'FUSESAFE MATLAB backend folder not found.');

addpath(matlabDir);

%% 2. LOAD CENTRAL CONFIGURATION

cfg = fusesafe_config();

% ANSYS executable from central configuration
ansysExe = cfg.ansysExe;

% ANSYS journal
journalFile = fullfile(workDir, 'ansys_test.wbjn');

% Communication files
requestFile = fullfile(workDir, 'request.csv');
responseFile = fullfile(workDir, 'response.csv');
errorFile = fullfile(workDir, 'ansys_error.txt');
logFile = fullfile(workDir, 'ansys_batch.log');

%% 3. GENERATE A UNIQUE TEST REQUEST

runID = char(datetime('now', ...
    'Format', 'yyyyMMdd_HHmmss_SSS'));

% Known test input
inputValue = 7.35;

% Expected ANSYS result
expectedResult = inputValue * 2.0;

% Create MATLAB request table
request = table( ...
    string(runID), ...
    inputValue, ...
    'VariableNames', {'run_id', 'input_value'});

%% 4. VERIFY REQUIRED FILES

assert(isfile(ansysExe), ...
    'ANSYS executable not found. Check fusesafe_config.m.');

assert(isfile(journalFile), ...
    'ANSYS journal file not found.');

assert(isfolder(workDir), ...
    'Communication directory not found.');

%% 5. REMOVE PREVIOUS OUTPUTS

filesToDelete = {
    responseFile
    errorFile
    logFile
};

for k = 1:numel(filesToDelete)

    if isfile(filesToDelete{k})
        delete(filesToDelete{k});
    end

end

%% 6. WRITE MATLAB REQUEST

writetable(request, requestFile);

fprintf('\n====================================\n');
fprintf('FUSESAFE MATLAB-ANSYS TEST\n');
fprintf('====================================\n');

fprintf('Request created successfully.\n');
fprintf('Run ID: %s\n', runID);
fprintf('Input: %.2f\n', inputValue);

%% 7. CONSTRUCT ANSYS COMMAND

command = sprintf( ...
    '"%s" -B -R "%s"', ...
    ansysExe, journalFile);

%% 8. PASS COMMUNICATION DIRECTORY TO ANSYS

% ANSYS journal reads this environment variable.
% This avoids hard-coded repository paths.

previousDir = getenv('FUSESAFE_COMMUNICATION_DIR');

setenv('FUSESAFE_COMMUNICATION_DIR', workDir);

envCleanup = onCleanup(@() ...
    setenv('FUSESAFE_COMMUNICATION_DIR', previousDir));

%% 9. LAUNCH ANSYS WORKBENCH

fprintf('\nLaunching ANSYS Workbench...\n');

[status, commandOutput] = system(command, '-echo');

% Restore previous environment variable
clear envCleanup;

%% 10. SAVE EXECUTION LOG

fid = fopen(logFile, 'w');

assert(fid ~= -1, ...
    'Could not create ANSYS execution log.');

fprintf(fid, 'Run ID: %s\n', runID);
fprintf(fid, 'Exit code: %d\n', status);
fprintf(fid, 'Command: %s\n', command);

fprintf(fid, '\nExecution output:\n%s\n', commandOutput);

fclose(fid);

%% 11. CHECK ANSYS EXECUTION

if status ~= 0

    error(['ANSYS process failed. ' ...
        'Check ansys_batch.log for details.']);

end

if isfile(errorFile)

    error('ANSYS journal reported an error: %s', ...
        fileread(errorFile));

end

assert(isfile(responseFile), ...
    'ANSYS did not generate response.csv.');

%% 12. READ ANSYS RESPONSE

response = readtable(responseFile, ...
    'Delimiter', ',', ...
    'VariableNamingRule', 'preserve', ...
    'TextType', 'string');

%% 13. VALIDATE RESPONSE

assert(height(response) == 1, ...
    'Unexpected response row count.');

assert(response.run_id(1) == string(runID), ...
    'Run ID mismatch.');

assert(abs(response.input_value(1) - inputValue) < 1e-10, ...
    'Input value mismatch.');

assert(abs(response.result_value(1) - expectedResult) < 1e-10, ...
    'Calculation result mismatch.');

%% 14. DISPLAY FINAL RESULT

disp(response);

fprintf('\n====================================\n');
fprintf('FUSESAFE AUTOMATION TEST: PASSED\n');
fprintf('====================================\n');

fprintf('ANSYS result: %.2f\n', ...
    response.result_value(1));

fprintf('Expected result: %.2f\n', ...
    expectedResult);

fprintf('Run ID verified: %s\n', runID);

fprintf('\nMATLAB-ANSYS communication successful.\n');

