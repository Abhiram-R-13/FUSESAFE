
% FUSESAFE preliminary allowable stress calculation
% Uses the team's revised provisional yield-strength input.
% This is an educational screening threshold, NOT a certified
% aircraft structural design allowable.

clear;
clc;

% Current provisional ANSYS material input
material_name = 'AA2024_T3_Bare_Provisional';
yield_strength_MPa = 290;

% Required factor of safety
required_FoS = 2;

% Calculate preliminary screening threshold
allowable_stress_MPa = yield_strength_MPa / required_FoS;

% Display inputs and result
fprintf('FUSESAFE preliminary stress threshold\n');
fprintf('Material: %s\n', material_name);
fprintf('Provisional yield strength: %.2f MPa\n', yield_strength_MPa);
fprintf('Required factor of safety: %.2f\n', required_FoS);
fprintf('Preliminary allowable stress: %.2f MPa\n', allowable_stress_MPa);

fprintf('\nPROVISIONAL: 290 MPa is a team-selected modelling input.\n');
fprintf('It is not a certified sheet-specific design allowable.\n');
fprintf('No window FEA result is calculated by this script.\n');
