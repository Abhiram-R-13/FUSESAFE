function [materials, isApproved] = ...
    read_material_configuration_v2(configFile)

% FUSESAFE MATERIAL CONFIGURATION VALIDATION
% Validates material data regardless of approval status.
% Pending approval still blocks structural simulation.

%% 1. Check input

if nargin ~= 1 || ~isfile(configFile)
    error('Material configuration file not found.');
end

%% 2. Read material configuration

materials = readtable(configFile, ...
    'VariableNamingRule', 'preserve', ...
    'TextType', 'string');

%% 3. Validate column names

expectedColumns = {
    'component'
    'material_name'
    'youngs_modulus_mpa'
    'poissons_ratio'
    'density_kg_per_mm3'
    'tensile_yield_strength_mpa'
    'approval_status'
    'source_reference'
};

if ~isequal(materials.Properties.VariableNames, ...
        expectedColumns')

    error('Incorrect material configuration columns.');

end

%% 4. Validate number of components

if height(materials) ~= 2
    error('Exactly two material components are required.');
end

%% 5. Validate component names

expectedComponents = ["skin_body"; "reinforcement_band"];

actualComponents = strtrim(string(materials.component));

if any(ismissing(actualComponents)) || ...
        any(actualComponents ~= expectedComponents)

    error('Unexpected material component names.');

end

%% 6. Validate approval status

statuses = lower(strtrim(string(materials.approval_status)));

if any(ismissing(statuses)) || ...
        any(~ismember(statuses, ["pending", "approved"]))

    error('Invalid material approval status.');

end

isApproved = all(statuses == "approved");

%% 7. Validate material names and references

names = strtrim(string(materials.material_name));

sources = strtrim(string(materials.source_reference));

if any(ismissing(names)) || any(strlength(names) == 0)

    error('Material names are missing.');

end

if any(ismissing(sources)) || any(strlength(sources) == 0)

    error('Material source references are missing.');

end

%% 8. Validate mechanical properties

numericColumns = {
    'youngs_modulus_mpa'
    'poissons_ratio'
    'density_kg_per_mm3'
    'tensile_yield_strength_mpa'
};

for k = 1:numel(numericColumns)

    columnData = materials.(numericColumns{k});

    if ~isnumeric(columnData)

        error('Material property %s must be numeric.', ...
            numericColumns{k});

    end

end

properties = [
    materials.youngs_modulus_mpa, ...
    materials.poissons_ratio, ...
    materials.density_kg_per_mm3, ...
    materials.tensile_yield_strength_mpa
];

if any(~isfinite(properties), 'all') || ...
        any(properties <= 0, 'all')

    error('Material properties must be positive and finite.');

end

if any(materials.poissons_ratio >= 0.5)

    error('Invalid Poisson ratio.');

end

%% 9. Report validation and approval separately

fprintf('\n====================================\n');
fprintf('FUSESAFE MATERIAL CONFIGURATION\n');
fprintf('====================================\n');

fprintf('Material entries: %d\n', height(materials));

fprintf('Material property validation: PASSED\n');

if isApproved

    fprintf('Material approval: APPROVED\n');

else

    fprintf('Material approval: PENDING\n');

    fprintf('Structural simulation remains blocked.\n');

end

end