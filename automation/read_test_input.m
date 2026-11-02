clc;
clear;

% Project paths
projectRoot = 'S:\FUSESAFE_Automation_Test\FUSESAFE_Automation';
inputFile = fullfile(projectRoot, 'Inputs', 'test_input.csv');

% Check whether the file exists
if ~isfile(inputFile)
    error('Test input file not found.');
end

% Read CSV
data = readtable(inputFile);

% Expected columns
expectedColumns = {
    'window_width_mm'
    'window_height_mm'
    'corner_radius_mm'
    'skin_thickness_mm'
    'pressure_diff_kpa'
    'required_fos'
};

% Validate column names
if ~isequal(data.Properties.VariableNames, expectedColumns')
    error('Input column names do not match the agreed interface.');
end

% Check for missing or invalid values
if height(data) ~= 1 || any(ismissing(data))
    error('Input must contain exactly one complete data row.');
end

% Display values
disp('FUSESAFE INPUT VALIDATION: PASSED');
disp(data);