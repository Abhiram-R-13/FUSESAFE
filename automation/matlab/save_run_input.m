% Save input data into the specified run folder

% Active automation directory
automationRoot = 'S:\solid mech project\Github\FUSESAFE\automation';

% Input file
inputFile = fullfile(automationRoot, 'Inputs', 'test_input.csv');

% Check input file
if ~isfile(inputFile)
    error('Input file not found: %s', inputFile);
end

% Read input data
data = readtable(inputFile);

% Check runID exists
if ~exist('runID', 'var')
    error('runID is not available. Generate a run ID first.');
end

% Locate run folder
runFolder = fullfile(automationRoot, 'Runs', runID);

% Check run folder exists
if ~exist(runFolder, 'dir')
    error('Run folder does not exist: %s', runFolder);
end

% Save input copy
outputFile = fullfile(runFolder, 'input.csv');
writetable(data, outputFile);

% Verify
if isfile(outputFile)
    fprintf('INPUT SAVING: PASSED\n');
    fprintf('Saved at: %s\n', outputFile);
else
    error('Input file was not saved.');
end