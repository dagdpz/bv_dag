function prt_fname = mat2prt_BA_fixmemstim(mat_file, run_name)

if nargin < 2,
    run_name = '';
end

[pathname,filename,ext] = fileparts(mat_file);
load(mat_file, '-mat');
n_blocks = length(trial); % you need to find number of blocks (i.e. rows) from data

%% task timing parameters
reward_time = task.timing.ITI_success*1000;
ITI_fail = task.timing.ITI_fail*1000;

memory_trials =  trial([trial.type] == 3);
if size(memory_trials,2) > 0
    fix_hold = memory_trials(1).task.timing.fix_time_hold*1000; % initial fixation time in ms
    mem_hold = memory_trials(1).task.timing.mem_time_hold*1000; % duration of memory period in ms
    tar_hold = memory_trials(1).task.timing.tar_time_hold*1000; % target hold time in ms
    stim_onset = fix_hold + memory_trials(1).task.timing.cue_time_hold*1000;
else
    fix_hold = 10*1000;
    mem_hold = 10*1000;
    tar_hold = 1.5*1000;
    stim_onset = fix_hold + 0.2*1000;
end
offset_saccade = 1000; % time to exclude before saccade in ms

% stim_offset = max([trial.microstim_end])*1000;

%% this is manual part - defining condition names and etc.

NrofPreds = 11;

prtpreds(1).name = 'fixation';
prtpreds(1).r = 150; %189;
prtpreds(1).g = 255; %183;
prtpreds(1).b = 100; %107;

prtpreds(2).name = 'fixation microstim';
prtpreds(2).r = 0; %255;
prtpreds(2).g = 160; %255;
prtpreds(2).b = 0;

prtpreds(3).name = 'memory right';
prtpreds(3).r = 255; %221;
prtpreds(3).g = 150; %160;
prtpreds(3).b = 150; %221;

prtpreds(4).name = 'memory right microstim';
prtpreds(4).r = 255;
prtpreds(4).g = 0;
prtpreds(4).b = 0; %255;

prtpreds(5).name = 'memory left';
prtpreds(5).r = 100; %176;
prtpreds(5).g = 180; %224;
prtpreds(5).b = 255; %230;

prtpreds(6).name = 'memory left microstim';
prtpreds(6).r = 0; %30;
prtpreds(6).g = 0; %144;
prtpreds(6).b = 255;

prtpreds(7).name = 'post fixation';
prtpreds(7).r = 218;
prtpreds(7).g = 165;
prtpreds(7).b = 32;

prtpreds(8).name = 'post memory right';
prtpreds(8).r = 188;
prtpreds(8).g = 143;
prtpreds(8).b = 143;

prtpreds(9).name = 'post memory left';
prtpreds(9).r = 152;
prtpreds(9).g = 251;
prtpreds(9).b = 152;

prtpreds(10).name = 'reward';
prtpreds(10).r = 0;
prtpreds(10).g = 0;
prtpreds(10).b = 255;

prtpreds(11).name = 'abort';
prtpreds(11).r = 0;
prtpreds(11).g = 0;
prtpreds(11).b = 0;

% [prtpreds(1:NrofPreds).n_correct_trials] = deal([]); % empty array to be filled in cumulatively
[prtpreds(1:NrofPreds).onset] = deal([]);
[prtpreds(1:NrofPreds).offset] = deal([]);

%% trial conditions, states, and state onsets
idx_success = find([trial.success] == 1); % successful trials
idx_abort = find([trial.success] == 0); % aborted trials
idx_fix = find([trial.type] == 1); % fixation trials
idx_fix_success = intersect(idx_success, idx_fix); % successful fixation trials
idx_mem = find([trial.type] == 3); % memory saccade trials
idx_mem_success = intersect(idx_success, idx_mem); % successful memory saccade trials
idx_stim = find([trial.microstim] == 1); % stimulation trials
idx_nostim = find([trial.microstim] == 0); % no-stimulation trials
idx_fix_stim = intersect(idx_fix_success, idx_stim); % successful fixation trials with microstimulation
idx_fix_nostim = intersect(idx_fix_success, idx_nostim); % successful fixation trials without microstimulation

% get target positions
if ~isempty(idx_mem)
    target_selected_temp=cat(1,trial(idx_mem_success).target_selected);
    target_selected =target_selected_temp(:,1); % eye
    eye = cat(1,trial(idx_mem_success).eye);
    tar = cat(1,eye.tar);
    tar = tar(sub2ind(size(tar),[1:size(tar,1)],target_selected')); % sub2ind is important function converting subscripts to linear index
    pos = cat(1,tar.pos);
    target_left = double(pos(:,1)<0);
    
    idx_mem_left = idx_mem_success(target_left == 1); % successful memory saccades to the left
    idx_mem_right = idx_mem_success(target_left == 0); % successful memory saccades to the right
    idx_mem_left_stim = intersect(idx_mem_left, idx_stim); % successful memory saccades to the left with microstimulation
    idx_mem_left_nostim = intersect(idx_mem_left, idx_nostim); % successful memory saccades to the left without microstimulation
    idx_mem_right_stim = intersect(idx_mem_right, idx_stim); % successful memory saccades to the right with microstimulation
    idx_mem_right_nostim = intersect(idx_mem_right, idx_nostim); % successful memory saccades to the right without microstimulation
else
    idx_mem_left = [];
    idx_mem_right = [];
    idx_mem_left_stim = [];
    idx_mem_left_nostim = [];
    idx_mem_right_stim = [];
    idx_mem_right_nostim = [];
end

% get states and state onsets for fixation and memory trials
states_fix = cat(1, trial(idx_fix_success).states);
states_onset_fix = round(cat(1, trial(idx_fix_success).states_onset)*1000);
states_mem_left = cat(1, trial(idx_mem_left).states);
states_onset_mem_left = round(cat(1, trial(idx_mem_left).states_onset)*1000);
states_mem_right = cat(1, trial(idx_mem_right).states);
states_onset_mem_right = round(cat(1, trial(idx_mem_right).states_onset)*1000);

states_fix_stim = cat(1, trial(idx_fix_stim).states);
states_onset_fix_stim = round(cat(1, trial(idx_fix_stim).states_onset)*1000);
states_fix_nostim = cat(1, trial(idx_fix_nostim).states);
states_onset_fix_nostim = round(cat(1, trial(idx_fix_nostim).states_onset)*1000);
states_mem_left_stim = cat(1, trial(idx_mem_left_stim).states);
states_onset_mem_left_stim = round(cat(1, trial(idx_mem_left_stim).states_onset)*1000);
states_mem_left_nostim = cat(1, trial(idx_mem_left_nostim).states);
states_onset_mem_left_nostim = round(cat(1, trial(idx_mem_left_nostim).states_onset)*1000);
states_mem_right_stim = cat(1, trial(idx_mem_right_stim).states);
states_onset_mem_right_stim = round(cat(1, trial(idx_mem_right_stim).states_onset)*1000);
states_mem_right_nostim = cat(1, trial(idx_mem_right_nostim).states);
states_onset_mem_right_nostim = round(cat(1, trial(idx_mem_right_nostim).states_onset)*1000);

% get states and state onsets for all rewarded trials
states_reward_fix = cat(1, trial(idx_fix_success).states);
states_onset_reward_fix = round(cat(1, trial(idx_fix_success).states_onset)*1000);
states_reward_mem = cat(1, trial(idx_mem_success).states);
states_onset_reward_mem = round(cat(1, trial(idx_mem_success).states_onset)*1000);

% get states and state onsets for aborted trials
% states_abort = [];
states_onset_abort = [];
n_trial_abort = 0;
for t = idx_abort % loop through all aborted trials
    n_trial_abort = n_trial_abort + 1;
        states_onset_abort(n_trial_abort,1) = round(trial(t).states_onset(1)*1000);
        states_onset_abort(n_trial_abort,2) = round(trial(t).states_onset(end)*1000);
        
%     if strcmp(trial(t).abort_code, 'ABORT_EYE_FIX_ACQ_STATE') == 0
%         n_trial_abort = n_trial_abort + 1;
%         %     states_abort(n_trial_abort,1) = trial(t).states(1);
%         %     states_abort(n_trial_abort,2) = trial(t).states(end);
%         states_onset_abort(n_trial_abort,1) = round(trial(t).states_onset(1)*1000);
%         states_onset_abort(n_trial_abort,2) = round(trial(t).states_onset(end)*1000);
%     end
end


%% add predictors to protocol
% predictor: fixation without microstimulation
prtpreds(1).onset = states_onset_fix_nostim(states_fix_nostim == 3) + stim_onset; % from time corresponding to beginning of memory period/stimulation
prtpreds(1).offset = states_onset_fix_nostim(states_fix_nostim == 3) + stim_onset + mem_hold - offset_saccade; % to time corresponding to end of (relevant part) of memory period

% predictor: fixation with microstimulation 
prtpreds(2).onset = states_onset_fix_stim(states_fix_stim == 3) + stim_onset; % from time corresponding to beginning of memory period
prtpreds(2).offset = states_onset_fix_stim(states_fix_stim == 3) + stim_onset + mem_hold - offset_saccade; % to time corresponding to end of (relevant part) of memory period

% predictor: memory right without microstimulation
prtpreds(3).onset = states_onset_mem_right_nostim(states_mem_right_nostim == 7); % from beginning of memory period
prtpreds(3).offset = states_onset_mem_right_nostim(states_mem_right_nostim == 7) + mem_hold - offset_saccade; % to end of (relevant part) of memory period

% predictor: memory right with microstimulation
prtpreds(4).onset = states_onset_mem_right_stim(states_mem_right_stim == 7); % from beginning of memory period
prtpreds(4).offset = states_onset_mem_right_stim(states_mem_right_stim == 7) + mem_hold - offset_saccade; % to end of (relevant part) of memory period

% predictor: memory left without microstimulation
prtpreds(5).onset = states_onset_mem_left_nostim(states_mem_left_nostim == 7); % from beginning of memory period
prtpreds(5).offset = states_onset_mem_left_nostim(states_mem_left_nostim == 7) + mem_hold - offset_saccade; % to end of (relevant part) of memory period

% predictor: memory left with microstimulation
prtpreds(6).onset = states_onset_mem_left_stim(states_mem_left_stim == 7); % from beginning of memory period
prtpreds(6).offset = states_onset_mem_left_stim(states_mem_left_stim == 7) + mem_hold - offset_saccade; % to end of (relevant part) of memory period

% predictor: post-fixation
prtpreds(7).onset = states_onset_fix(states_fix == 3) + stim_onset + mem_hold - offset_saccade + 1; % from time corresponding to end of (relevant part of) memory period
prtpreds(7).offset = states_onset_fix(states_fix == 20); % to success feedback

% predictor: post-memory right
prtpreds(8).onset = states_onset_mem_right(states_mem_right == 7) + mem_hold - offset_saccade + 1; % end of (relevant part) of memory period
prtpreds(8).offset = states_onset_mem_right(states_mem_right == 20); % to success feedback

% predictor: post-memory left
prtpreds(9).onset = states_onset_mem_left(states_mem_left == 7) + mem_hold - offset_saccade + 1; % from end of (relevant part) of memory period
prtpreds(9).offset = states_onset_mem_left(states_mem_left == 20); % to success feedback

% predictor: reward
prtpreds(10).onset = sort([states_onset_reward_fix(states_reward_fix == 20); states_onset_reward_mem(states_reward_mem == 20)] + 1); % from beginning of reward period
prtpreds(10).offset = sort([states_onset_reward_fix(states_reward_fix == 21); states_onset_reward_mem(states_reward_mem == 21)] + reward_time); % to end of ITI
% prtpreds(13).offset = sort([states_onset_reward_fix(states_reward_fix == 50 | states_reward_fix == 99); states_onset_reward_mem(states_reward_mem == 50 | states_reward_mem == 99)] + reward_time); % to end of ITI

% predictor: abort
prtpreds(11).onset = states_onset_abort(:,1);
prtpreds(11).offset = states_onset_abort(:,2) + ITI_fail;

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

disp(['Protocol ' prt_fname ' saved']);

end
