function plan = prepare_ansys_execution_plan_v2( ...
    runInfo, readiness, ansysExe)

% FUSESAFE V2 ANSYS EXECUTION PLAN
% Dry-run only. Does not launch ANSYS.

%% 1. Validate inputs

if ~isfolder(runInfo.run_folder)
    error('Run directory not found.');
end

requiredFields = {
    'materials_approved'
    'project_available'
    'project_verified'
    'ansys_available'
    'ready'
    'blockers'
};

for k = 1:numel(requiredFields)
    if ~isfield(readiness, requiredFields{k})
        error('Missing readiness field: %s', ...
            requiredFields{k});
    end
end

%% 2. Define execution plan

plan.run_id = runInfo.run_id;

plan.created_at = char(datetime('now', ...
    'Format', 'yyyy-MM-dd HH:mm:ss'));

plan.execution_mode = 'DRY_RUN';

plan.ansys_executable = ansysExe;

plan.ansys_available = isfile(ansysExe);

plan.materials_approved = readiness.materials_approved;

plan.project_available = readiness.project_available;

plan.project_verified = readiness.project_verified;

plan.readiness_passed = readiness.ready;

plan.launch_attempted = false;

plan.command_generated = false;

plan.execution_status = 'blocked';

plan.blockers = readiness.blockers;

%% 3. Determine status

if readiness.ready && plan.ansys_available

    plan.execution_status = ...
        'ready_for_journal_configuration';

    plan.next_action = ...
        'Configure and verify the structural ANSYS journal.';

else

    plan.execution_status = 'blocked';

    plan.next_action = ...
        'Resolve all readiness blockers before ANSYS execution.';

end

%% 4. Save execution plan

planFile = fullfile(runInfo.run_folder, ...
    'execution_plan.json');

if isfile(planFile)
    error('Execution plan already exists. Not overwriting.');
end

jsonText = jsonencode(plan, PrettyPrint=true);

fid = fopen(planFile, 'w');

if fid == -1
    error('Could not create execution plan.');
end

fprintf(fid, '%s', jsonText);

fclose(fid);

%% 5. Display result

fprintf('\n====================================\n');
fprintf('FUSESAFE ANSYS EXECUTION PLAN\n');
fprintf('====================================\n');

fprintf('Run ID: %s\n', plan.run_id);

fprintf('Mode: %s\n', plan.execution_mode);

fprintf('Status: %s\n', plan.execution_status);

fprintf('ANSYS launched: No\n');

fprintf('Saved: %s\n', planFile);

end