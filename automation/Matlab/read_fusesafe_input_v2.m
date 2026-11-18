function data = read_fusesafe_input_v2(inputFile)
% FUSESAFE V2 INPUT VALIDATION
% Validates the six application inputs against their design limits.

%% 1. Check input file

if nargin ~= 1 || ~isfile(inputFile)
    error('FUSESAFE:InputFileMissing', ...
        'A valid input CSV file must be provided.');
end

%% 2. Read CSV

data = readtable(inputFile, ...
    'VariableNamingRule', 'preserve');

%% 3. Expected columns

expectedColumns = {
    'window_width_mm'
    'window_height_mm'
    'fuselage_radius_mm'
    'skin_thickness_mm'
    'pressure_diff_kpa'
    'required_fos'
};

if ~isequal(data.Properties.VariableNames, expectedColumns')
    error('FUSESAFE:InvalidColumns', ...
        'Input CSV columns do not match the V2 interface.');
end

%% 4. Check row count

if height(data) ~= 1
    error('FUSESAFE:InvalidRowCount', ...
        'Input CSV must contain exactly one data row.');
end

%% 5. Check numeric values

values = data{1,:};

if ~isnumeric(values) || any(~isfinite(values))
    error('FUSESAFE:InvalidValues', ...
        'All six input parameters must be finite numeric values.');
end

%% 6. Design limits and step sizes

parameterNames = expectedColumns';

minimumValues = [250, 300, 1500, 1.8, 40, 1.5];
maximumValues = [500, 550, 2500, 3.0, 70, 2.5];
stepSizes = [10, 10, 100, 0.1, 5, 0.1];

%% 7. Validate ranges and increments

for k = 1:numel(values)

    value = values(k);

    if value < minimumValues(k) || value > maximumValues(k)
        error('FUSESAFE:ValueOutOfRange', ...
            '%s must be between %g and %g.', ...
            parameterNames{k}, ...
            minimumValues(k), maximumValues(k));
    end

    stepPosition = ...
        (value - minimumValues(k)) / stepSizes(k);

    if abs(stepPosition - round(stepPosition)) > 1e-8
        error('FUSESAFE:InvalidStep', ...
            '%s does not follow the required step size of %g.', ...
            parameterNames{k}, stepSizes(k));
    end

end

%% 8. Display validation result

fprintf('\n====================================\n');
fprintf('FUSESAFE V2 INPUT VALIDATION: PASSED\n');
fprintf('====================================\n');

disp(data);

fprintf('\nAll six input parameters satisfy the defined limits.\n');

end