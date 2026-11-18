function report = parse_ansys_solver_log_v2(solverOutFile, errFile)

% FUSESAFE V2 ANSYS SOLVER LOG PARSER
% Extracts solver status, warnings, errors, mesh statistics,
% completed substeps and execution time.
%
% Does not launch or modify ANSYS.

%% 1. Validate input arguments

if nargin ~= 2
    error('Two input arguments are required.');
end

if ~isfile(solverOutFile)
    error('Solver output file not found: %s', solverOutFile);
end

%% 2. Read solver files

logText = fileread(solverOutFile);

if isfile(errFile)
    errText = fileread(errFile);
else
    errText = '';
end

logLines = splitlines(string(logText));

%% 3. Solver completion status

report.solver_completed = ...
    contains(logText, 'RUN COMPLETED', 'IgnoreCase', true);

report.solution_converged = ...
    contains(logText, 'SOLUTION CONVERGED', 'IgnoreCase', true);

%% 4. Extract warning count

warningToken = regexp(logText, ...
    'NUMBER OF WARNING\s+MESSAGES\s+ENCOUNTERED\s*=\s*(\d+)', ...
    'tokens', 'once', 'ignorecase');

report.warning_count = NaN;

if ~isempty(warningToken)
    report.warning_count = str2double(warningToken{1});
end

%% 5. Extract error count

errorToken = regexp(logText, ...
    'NUMBER OF ERROR\s+MESSAGES\s+ENCOUNTERED\s*=\s*(\d+)', ...
    'tokens', 'once', 'ignorecase');

report.error_count = NaN;

if ~isempty(errorToken)
    report.error_count = str2double(errorToken{1});
end

report.error_file_exists = isfile(errFile);

report.error_file_contains_error = ...
    contains(errText, '*** ERROR ***', 'IgnoreCase', true);

%% 6. Extract total node count

nodeToken = regexp(logText, ...
    'Total number of nodes\s*=\s*(\d+)', ...
    'tokens', 'once', 'ignorecase');

report.total_nodes = NaN;

if ~isempty(nodeToken)
    report.total_nodes = str2double(nodeToken{1});
end

%% 7. Extract total element count

elementToken = regexp(logText, ...
    'Total number of elements\s*=\s*(\d+)', ...
    'tokens', 'once', 'ignorecase');

report.total_elements = NaN;

if ~isempty(elementToken)
    report.total_elements = str2double(elementToken{1});
end

%% 8. Extract SHELL281 element count

report.shell281_elements = NaN;

shellLines = logLines(contains(logLines, ...
    'SHELL281', 'IgnoreCase', true));

for k = 1:numel(shellLines)

    currentLine = strtrim(char(shellLines(k)));

    % Separate the line into whitespace-delimited tokens
    tokens = regexp(currentLine, '\s+', 'split');

    % Find the exact SHELL281 token
    typeIndex = find(strcmpi(tokens, 'SHELL281'), 1);

    if ~isempty(typeIndex) && typeIndex >= 2

        % The token immediately before SHELL281 is the count
        elementCount = str2double(tokens{typeIndex - 1});

        if isfinite(elementCount)
            report.shell281_elements = elementCount;
            break;
        end

    end

end

%% 9. Extract completed load substeps

substepMatches = regexp(logText, ...
    'LOAD STEP\s+\d+\s+SUBSTEP\s+\d+\s+COMPLETED', ...
    'match', 'ignorecase');

report.completed_substeps = numel(substepMatches);

%% 10. Extract solver execution time

timeToken = regexp(logText, ...
    'Elapsed Time\s*\(sec\)\s*=\s*([\d.]+)', ...
    'tokens', 'once', 'ignorecase');

report.elapsed_time_seconds = NaN;

if ~isempty(timeToken)
    report.elapsed_time_seconds = str2double(timeToken{1});
end

%% 11. Store source file information

report.log_file = solverOutFile;
report.error_file = errFile;

%% 12. Determine final solver status

report.result_status = 'REQUIRES_REVIEW';

if report.solver_completed && ...
        report.solution_converged && ...
        ~isnan(report.warning_count) && ...
        ~isnan(report.error_count) && ...
        report.error_count == 0

    if report.warning_count == 0

        report.result_status = 'SUCCESS';

    else

        report.result_status = 'SUCCESS_WITH_WARNINGS';

    end

end

%% 13. Display extracted information

fprintf('\n====================================\n');
fprintf('FUSESAFE V2 SOLVER LOG ANALYSIS\n');
fprintf('====================================\n\n');

fprintf('Solver completed: %d\n', ...
    report.solver_completed);

fprintf('Solution converged: %d\n', ...
    report.solution_converged);

fprintf('Warning count: %g\n', ...
    report.warning_count);

fprintf('Error count: %g\n', ...
    report.error_count);

fprintf('Total nodes: %g\n', ...
    report.total_nodes);

fprintf('Total elements: %g\n', ...
    report.total_elements);

fprintf('SHELL281 elements: %g\n', ...
    report.shell281_elements);

fprintf('Completed substeps: %d\n', ...
    report.completed_substeps);

fprintf('Elapsed time: %g seconds\n', ...
    report.elapsed_time_seconds);

fprintf('\nFinal status: %s\n', ...
    report.result_status);

fprintf('\n====================================\n');

end