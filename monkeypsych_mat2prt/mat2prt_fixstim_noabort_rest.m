function prt_fname = mat2prt_fixstim_noabort_rest(mat_file, run_name)

if nargin < 2,
    run_name = '';
end

[pathname,filename,ext] = fileparts(mat_file);
load(mat_file, '-mat');
n_blocks = length(trial); % you need to find number of blocks (i.e. rows) from data

%% task timing parameters
reward_time = task.timing.ITI_success*1000;
ITI_fail = task.timing.ITI_fail*1000;

stim_onset = min([trial.microstim_start])*1000;
stim_offset = max([trial.microstim_end])*1000;

%% this is manual part - defining condition names and etc.

NrofPreds = 2;

prtpreds(1).name = 'fixation';
prtpreds(1).r = 150; %189;
prtpreds(1).g = 255; %183;
prtpreds(1).b = 100; %107;

prtpreds(2).name = 'fixation microstim';
prtpreds(2).r = 0; %255;
prtpreds(2).g = 160; %255;
prtpreds(2).b = 0;

% [prtpreds(1:NrofPreds).n_correct_trials] = deal([]); % empty array to be filled in cumulatively
[prtpreds(1:NrofPreds).onset] = deal([]);
[prtpreds(1:NrofPreds).offset] = deal([]);

%% trial conditions, states, and state onsets
idx_success = find([trial.success] == 1); % successful trials
idx_abort = find([trial.success] == 0); % aborted trials
idx_fix = find([trial.type] == 1); % fixation trials
idx_fix_success = intersect(idx_success, idx_fix); % successful fixation trials
idx_stim = find([trial.microstim] == 1); % stimulation trials
idx_nostim = find([trial.microstim] == 0); % no-stimulation trials
idx_fix_stim = intersect(idx_fix_success, idx_stim); % successful fixation trials with microstimulation
idx_fix_nostim = intersect(idx_fix_success, idx_nostim); % successful fixation trials without microstimulation

% get states and state onsets for fixation and memory trials
states_fix_stim = cat(1, trial(idx_fix_stim).states);
states_onset_fix_stim = round(cat(1, trial(idx_fix_stim).states_onset)*1000);
states_fix_nostim = cat(1, trial(idx_fix_nostim).states);
states_onset_fix_nostim = round(cat(1, trial(idx_fix_nostim).states_onset)*1000);

% get states and state onsets for all rewarded trials
states_reward_fix = cat(1, trial(idx_fix_success).states);
states_onset_reward_fix = round(cat(1, trial(idx_fix_success).states_onset)*1000);

% get states and state onsets for aborted trials
% states_abort = [];
states_onset_abort = [];
n_trial_abort = 0;
for t = idx_abort % loop through all aborted trials
    n_trial_abort = n_trial_abort + 1;
%     states_abort(n_trial_abort,1) = trial(t).states(1);
%     states_abort(n_trial_abort,2) = trial(t).states(end);
    states_onset_abort(n_trial_abort,1) = round(trial(t).states_onset(1)*1000);
    states_onset_abort(n_trial_abort,2) = round(trial(t).states_onset(end)*1000);           
end


%% add predictors to protocol
% predictor: fixation without microstimulation
prtpreds(1).onset = states_onset_fix_nostim(states_fix_nostim == 3) + stim_onset; % from time corresponding to beginning of microstimulation
prtpreds(1).offset = states_onset_fix_nostim(states_fix_nostim == 3) + stim_offset; % to time corresponding to end of microstimulation

% predictor: fixation with microstimulation 
prtpreds(2).onset = states_onset_fix_stim(states_fix_stim == 3) + stim_onset; % from beginning of microstimulation
prtpreds(2).offset = states_onset_fix_stim(states_fix_stim == 3) + stim_offset; % to end of microstimulation

%% create PRT file
if isempty(run_name)
    prt_fname = [pathname filesep filename  '.prt'];
else
    prt_fname = [pathname filesep filename(1:end-2) run_name '.prt'];    
end

fid = fopen(prt_fname,'w');

fprintf(fid,'\n');

fprintf(fid,'FileVersion:\t%d\n\n',2);

fprintf(fid,'ResolutionOfTime:\t%s\n\n','msec');

fprintf(fid,'Experiment:\t%s\n\n',filename);

fprintf(fid,'BackgroundColor:\t%d %d %d\n',0,0,0);
fprintf(fid,'TextColor:\t%d %d %d\n',255,255,255);
fprintf(fid,'TimeCourseColor:\t%d %d %d\n',255,255,255);
fprintf(fid,'TimeCourseThick:\t%d\n',3);
fprintf(fid,'ReferenceFuncColor:\t%d %d %d\n',0,0,80);
fprintf(fid,'ReferenceFuncThick:\t%d\n\n',3);

fprintf(fid,'NrOfConditions:\t%d\n\n',NrofPreds );


for cond = 1:NrofPreds,
    
    fprintf(fid,'%s\n',prtpreds(cond).name);
    fprintf(fid,'%d\n',length(prtpreds(cond).onset)); % (prtpreds(k).onset) = row with onset times of condition i (line 51)
    
    for rep = 1:length(prtpreds(cond).onset) % for each repetition of one condition
        fprintf(fid,' %d \t %d \n', (prtpreds(cond).onset(rep)), (prtpreds(cond).offset(rep)));
    end
    
    fprintf(fid,'Color: %d %d %d\n\n',prtpreds(cond).r, prtpreds(cond).g, prtpreds(cond).b);
end

fclose(fid);

if 1
    disp(['Protocol ' prt_fname ' saved']);
end

end