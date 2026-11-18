clc;
clear;
close all;

%% 1. DEFINE ALL PATHS

projectRoot = 'S:\solid mech project\Github\FUSESAFE';

workingRoot = 'S:\solid mech project\FUSESAFE_M4_Working\09_Day3_FreshSolve_Copy';

processedFolder = fullfile(workingRoot, ...
    'Results_Export', ...
    'Processed_Fresh_Day3_20261109');

exportFolder = fullfile(workingRoot, 'Results_Export');

mechFolder = fullfile(workingRoot, ...
    'FUSESAFE_M2_B_Day3_Fine_Setup_files', ...
    'dp0', 'SYS', 'MECH');

runID = 'RUN_DAY3_FRESH_20261109_01';

runFolder = fullfile(projectRoot, ...
    'automation', 'Runs', runID);

%% 2. CHECK SOURCE FILES BEFORE COPYING

requiredFiles = {
    fullfile(processedFolder, 'results.csv')
    fullfile(processedFolder, 'run_summary.json')
    fullfile(processedFolder, 'optimization_history.csv')
    fullfile(exportFolder, 'fresh_equivalent_stress_top_bottom.txt')
    fullfile(exportFolder, 'fresh_total_deformation.txt')
    fullfile(mechFolder, 'solve.out')
};

for i = 1:numel(requiredFiles)

    if ~isfile(requiredFiles{i})
        error('Required source file is missing:\n%s', ...
            requiredFiles{i});
    end

end

fprintf('All required source files found.\n');

%% 3. CREATE RUN FOLDER STRUCTURE

folders = {
    fullfile(runFolder, 'Inputs')
    fullfile(runFolder, 'Raw_ANSYS')
    fullfile(runFolder, 'Processed_Results')
    fullfile(runFolder, 'Logs')
};

for i = 1:numel(folders)

    if ~exist(folders{i}, 'dir')
        mkdir(folders{i});
    end

end

fprintf('Folder structure created.\n');

%% 4. COPY PROCESSED RESULTS

copyfile(fullfile(processedFolder, 'results.csv'), ...
    fullfile(runFolder, 'Processed_Results'));

copyfile(fullfile(processedFolder, 'run_summary.json'), ...
    fullfile(runFolder, 'Processed_Results'));

copyfile(fullfile(processedFolder, 'optimization_history.csv'), ...
    fullfile(runFolder, 'Processed_Results'));

fprintf('Processed results copied.\n');

%% 5. COPY RAW ANSYS EXPORTS

copyfile(fullfile(exportFolder, ...
    'fresh_equivalent_stress_top_bottom.txt'), ...
    fullfile(runFolder, 'Raw_ANSYS'));

copyfile(fullfile(exportFolder, ...
    'fresh_total_deformation.txt'), ...
    fullfile(runFolder, 'Raw_ANSYS'));

fprintf('Raw ANSYS exports copied.\n');

%% 6. COPY SOLVER FILES

solverFiles = {
    'solve.out'
    'file0.err'
    'ds.dat'
    'file.rst'
};

for i = 1:numel(solverFiles)

    sourceFile = fullfile(mechFolder, solverFiles{i});

    if isfile(sourceFile)

        copyfile(sourceFile, fullfile(runFolder, 'Logs'));

        fprintf('Copied solver file: %s\n', solverFiles{i});

    else

        fprintf('Optional solver file not found: %s\n', ...
            solverFiles{i});

    end

end

%% 7. CREATE INPUT RECORD

inputRecord.run_id = runID;

inputRecord.candidate_name = 'C_Day3_Fresh_4mm';

inputRecord.total_band_thickness_mm = 4;
inputRecord.added_thickness_mm = 2;
inputRecord.added_mass_kg = [];

inputRecord.elastic_modulus_mpa = 73100;
inputRecord.poisson_ratio = 0.33;
inputRecord.density_kg_m3 = 2780;

inputRecord.workbench_yield_strength_mpa = 345;
inputRecord.assessment_yield_strength_mpa = 290;

inputRecord.required_fos = 2;

inputRecord.material_approval = 'PENDING';

inputRecord.material_note = ...
    '290 MPa is the provisional assessment basis. Workbench stores 345 MPa yield strength.';

inputRecord.source_project = ...
    'FUSESAFE_M2_B_Day3_Fine_Setup.wbpj';

inputRecord.source_project_location = workingRoot;

inputRecord.input_completeness_note = ...
    'Refer to the source Workbench project for complete geometry and loading definitions.';

jsonText = jsonencode(inputRecord, 'PrettyPrint', true);

fid = fopen(fullfile(runFolder, ...
    'Inputs', 'input_record.json'), 'w');

if fid == -1
    error('Could not create input_record.json');
end

fprintf(fid, '%s', jsonText);
fclose(fid);

fprintf('Input record created.\n');

%% 8. CREATE RUN MANIFEST

manifest.run_id = runID;

manifest.candidate_name = 'C_Day3_Fresh_4mm';

manifest.run_type = 'Fresh baseline structural simulation';

manifest.processing_status = 'COMPLETED';

manifest.solver_status = 'SUCCESS_WITH_WARNINGS';

manifest.maximum_stress_mpa = 464.23;

manifest.maximum_deformation_mm = 13.157;

manifest.actual_fos = 0.624690347457079;

manifest.required_fos = 2;

manifest.acceptance = 'FAIL';

manifest.solver_errors = 0;

manifest.solver_warnings = 4;

manifest.added_mass_status = 'NOT_CALCULATED';

manifest.material_approval = 'PENDING';

manifest.optimization_status = ...
    'Baseline only - optimization search not performed';

manifest.package_created = datestr(now, ...
    'yyyy-mm-dd HH:MM:SS');

jsonText = jsonencode(manifest, 'PrettyPrint', true);

fid = fopen(fullfile(runFolder, ...
    'run_manifest.json'), 'w');

if fid == -1
    error('Could not create run_manifest.json');
end

fprintf(fid, '%s', jsonText);
fclose(fid);

fprintf('Run manifest created.\n');

%% 9. VERIFY GENERATED PACKAGE

fprintf('\n========================================\n');
fprintf('FUSESAFE RUN PACKAGE VERIFICATION\n');
fprintf('========================================\n');

allFiles = dir(fullfile(runFolder, '**', '*'));

allFiles = allFiles(~[allFiles.isdir]);

for i = 1:numel(allFiles)

    fprintf('%s | %.2f MB\n', ...
        fullfile(allFiles(i).folder, allFiles(i).name), ...
        allFiles(i).bytes / 1e6);

end

fprintf('\nTotal files: %d\n', numel(allFiles));

fprintf('\nPackage location:\n%s\n', runFolder);

fprintf('\nRUN PACKAGE CREATION COMPLETED\n');