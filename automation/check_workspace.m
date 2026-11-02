clc;
clear;

% FUSESAFE automation root folder
projectRoot = 'S:\FUSESAFE_Automation_Test\FUSESAFE_Automation';

% Required folders
requiredFolders = {
    'MATLAB'
    'Inputs'
    'Runs'
    'Logs'
    'Reference'
};

fprintf('FUSESAFE WORKSPACE CHECK\n\n');

for i = 1:length(requiredFolders)
    folderPath = fullfile(projectRoot, requiredFolders{i});

    if isfolder(folderPath)
        fprintf('[OK] %s\n', requiredFolders{i});
    else
        fprintf('[MISSING] %s\n', requiredFolders{i});
    end
end

% Check input template
inputFile = fullfile(projectRoot, 'Inputs', 'input_template.csv');

if isfile(inputFile)
    fprintf('\n[OK] input_template.csv found\n');
else
    fprintf('\n[MISSING] input_template.csv\n');
end