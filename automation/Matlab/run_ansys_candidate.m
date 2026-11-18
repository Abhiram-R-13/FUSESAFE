function result = run_ansys_candidate( ...
    totalThickness_mm, projectFile, batchRoot, ansysExe)

% FUSESAFE: AUTOMATED ANSYS CANDIDATE RUNNER
%
% 1. Launches ANSYS Workbench in batch mode.
% 2. Opens the specified Workbench project.
% 3. Creates a new design point.
% 4. Updates B_Band thickness (P1) and membrane offset (P4).
% 5. Updates the structural analysis.
% 6. Checks stress and deformation outputs.
% 7. Exports and validates P1, P2, P3 and P4.
% 8. Copies Mechanical solver diagnostics.
% 9. Returns the actual candidate results to MATLAB.
%
% IMPORTANT:
% - This prototype assumes a fixed skin thickness of 2 mm.
% - The offset convention is d = (skin thickness - band thickness)/2.
% - The supplied project is saved by Workbench. Use an isolated project
%   copy for testing; do not pass the production project until validated.

%% 1. VALIDATE INPUTS

if nargin ~= 4
    error(['Four input arguments are required: ' ...
        'totalThickness_mm, projectFile, batchRoot, ansysExe.']);
end

if ~isnumeric(totalThickness_mm) || ...
        ~isscalar(totalThickness_mm) || ...
        ~isfinite(totalThickness_mm) || ...
        totalThickness_mm < 2
    error('Invalid total B_Band thickness. It must be >= 2 mm.');
end

if ~isfile(projectFile)
    error('Workbench project not found: %s', projectFile);
end

if ~isfile(ansysExe)
    error('ANSYS executable not found: %s', ansysExe);
end

if ~isfolder(batchRoot)
    [success, message] = mkdir(batchRoot);
    if ~success
        error('Could not create batch folder: %s', message);
    end
end

projectFolder = fileparts(projectFile);

if isfile(fullfile(projectFolder, '.lock'))
    error('Workbench project is locked. Close Workbench first.');
end

%% 2. CREATE UNIQUE CANDIDATE FOLDER

runID = ['CAND_' char(datetime('now', ...
    'Format', 'yyyyMMdd_HHmmss_SSS'))];

runFolder = fullfile(batchRoot, runID);

[success, message] = mkdir(runFolder);
if ~success
    error('Could not create candidate folder: %s', message);
end

journalFile = fullfile(runFolder, 'candidate.wbjn');
outputCSV = fullfile(runFolder, 'results.csv');
statusFile = fullfile(runFolder, 'status.txt');
logFile = fullfile(runFolder, 'ansys_batch.log');

%% 3. PREPARE THICKNESS AND OFFSET EXPRESSIONS

% Current prototype: skin thickness is fixed at 2 mm.
% When skin thickness becomes an app input, pass it into this function
% rather than keeping this fixed value.
skinThickness_mm = 2;

% Member 1's proposed shell-face alignment relationship.
membraneOffset_mm = ...
    (skinThickness_mm - totalThickness_mm) / 2;

thicknessExpression = sprintf( ...
    '%.12g [mm]', totalThickness_mm);

offsetExpression = sprintf( ...
    '%.12g [mm]', membraneOffset_mm);

%% 4. CREATE WORKBENCH JOURNAL

journalLines = {
    '# FUSESAFE AUTOMATED CANDIDATE RUN'
    'SetScriptVersion(Version="25.1.122")'
    'import traceback'
    'import os'
    ['projectFile = r"' projectFile '"']
    ['outputCSV = r"' outputCSV '"']
    ['statusFile = r"' statusFile '"']
    sprintf('requestedThickness = %.12g', totalThickness_mm)
    sprintf('requestedOffset = %.12g', membraneOffset_mm)
    ''
    'try:'
    '    Open(FilePath=projectFile)'
    ''
    '    actualProject = os.path.normcase(os.path.abspath(GetProjectFile()))'
    '    expectedProject = os.path.normcase(os.path.abspath(projectFile))'
    ''
    '    if actualProject != expectedProject:'
    '        raise Exception("Wrong Workbench project opened.")'
    ''
    '    SetDesignPointUpdateOption(UpdateOption="Foreground")'
    ''
    '    parameter1 = Parameters.GetParameter(Name="P1")'
    '    parameter4 = Parameters.GetParameter(Name="P4")'
    '    p2 = Parameters.GetParameter(Name="P2")'
    '    p3 = Parameters.GetParameter(Name="P3")'
    ''
    '    dp = Parameters.CreateDesignPoint(Retained=True)'
    ''
    sprintf(['    dp.SetParameterExpression(' ...
        'Parameter=parameter1, Expression="%s")'], thicknessExpression)
    sprintf(['    dp.SetParameterExpression(' ...
        'Parameter=parameter4, Expression="%s")'], offsetExpression)
    ''
    '    UpdateAllDesignPoints(DesignPoints=[dp])'
    ''
    '    p2OK = Parameters.IsParameterInDesignPointUpToDate(DesignPoint=dp, Parameter=p2)'
    '    p3OK = Parameters.IsParameterInDesignPointUpToDate(DesignPoint=dp, Parameter=p3)'
    ''
    '    if not p2OK or not p3OK:'
    '        raise Exception("FEA outputs are not up to date.")'
    ''
    '    Save(Overwrite=True)'
    ''
    '    Parameters.ExportAllDesignPointsData(FilePath=outputCSV)'
    ''
    '    f = open(statusFile, "w")'
    '    f.write("BATCH_STATUS=SUCCESS\n")'
    '    f.write("DESIGN_POINT=%s\n" % str(dp.Name))'
    '    f.write("THICKNESS_MM=%.12g\n" % requestedThickness)'
    '    f.write("OFFSET_MM=%.12g\n" % requestedOffset)'
    '    f.write("P2_UP_TO_DATE=True\n")'
    '    f.write("P3_UP_TO_DATE=True\n")'
    '    f.close()'
    ''
    'except Exception:'
    '    f = open(statusFile, "w")'
    '    f.write("BATCH_STATUS=FAILED\n")'
    '    f.write(traceback.format_exc())'
    '    f.close()'
    '    raise'
};


%% 5. WRITE JOURNAL FILE

fid = fopen(journalFile, 'w');
if fid == -1
    error('Could not create Workbench journal: %s', journalFile);
end

try
    for k = 1:numel(journalLines)
        fprintf(fid, '%s\n', journalLines{k});
    end
    fclose(fid);
catch ME
    fclose(fid);
    rethrow(ME);
end

fprintf('\nWorkbench journal created:\n%s\n', journalFile);

%% 6. LAUNCH ANSYS BATCH PROCESS

command = sprintf('"%s" -B -R "%s"', ansysExe, journalFile);

fprintf('\n====================================\n');
fprintf('FUSESAFE ANSYS BATCH EXECUTION\n');
fprintf('====================================\n');
fprintf('Requested band thickness: %.6f mm\n', totalThickness_mm);
fprintf('Requested membrane offset: %.6f mm\n', membraneOffset_mm);
fprintf('Launching ANSYS...\n');

[exitCode, commandOutput] = system(command);

%% 7. SAVE ANSYS EXECUTION LOG

fid = fopen(logFile, 'a');
if fid == -1
    error('Could not save ANSYS execution log: %s', logFile);
end

fprintf(fid, '%s', commandOutput);
fprintf(fid, '\nMATLAB_SYSTEM_EXIT_CODE=%d\n', exitCode);
fclose(fid);

fprintf('\nANSYS exit code: %d\n', exitCode);

if exitCode ~= 0
    error(['ANSYS batch execution failed. Inspect the log: %s'], logFile);
end

%% 8. VALIDATE BATCH STATUS

if ~isfile(statusFile)
    error('ANSYS status file was not generated: %s', statusFile);
end

statusLines = splitlines(string(fileread(statusFile)));

batchSuccess = any(strip(statusLines) == "BATCH_STATUS=SUCCESS");
if ~batchSuccess
    error(['ANSYS candidate execution failed. Inspect status file: %s'], ...
        statusFile);
end

dpLine = statusLines(startsWith(strip(statusLines), "DESIGN_POINT="));
if isempty(dpLine)
    error('Design point ID missing from status file.');
end

dpNumber = strip(extractAfter(dpLine(1), '='));
dpName = "DP " + dpNumber;
fprintf('\nIdentified design point: %s\n', dpName);

% Check the requested values recorded by the Workbench journal.
thicknessLine = statusLines(startsWith(strip(statusLines), "THICKNESS_MM="));
offsetLine = statusLines(startsWith(strip(statusLines), "OFFSET_MM="));

if isempty(thicknessLine) || isempty(offsetLine)
    error('Thickness or offset value is missing from the status file.');
end

recordedThickness = str2double(extractAfter(thicknessLine(1), '='));
recordedOffset = str2double(extractAfter(offsetLine(1), '='));

if ~isfinite(recordedThickness) || ...
        abs(recordedThickness - totalThickness_mm) > 1e-8
    error('Status-file thickness does not match the requested thickness.');
end

if ~isfinite(recordedOffset) || ...
        abs(recordedOffset - membraneOffset_mm) > 1e-8
    error('Status-file offset does not match the requested offset.');
end

%% 9. VALIDATE EXPORTED CSV HEADER

if ~isfile(outputCSV)
    error('ANSYS results CSV was not generated: %s', outputCSV);
end

rawLines = readlines(outputCSV);
requiredColumns = ["Name", "P1", "P2", "P3", "P4"];
headerIndex = [];
headerFields = strings(0, 1);

for lineIndex = 1:numel(rawLines)
    % Remove optional CSV quote characters around header names.
    headerText = erase(strtrim(rawLines(lineIndex)), '"');
    fields = strtrim(split(headerText, ','));
    fields(fields == "") = [];

    if all(ismember(requiredColumns, fields))
        headerIndex = lineIndex;
        headerFields = fields;
        break;
    end
end

if isempty(headerIndex)
    error(['ANSYS parameter header must contain Name, P1, P2, P3 and P4. ' ...
        'Check the exported CSV: %s'], outputCSV);
end

headerNames = cellstr(headerFields(:)');
if numel(unique(headerNames)) ~= numel(headerNames)
    error('ANSYS exported duplicate parameter column names.');
end

%% 10. IMPORT ACTUAL ANSYS RESULTS

opts = delimitedTextImportOptions('NumVariables', numel(headerNames));
opts.Delimiter = ',';
opts.VariableNamesLine = headerIndex;
opts.DataLines = [headerIndex + 1, Inf];
opts.VariableNames = headerNames;
opts.VariableTypes = repmat({'double'}, 1, numel(headerNames));

nameColumnIndex = find(strcmp(headerNames, 'Name'), 1, 'first');
if isempty(nameColumnIndex)
    error('The exported parameter table has no Name column.');
end
opts.VariableTypes{nameColumnIndex} = 'string';
opts.VariableNamingRule = 'preserve';

T = readtable(outputCSV, opts);
if isempty(T)
    error('ANSYS exported an empty parameter table.');
end

if ~all(ismember({'Name','P1','P2','P3','P4'}, ...
        T.Properties.VariableNames))
    error('ANSYS export is missing one or more required columns.');
end

%% 11. IDENTIFY THE NEW DESIGN POINT

candidate = T(T.Name == dpName, :);
if height(candidate) ~= 1
    error(['Could not uniquely identify design point %s in the ANSYS export.'], ...
        dpName);
end

%% 12. VALIDATE ACTUAL PARAMETER AND FEA RESULTS

actualThickness_mm = candidate.P1;
actualOffset_mm = candidate.P4;
actualDeformation_mm = candidate.P2;
actualStress_MPa = candidate.P3;

if ~isfinite(actualThickness_mm) || ...
        abs(actualThickness_mm - totalThickness_mm) > 1e-8
    error('ANSYS P1 thickness does not match the requested thickness.');
end

if ~isfinite(actualOffset_mm) || ...
        abs(actualOffset_mm - membraneOffset_mm) > 1e-8
    error(['ANSYS P4 membrane offset does not match the requested offset. ' ...
        'Requested %.12g mm; exported %.12g mm.'], ...
        membraneOffset_mm, actualOffset_mm);
end

if ~isfinite(actualDeformation_mm) || ~isfinite(actualStress_MPa)
    error('ANSYS returned invalid stress or deformation.');
end

if actualDeformation_mm < 0 || actualStress_MPa <= 0
    error('Invalid deformation or stress result.');
end

%% 13. VALIDATE AND COPY MECHANICAL SOLVER DIAGNOSTICS

[~, projectName] = fileparts(projectFile);
projectFilesFolder = fullfile(projectFolder, [projectName '_files']);
dpFolder = fullfile(projectFilesFolder, ['dp' char(dpNumber)]);
mechFolder = fullfile(dpFolder, 'SYS', 'MECH');
solveOutSource = fullfile(mechFolder, 'solve.out');
errorSource = fullfile(mechFolder, 'file0.err');

if ~isfile(solveOutSource) || ~isfile(errorSource)
    error(['Retained Mechanical solver diagnostics are missing. ' ...
        'Expected folder: %s'], mechFolder);
end

solveOutCopy = fullfile(runFolder, 'solve.out');
errorFileCopy = fullfile(runFolder, 'file0.err');

[copyOK, copyMessage] = copyfile(solveOutSource, solveOutCopy, 'f');
if ~copyOK
    error('Could not copy solve.out: %s', copyMessage);
end

[copyOK, copyMessage] = copyfile(errorSource, errorFileCopy, 'f');
if ~copyOK
    error('Could not copy file0.err: %s', copyMessage);
end

solveText = fileread(solveOutSource);

warningToken = regexp(solveText, ...
    'NUMBER OF WARNING MESSAGES ENCOUNTERED\s*=\s*(\d+)', ...
    'tokens', 'once');
errorToken = regexp(solveText, ...
    'NUMBER OF ERROR\s+MESSAGES ENCOUNTERED\s*=\s*(\d+)', ...
    'tokens', 'once');

if isempty(warningToken) || isempty(errorToken)
    error('Could not parse warning/error totals from solve.out.');
end

warningCount = str2double(warningToken{1});
errorCount = str2double(errorToken{1});

runCompleted = contains(solveText, 'RUN COMPLETED', 'IgnoreCase', true);
hasConverged = contains(solveText, 'SOLUTION CONVERGED', 'IgnoreCase', true);

if ~isfinite(warningCount) || ~isfinite(errorCount) || ...
        warningCount < 0 || errorCount < 0 || ...
        ~runCompleted || ~hasConverged || errorCount > 0
    error(['Mechanical solver did not pass validation. ' ...
        'RUN_COMPLETED=%d, CONVERGED=%d, WARNINGS=%g, ERRORS=%g'], ...
        runCompleted, hasConverged, warningCount, errorCount);
end

if warningCount > 0
    candidateStatus = 'SUCCESS_WITH_WARNINGS';
else
    candidateStatus = 'SUCCESS';
end

%% 14. PREPARE RETURN STRUCTURE

result.run_id = runID;
result.design_point = char(dpName);
result.total_band_thickness_mm = actualThickness_mm;
result.membrane_offset_mm = actualOffset_mm;
result.skin_thickness_assumed_mm = skinThickness_mm;
result.maximum_deformation_mm = actualDeformation_mm;
result.maximum_stress_mpa = actualStress_MPa;
result.ansys_exit_code = exitCode;
result.status = candidateStatus;
result.solver_warning_count = warningCount;
result.solver_error_count = errorCount;
result.solve_out_file = solveOutCopy;
result.error_file = errorFileCopy;
result.run_folder = runFolder;
result.results_file = outputCSV;
result.journal_file = journalFile;
result.log_file = logFile;
result.status_file = statusFile;

%% 15. DISPLAY FINAL RESULTS

fprintf('\n====================================\n');
fprintf('FUSESAFE CANDIDATE COMPLETED\n');
fprintf('====================================\n');
fprintf('Run ID: %s\n', result.run_id);
fprintf('Design point: %s\n', result.design_point);
fprintf('Total band thickness: %.6f mm\n', ...
    result.total_band_thickness_mm);
fprintf('Membrane offset: %.6f mm\n', result.membrane_offset_mm);
fprintf('Maximum deformation: %.6f mm\n', ...
    result.maximum_deformation_mm);
fprintf('Maximum stress: %.6f MPa\n', ...
    result.maximum_stress_mpa);
fprintf('ANSYS exit code: %d\n', result.ansys_exit_code);
fprintf('Solver status: %s\n', result.status);
fprintf('Results folder: %s\n', result.run_folder);
fprintf('\nCANDIDATE PROCESSING COMPLETED\n');

end
