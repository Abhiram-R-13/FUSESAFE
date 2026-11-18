function [status, runID, resultsTable, historyTable] = ...
    run_optimization_search_resumable(inputs)

% FUSESAFE - AUTOMATIC THICKNESS OPTIMIZATION CONTROLLER
%
% Controls:
% 1. Coarse thickness search
% 2. Fine thickness search
% 3. MATLAB-to-ANSYS batch execution
% 4. Stress and deformation retrieval
% 5. Added mass and FoS calculation
% 6. Failed candidate recording
% 7. Optimization history
% 8. Lightest feasible candidate selection
%
% IMPORTANT:
% Current ANSYS prototype changes B_Band thickness only.
% Other app inputs are not yet connected to ANSYS.

%% 1. VALIDATE INPUTS

if nargin ~= 1 || ~isstruct(inputs) || ~isscalar(inputs)
    error('A scalar inputs structure is required.');
end

requiredFields = {'RequiredFoS','YieldStrength'};

for k = 1:numel(requiredFields)
    if ~isfield(inputs,requiredFields{k})
        error('Missing input field: %s',requiredFields{k});
    end
end

requiredFoS = inputs.RequiredFoS;
yieldStrength = inputs.YieldStrength;

if ~isnumeric(requiredFoS) || ~isscalar(requiredFoS) || ...
        ~isfinite(requiredFoS) || requiredFoS <= 0
    error('Invalid RequiredFoS.');
end

if ~isnumeric(yieldStrength) || ~isscalar(yieldStrength) || ...
        ~isfinite(yieldStrength) || yieldStrength <= 0
    error('Invalid YieldStrength.');
end

% 2. LOAD CENTRAL CONFIGURATION

cfg = fusesafe_config();


projectFile = cfg.projectFile;
ansysExe = cfg.ansysExe;
runsRoot = cfg.runsRoot;

if isfield(inputs,'ProjectFile') && ~isempty(inputs.ProjectFile)
    if ~(ischar(inputs.ProjectFile) || ...
            (isstring(inputs.ProjectFile) && isscalar(inputs.ProjectFile)))
        error('ProjectFile must be a character vector or scalar string.');
    end
    projectFile = char(string(inputs.ProjectFile));
end

if isfield(inputs,'RunsRoot') && ~isempty(inputs.RunsRoot)
    if ~(ischar(inputs.RunsRoot) || ...
            (isstring(inputs.RunsRoot) && isscalar(inputs.RunsRoot)))
        error('RunsRoot must be a character vector or scalar string.');
    end
    runsRoot = char(string(inputs.RunsRoot));
end

testRoot = fileparts(projectFile);
[~, projectStem] = fileparts(projectFile);
projectFilesRoot = fullfile(testRoot,[projectStem '_files']);
lockFile = fullfile(testRoot,'.lock');

if ~isfolder(projectFilesRoot)
    error('Workbench companion folder is missing.');
end

if ~isfolder(testRoot)
    error('Automation prototype folder not found.');
end

if ~isfile(projectFile)
    error('Workbench project not found.');
end

if ~isfile(ansysExe)
    error('ANSYS executable not found.');
end

if isfile(lockFile)
    error('Close Workbench before starting optimization.');
end

if exist('run_ansys_candidate','file') ~= 2
    error('run_ansys_candidate.m is not available on MATLAB path.');
end

% 3. DEFINE SEARCH CANDIDATES



% Original thickness is 2 mm.
% Search values represent ADDED thickness.

if isfield(inputs,'AddedThicknessCandidates')

    % Custom candidate list for preliminary testing
    addedCandidates = inputs.AddedThicknessCandidates;

    if ~isnumeric(addedCandidates) || ...
            isempty(addedCandidates) || ...
            any(~isfinite(addedCandidates)) || ...
            any(addedCandidates < 0 | addedCandidates > 5)

        error('Invalid custom thickness candidates.');
    end

    addedCandidates = unique(addedCandidates(:)','stable');

else

    % Coarse search: 0 to 5 mm, 0.25 mm increments
    coarse = 0:0.25:5;

    % Fine search: 0 to 5 mm, 0.1 mm increments
    fine = 0:0.1:5;

    % Remove the 11 values already evaluated in coarse search
    fineOnly = fine(~ismember(round(fine,10), ...
                             round(coarse,10)));

    % 21 coarse + 40 additional fine = 61 unique candidates
    addedCandidates = [coarse fineOnly];

end

if numel(addedCandidates) ~= numel(unique(addedCandidates))
    error('Duplicate thickness candidates detected.');
end

fprintf('\n========================================\n');
fprintf('FUSESAFE OPTIMIZATION INITIALIZATION\n');
fprintf('========================================\n');

fprintf('Required FoS: %.3f\n',requiredFoS);
fprintf('Yield strength: %.3f MPa\n',yieldStrength);
fprintf('Number of candidates: %d\n',numel(addedCandidates));

%% 4. DEFINE MASS CALCULATION

baseThickness = 2;          % mm
bandArea = 84406;           % mm^2
density = 2.78e-6;          % kg/mm^3

%% 5. PREPARE NEW OR RESUMED RUN

if ~isfolder(runsRoot)
    mkdir(runsRoot);
end

resumeRequested = false;
fosThresholdChanged = false;
resumeID = '';

if isfield(inputs,'ResumeRunID') && ~isempty(inputs.ResumeRunID)
    if ~(ischar(inputs.ResumeRunID) || ...
            (isstring(inputs.ResumeRunID) && isscalar(inputs.ResumeRunID)))
        error('ResumeRunID must be a character vector or scalar string.');
    end

    resumeID = strtrim(char(string(inputs.ResumeRunID)));
    resumeRequested = ~isempty(resumeID);
end

emptyResultsTable = table( ...
    zeros(0,1),zeros(0,1),zeros(0,1),zeros(0,1),strings(0,1), ...
    'VariableNames',{'AddedThickness','AddedMass','MaxStress', ...
    'MaxDisplacement','SolveStatus'});

emptyHistoryTable = table( ...
    zeros(0,1),zeros(0,1),zeros(0,1),zeros(0,1),zeros(0,1), ...
    'VariableNames',{'Iter','Thickness_mm','Mass_kg','Stress_MPa','FoS'});

totalCandidates = numel(addedCandidates);

if resumeRequested

    if isempty(regexp(resumeID,'^OPT_[A-Za-z0-9_]+$','once'))
        error('Invalid ResumeRunID format.');
    end

    runID = resumeID;
    runFolder = fullfile(runsRoot,runID);

    if ~isfolder(runFolder)
        error('Requested optimization run does not exist.');
    end

    resultsFile = fullfile(runFolder,'results.csv');
    historyFile = fullfile(runFolder,'optimization_history.csv');
    failureFile = fullfile(runFolder,'failure_log.txt');
    manifestFile = fullfile(runFolder,'run_manifest.json');
    candidateRoot = fullfile(runFolder,'Candidate_Runs');

    if ~isfile(manifestFile) || ~isfile(resultsFile) || ~isfile(historyFile)
        error('Existing run package is incomplete.');
    end

    manifest = jsondecode(fileread(manifestFile));

    requiredManifestFields = {'run_id','status','required_fos', ...
        'yield_strength_mpa','search_candidates_added_mm','total_candidates'};

    if ~all(isfield(manifest,requiredManifestFields))
        error('Run manifest is missing required fields.');
    end

    if ~strcmp(char(string(manifest.run_id)),runID)
        error('Run ID does not match the manifest.');
    end

    allowedResumeStates = {'RUNNING','INCOMPLETE','INCOMPLETE_WITH_FEASIBLE_CANDIDATE','SUCCESS','NO_FEASIBLE_DESIGN'};
    currentRunState = char(string(manifest.status));

    if ~ismember(currentRunState,allowedResumeStates)
        error('This optimization run cannot be resumed.');
    end

    fosThresholdChanged = abs(double(manifest.required_fos)-requiredFoS)>1e-9;

    if abs(double(manifest.yield_strength_mpa)-yieldStrength)>1e-9
        error('Yield strength differs from the original run. Keep the material basis unchanged when reusing existing FEA results.');
    end

    storedCandidates = double(manifest.search_candidates_added_mm(:)');

    if numel(storedCandidates) ~= numel(addedCandidates) || ...
       any(abs(storedCandidates-addedCandidates)>1e-9)
        error('Candidate list differs from the original optimization.');
    end

    if double(manifest.total_candidates) ~= totalCandidates
        error('Total candidate count differs from the original run.');
    end

    resultsTable = readtable(resultsFile,'TextType','string');
    historyTable = readtable(historyFile,'TextType','string');

    if ~isequal(resultsTable.Properties.VariableNames, ...
            emptyResultsTable.Properties.VariableNames)
        error('Existing results.csv has an incompatible schema.');
    end

    if ~isequal(historyTable.Properties.VariableNames, ...
            emptyHistoryTable.Properties.VariableNames)
        error('Existing optimization_history.csv has an incompatible schema.');
    end

    if height(resultsTable)==0
        resultsTable = emptyResultsTable;
    end

    if height(historyTable)==0
        historyTable = emptyHistoryTable;
    end

    resultsTable.AddedThickness = double(resultsTable.AddedThickness);
    resultsTable.AddedMass = double(resultsTable.AddedMass);
    resultsTable.MaxStress = double(resultsTable.MaxStress);
    resultsTable.MaxDisplacement = double(resultsTable.MaxDisplacement);
    resultsTable.SolveStatus = string(resultsTable.SolveStatus);

    historyTable.Iter = double(historyTable.Iter);
    historyTable.Thickness_mm = double(historyTable.Thickness_mm);
    historyTable.Mass_kg = double(historyTable.Mass_kg);
    historyTable.Stress_MPa = double(historyTable.Stress_MPa);
    historyTable.FoS = double(historyTable.FoS);

    validStatuses = {'SUCCESS','SUCCESS_WITH_WARNINGS','FAILED'};

    if any(~ismember(cellstr(resultsTable.SolveStatus),validStatuses))
        error('Existing results.csv contains an unknown status.');
    end

    if numel(unique(round(resultsTable.AddedThickness,10))) ~= height(resultsTable)
        error('Duplicate candidate rows detected in results.csv.');
    end

    if any(~isfinite(historyTable.Iter)) || ...
       any(historyTable.Iter<1) || ...
       any(historyTable.Iter>totalCandidates) || ...
       any(historyTable.Iter~=fix(historyTable.Iter)) || ...
       numel(unique(historyTable.Iter))~=height(historyTable)
        error('Existing optimization history has invalid iteration values.');
    end

    % Check result rows and repair history if MATLAB stopped between saves.
    for rr = 1:height(resultsTable)

        candidateIndex = find(abs(addedCandidates- ...
            resultsTable.AddedThickness(rr))<=1e-9,1);

        if isempty(candidateIndex)
            error('Existing result contains an unknown thickness.');
        end

        historyMatch = find(historyTable.Iter==candidateIndex);
        isFailed = strcmp(char(resultsTable.SolveStatus(rr)),'FAILED');

        if isFailed
            historyTable = historyTable(historyTable.Iter~=candidateIndex,:);
        elseif isempty(historyMatch)
            stressValue = resultsTable.MaxStress(rr);

            if ~isfinite(stressValue) || stressValue<=0
                error('Cannot reconstruct history for an invalid result.');
            end

            repairedRow = table(candidateIndex, ...
                resultsTable.AddedThickness(rr), ...
                resultsTable.AddedMass(rr),stressValue, ...
                yieldStrength/stressValue, ...
                'VariableNames',historyTable.Properties.VariableNames);

            historyTable = [historyTable;repairedRow];
        elseif numel(historyMatch)>1
            error('Duplicate history entries detected.');
        end
    end

    for hh = 1:height(historyTable)
        candidateIndex = historyTable.Iter(hh);
        resultMatch = find(abs(resultsTable.AddedThickness- ...
            addedCandidates(candidateIndex))<=1e-9,1);

        if isempty(resultMatch) || ...
           strcmp(char(resultsTable.SolveStatus(resultMatch)),'FAILED')
            error('Optimization history contains an invalid candidate.');
        end
    end

    if ~isfolder(candidateRoot)
        error('Candidate run folder is missing.');
    end

    if ~isfile(failureFile)
        fid = fopen(failureFile,'w');
        if fid~=-1
            fclose(fid);
        end
    end

    manifest.required_fos = requiredFoS;
    manifest.status = 'RUNNING';
    manifest.resumed_at = char(datetime('now','Format','yyyy-MM-dd HH:mm:ss'));
    manifest.completed_candidates = height(resultsTable);
    manifest.failed_candidates = nnz(resultsTable.SolveStatus=="FAILED");
    manifest.successful_candidates = nnz(resultsTable.SolveStatus=="SUCCESS");
    manifest.warning_candidates = nnz(resultsTable.SolveStatus=="SUCCESS_WITH_WARNINGS");

    writetable(resultsTable,resultsFile);
    writetable(historyTable,historyFile);

    selectedFile = fullfile(runFolder,'selected_candidate.csv');
    if isfile(selectedFile)
        delete(selectedFile);
    end

    writeManifest(manifestFile,manifest);

    fprintf('Resuming optimization: %s\n',runID);

else

    runID = ['OPT_' char(datetime('now','Format','yyyyMMdd_HHmmss_SSS'))];
    runFolder = fullfile(runsRoot,runID);
    mkdir(runFolder);

    candidateRoot = fullfile(runFolder,'Candidate_Runs');
    mkdir(candidateRoot);

    resultsFile = fullfile(runFolder,'results.csv');
    historyFile = fullfile(runFolder,'optimization_history.csv');
    failureFile = fullfile(runFolder,'failure_log.txt');
    manifestFile = fullfile(runFolder,'run_manifest.json');

    resultsTable = emptyResultsTable;
    historyTable = emptyHistoryTable;

    writetable(resultsTable,resultsFile);
    writetable(historyTable,historyFile);

    manifest.run_id = runID;
    manifest.required_fos = requiredFoS;
    manifest.status = 'RUNNING';
    manifest.total_candidates = totalCandidates;
    manifest.completed_candidates = 0;
    manifest.failed_candidates = 0;
    manifest.successful_candidates = 0;
    manifest.warning_candidates = 0;
    manifest.required_fos = requiredFoS;
    manifest.yield_strength_mpa = yieldStrength;
    manifest.yield_strength_basis = 'Provisional assessment basis';
    manifest.material_approval = 'PENDING';
    manifest.base_band_thickness_mm = baseThickness;
    manifest.search_candidates_added_mm = addedCandidates;
    manifest.model_scope = 'Prototype varies B_Band thickness parameter P1 and membrane offset parameter P4.';
    manifest.project_file = projectFile;
    manifest.optimization_runs_root = runsRoot;
    manifest.skin_thickness_assumed_mm = 2;
    manifest.parameter_mapping = 'P1=total band thickness; P4=(2-P1)/2.';
    manifest.other_app_inputs_connected = false;

    writeManifest(manifestFile,manifest);

end

%% 8. PROCESS EACH CANDIDATE

for k = 1:totalCandidates

    addedThickness = addedCandidates(k);
    totalThickness = baseThickness + addedThickness;
    addedMass = bandArea * addedThickness * density;

    existingRows = find(abs(resultsTable.AddedThickness-addedThickness)<=1e-9);

    if numel(existingRows)>1
        error('Duplicate candidate result rows detected.');
    end

    shouldCheckRecovery = isempty(existingRows);

    if ~isempty(existingRows)
        previousStatus = char(resultsTable.SolveStatus(existingRows));

        if any(strcmp(previousStatus,{'SUCCESS','SUCCESS_WITH_WARNINGS'}))
            fprintf('Skipping completed candidate %.4f mm (%s).\n', ...
                addedThickness,previousStatus);
            continue;
        elseif strcmp(previousStatus,'FAILED') && fosThresholdChanged
            fprintf('Skipping failed candidate %.4f mm because only Required FoS changed; no FEA rerun for threshold reassessment.\n',addedThickness);
            continue;
        elseif ~strcmp(previousStatus,'FAILED')
            error('Cannot resume an unknown candidate status.');
        end

        shouldCheckRecovery = true;
        fprintf('Previously failed candidate %.4f mm; checking saved candidate folders.\n', ...
            addedThickness);
    end

    fprintf('\n----------------------------------------\n');
    fprintf('Candidate %d of %d\n',k,totalCandidates);
    fprintf('Added thickness: %.4f mm\n',addedThickness);
    fprintf('Total B_Band thickness: %.4f mm\n',totalThickness);

    stress = NaN;
    deformation = NaN;
    actualFoS = NaN;
    solveStatus = string('FAILED');

    recovered = false;
    recoveredResult = struct();

    if shouldCheckRecovery
        [recovered,recoveredResult] = recoverCandidateFromFolders( ...
            candidateRoot,totalThickness);
    end

    if recovered
        stress = recoveredResult.maximum_stress_mpa;
        deformation = recoveredResult.maximum_deformation_mm;
        actualFoS = yieldStrength/stress;
        solveStatus = string(recoveredResult.status);

        fprintf('Recovered %s from %s without launching ANSYS.\n', ...
            recoveredResult.design_point,recoveredResult.source_folder);
        fprintf('Recovered stress: %.6f MPa, deformation: %.6f mm, FoS: %.6f\n', ...
            stress,deformation,actualFoS);
    else
        if shouldCheckRecovery && ~isempty(existingRows)
            fprintf('No valid saved result found. Retrying ANSYS for %.4f mm.\n', ...
                addedThickness);
        end

        try
            ansysResult = run_ansys_candidate( ...
                totalThickness,projectFile,candidateRoot,ansysExe);

            if ~any(strcmp(ansysResult.status, ...
                    {'SUCCESS','SUCCESS_WITH_WARNINGS'}))
                error('ANSYS candidate did not return an accepted status.');
            end

            stress = ansysResult.maximum_stress_mpa;
            deformation = ansysResult.maximum_deformation_mm;

            if ~isfinite(stress) || stress<=0
                error('Invalid maximum stress.');
            end

            if ~isfinite(deformation) || deformation<0
                error('Invalid maximum deformation.');
            end

            actualFoS = yieldStrength/stress;
            solveStatus = string(ansysResult.status);

            fprintf('Candidate completed: stress %.6f MPa, FoS %.6f\n', ...
                stress,actualFoS);

        catch ME
            fprintf('CANDIDATE FAILED: %s\n',ME.message);

            fid = fopen(failureFile,'a');
            if fid~=-1
                fprintf(fid,'\nCandidate %d\n',k);
                fprintf(fid,'Added thickness: %.6f mm\n',addedThickness);
                fprintf(fid,'Error: %s\n',ME.message);
                fclose(fid);
            end
        end
    end

    resultRow = table(addedThickness,addedMass,stress,deformation, ...
        solveStatus,'VariableNames',resultsTable.Properties.VariableNames);

    if isempty(existingRows)
        resultsTable = [resultsTable;resultRow];
    else
        resultsTable(existingRows,:) = resultRow;
    end

    historyTable = historyTable(historyTable.Iter~=k,:);

    if ~strcmp(char(solveStatus),'FAILED')
        historyRow = table(k,addedThickness,addedMass,stress,actualFoS, ...
            'VariableNames',historyTable.Properties.VariableNames);
        historyTable = [historyTable;historyRow];
        historyTable = sortrows(historyTable,'Iter');
    end

    writetable(resultsTable,resultsFile);
    writetable(historyTable,historyFile);

    manifest.completed_candidates = height(resultsTable);
    manifest.failed_candidates = nnz(strcmp(cellstr(resultsTable.SolveStatus),'FAILED'));
    manifest.successful_candidates = nnz(strcmp(cellstr(resultsTable.SolveStatus),'SUCCESS'));
    manifest.warning_candidates = nnz(strcmp(cellstr(resultsTable.SolveStatus),'SUCCESS_WITH_WARNINGS'));
    manifest.last_candidate_index = k;
    manifest.updated_at = char(datetime('now','Format','yyyy-MM-dd HH:mm:ss'));

    writeManifest(manifestFile,manifest);

    fprintf('Checkpoint saved: %d/%d\n',height(resultsTable),totalCandidates);

end

%% 12. IDENTIFY FEASIBLE CANDIDATES

successful = resultsTable.SolveStatus == "SUCCESS";

fosByResult = nan(height(resultsTable),1);

for resultIndex = 1:height(resultsTable)
    candidateIndex = find(abs(addedCandidates-resultsTable.AddedThickness(resultIndex))<=1e-9,1);
        if isempty(candidateIndex)
            error('Could not map result to original candidate index.');
        end
        historyIndexForResult = find(historyTable.Iter==candidateIndex,1,'first');

    if ~isempty(historyIndexForResult)
        fosByResult(resultIndex) = historyTable.FoS(historyIndexForResult);
    end
end

feasible = successful & ...
    fosByResult >= requiredFoS;
%% 12A. STRUCTURAL ACCEPTANCE ASSESSMENT

allowableStress = yieldStrength / requiredFoS;

structuralAcceptance = repmat( ...
    "NOT_EVALUATED",height(resultsTable),1);

for resultIndex = 1:height(resultsTable)

    stress = resultsTable.MaxStress(resultIndex);
    solverStatus = resultsTable.SolveStatus(resultIndex);

    if solverStatus ~= "FAILED" && ...
            isfinite(stress) && stress > 0 && ...
            isfinite(fosByResult(resultIndex))

        if stress <= allowableStress
            structuralAcceptance(resultIndex) = "PASS";
        else
            structuralAcceptance(resultIndex) = "FAIL";
        end
    end
end

structuralAssessmentTable = table( ...
    resultsTable.AddedThickness, ...
    resultsTable.AddedMass, ...
    resultsTable.MaxStress, ...
    resultsTable.MaxDisplacement, ...
    fosByResult, ...
    repmat(requiredFoS,height(resultsTable),1), ...
    repmat(allowableStress,height(resultsTable),1), ...
    resultsTable.SolveStatus, ...
    structuralAcceptance, ...
    'VariableNames',{ ...
    'AddedThickness','AddedMass','MaxStress', ...
    'MaxDisplacement','ActualFoS','RequiredFoS', ...
    'AllowableStress_MPa','SolveStatus', ...
    'StructuralAcceptance'});

structuralAssessmentFile = fullfile( ...
    runFolder,'structural_assessment.csv');

writetable(structuralAssessmentTable, ...
    structuralAssessmentFile);

if any(feasible)

    feasibleRows = find(feasible);

    [~,bestIndex] = min( ...
        resultsTable.AddedMass(feasibleRows));

    selectedIndex = feasibleRows(bestIndex);

    selectedCandidate = resultsTable(selectedIndex,:);

    selectedCandidateIndex = find(abs(addedCandidates-selectedCandidate.AddedThickness)<=1e-9,1);
    if isempty(selectedCandidateIndex)
        error('Could not map selected candidate to original index.');
    end
    historyIndex = find(historyTable.Iter==selectedCandidateIndex,1,'first');

if isempty(historyIndex)
    error('Selected candidate is missing from optimization history.');
end

selectedHistory = historyTable(historyIndex,:);

    writetable(selectedCandidate, ...
        fullfile(runFolder,'selected_candidate.csv'));

    manifest.selected_thickness_added_mm = ...
        selectedCandidate.AddedThickness;

    manifest.selected_mass_kg = ...
        selectedCandidate.AddedMass;

    manifest.selected_stress_mpa = ...
        selectedCandidate.MaxStress;

    manifest.selected_fos = selectedHistory.FoS;

    if any(ismember(cellstr(resultsTable.SolveStatus), ...
        {'FAILED','SUCCESS_WITH_WARNINGS'}))
        manifest.status = 'INCOMPLETE_WITH_FEASIBLE_CANDIDATE';
    else
        manifest.status = 'SUCCESS';
    end

else

    if any(ismember(cellstr(resultsTable.SolveStatus), ...
        {'FAILED','SUCCESS_WITH_WARNINGS'}))
        manifest.status = 'INCOMPLETE';
    else
        manifest.status = 'NO_FEASIBLE_DESIGN';
    end

end

%% 13. FINAL RUN STATUS

manifest.completed_candidates = totalCandidates;

manifest.failed_candidates = nnz( ...
    resultsTable.SolveStatus == "FAILED");

manifest.successful_candidates = nnz( ...
    resultsTable.SolveStatus == "SUCCESS");

manifest.warning_candidates = nnz( ...
    resultsTable.SolveStatus == "SUCCESS_WITH_WARNINGS");

manifest.finished_at = char(datetime('now', ...
    'Format','yyyy-MM-dd HH:mm:ss'));

writeManifest(manifestFile,manifest);

status = manifest.status;

%% 14. DISPLAY FINAL SUMMARY

fprintf('\n========================================\n');

fprintf('FUSESAFE OPTIMIZATION COMPLETED\n');

fprintf('========================================\n');

fprintf('Run ID: %s\n',runID);

fprintf('Total candidates: %d\n',totalCandidates);

fprintf('Clean successful candidates: %d\n', ...
    manifest.successful_candidates);

fprintf('Completed with warnings: %d\n', ...
    manifest.warning_candidates);

fprintf('Failed candidates: %d\n', ...
    manifest.failed_candidates);

fprintf('Final status: %s\n',status);

if any(feasible)

    fprintf('\nSelected candidate:\n');

    disp(selectedCandidate);

    fprintf('Selected FoS: %.6f\n',selectedHistory.FoS);

else

    fprintf('\nNo feasible candidate found in tested range.\n');

end

fprintf('\nResults file: %s\n',resultsFile);

fprintf('History file: %s\n',historyFile);

fprintf('Run folder: %s\n',runFolder);

end


%% LOCAL FUNCTION: SAVE JSON MANIFEST

function writeManifest(filePath,data)

fid = fopen(filePath,'w');

if fid == -1
    error('Could not write optimization manifest.');
end

try

    fprintf(fid,'%s',jsonencode(data,PrettyPrint=true));

    fclose(fid);

catch ME

    fclose(fid);

    rethrow(ME);

end

end


%% LOCAL FUNCTION: RECOVER A PREVIOUSLY COMPLETED CANDIDATE

function [found,result] = recoverCandidateFromFolders(candidateRoot,requestedThickness)

found = false;
result = struct();

candidateFolders = dir(fullfile(candidateRoot,'CAND_*'));
candidateFolders = candidateFolders([candidateFolders.isdir]);

if isempty(candidateFolders)
    return;
end

[~,folderOrder] = sort([candidateFolders.datenum],'descend');
candidateFolders = candidateFolders(folderOrder);

requiredFiles = {'status.txt','results.csv','solve.out','file0.err'};

for folderIndex = 1:numel(candidateFolders)
    sourceFolder = fullfile(candidateFolders(folderIndex).folder, ...
        candidateFolders(folderIndex).name);

    allFilesPresent = true;
    for fileIndex = 1:numel(requiredFiles)
        if ~isfile(fullfile(sourceFolder,requiredFiles{fileIndex}))
            allFilesPresent = false;
            break;
        end
    end
    if ~allFilesPresent
        continue;
    end

    try
        statusLines = readlines(fullfile(sourceFolder,'status.txt'));
        batchStatus = readCandidateStatusField(statusLines,'BATCH_STATUS');
        dpText = readCandidateStatusField(statusLines,'DESIGN_POINT');
        thicknessText = readCandidateStatusField(statusLines,'THICKNESS_MM');
        p2Ready = readCandidateStatusField(statusLines,'P2_UP_TO_DATE');
        p3Ready = readCandidateStatusField(statusLines,'P3_UP_TO_DATE');

        if ~strcmpi(batchStatus,'SUCCESS') || ...
                ~strcmpi(p2Ready,'True') || ~strcmpi(p3Ready,'True')
            continue;
        end

        dpNumber = str2double(dpText);
        recordedThickness = str2double(thicknessText);
        if ~isfinite(dpNumber) || dpNumber<0 || dpNumber~=fix(dpNumber) || ...
                ~isfinite(recordedThickness) || ...
                abs(recordedThickness-requestedThickness)>1e-8
            continue;
        end

        csvFile = fullfile(sourceFolder,'results.csv');
        csvLines = readlines(csvFile);
        headerIndex = find(strcmp(strtrim(csvLines),'Name,P1,P2,P3'),1,'first');
        if isempty(headerIndex)
            continue;
        end

        opts = delimitedTextImportOptions('NumVariables',4);
        opts.Delimiter = ',';
        opts.VariableNamesLine = headerIndex;
        opts.DataLines = [headerIndex+1,Inf];
        opts.VariableNames = {'Name','P1','P2','P3'};
        opts.VariableTypes = {'string','double','double','double'};
        opts.VariableNamingRule = 'preserve';
        exportedTable = readtable(csvFile,opts);

        expectedDPName = string(sprintf('DP %.0f',dpNumber));
        dpRow = exportedTable(exportedTable.Name==expectedDPName,:);
        if height(dpRow)~=1
            continue;
        end

        if ~isfinite(dpRow.P1) || ~isfinite(dpRow.P2) || ...
                ~isfinite(dpRow.P3) || ...
                abs(dpRow.P1-requestedThickness)>1e-8 || ...
                dpRow.P2<0 || dpRow.P3<=0
            continue;
        end

        solveText = fileread(fullfile(sourceFolder,'solve.out'));
        warningToken = regexp(solveText, ...
            'NUMBER OF WARNING MESSAGES ENCOUNTERED\s*=\s*(\d+)', ...
            'tokens','once');
        errorToken = regexp(solveText, ...
            'NUMBER OF ERROR\s+MESSAGES ENCOUNTERED\s*=\s*(\d+)', ...
            'tokens','once');
        if isempty(warningToken) || isempty(errorToken)
            continue;
        end

        warningCount = str2double(warningToken{1});
        errorCount = str2double(errorToken{1});
        runCompleted = contains(solveText,'RUN COMPLETED','IgnoreCase',true);
        hasConverged = contains(solveText,'SOLUTION CONVERGED','IgnoreCase',true);
        if ~runCompleted || ~hasConverged || ...
                ~isfinite(warningCount) || warningCount<0 || ...
                ~isfinite(errorCount) || errorCount~=0
            continue;
        end

        if warningCount>0
            recoveredStatus = 'SUCCESS_WITH_WARNINGS';
        else
            recoveredStatus = 'SUCCESS';
        end

        result.maximum_stress_mpa = dpRow.P3;
        result.maximum_deformation_mm = dpRow.P2;
        result.status = recoveredStatus;
        result.design_point = char(expectedDPName);
        result.solver_warning_count = warningCount;
        result.solver_error_count = errorCount;
        result.source_folder = sourceFolder;

        found = true;
        return;

    catch
        % Ignore incomplete or malformed folders and inspect the next one.
        continue;
    end
end

end

function value = readCandidateStatusField(statusLines,fieldName)

prefix = [char(fieldName) '='];
matchingLine = find(startsWith(strtrim(statusLines),prefix),1,'first');
if isempty(matchingLine)
    value = '';
else
    value = char(strtrim(extractAfter(strtrim(statusLines(matchingLine)),prefix)));
end

end

