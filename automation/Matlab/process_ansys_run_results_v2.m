function [resultRow, summary] = ...
    process_ansys_run_results_v2(cfg)

% FUSESAFE V2 INTEGRATED ANSYS RESULT PROCESSOR
%
% Connects:
% 1. Solver log parser
% 2. Stress result extractor
% 3. Deformation extractor
% 4. Factor of Safety calculator
%
% Generates:
% results.csv
% run_summary.json
%
% Does not launch ANSYS or modify the source project.

%% 1. Validate configuration

requiredFields = {
    'run_id'
    'output_folder'
    'candidate_name'
    'total_band_thickness_mm'
    'added_thickness_mm'
    'added_mass_kg'
    'yield_strength_mpa'
    'required_fos'
    'solver_out_file'
    'error_file'
    'stress_export_file'
    'deformation_export_file'
    'material_basis_note'
};

if ~isstruct(cfg) || ~isscalar(cfg)
    error('Configuration must be a scalar structure.');
end

for k = 1:numel(requiredFields)

    if ~isfield(cfg, requiredFields{k})
        error('Missing configuration field: %s', ...
            requiredFields{k});
    end

end

%% 2. Validate output directory

if ~isfolder(cfg.output_folder)
    error('Output directory does not exist.');
end

%% 3. Validate source files

sourceFiles = {
    cfg.solver_out_file
    cfg.stress_export_file
    cfg.deformation_export_file
};

for k = 1:numel(sourceFiles)

    if ~isfile(sourceFiles{k})
        error('Required result file not found: %s', ...
            sourceFiles{k});
    end

end

%% 4. Validate numerical configuration

if ~isnumeric(cfg.yield_strength_mpa) || ...
        ~isscalar(cfg.yield_strength_mpa) || ...
        ~isfinite(cfg.yield_strength_mpa) || ...
        cfg.yield_strength_mpa <= 0

    error('Invalid yield strength.');

end

if ~isnumeric(cfg.required_fos) || ...
        ~isscalar(cfg.required_fos) || ...
        ~isfinite(cfg.required_fos) || ...
        cfg.required_fos <= 0

    error('Invalid required FoS.');

end

if ~isnumeric(cfg.added_mass_kg) || ...
        ~isscalar(cfg.added_mass_kg) || ...
        (~isfinite(cfg.added_mass_kg) && ...
         ~isnan(cfg.added_mass_kg)) || ...
        cfg.added_mass_kg < 0

    error('Invalid added mass.');

end

%% 5. Parse ANSYS solver output

fprintf('\nPROCESSING ANSYS SOLVER OUTPUT...\n');

solverReport = parse_ansys_solver_log_v2( ...
    cfg.solver_out_file, cfg.error_file);

if ~solverReport.solver_completed
    error('ANSYS solver did not report RUN COMPLETED.');
end

if ~solverReport.solution_converged
    error('ANSYS solution did not converge.');
end

if isnan(solverReport.error_count) || ...
        solverReport.error_count ~= 0

    error('Solver error count is missing or non-zero.');

end

%% 6. Extract equivalent stress

fprintf('\nEXTRACTING STRESS RESULTS...\n');

[stressReport, stressTable] = ...
    extract_ansys_results_v2(cfg.stress_export_file);

%% 7. Extract total deformation

fprintf('\nEXTRACTING DEFORMATION RESULTS...\n');

[deformationReport, deformationTable] = ...
    extract_ansys_deformation_v2( ...
    cfg.deformation_export_file);

%% 8. Cross-check mesh node counts

if solverReport.total_nodes ~= ...
        stressReport.unique_node_count

    error('Solver and stress export node counts do not match.');

end

if solverReport.total_nodes ~= ...
        deformationReport.unique_node_count

    error('Solver and deformation export node counts do not match.');

end

if ~stressReport.top_bottom_pairs_complete

    error('Stress export does not contain complete Top/Bottom pairs.');

end

if ~deformationReport.one_record_per_node

    error('Deformation export does not contain one record per node.');

end

%% 9. Prepare candidate data for FoS calculation

candidateData = table( ...
    string(cfg.candidate_name), ...
    cfg.total_band_thickness_mm, ...
    cfg.added_thickness_mm, ...
    stressReport.maximum_stress_mpa, ...
    'VariableNames', { ...
        'Candidate', ...
        'TotalBandThickness_mm', ...
        'AddedThickness_mm', ...
        'MaxStress_MPa'});

%% 10. Calculate actual Factor of Safety

fprintf('\nCALCULATING FACTOR OF SAFETY...\n');

[fosResults, fosSummary] = calculate_fos_v2( ...
    candidateData, ...
    cfg.yield_strength_mpa, ...
    cfg.required_fos);

%% 11. Construct application-compatible result row

solveStatus = string(solverReport.result_status);

errorMessage = "";

if solverReport.warning_count > 0

    errorMessage = string(sprintf( ...
        'Solver completed with %d warning(s). Review solver log.', ...
        solverReport.warning_count));

end

resultRow = table( ...
    string(cfg.run_id), ...
    cfg.added_thickness_mm, ...
    cfg.added_mass_kg, ...
    stressReport.maximum_stress_mpa, ...
    fosResults.ActualFoS(1), ...
    deformationReport.maximum_deformation_mm, ...
    solveStatus, ...
    errorMessage, ...
    'VariableNames', { ...
        'run_id', ...
        'added_thickness_mm', ...
        'added_mass_kg', ...
        'max_stress_mpa', ...
        'actual_fos', ...
        'max_deformation_mm', ...
        'solve_status', ...
        'error_message'});
%% 12. Construct integrated summary

summary.run_id = cfg.run_id;

summary.candidate_name = cfg.candidate_name;

summary.total_band_thickness_mm = ...
    cfg.total_band_thickness_mm;

summary.added_thickness_mm = cfg.added_thickness_mm;

if isnan(cfg.added_mass_kg)
    summary.added_mass_kg = [];
else
    summary.added_mass_kg = cfg.added_mass_kg;
end

summary.material_basis_note = cfg.material_basis_note;

summary.material_yield_strength_mpa = ...
    cfg.yield_strength_mpa;

summary.required_fos = cfg.required_fos;

summary.allowable_stress_mpa = ...
    fosSummary.allowable_stress_mpa;

summary.actual_fos = fosResults.ActualFoS(1);

summary.passes_required_fos = ...
    fosResults.MeetsRequiredFoS(1);

summary.stress = stressReport;

summary.deformation = deformationReport;

summary.solver = solverReport;

summary.mesh.total_nodes = solverReport.total_nodes;

summary.mesh.total_elements = solverReport.total_elements;

summary.mesh.shell281_elements = ...
    solverReport.shell281_elements;

summary.mesh.surface_effect_elements = ...
    solverReport.total_elements - solverReport.shell281_elements;

summary.result_status = char(solveStatus);

summary.processing_status = 'COMPLETED';

%% 13. Define output files

resultsFile = fullfile(cfg.output_folder, 'results.csv');

summaryFile = fullfile(cfg.output_folder, 'run_summary.json');

%% 14. Protect existing files

if isfile(resultsFile) || isfile(summaryFile)

    error(['Output already exists. Choose a new output folder ' ...
        'to avoid overwriting existing evidence.']);

end

%% 15. Save results CSV

writetable(resultRow, resultsFile);

%% 16. Save integrated JSON summary

fid = fopen(summaryFile, 'w');

if fid == -1
    error('Could not create run_summary.json.');
end

try

    fprintf(fid, '%s', ...
        jsonencode(summary, PrettyPrint=true));

    fclose(fid);

catch ME

    fclose(fid);
    rethrow(ME);

end

%% 17. Display final status

fprintf('\n========================================\n');
fprintf('FUSESAFE V2 RESULT PROCESSING SUMMARY\n');
fprintf('========================================\n');

fprintf('Run ID: %s\n', cfg.run_id);

fprintf('Maximum stress: %.6f MPa\n', ...
    stressReport.maximum_stress_mpa);

fprintf('Maximum deformation: %.6f mm\n', ...
    deformationReport.maximum_deformation_mm);

fprintf('Actual FoS: %.6f\n', ...
    fosResults.ActualFoS(1));

fprintf('Required FoS: %.2f\n', ...
    cfg.required_fos);

fprintf('FoS acceptance: %s\n', ...
    fosResults.Status(1));

fprintf('Solver status: %s\n', solveStatus);

fprintf('Result CSV: %s\n', resultsFile);

fprintf('Summary JSON: %s\n', summaryFile);

fprintf('\nRESULT PROCESSING COMPLETED\n');

end