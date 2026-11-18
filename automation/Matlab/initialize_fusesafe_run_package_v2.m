function [runInfo, readiness, plan, packageReport] = ...
    initialize_fusesafe_run_package_v2( ...
    inputFile, automationRoot, projectArchive, ...
    projectVerified, ansysExe)

% FUSESAFE V2 COMPLETE RUN PACKAGE INITIALIZATION
% Creates and validates a complete pre-simulation run package.
% Does NOT launch ANSYS or perform structural FEA.

%% 1. Validate arguments

if nargin ~= 5
    error('Five input arguments are required.');
end

if ~islogical(projectVerified) || ~isscalar(projectVerified)
    error('projectVerified must be a logical scalar.');
end

%% 2. Locate reference templates

referenceFolder = fullfile(automationRoot, 'Reference');

resultsTemplate = fullfile(referenceFolder, ...
    'results_template_v2.csv');

historyTemplate = fullfile(referenceFolder, ...
    'optimization_history_template_v2.csv');

materialTemplate = fullfile(referenceFolder, ...
    'material_configuration_template_v2.csv');

requiredFiles = {
    inputFile
    resultsTemplate
    historyTemplate
    materialTemplate
};

for k = 1:numel(requiredFiles)
    if ~isfile(requiredFiles{k})
        error('Required file missing: %s', requiredFiles{k});
    end
end

%% 3. Prepare run directory and input snapshot

runInfo = prepare_fusesafe_run_v2( ...
    inputFile, automationRoot);

%% 4. Initialize output files

resultsFile = fullfile(runInfo.run_folder, 'results.csv');

historyFile = fullfile(runInfo.run_folder, ...
    'optimization_history.csv');

materialFile = fullfile(runInfo.run_folder, ...
    'material_configuration.csv');

outputFiles = {resultsFile, historyFile, materialFile};

for k = 1:numel(outputFiles)
    if isfile(outputFiles{k})
        error('Output file already exists: %s', outputFiles{k});
    end
end

copyfile(resultsTemplate, resultsFile);
copyfile(historyTemplate, historyFile);
copyfile(materialTemplate, materialFile);

%% 5. Check execution readiness

readiness = check_fusesafe_execution_readiness_v2( ...
    materialFile, projectArchive, projectVerified, ansysExe);

%% 6. Save readiness report

readinessFile = fullfile(runInfo.run_folder, ...
    'execution_readiness.json');

fid = fopen(readinessFile, 'w');

if fid == -1
    error('Could not create execution_readiness.json.');
end

fprintf(fid, '%s', jsonencode(readiness, PrettyPrint=true));
fclose(fid);

%% 7. Prepare ANSYS execution plan

plan = prepare_ansys_execution_plan_v2( ...
    runInfo, readiness, ansysExe);

%% 8. Validate complete run package

packageReport = validate_fusesafe_run_package_v2(runInfo);

%% 9. Update returned run information

runInfo.results_file = resultsFile;
runInfo.history_file = historyFile;
runInfo.material_file = materialFile;
runInfo.readiness_file = readinessFile;

runInfo.execution_plan_file = fullfile( ...
    runInfo.run_folder, 'execution_plan.json');

runInfo.package_validation_file = fullfile( ...
    runInfo.run_folder, 'package_validation.json');

%% 10. Display final status

fprintf('\n========================================\n');
fprintf('FUSESAFE V2 INITIALIZATION SUMMARY\n');
fprintf('========================================\n');

fprintf('Run ID: %s\n', runInfo.run_id);
fprintf('Package validation: %d\n', packageReport.package_valid);
fprintf('Execution readiness: %d\n', readiness.ready);
fprintf('ANSYS launched: No\n');

fprintf('Run folder: %s\n', runInfo.run_folder);

fprintf('\nINITIALIZATION COMPLETED\n');

end