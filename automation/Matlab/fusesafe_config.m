function cfg = fusesafe_config()
% Central configuration for FUSESAFE Member 4 backend.

% Update these paths when moving to another computer.

cfg.projectRoot = 'S:\solid mech project\FUSESAFE_M4_Working\16_P1P4_Optimization_Project';

cfg.projectFile = fullfile(cfg.projectRoot, 'FUSESAFE_Thickness_Study.wbpj');

cfg.ansysExe = 'S:\STUDY\PROGRAM_FILES\Ansys\Ansys folder\ANSYS Inc\v251\Framework\bin\Win64\RunWB2.exe';

cfg.runsRoot = fullfile(cfg.projectRoot, 'Optimization_Runs_P1P4');

cfg.lockFile = fullfile(cfg.projectRoot, '.lock');

end