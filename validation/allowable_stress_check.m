% FUSESAFE preliminary allowable stress calculation
% Uses a typical material property, NOT a design allowable.

clear;
clc;

% Preliminary material property
yield_strength_MPa = 345;

% Required factor of safety
required_FoS = 2;

% Calculate the preliminary stress threshold
allowable_stress_MPa = yield_strength_MPa / required_FoS;

% Display inputs and result
fprintf('FUSESAFE preliminary stress threshold\n');
fprintf('Typical yield strength: %.2f MPa\n', yield_strength_MPa);
fprintf('Required factor of safety: %.2f\n', required_FoS);
fprintf('Preliminary allowable stress: %.2f MPa\n', allowable_stress_MPa);
fprintf('PROVISIONAL: typical property, not a design allowable.\n');
fprintf('No window FEA result has been checked by this script.\n');