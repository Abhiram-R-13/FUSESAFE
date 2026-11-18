function report = validate_fusesafe_run_package_v2(runInfo)
% FUSESAFE V2 RUN PACKAGE VALIDATION
% Checks files, schemas and run metadata.
% Does not launch ANSYS or perform structural FEA.

%% 1. Check run information

if ~isstruct(runInfo) || ...
        ~isfield(runInfo, 'run_id') || ...
        ~isfield(runInfo, 'run_folder')

    error('Invalid runInfo structure.');
end

runFolder = runInfo.run_folder;

if ~isfolder(runFolder)
    error('Run folder does not exist.');
end

%% 2. Define required files

fileNames = {
    'input.csv'
    'manifest.json'
    'material_configuration.csv'
    'results.csv'
    'optimization_history.csv'
    'execution_readiness.json'
    'execution_plan.json'
};

checks = struct();

%% 3. Check file existence

for k = 1:numel(fileNames)

    fieldName = matlab.lang.makeValidName(fileNames{k});

    checks.(fieldName) = ...
        isfile(fullfile(runFolder, fileNames{k}));

end

%% 4. Stop if required files are missing

fileChecks = cell2mat(struct2cell(checks));

if ~all(fileChecks)
    error('Run package contains missing files.');
end

%% 5. Read package files

inputData = readtable(fullfile(runFolder, 'input.csv'), ...
    'VariableNamingRule', 'preserve');

manifest = jsondecode(fileread( ...
    fullfile(runFolder, 'manifest.json')));

materials = readtable( ...
    fullfile(runFolder, 'material_configuration.csv'), ...
    'VariableNamingRule', 'preserve');

results = readtable(fullfile(runFolder, 'results.csv'), ...
    'VariableNamingRule', 'preserve');

history = readtable( ...
    fullfile(runFolder, 'optimization_history.csv'), ...
    'VariableNamingRule', 'preserve');

readiness = jsondecode(fileread( ...
    fullfile(runFolder, 'execution_readiness.json')));

plan = jsondecode(fileread( ...
    fullfile(runFolder, 'execution_plan.json')));

%% 6. Validate input schema

expectedInput = {
    'window_width_mm'
    'window_height_mm'
    'fuselage_radius_mm'
    'skin_thickness_mm'
    'pressure_diff_kpa'
    'required_fos'
};

checks.input_schema = isequal( ...
    inputData.Properties.VariableNames, expectedInput');

checks.input_row = height(inputData) == 1;

checks.input_numeric = ...
    isnumeric(inputData{1,:}) && ...
    all(isfinite(inputData{1,:})) && ...
    all(inputData{1,:} > 0);

%% 7. Validate manifest

checks.manifest_run_id = ...
    strcmp(manifest.run_id, runInfo.run_id);

checks.manifest_status = ...
    strcmp(manifest.status, 'prepared');

checks.solve_not_completed = ...
    ~manifest.structural_solve_completed;

checks.manifest_schema_version = ...
    strcmp(manifest.schema_version, '2.0');

%% 8. Validate material configuration

expectedMaterial = {
    'component'
    'material_name'
    'youngs_modulus_mpa'
    'poissons_ratio'
    'density_kg_per_mm3'
    'tensile_yield_strength_mpa'
    'approval_status'
    'source_reference'
};

checks.material_schema = isequal( ...
    materials.Properties.VariableNames, expectedMaterial');

expectedComponents = ...
    ["skin_body"; "reinforcement_band"];

checks.material_components = ...
    height(materials) == 2 && ...
    all(string(materials.component) == expectedComponents);

checks.material_pending = ...
    all(lower(string(materials.approval_status)) == "pending");

%% 9. Validate results schemas

expectedResults = {
    'run_id'
    'added_thickness_mm'
    'added_mass_kg'
    'max_stress_mpa'
    'actual_fos'
    'max_deformation_mm'
    'solve_status'
    'error_message'
};

expectedHistory = {
    'iteration'
    'added_thickness_mm'
    'added_mass_kg'
    'max_stress_mpa'
    'actual_fos'
    'solve_status'
};

checks.results_schema = isequal( ...
    results.Properties.VariableNames, expectedResults');

checks.history_schema = isequal( ...
    history.Properties.VariableNames, expectedHistory');

checks.results_empty = height(results) == 0;

checks.history_empty = height(history) == 0;

%% 10. Validate execution protection

checks.readiness_blocked = ~readiness.ready;

checks.plan_blocked = ...
    strcmp(plan.execution_status, 'blocked');

checks.dry_run_mode = ...
    strcmp(plan.execution_mode, 'DRY_RUN');

checks.ansys_not_launched = ~plan.launch_attempted;

%% 11. Final validation

allChecks = cell2mat(struct2cell(checks));

report.run_id = runInfo.run_id;

report.checked_at = char(datetime('now', ...
    'Format', 'yyyy-MM-dd HH:mm:ss'));

report.package_valid = all(allChecks);

report.checks = checks;

%% 12. Save validation report

reportFile = fullfile(runFolder, ...
    'package_validation.json');

if isfile(reportFile)
    error('Package validation report already exists.');
end

fid = fopen(reportFile, 'w');

if fid == -1
    error('Could not create package validation report.');
end

fprintf(fid, '%s', ...
    jsonencode(report, PrettyPrint=true));

fclose(fid);

%% 13. Display report

fprintf('\n====================================\n');
fprintf('FUSESAFE V2 PACKAGE VALIDATION\n');
fprintf('====================================\n');

disp(checks);

fprintf('Package valid: %d\n', report.package_valid);

fprintf('Report: %s\n', reportFile);

end