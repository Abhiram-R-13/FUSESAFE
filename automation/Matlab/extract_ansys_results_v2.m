function [report, stressTable] = ...
    extract_ansys_results_v2(stressExport)

% FUSESAFE V2 ANSYS STRESS RESULT EXTRACTOR
%
% Reads actual ANSYS Top/Bottom equivalent stress exports.
% Preserves duplicate node records.
% Does not launch or modify ANSYS.

%% 1. Validate input

if nargin ~= 1
    error('One stress export file is required.');
end

if ~isfile(stressExport)
    error('ANSYS stress export not found.');
end

%% 2. Locate the actual column header

rawLines = readlines(stressExport);

headerIndex = find( ...
    contains(rawLines, 'Node Number') & ...
    contains(rawLines, 'Equivalent (von-Mises) Stress'), ...
    1, 'first');

if isempty(headerIndex)
    error('ANSYS stress export header not found.');
end

%% 3. Configure import

opts = delimitedTextImportOptions('NumVariables', 5);

opts.Delimiter = '\t';

opts.DataLines = [headerIndex + 1, Inf];

opts.VariableNames = {
    'Node Number'
    'X Location (mm)'
    'Y Location (mm)'
    'Z Location (mm)'
    'Equivalent (von-Mises) Stress (MPa)'
};

opts.VariableTypes = repmat({'double'}, 1, 5);

opts.VariableNamingRule = 'preserve';

%% 4. Import actual numerical data

stressTable = readtable(stressExport, opts);

if isempty(stressTable)
    error('No numerical stress records found.');
end

%% 5. Validate numerical data

numericData = stressTable{:,:};

invalidRows = any(~isfinite(numericData), 2);

report.invalid_rows = nnz(invalidRows);

if report.invalid_rows > 0
    error('Stress export contains invalid numerical records.');
end

nodeIDs = stressTable.("Node Number");

if any(nodeIDs <= 0 | nodeIDs ~= floor(nodeIDs))
    error('Invalid mesh node identifiers detected.');
end

stressValues = stressTable. ...
    ("Equivalent (von-Mises) Stress (MPa)");

if any(stressValues < 0)
    error('Negative equivalent stress detected.');
end

%% 6. Check Top/Bottom records

[uniqueNodeIDs, ~, groupIndex] = unique(nodeIDs);

rowsPerNode = accumarray(groupIndex, 1);

report.total_exported_rows = height(stressTable);

report.unique_node_count = numel(uniqueNodeIDs);

report.nodes_with_one_record = nnz(rowsPerNode == 1);

report.nodes_with_two_records = nnz(rowsPerNode == 2);

report.nodes_with_other_record_counts = ...
    nnz(rowsPerNode ~= 1 & rowsPerNode ~= 2);

report.top_bottom_pairs_complete = ...
    all(rowsPerNode == 2);

%% 7. Calculate stress statistics

[maxStress, maxIndex] = max(stressValues);

[minStress, minIndex] = min(stressValues);

report.maximum_stress_mpa = maxStress;

report.minimum_stress_mpa = minStress;

report.average_stress_mpa = mean(stressValues);

%% 8. Extract maximum-stress location

maxRow = stressTable(maxIndex,:);

report.maximum_node_id = maxRow.("Node Number");

report.maximum_location_x_mm = ...
    maxRow.("X Location (mm)");

report.maximum_location_y_mm = ...
    maxRow.("Y Location (mm)");

report.maximum_location_z_mm = ...
    maxRow.("Z Location (mm)");

report.maximum_stress_records = ...
    nnz(stressValues == maxStress);

%% 9. Extract minimum-stress location

minRow = stressTable(minIndex,:);

report.minimum_node_id = minRow.("Node Number");

report.minimum_location_x_mm = ...
    minRow.("X Location (mm)");

report.minimum_location_y_mm = ...
    minRow.("Y Location (mm)");

report.minimum_location_z_mm = ...
    minRow.("Z Location (mm)");

%% 10. Store source information

report.source_file = stressExport;

report.result_type = 'Equivalent von-Mises Stress';

report.result_position = 'Top/Bottom';

report.stress_unit = 'MPa';

report.coordinate_system = 'Global';

report.average_method = ...
    'Arithmetic mean of all exported Top/Bottom records';

%% 11. Display report

fprintf('\n====================================\n');
fprintf('FUSESAFE V2 STRESS EXTRACTION\n');
fprintf('====================================\n');

fprintf('Exported rows: %d\n', ...
    report.total_exported_rows);

fprintf('Unique nodes: %d\n', ...
    report.unique_node_count);

fprintf('Complete Top/Bottom pairs: %d\n', ...
    report.top_bottom_pairs_complete);

fprintf('\nMaximum stress: %.6f MPa\n', maxStress);

fprintf('Maximum node: %.0f\n', ...
    report.maximum_node_id);

fprintf('Maximum location: %.6f, %.6f, %.6f mm\n', ...
    report.maximum_location_x_mm, ...
    report.maximum_location_y_mm, ...
    report.maximum_location_z_mm);

fprintf('\nMinimum stress: %.6f MPa\n', minStress);

fprintf('Minimum node: %.0f\n', ...
    report.minimum_node_id);

fprintf('Average stress: %.6f MPa\n', ...
    report.average_stress_mpa);

fprintf('\nSTRESS EXTRACTION COMPLETED\n');

end