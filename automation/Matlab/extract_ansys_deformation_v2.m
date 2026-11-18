function [report, deformationTable] = ...
    extract_ansys_deformation_v2(deformationExport)

% FUSESAFE V2 ANSYS DEFORMATION EXTRACTOR
%
% Extracts actual ANSYS total deformation results.
% Identifies maximum and minimum deformation locations.
% Does not launch or modify ANSYS.

%% 1. Validate input

if nargin ~= 1
    error('One deformation export file is required.');
end

if ~isfile(deformationExport)
    error('ANSYS deformation export not found.');
end

%% 2. Locate column header

rawLines = readlines(deformationExport);

headerIndex = find( ...
    contains(rawLines, 'Node Number') & ...
    contains(rawLines, 'Total Deformation (mm)'), ...
    1, 'first');

if isempty(headerIndex)
    error('ANSYS deformation export header not found.');
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
    'Total Deformation (mm)'
};

opts.VariableTypes = repmat({'double'}, 1, 5);

opts.VariableNamingRule = 'preserve';

%% 4. Import data

deformationTable = readtable(deformationExport, opts);

if isempty(deformationTable)
    error('No numerical deformation records found.');
end

%% 5. Validate numerical data

numericData = deformationTable{:,:};

invalidRows = any(~isfinite(numericData), 2);

report.invalid_rows = nnz(invalidRows);

if report.invalid_rows > 0
    error('Deformation export contains invalid records.');
end

nodeIDs = deformationTable.("Node Number");

if any(nodeIDs <= 0 | nodeIDs ~= floor(nodeIDs))
    error('Invalid mesh node identifiers detected.');
end

deformationValues = deformationTable. ...
    ("Total Deformation (mm)");

if any(deformationValues < 0)
    error('Negative total deformation detected.');
end

%% 6. Validate node records

[uniqueNodeIDs, ~, groupIndex] = unique(nodeIDs);

rowsPerNode = accumarray(groupIndex, 1);

report.total_exported_rows = height(deformationTable);

report.unique_node_count = numel(uniqueNodeIDs);

report.duplicate_node_count = ...
    nnz(rowsPerNode > 1);

report.nodes_with_one_record = ...
    nnz(rowsPerNode == 1);

report.one_record_per_node = ...
    all(rowsPerNode == 1);

%% 7. Calculate deformation statistics

[maxDeformation, maxIndex] = max(deformationValues);

[minDeformation, minIndex] = min(deformationValues);

report.maximum_deformation_mm = maxDeformation;

report.minimum_deformation_mm = minDeformation;

report.average_deformation_mm = mean(deformationValues);

%% 8. Extract maximum deformation location

maxRow = deformationTable(maxIndex,:);

report.maximum_node_id = maxRow.("Node Number");

report.maximum_location_x_mm = ...
    maxRow.("X Location (mm)");

report.maximum_location_y_mm = ...
    maxRow.("Y Location (mm)");

report.maximum_location_z_mm = ...
    maxRow.("Z Location (mm)");

%% 9. Extract minimum deformation location

minRow = deformationTable(minIndex,:);

report.minimum_node_id = minRow.("Node Number");

report.minimum_location_x_mm = ...
    minRow.("X Location (mm)");

report.minimum_location_y_mm = ...
    minRow.("Y Location (mm)");

report.minimum_location_z_mm = ...
    minRow.("Z Location (mm)");

%% 10. Store source information

report.source_file = deformationExport;

report.result_type = 'Total Deformation';

report.deformation_unit = 'mm';

report.coordinate_system = 'Global';

report.display_time = 'Last';

%% 11. Display results

fprintf('\n====================================\n');
fprintf('FUSESAFE V2 DEFORMATION EXTRACTION\n');
fprintf('====================================\n');

fprintf('Exported rows: %d\n', ...
    report.total_exported_rows);

fprintf('Unique nodes: %d\n', ...
    report.unique_node_count);

fprintf('Invalid rows: %d\n', ...
    report.invalid_rows);

fprintf('One record per node: %d\n', ...
    report.one_record_per_node);

fprintf('\nMaximum deformation: %.6f mm\n', ...
    report.maximum_deformation_mm);

fprintf('Maximum node: %.0f\n', ...
    report.maximum_node_id);

fprintf('Maximum location: %.6f, %.6f, %.6f mm\n', ...
    report.maximum_location_x_mm, ...
    report.maximum_location_y_mm, ...
    report.maximum_location_z_mm);

fprintf('\nMinimum deformation: %.6f mm\n', ...
    report.minimum_deformation_mm);

fprintf('Average deformation: %.6f mm\n', ...
    report.average_deformation_mm);

fprintf('\nDEFORMATION EXTRACTION COMPLETED\n');

end