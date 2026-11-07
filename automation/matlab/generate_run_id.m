% Generate a unique run ID
runID = ['RUN_' datestr(now, 'yyyymmdd_HHMMSS_FFF')];

% Active automation directory
automationRoot = 'S:\solid mech project\Github\FUSESAFE\automation';

% Create run folder
runFolder = fullfile(automationRoot, 'Runs', runID);

if ~exist(runFolder, 'dir')
    mkdir(runFolder);
end

fprintf('RUN ID: %s\n', runID);
fprintf('RUN FOLDER: %s\n', runFolder);
fprintf('RUN FOLDER CREATION: PASSED\n');