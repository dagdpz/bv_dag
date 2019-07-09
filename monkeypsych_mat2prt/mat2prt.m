function mat2prt(mat_file, run_name) % see also "monkeypsych_dev_microstim_NO_pre_memory_NO_cue_0to9.m"

if nargin < 2,
    run_name = '';
end

[pathname,filename,ext] = fileparts(mat_file);
load('-mat', mat_file);
n_trials = length(trial);


%% task timing parameters
reward_time = task.timing.ITI_success*1000;
ITI_fail = task.timing.ITI_fail*1000;

memory_trials =  trial([trial.type] == 3);
fix_hold = memory_trials(1).task.timing.fix_time_hold*1000; % initial fixation time in ms
mem_hold = memory_trials(1).task.timing.mem_time_hold*1000; % duration of memory period in ms
tar_hold = memory_trials(1).task.timing.tar_time_hold*1000; % target hold time in ms
offset_saccade = 1000; % time to exclude before saccade in ms

% for variable memory period timing replace memory hold time by relevant
% time period of memory period (first x milliseconds), do not use saccade
% offset
mem_hold = 9000;
offset_saccade = 0;

% post_mem = [];
% 
% for i = 1:n_trials
%     
%     if trial(i).success == 1        
%         time_reward_start = round(trial(i).states_onset(trial(i).states == 21)*1000);
%         time_fix_mem = round(trial(i).states_onset(trial(i).states == 3)*1000) + fix_hold + mem_hold;
%         time_post_mem = time_reward_start - time_fix_mem;        
%     else
%         time_post_mem = NaN;
%     end
%     
%     post_mem = [post_mem time_post_mem];
%     
% end

%% this is manual part - defining condition names and etc.

NrofPreds = 14;

prtpreds(1).name = '1 fixation ';
prtpreds(1).r = 189;
prtpreds(1).g = 183;
prtpreds(1).b = 107;

prtpreds(2).name = '2 post fixation';
prtpreds(2).r = 218;
prtpreds(2).g = 165;
prtpreds(2).b = 32;

prtpreds(3).name = '3 fixation microstim';
prtpreds(3).r = 255;
prtpreds(3).g = 255;
prtpreds(3).b = 0;

prtpreds(4).name = '4 post fixation microstim';
prtpreds(4).r = 255;
prtpreds(4).g = 181;
prtpreds(4).b = 97;

prtpreds(5).name = '5 memory right';
prtpreds(5).r = 221;
prtpreds(5).g = 160;
prtpreds(5).b = 221;

prtpreds(6).name = '6 post memory right';
prtpreds(6).r = 188;
prtpreds(6).g = 143;
prtpreds(6).b = 143;

prtpreds(7).name = '7 memory right microstim';
prtpreds(7).r = 255;
prtpreds(7).g = 0;
prtpreds(7).b = 255;

prtpreds(8).name = '8 post-memory right microstim';
prtpreds(8).r = 165;
prtpreds(8).g = 42;
prtpreds(8).b = 42;

prtpreds(9).name = '9 memory left';
prtpreds(9).r = 176;
prtpreds(9).g = 224;
prtpreds(9).b = 230;

prtpreds(10).name = '10 post memory left';
prtpreds(10).r = 152;
prtpreds(10).g = 251;
prtpreds(10).b = 152;

prtpreds(11).name = '11 memory left microstim';
prtpreds(11).r = 30;
prtpreds(11).g = 144;
prtpreds(11).b = 255;

prtpreds(12).name = '12 post memory left microstim';
prtpreds(12).r = 0;
prtpreds(12).g = 255;
prtpreds(12).b = 0;

prtpreds(13).name = '13 reward';
prtpreds(13).r = 0;
prtpreds(13).g = 0;
prtpreds(13).b = 255;

prtpreds(14).name = '14 abort';
prtpreds(14).r = 255;
prtpreds(14).g = 0;
prtpreds(14).b = 0;

% [prtpreds(1:NrofPreds).n_correct_trials] = deal([]); % empty array to be filled in cumulatively
[prtpreds(1:NrofPreds).onset] = deal([]);
[prtpreds(1:NrofPreds).offset] = deal([]);

for i = 1:n_blocks
    
    states = trial(i).states;
    states_onset =  round(trial(i).states_onset*1000);
    
    if trial(i).success > 0 && trial(i).type == 1 && trial(i).microstim == 0
        % fixation, no microstim, successful
        
        cond = 1; % fixation
        % set onset / offset times
        prtpreds(cond).onset =  [prtpreds(cond).onset states_onset(states == 3)+fix_hold]; % from time corresponding to cue onset in memory trials
        prtpreds(cond).offset = [prtpreds(cond).offset states_onset(states == 3)+fix_hold+mem_hold-offset_saccade]; % to time corresponding to end of (relevant part of) memory period
        
        cond = 2; % post fixation
        prtpreds(cond).onset =  [prtpreds(cond).onset states_onset(states == 3)+fix_hold+mem_hold-offset_saccade+1]; % from time corresponding to end of (relevant part of) memory period
        prtpreds(cond).offset = [prtpreds(cond).offset states_onset(states == 20)]; % to success feedback
        
        cond = 13; % reward
        prtpreds(cond).onset =  [prtpreds(cond).onset states_onset(states == 20)+1]; % from success feedback
        prtpreds(cond).offset = [prtpreds(cond).offset states_onset(states == 50)+reward_time]; % to end of ITI/reward
        
    elseif trial(i).success > 0 && trial(i).type == 1 && trial(i).microstim == 1
        % fixation, microstim, successful
        
        cond = 3; % fixation microstim
        % set onset / offset times
        prtpreds(cond).onset =  [prtpreds(cond).onset states_onset(states == 3)+fix_hold]; % from time corresponding to cue onset in memory trials
        prtpreds(cond).offset = [prtpreds(cond).offset states_onset(states == 3)+fix_hold+mem_hold-offset_saccade];
        
        cond = 4; % post fixation microstim
        prtpreds(cond).onset =  [prtpreds(cond).onset states_onset(states == 3)+fix_hold+mem_hold-offset_saccade+1]; % from time corresponding to end of memory period
        prtpreds(cond).offset = [prtpreds(cond).offset states_onset(states == 20)]; % to success feedback
        
        cond = 13; % reward
        prtpreds(cond).onset =  [prtpreds(cond).onset states_onset(states == 20)+1]; % from success feedback
        prtpreds(cond).offset = [prtpreds(cond).offset states_onset(states == 50)+reward_time]; % to end of ITI/reward
        
        
    elseif trial(i).success > 0 && trial(i).type == 3 && trial(i).eye.tar(isnan(trial(i).target_selected) == 0).pos(1) > 0 && trial(i).microstim == 0
        % memory, right, no microstim, successful
        
        cond = 5; % memory right
        prtpreds(cond).onset =  [prtpreds(cond).onset states_onset(states == 7)]; % from beginning of memory period
        prtpreds(cond).offset = [prtpreds(cond).offset states_onset(states == 7)+mem_hold-offset_saccade]; % to end of (relevant part of) memory period
        
        cond = 6; % post memory right
        prtpreds(cond).onset =  [prtpreds(cond).offset states_onset(states == 7)+mem_hold-offset_saccade+1]; % from end of (relevant part of) memory period
        prtpreds(cond).offset = [prtpreds(cond).offset states_onset(states == 20)]; % to success feedback
        
        cond = 13; % reward
        prtpreds(cond).onset =  [prtpreds(cond).onset states_onset(states == 20)+1]; % from success feedback
        prtpreds(cond).offset = [prtpreds(cond).offset states_onset(states == 50)+reward_time]; % to end of ITI/reward
        
    elseif trial(i).success > 0 && trial(i).type == 3 && trial(i).eye.tar(isnan(trial(i).target_selected) == 0).pos(1) > 0 && trial(i).microstim == 1
        % memory, right, microstim, successful
        
        cond = 7; % memory right microstim
        prtpreds(cond).onset =  [prtpreds(cond).onset states_onset(states == 7)]; % from beginning of memory period
        prtpreds(cond).offset = [prtpreds(cond).offset states_onset(states == 7)+mem_hold-offset_saccade]; % to end of (relevant part of) memory period
        
        cond = 8; % post memory right microstim
        prtpreds(cond).onset =  [prtpreds(cond).offset states_onset(states == 7)+mem_hold-offset_saccade+1]; % from end of (relevant part of) memory period
        prtpreds(cond).offset = [prtpreds(cond).offset states_onset(states == 20)]; % to success feedback
        
        cond = 13; % reward
        prtpreds(cond).onset =  [prtpreds(cond).onset states_onset(states == 20)+1]; % from success feedback
        prtpreds(cond).offset = [prtpreds(cond).offset states_onset(states == 50)+reward_time]; % to end of ITI/reward
        
        
    elseif trial(i).success > 0 && trial(i).type == 3 && trial(i).eye.tar(isnan(trial(i).target_selected) == 0).pos(1) < 0 && trial(i).microstim == 0
        % memory, left, no microstim, successful
        
        cond = 9; % memory left
        prtpreds(cond).onset =  [prtpreds(cond).onset states_onset(states == 7)]; % from beginning of memory period
        prtpreds(cond).offset = [prtpreds(cond).offset states_onset(states == 7)+mem_hold-offset_saccade]; % to end of (relevant part of) memory period
        
        cond = 10; % post memory left
        prtpreds(cond).onset =  [prtpreds(cond).offset states_onset(states == 7)+mem_hold-offset_saccade+1]; % from end of (relevant part of) memory period
        prtpreds(cond).offset = [prtpreds(cond).offset states_onset(states == 20)]; % to success feedback
        
        cond = 13; % reward
        prtpreds(cond).onset =  [prtpreds(cond).onset states_onset(states == 20)+1]; % from success feedback
        prtpreds(cond).offset = [prtpreds(cond).offset states_onset(states == 50)+reward_time]; % to end of ITI/reward
        
    elseif trial(i).success > 0 && trial(i).type == 3 && trial(i).eye.tar(isnan(trial(i).target_selected) == 0).pos(1) < 0 && trial(i).microstim == 1
        % memory, left, no microstim, successful
        
        cond = 11; % memory left microstim
        prtpreds(cond).onset =  [prtpreds(cond).onset states_onset(states == 7)]; % from beginning of memory period
        prtpreds(cond).offset = [prtpreds(cond).offset states_onset(states == 7)+mem_hold-offset_saccade]; % to end of (relevant part of) memory period
        
        cond = 12; % post memory left microstim
        prtpreds(cond).onset =  [prtpreds(cond).offset states_onset(states == 7)+mem_hold-offset_saccade+1]; % from end of (relevant part of) memory period
        prtpreds(cond).offset = [prtpreds(cond).offset states_onset(states == 20)]; % to success feedback
        
        cond = 13; % reward
        prtpreds(cond).onset =  [prtpreds(cond).onset states_onset(states == 20)+1]; % from success feedback
        prtpreds(cond).offset = [prtpreds(cond).offset states_onset(states == 50)+reward_time]; % to end of ITI/reward
        
    else
        cond = 14; % abort
        prtpreds(cond).onset =  [prtpreds(cond).onset states_onset(states == 1)]; % from initializing trial
        prtpreds(cond).offset = [prtpreds(cond).offset states_onset(states == 50)+ITI_fail]; % to end of trial plus ITI for aborted trial
    end
end
  

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