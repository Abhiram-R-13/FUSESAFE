% FUSESAFE Workspace Verification Utility

%% FUSESAFE automation root folder

projectRoot = 'S:\solid mech project\Github\FUSESAFE\automation';

%% Required folders

requiredFolders = {
    'matlab'
    'communication_test'
    'Inputs'
    'Runs'
    'Logs'
    'Reference'
};

fprintf('FUSESAFE WORKSPACE CHECK\n\n');

allFoldersPresent = true;

for i = 1:length(requiredFolders)

    folderPath = fullfile(projectRoot, requiredFolders{i});

    if isfolder(folderPath)
        fprintf('[OK] %s\n', requiredFolders{i});
    else
        fprintf('[MISSING] %s\n', requiredFolders{i});
        allFoldersPresent = false;
    end

end

%% Check input template

inputFile = fullfile(projectRoot, 'Inputs', 'input_template.csv');

if isfile(inputFile)
    fprintf('\n[OK] input_template.csv found\n');
else
    fprintf('\n[MISSING] input_template.csv\n');
    allFoldersPresent = false;
end

%% Final status

if allFoldersPresent
    fprintf('\nWORKSPACE CHECK: PASSED\n');
else
    error('WORKSPACE CHECK: FAILED. Missing folders or files.');
end