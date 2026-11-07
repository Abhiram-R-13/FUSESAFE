clc;
clearvars;

%% 1. Define file locations

workDir = 'S:\solid mech project\Github\FUSESAFE\automation\communication_test';

ansysExe = ...
    'S:\STUDY\PROGRAM_FILES\Ansys\Ansys folder\ANSYS Inc\v251\Framework\bin\Win64\RunWB2.exe';

journalFile = fullfile(workDir, 'ansys_test.wbjn');

requestFile = fullfile(workDir, 'request.csv');
responseFile = fullfile(workDir, 'response.csv');

errorFile = fullfile(workDir, 'ansys_error.txt');
logFile = fullfile(workDir, 'ansys_batch.log');


%% 2. Generate a unique request

runID = char(datetime('now', ...
    'Format', 'yyyyMMdd_HHmmss_SSS'));

inputValue = 7.35;

expectedResult = inputValue * 2;

request = table(string(runID), inputValue, ...
    'VariableNames', {'run_id', 'input_value'});


%% 3. Verify required files

assert(isfile(ansysExe), ...
    'Ansys executable not found.');

assert(isfile(journalFile), ...
    'Ansys journal not found.');


%% 4. Remove previous outputs

filesToDelete = {responseFile, errorFile, logFile};

for k = 1:numel(filesToDelete)

    if isfile(filesToDelete{k})
        delete(filesToDelete{k});
    end

end


%% 5. Write MATLAB request

writetable(request, requestFile);

fprintf('\nRequest created.\n');
fprintf('Run ID: %s\n', runID);
fprintf('Input: %.2f\n', inputValue);


%% 6. Construct Ansys command

command = sprintf( ...
    '"%s" -B -R "%s"', ...
    ansysExe, journalFile);


%% 7. Launch Ansys and wait

fprintf('\nLaunching Ansys Workbench...\n');

[status, commandOutput] = system(command, '-echo');


%% 8. Save execution information

fid = fopen(logFile, 'w');

assert(fid ~= -1, ...
    'Could not create Ansys execution log.');

fprintf(fid, 'Run ID: %s\n', runID);
fprintf(fid, 'Exit code: %d\n', status);
fprintf(fid, 'Command: %s\n', command);
fprintf(fid, '\nExecution output:\n%s\n', commandOutput);

fclose(fid);


%% 9. Check Ansys execution

if status ~= 0

    error('Ansys process failed. Check ansys_batch.log.');

end

if isfile(errorFile)

    error('Ansys journal reported an error: %s', ...
        fileread(errorFile));

end

assert(isfile(responseFile), ...
    'Ansys did not generate response.csv.');


%% 10. Read Ansys response

response = readtable(responseFile, ...
    'Delimiter', ',', ...
    'VariableNamingRule', 'preserve', ...
    'TextType', 'string');


%% 11. Validate response

assert(height(response) == 1, ...
    'Unexpected response row count.');

assert(response.run_id(1) == string(runID), ...
    'Run ID mismatch.');

assert(abs(response.input_value(1) - inputValue) < 1e-10, ...
    'Input value mismatch.');

assert(abs(response.result_value(1) - expectedResult) < 1e-10, ...
    'Calculation result mismatch.');


%% 12. Display final result

disp(response);

fprintf('\n====================================\n');
fprintf('FUSESAFE AUTOMATION TEST: PASSED\n');
fprintf('====================================\n');

fprintf('Ansys result: %.2f\n', ...
    response.result_value(1));

fprintf('Run ID verified: %s\n', runID);