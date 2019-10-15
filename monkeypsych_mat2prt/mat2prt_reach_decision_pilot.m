function prt_fname = mat2prt_reach_decision_pilot(mat_file, run_name)
% Peter's thesis on reach decisions

if nargin < 2,
    run_name = '';
end

% mat_file = ('Y:\Personal\Peter\Data\MAPA\20190808\MAPA_2019-08-08_03.mat')
% mat_file = ('Y:\Personal\Peter\Data\IVSK\20190620\IVSK2019-06-20_17.mat')
% run_name = '';

[pathname,filename,ext] = fileparts(mat_file);
load(mat_file, '-mat');

%% task timing parameters

cue_onset_delay = 0; %cue is roughly 200 ms long (sometimes 214, 213 etc.)
cue_offset_delay = 800;

% duration of memory period in ms, starting from 7 s after beginning of memory: -> [onset + 7000 onset, lasting 14000]
mem_onset_delay = 7000; % delay is 15 s long
mem_offset_delay = -1000;

% [onset of state 9 onset of state 10 + 200 ms] (you add 200 ms
% because of estimated longer duration to reach the final destination in
% the target (state 10 starts when crossing the border of the target)
mov_onset_delay = 0;
mov_offset_delay = 200;


ITI_onset_delay = 0;
ITI_offset_delay = 0;

aborted_onset_delay = 0;
aborted_offset_delay = 0;
%% this is manual part - defining condition names and etc.

NrofPreds = 3*8+1+1; % 3 events of interest, 8 trial types + 1 ITI + 1 aborted


%% CHANGE "TRIAL" TO GET conditions

[trial.target_chosen] = deal([]); % preallocate trial.target_chosen
[trial.choice] = deal([]);
[trial.eff_name] = deal([]);
[trial([trial.effector]==3).eff_name] = deal({'sac'});
[trial([trial.effector]==4).eff_name] = deal({'reach'});

for k = 1 : length(trial)
    
    % defining, what choice trials are
    if trial(k).task.correct_choice_target == [1 2]
        trial(k).choice = {'choi'};
    elseif trial(k).task.correct_choice_target == 1
        trial(k).choice = {'instr'};
    end
    
    
    % target chosen
    if ~isnan(trial(k).target_selected)
        
        if trial(k).effector == 3 % get only saccade trials
            whichtarget = trial(k).target_selected(1); % here in saccade trials pic the number (can be 1 or 2) which is FIRST in target_selected (because it is for saccades)
            
            if       trial(k).eye.tar(whichtarget).pos(1) < 0
                trial(k).target_chosen = {'l'};
            elseif   trial(k).eye.tar(whichtarget).pos(1) > 0
                trial(k).target_chosen = {'r'};
            end
            
        elseif trial(k).effector == 4 % get only reach trials
            whichtarget = trial(k).target_selected(2); % here in reach trials pic the number (its value can be 1 or 2) which is SECOND in target_selected (because it is for reaches)
            
            if       trial(k).hnd.tar(whichtarget).pos(1) < 0
                trial(k).target_chosen = {'l'};
            elseif   trial(k).hnd.tar(whichtarget).pos(1) > 0
                trial(k).target_chosen = {'r'};
            end
        end % if for which effector
        
    else
        trial(k).target_chosen = {'none'};
        
    end  % if for chosen target or not
    
    
end


%% COLORS

% https://docplayer.org/docs-images/54/34504262/images/3-0.png
% https://www.rapidtables.com/web/color/RGB_Color.html
% https://pinetools.com/lighten-color

%% +++++ EYE/SACCADE ++++++

%% saccade CHOICE LEFT - red

% 'eye_choice_left_cue'
prtpreds(1).name = {'sac_choi_l_cue'};
prtpreds(1).r = 227;
prtpreds(1).g = 35;
prtpreds(1).b = 34;

% 'eye_choice_left_mem'
prtpreds(2).name = {'sac_choi_l_mem'};
prtpreds(2).r = 227;
prtpreds(2).g = 35;
prtpreds(2).b = 34;

% 'eye_choice_left_mov'
prtpreds(3).name = {'sac_choi_l_mov'};
prtpreds(3).r = 227;
prtpreds(3).g = 35;
prtpreds(3).b = 34;


% saccade CHOICE RIGHT - orange

% 'eye_choice_right_cue'
prtpreds(4).name = {'sac_choi_r_cue'};
prtpreds(4).r = 241;
prtpreds(4).g = 142;
prtpreds(4).b = 28;

% 'eye_choice_right_mem'
prtpreds(5).name = {'sac_choi_r_mem'};
prtpreds(5).r = 241;
prtpreds(5).g = 142;
prtpreds(5).b = 28;

% 'eye_choice_right_mov'
prtpreds(6).name = {'sac_choi_r_mov'};
prtpreds(6).r = 241;
prtpreds(6).g = 142;
prtpreds(6).b = 28;

% saccade INSTRUCTED LEFT - violett

% 'eye_instructed_left_cue'
prtpreds(7).name = {'sac_instr_l_cue'};
prtpreds(7).r = 109;
prtpreds(7).g = 57;
prtpreds(7).b = 139;

% 'eye_instructed_left_mem'
prtpreds(8).name = {'sac_instr_l_mem'};
prtpreds(8).r = 109;
prtpreds(8).g = 57;
prtpreds(8).b = 139;

% 'eye_instructed_left_mov'
prtpreds(9).name = {'sac_instr_l_mov'};
prtpreds(9).r = 109;
prtpreds(9).g = 57;
prtpreds(9).b = 139;

% saccade INSTRUCTED RIGHT - red-violett

% 'eye_instructed_right_cue'
prtpreds(10).name = {'sac_instr_r_cue'};
prtpreds(10).r = 196;
prtpreds(10).g = 3;
prtpreds(10).b = 125;

% 'eye_instructed_right_mem'
prtpreds(11).name = {'sac_instr_r_mem'};
prtpreds(11).r = 196;
prtpreds(11).g = 3;
prtpreds(11).b = 125;

% 'eye_instructed_right_mov'
prtpreds(12).name = {'sac_instr_r_mov'};
prtpreds(12).r = 196;
prtpreds(12).g = 3;
prtpreds(12).b = 125;

%% +++++ HAND/REACH ++++++

% reach CHOICE LEFT - green-yellow

% 'hand_choice_left_cue'
prtpreds(13).name = {'reach_choi_l_cue'};
prtpreds(13).r = 0;
prtpreds(13).g = 142;
prtpreds(13).b = 91;

% 'hand_choice_left_mem'
prtpreds(14).name = {'reach_choi_l_mem'};
prtpreds(14).r = 0;
prtpreds(14).g = 142;
prtpreds(14).b = 91;

% 'hand_choice_left_mov'
prtpreds(15).name = {'reach_choi_l_mov'};
prtpreds(15).r = 0;
prtpreds(15).g = 142;
prtpreds(15).b = 91;

% reach CHOICE RIGHT - yellow

% 'hand_choice_right_cue'
prtpreds(16).name = {'reach_choi_r_cue'};
prtpreds(16).r = 140;
prtpreds(16).g = 187;
prtpreds(16).b = 38;

% 'hand_choice_right_mem'
prtpreds(17).name = {'reach_choi_r_mem'};
prtpreds(17).r = 140;
prtpreds(17).g = 187;
prtpreds(17).b = 38;

% 'hand_choice_right_mov'
prtpreds(18).name = {'reach_choi_r_mov'};
prtpreds(18).r = 140;
prtpreds(18).g = 187;
prtpreds(18).b = 38;

% reach INSTRUCTED LEFT - blue

% 'hand_instructed_left_cue'
prtpreds(19).name = {'reach_instr_l_cue'};
prtpreds(19).r = 42;
prtpreds(19).g = 113;
prtpreds(19).b = 176;

% 'hand_instructed_left_mem'
prtpreds(20).name = {'reach_instr_l_mem'};
prtpreds(20).r = 42;
prtpreds(20).g = 113;
prtpreds(20).b = 176;

% 'hand_instructed_left_mov'
prtpreds(21).name = {'reach_instr_l_mov'};
prtpreds(21).r = 42;
prtpreds(21).g = 113;
prtpreds(21).b = 176;

% reach INSTRUCTED RIGHT - green

% 'hand_instructed_right_cue'
prtpreds(22).name = {'reach_instr_r_cue'};
prtpreds(22).r = 7;
prtpreds(22).g = 186;
prtpreds(22).b = 233;

% 'hand_instructed_right_mem'
prtpreds(23).name = {'reach_instr_r_mem'};
prtpreds(23).r = 7;
prtpreds(23).g = 186;
prtpreds(23).b = 233;

% 'hand_instructed_right_mov'
prtpreds(24).name = {'reach_instr_r_mov'};
prtpreds(24).r = 7;
prtpreds(24).g = 186;
prtpreds(24).b = 233;

%%
% 'ITI'
prtpreds(25).name = {'ITI'};
prtpreds(25).r = 220;
prtpreds(25).g = 220;
prtpreds(25).b = 220;

% aborted trials
prtpreds(26).name = {'aborted'};
prtpreds(26).r = 128;
prtpreds(26).g = 128;
prtpreds(26).b = 128;

%% GET ONSETS AND OFFSETS AND PUT THEM IN PRTPREDS

eff = {'sac' 'reach'};
cho = {'choi' 'instr'};
sid = {'l' 'r'}; % leaving out none
pha = {'cue' 'mem' 'mov'};


% [prtpreds(1:NrofPreds).n_correct_trials] = deal([]); % empty array to be filled in cumulatively
[prtpreds(1:NrofPreds).onset] = deal([]);
[prtpreds(1:NrofPreds).offset] = deal([]);


for i = 1:length(eff)
    
    for k = 1:length(cho)
        
        for l = 1:length(sid)
            
            for m = 1:length(pha)
                
                
                % filter out all trials with respective combined condition
                temp = trial(...
                    [trial.success]       == 1      & ...
                    strcmp(eff(i),[trial.eff_name]) & ...
                    strcmp(cho(k),[trial.choice])   & ...
                    strcmp(sid(l),[trial.target_chosen]) );
                
                % create temporary name out of loop inputs to compare with
                % hard coded name from prtpreds from above
                temp_name = cellstr(strcat(eff(i),'_', cho(k),'_',sid(l),'_',pha(m)));
                temp_index = strcmp(temp_name,[prtpreds.name]);
                
                % get the onsets for the respective phase
                onset_times = [temp.states_onset];
                
                
                if     strcmp('cue',pha(m))
                    
                    if isempty(temp)
                        prtpreds(temp_index).onset  = [];
                        prtpreds(temp_index).offset = [];
                        
                    else
                        onset_idx = [temp.states] == 6;
                        offset_idx = [temp.states] == 7;
                        
                        prtpreds(temp_index).onset  = round(onset_times(onset_idx)*1000)  + cue_onset_delay;
                        prtpreds(temp_index).offset = round(onset_times(offset_idx)*1000) + cue_offset_delay;
                    end
                    
                    
                elseif strcmp('mem',pha(m))
                    
                    if isempty(temp)
                        prtpreds(temp_index).onset  = [];
                        prtpreds(temp_index).offset = [];
                        
                    else
                        onset_idx = [temp.states] == 7;
                        offset_idx = [temp.states] == 9;
                        
                        prtpreds(temp_index).onset  = round(onset_times(onset_idx)*1000)  + mem_onset_delay;
                        prtpreds(temp_index).offset = round(onset_times(offset_idx)*1000) + mem_offset_delay;
                    end
                    
                    
                elseif strcmp('mov',pha(m))
                    
                    if isempty(temp)
                        prtpreds(temp_index).onset  = [];
                        prtpreds(temp_index).offset = [];
                        
                    else
                        onset_idx = [temp.states] == 9;
                        offset_idx = [temp.states] == 10;
                        
                        prtpreds(temp_index).onset  = round(onset_times(onset_idx)*1000) + mov_onset_delay;
                        prtpreds(temp_index).offset = round(onset_times(offset_idx)*1000) + mov_offset_delay;
                    end
                    
                end %if state of which phase of the trial
                
                
            end % loop phase
        end % loop side of target (left/right)
    end % loop choice
end % loop effector


%temp = trial([trial.success] == 0);



%% Add ITI Onsets and Offsets

ITI_onset = [];
ITI_offset = [];

for i = 1:length(trial) %loop over trials to get the ITI (state 50) onsets and offsets
    
    ITI_samples = trial(i).tSample_from_time_start(trial(i).state == 50);
    
    ITI_onset  = [ITI_onset ITI_samples(1)]; % first one of ITI
    ITI_offset = [ITI_offset ITI_samples(end)]; % last one of ITI
    
end

% convert to mili seconds and add variable delay (see beginning of file)
prtpreds(strcmp('ITI',[prtpreds.name])).onset  = round(ITI_onset *1000) + ITI_onset_delay;
prtpreds(strcmp('ITI',[prtpreds.name])).offset = round(ITI_offset*1000) + ITI_offset_delay;


%% Add Aborted Onsets and Offsets

aborted_onset = [];
aborted_offset = [];
temp_aborted = trial([trial.success] == 0);

for i = 1:length(temp_aborted) % loop over unsuccessful trials to get the a vector with every timestamp from the trial, but not the ITI 
    
    aborted_cue = temp_aborted(i).states_onset(temp_aborted(i).states == 6);
    
    if isempty(aborted_cue) % if error occured before onset of the cue, no aborted trial has to be modeled, so skip it
        continue;
    end
    
    aborted_samples = temp_aborted(i).tSample_from_time_start(temp_aborted(i).state ~= 50);
    
    aborted_onset  = [aborted_onset aborted_cue]; 
    aborted_offset = [aborted_offset aborted_samples(end)]; % last one before ITI
    
end

% convert to mili seconds and add variable delay (see beginning of file)
prtpreds(strcmp('aborted',[prtpreds.name])).onset  = round(aborted_onset *1000) + aborted_onset_delay;
prtpreds(strcmp('aborted',[prtpreds.name])).offset = round(aborted_offset*1000) + aborted_offset_delay;



%%
for i = 1:length(prtpreds)
    prtpreds(i).name = char(prtpreds(i).name );
end


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