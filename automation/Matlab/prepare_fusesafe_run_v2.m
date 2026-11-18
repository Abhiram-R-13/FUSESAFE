function runInfo = prepare_fusesafe_run_v2(inputFile, automationRoot)
% FUSESAFE V2 RUN PREPARATION
% Creates a unique run directory and preserves validated inputs.

%% 1. Validate arguments

if nargin ~= 2
    error('Provide inputFile and automationRoot.');
end

if ~isfile(inputFile)
    error('Input file not found: %s', inputFile);
end

if ~isfolder(automationRoot)
    error('Automation directory not found.');
end

%% 2. Read and validate inputs

data = read_fusesafe_input_v2(inputFile);

%% 3. Define Runs directory

runsRoot = fullfile(automationRoot, 'Runs');

if ~isfolder(runsRoot)
    error('Runs directory does not exist.');
end

%% 4. Generate unique Run ID

baseRunID = ['RUN_' char(datetime('now', ...
    'Format', 'yyyyMMdd_HHmmss_SSS'))];

runID = baseRunID;
runFolder = fullfile(runsRoot, runID);

counter = 1;

while isfolder(runFolder)

    runID = sprintf('%s_%02d', baseRunID, counter);

    runFolder = fullfile(runsRoot, runID);

    counter = counter + 1;

end

%% 5. Create run directory

[success, message] = mkdir(runFolder);

if ~success
    error('Run folder creation failed: %s', message);
end

%% 6. Save input snapshot

inputSnapshot = fullfile(runFolder, 'input.csv');

writetable(data, inputSnapshot);

if ~isfile(inputSnapshot)
    error('Input snapshot could not be saved.');
end

%% 7. Create manifest

manifest.run_id = runID;

manifest.run_date = char(datetime('now', ...
    'Format', 'yyyy-MM-dd HH:mm:ss'));

manifest.schema_version = '2.0';

manifest.input_file = 'input.csv';

manifest.results_file = 'results.csv';

manifest.optimization_history_file = ...
    'optimization_history.csv';

manifest.status = 'prepared';

manifest.structural_solve_completed = false;

manifest.material_configuration = 'pending_approval';

%% 8. Write JSON manifest

manifestFile = fullfile(runFolder, 'manifest.json');

jsonText = jsonencode(manifest, PrettyPrint=true);

fid = fopen(manifestFile, 'w');

if fid == -1
    error('Could not create manifest.json.');
end

fprintf(fid, '%s', jsonText);

fclose(fid);

%% 9. Prepare return information

runInfo.run_id = runID;

runInfo.run_folder = runFolder;

runInfo.input_file = inputSnapshot;

runInfo.manifest_file = manifestFile;

runInfo.status = manifest.status;

%% 10. Verify and display

if ~isfile(manifestFile)
    error('Manifest verification failed.');
end

fprintf('\n====================================\n');
fprintf('FUSESAFE V2 RUN PREPARATION: PASSED\n');
fprintf('====================================\n');

fprintf('Run ID: %s\n', runID);

fprintf('Run folder: %s\n', runFolder);

fprintf('Status: %s\n', manifest.status);

end