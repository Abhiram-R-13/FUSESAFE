function readiness = check_fusesafe_execution_readiness_v2( ...
    materialConfigFile, projectArchive, projectVerified, ansysExe)

% FUSESAFE V2 EXECUTION READINESS CHECK
% Does not launch ANSYS or modify any project.

if nargin ~= 4
    error('Four input arguments are required.');
end

%% 1. Initialize readiness report

readiness.materials_approved = false;
readiness.project_available = false;
readiness.project_verified = false;
readiness.ansys_available = false;

readiness.ready = false;
readiness.blockers = {};

%% 2. Check material approval

try
    [~, approved] = ...
        read_material_configuration_v2(materialConfigFile);

    readiness.materials_approved = approved;

catch ME
    readiness.blockers{end+1} = ...
        ['Material check failed: ' ME.message];
end

if ~readiness.materials_approved
    readiness.blockers{end+1} = ...
        'Material approval is pending.';
end

%% 3. Check project archive

if isfile(projectArchive)

    [~,~,extension] = fileparts(projectArchive);

    readiness.project_available = ...
        strcmpi(extension, '.wbpz');

end

if ~readiness.project_available
    readiness.blockers{end+1} = ...
        'Complete WBPZ project archive unavailable.';
end

%% 4. Check manual project verification

readiness.project_verified = ...
    islogical(projectVerified) && isscalar(projectVerified) ...
    && projectVerified;

if ~readiness.project_verified
    readiness.blockers{end+1} = ...
        'Project completeness has not been verified.';
end

%% 5. Check ANSYS executable

readiness.ansys_available = isfile(ansysExe);

if ~readiness.ansys_available
    readiness.blockers{end+1} = ...
        'ANSYS Workbench executable not found.';
end

%% 6. Final readiness

readiness.ready = ...
    readiness.materials_approved && ...
    readiness.project_available && ...
    readiness.project_verified && ...
    readiness.ansys_available;

%% 7. Display report

fprintf('\nFUSESAFE EXECUTION READINESS\n');

disp(readiness);

if readiness.ready
    fprintf('EXECUTION READINESS: PASSED\n');
else
    fprintf('EXECUTION READINESS: BLOCKED\n');
end

end