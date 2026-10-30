% FUSESAFE baseline analytical reference
% Thin, closed cylinder WITHOUT a window.
% These are hand-calculation reference values, not FEA results.

clear;
clc;

% Baseline inputs
pressure_kPa = 55;
radius_mm = 2000;
skin_thickness_mm = 2;

% Convert pressure to MPa
pressure_MPa = pressure_kPa / 1000;

% Nominal membrane stresses
hoop_stress_MPa = pressure_MPa * radius_mm / skin_thickness_mm;

axial_stress_MPa = pressure_MPa * radius_mm ...
    / (2 * skin_thickness_mm);

% Plane-stress von Mises stress; in-plane shear is zero
von_mises_MPa = sqrt(hoop_stress_MPa^2 ...
    + axial_stress_MPa^2 ...
    - hoop_stress_MPa * axial_stress_MPa);

% Display results
fprintf('FUSESAFE intact-cylinder analytical reference\n');
fprintf('Pressure: %.3f MPa\n', pressure_MPa);
fprintf('Hoop stress: %.2f MPa\n', hoop_stress_MPa);
fprintf('Axial stress: %.2f MPa\n', axial_stress_MPa);
fprintf('Nominal von Mises stress: %.2f MPa\n', von_mises_MPa);
fprintf('These are analytical values, not window FEA results.\n');