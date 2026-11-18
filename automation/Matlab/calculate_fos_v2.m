function [results, summary] = ...
    calculate_fos_v2(candidateData, yieldStrengthMPa, requiredFoS)

% FUSESAFE V2 FACTOR OF SAFETY CALCULATOR
%
% Uses raw maximum von-Mises stress.
% Does not suppress stress concentrations.
%
% Inputs:
% candidateData:
%   Candidate
%   TotalBandThickness_mm
%   AddedThickness_mm
%   MaxStress_MPa
%
% yieldStrengthMPa: Provisional tensile yield strength.
% requiredFoS: Required factor of safety.

%% 1. Validate inputs

if nargin ~= 3
    error('Three input arguments are required.');
end

if ~istable(candidateData) || isempty(candidateData)
    error('Candidate data must be a non-empty table.');
end

requiredVariables = {
    'Candidate'
    'TotalBandThickness_mm'
    'AddedThickness_mm'
    'MaxStress_MPa'
};

for k = 1:numel(requiredVariables)

    if ~ismember(requiredVariables{k}, ...
            candidateData.Properties.VariableNames)

        error('Missing candidate variable: %s', ...
            requiredVariables{k});

    end

end

if ~isscalar(yieldStrengthMPa) || ...
        ~isfinite(yieldStrengthMPa) || yieldStrengthMPa <= 0

    error('Yield strength must be a positive finite scalar.');

end

if ~isscalar(requiredFoS) || ...
        ~isfinite(requiredFoS) || requiredFoS <= 0

    error('Required FoS must be a positive finite scalar.');

end

%% 2. Validate candidate values

stress = candidateData.MaxStress_MPa;

if any(~isfinite(stress)) || any(stress <= 0)
    error('Maximum stress must contain positive finite values.');
end

if any(~isfinite(candidateData.TotalBandThickness_mm)) || ...
        any(candidateData.TotalBandThickness_mm <= 0)

    error('Invalid total band thickness.');

end

%% 3. Calculate allowable stress

allowableStressMPa = yieldStrengthMPa / requiredFoS;

%% 4. Calculate actual Factor of Safety

actualFoS = yieldStrengthMPa ./ stress;

%% 5. Determine acceptance

passes = actualFoS >= requiredFoS;

status = repmat("FAIL", height(candidateData), 1);

status(passes) = "PASS";

%% 6. Construct results table

results = candidateData;

results.YieldStrength_MPa = ...
    repmat(yieldStrengthMPa, height(results), 1);

results.AllowableStress_MPa = ...
    repmat(allowableStressMPa, height(results), 1);

results.RequiredFoS = ...
    repmat(requiredFoS, height(results), 1);

results.ActualFoS = actualFoS;

results.MeetsRequiredFoS = passes;

results.Status = status;

results.StressBasis = ...
    repmat("Raw maximum von-Mises stress", ...
    height(results), 1);

%% 7. Create summary

summary.yield_strength_mpa = yieldStrengthMPa;

summary.required_fos = requiredFoS;

summary.allowable_stress_mpa = allowableStressMPa;

summary.total_candidates = height(results);

summary.passing_candidates = nnz(passes);

summary.failing_candidates = nnz(~passes);

%% 8. Display results

fprintf('\n====================================\n');
fprintf('FUSESAFE V2 FACTOR OF SAFETY\n');
fprintf('====================================\n');

fprintf('Yield strength: %.2f MPa\n', ...
    yieldStrengthMPa);

fprintf('Required FoS: %.2f\n', requiredFoS);

fprintf('Allowable stress: %.2f MPa\n', ...
    allowableStressMPa);

disp(results);

fprintf('Passing candidates: %d\n', ...
    summary.passing_candidates);

fprintf('Failing candidates: %d\n', ...
    summary.failing_candidates);

fprintf('\nFoS CALCULATION COMPLETED\n');

end