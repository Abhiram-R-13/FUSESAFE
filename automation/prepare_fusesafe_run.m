clc;
clear;

%% 1. Project paths
projectRoot = 'S:\FUSESAFE_Automation_Test\FUSESAFE_Automation';

inputFile = fullfile(projectRoot, ...
    'Inputs', 'test_input.csv');

%% 2. Read input
if ~isfile(inputFile)
    error('Input file not found.');
end

data = readtable(inputFile);

%% 3. Validate input
expectedColumns = {
    'window_width_mm'
    'window_height_mm'
    'corner_radius_mm'
    'skin_thickness_mm'
    'pressure_diff_kpa'
    'required_fos'
};

if ~isequal(data.Properties.VariableNames, expectedColumns')
    error('Input column names are incorrect.');
end

if height(data) ~= 1 || any(ismissing(data))
    error('Input data is incomplete.');
end

if any(~isfinite(data{1,:})) || any(data{1,:} <= 0)
    error('Input values must be positive and finite.');
end

%% 4. Generate unique Run ID
runID = ['RUN_' char(datetime('now', ...
    'Format', 'yyyyMMdd_HHmmss_SSS'))];

%% 5. Create run folder
runFolder = fullfile(projectRoot, 'Runs', runID);

if ~mkdir(runFolder)
    error('Could not create run folder.');
end

%% 6. Save input
writetable(data, fullfile(runFolder, 'input.csv'));

%% 7. Create manifest
manifest.run_id = runID;
manifest.run_date = char(datetime('now', ...
    'Format', 'yyyy-MM-dd HH:mm:ss'));
manifest.input_file = 'input.csv';
manifest.results_file = 'results.csv';
manifest.status = 'prepared';

jsonText = jsonencode(manifest, PrettyPrint=true);

fid = fopen(fullfile(runFolder, 'manifest.json'), 'w');

if fid == -1
    error('Could not create manifest.');
end

fprintf(fid, '%s', jsonText);
fclose(fid);

%% 8. Display confirmation
fprintf('\nFUSESAFE RUN PREPARATION: PASSED\n');
fprintf('Run ID: %s\n', runID);
fprintf('Run folder: %s\n', runFolder);
fprintf('Status: %s\n', manifest.status);