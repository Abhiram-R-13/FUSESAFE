% FUSESAFE Input Validation Utility

%% 1. Project paths

projectRoot = 'S:\solid mech project\Github\FUSESAFE\automation';

inputFile = fullfile(projectRoot, 'Inputs', 'test_input.csv');

%% 2. Check whether the input file exists

if ~isfile(inputFile)
    error('Test input file not found: %s', inputFile);
end

%% 3. Read CSV

data = readtable(inputFile);

%% 4. Define expected columns

expectedColumns = {
    'window_width_mm'
    'window_height_mm'
    'corner_radius_mm'
    'skin_thickness_mm'
    'pressure_diff_kpa'
    'required_fos'
};

%% 5. Validate column names

if ~isequal(data.Properties.VariableNames, expectedColumns')
    error('Input column names do not match the agreed interface.');
end

%% 6. Check row count and missing values

if height(data) ~= 1 || any(ismissing(data))
    error('Input must contain exactly one complete data row.');
end

%% 7. Check positive and finite values

if any(~isfinite(data{1,:})) || any(data{1,:} <= 0)
    error('Input values must be positive and finite.');
end

%% 8. Display validation result

fprintf('\nFUSESAFE INPUT VALIDATION: PASSED\n\n');

disp(data);

fprintf('\nAll six input parameters are valid.\n');