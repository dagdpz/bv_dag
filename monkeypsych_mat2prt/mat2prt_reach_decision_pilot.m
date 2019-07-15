function prt_fname = mat2prt_reach_decision_pilot(mat_file, run_name)
% Peter's thesis on reach decisions

if nargin < 2,
    run_name = '';
end

% mat_file = ('Y:\Personal\Peter\Data\IVSK\20190620\IVSK2019-06-20_17.mat')
% run_name = '';

[pathname,filename,ext] = fileparts(mat_file);
load(mat_file, '-mat');

%% task timing parameters

cue_onset_delay = 0; %cue is roughly 200 ms long (sometimes 214, 213 etc.)
cue_offset_delay = 800;

% duration of memory period in ms, starting from 7 s after beginning of memory: -> [onset + 7000 onset + 14000]
mem_onset_delay = 7000; % delay is 15 s long
mem_offset_delay = -1000;

% [onset of state 9 onset of state 10 + 200 ms] (you add 200 ms
% because of estimated longer duration to reach the final destination in
% the target (state 10 starts when crossing the border of the target)
mov_onset_delay = 0; 
mov_offset_delay = 200;


%% this is manual part - defining condition names and etc.

NrofPreds = 3*8; % 3 events of interest, 8 trial types


%% CHANGE "TRIAL" TO GET conditions

[trial.target_chosen] = deal([]); % preallocate trial.target_chosen
[trial.choice] = deal([]);
[trial.eff_name] = deal([]); 
[trial([trial.effector]==3).eff_name] = deal({'eye'});
[trial([trial.effector]==4).eff_name] = deal({'hand'});

for k = 1 : length(trial)
    
    % defining, what choice trials are 
    if trial(k).task.correct_choice_target == [1 2]
        trial(k).choice = {'choice'};
    elseif trial(k).task.correct_choice_target == 1
        trial(k).choice = {'instructed'};
    end
 

    % target chosen
    if ~isnan(trial(k).target_selected)
        
        if trial(k).effector == 3 % get only saccade trials
            whichtarget = trial(k).target_selected(1); % here in saccade trials pic the number (can be 1 or 2) which is FIRST in target_selected (because it is for saccades)
            
            if       trial(k).eye.tar(whichtarget).pos(1) < 0
                trial(k).target_chosen = {'left'};
            elseif   trial(k).eye.tar(whichtarget).pos(1) > 0
                trial(k).target_chosen = {'right'};
            end
            
        elseif trial(k).effector == 4 % get only reach trials
            whichtarget = trial(k).target_selected(2); % here in reach trials pic the number (its value can be 1 or 2) which is SECOND in target_selected (because it is for reaches)
            
            if       trial(k).hnd.tar(whichtarget).pos(1) < 0
                 trial(k).target_chosen = {'left'};
            elseif   trial(k).hnd.tar(whichtarget).pos(1) > 0
                 trial(k).target_chosen = {'right'};
            end
        end % if for which effector

    else
         trial(k).target_chosen = {'none'};
        
    end  % if for chosen target or not
 
    
end



%% FILL IN "PRTPREDS" with name, onset, offset

eff = unique([trial.eff_name]); % 'eye', 'hand'
cho = unique([trial.choice]); % 'choice', 'instructed'
sid = {'left' 'right'}; % leaving out none
pha = {'cue' 'mem' 'mov'};


% [prtpreds(1:NrofPreds).n_correct_trials] = deal([]); % empty array to be filled in cumulatively
[prtpreds(1:NrofPreds).name] = deal([]);
[prtpreds(1:NrofPreds).onset] = deal([]);
[prtpreds(1:NrofPreds).offset] = deal([]);

runningNR = 0;

   
for i = 1:length(eff)

    for k = 1:length(cho)

        for l = 1:length(sid)
            
            for m = 1:length(pha)

                runningNR =runningNR +1;

                % filter out all trials with respective combined condition
                temp = trial(...
                    [trial.success]       == 1      & ...
                    strcmp(eff(i),[trial.eff_name]) & ...
                    strcmp(cho(k),[trial.choice])   & ...
                    strcmp(sid(l),[trial.target_chosen]) );
                
                % put the name of combined condition in the struct
                prtpreds(runningNR).name = char(strcat(eff(i),'_', cho(k),'_',sid(l),'_',pha(m)));
                prtpreds(runningNR).number = runningNR;

                % get the onsets for the repsective phase 
                onset_times = [temp.states_onset];
                
                if     strcmp('cue',pha(m))
                    
                    onset_idx = [temp.states] == 6;
                    offset_idx = [temp.states] == 7;
                    
                    prtpreds(runningNR).onset  = round(onset_times(onset_idx)*1000)  + cue_onset_delay;
                    prtpreds(runningNR).offset = round(onset_times(offset_idx)*1000) + cue_offset_delay;
                    
                elseif strcmp('mem',pha(m))
                    
                    onset_idx = [temp.states] == 7;
                    offset_idx = [temp.states] == 9;                    
                    
                    prtpreds(runningNR).onset  = round(onset_times(onset_idx)*1000)  + mem_onset_delay;
                    prtpreds(runningNR).offset = round(onset_times(offset_idx)*1000) + mem_offset_delay;
                    
                elseif strcmp('mov',pha(m))
                    
                    onset_idx = [temp.states] == 9;
                    offset_idx = [temp.states] == 10;
                    
                    prtpreds(runningNR).onset  = round(onset_times(onset_idx)*1000) + mov_onset_delay;
                    prtpreds(runningNR).offset = round(onset_times(offset_idx)*1000) + mov_offset_delay;

                end %if state of which phase of the trial
           
            end % loop phase
        end % loop side of target (left/right)
    end % loop choice
end % loop effector



%% COLORS

% https://docplayer.org/docs-images/54/34504262/images/3-0.png
% https://www.rapidtables.com/web/color/RGB_Color.html
% https://pinetools.com/lighten-color

%% EYE CHOICE LEFT
% 'eye_choice_left_cue' 
% red
prtpreds(1).r = 227; 
prtpreds(1).g = 35; 
prtpreds(1).b = 34; 

% 'eye_choice_left_mem'
% red-orange
prtpreds(2).r = 234;
prtpreds(2).g = 98;
prtpreds(2).b = 31;

% 'eye_choice_left_mov'
% orange
prtpreds(3).r = 253; 
prtpreds(3).g = 198; 
prtpreds(3).b = 11; 


%%

% 'eye_choice_right_cue'
prtpreds(4).r = 241;
prtpreds(4).g = 145;
prtpreds(4).b = 144;

% 'eye_choice_right_mem'
prtpreds(5).r = 244; 
prtpreds(5).g = 176; 
prtpreds(5).b = 143; 

% 'eye_choice_right_mov'
prtpreds(6).r = 254;
prtpreds(6).g = 226;
prtpreds(6).b = 132;

%% EYE INSTRUCTED LEFT

% 'eye_instructed_left_cue'
% green
prtpreds(7).r = 0;
prtpreds(7).g = 142;
prtpreds(7).b = 91;

% 'eye_instructed_left_mem'
% blue green
prtpreds(8).r = 6;
prtpreds(8).g = 150;
prtpreds(8).b = 187;

% 'eye_instructed_left_mov'
% blue
prtpreds(9).r = 42;
prtpreds(9).g = 113;
prtpreds(9).b = 176;

%% 

% 'eye_instructed_right_cue'
prtpreds(10).r = 70;
prtpreds(10).g = 255;
prtpreds(10).b = 188;

% 'eye_instructed_right_mem'
prtpreds(11).r = 101;
prtpreds(11).g = 219;
prtpreds(11).b = 250;

% 'eye_instructed_right_mov'
prtpreds(12).r = 137;
prtpreds(12).g = 184;
prtpreds(12).b = 226;

%% HAND CHOICE LEFT

% 'hand_choice_left_cue'
% green-yellow
prtpreds(13).r = 140;
prtpreds(13).g = 187;
prtpreds(13).b = 38;

% 'hand_choice_left_mem'
% yellow
prtpreds(14).r = 244;
prtpreds(14).g = 229;
prtpreds(14).b = 0;

% 'hand_choice_left_mov'
% yellow-orange
prtpreds(15).r = 253;
prtpreds(15).g = 198;
prtpreds(15).b = 11;

%%
% 'hand_choice_right_cue'
prtpreds(16).r = 201;
prtpreds(16).g = 230;
prtpreds(16).b = 136;

% 'hand_choice_right_mem'
prtpreds(17).r = 255;
prtpreds(17).g = 246;
prtpreds(17).b = 122;

% 'hand_choice_right_mov'
prtpreds(18).r = 254;
prtpreds(18).g = 226;
prtpreds(18).b = 132;

%% HAND INSTRUCTED LEFT
% 'hand_instructed_left_cue'
% red-purple
prtpreds(19).r = 196;
prtpreds(19).g = 3;
prtpreds(19).b = 125;

% 'hand_instructed_left_mem'
% purple
prtpreds(20).r = 109;
prtpreds(20).g = 57;
prtpreds(20).b = 139;

% 'hand_instructed_left_mov'
% blue-purple
prtpreds(21).r = 68;
prtpreds(21).g = 78;
prtpreds(21).b = 153;

%%

% 'hand_instructed_right_cue'
prtpreds(22).r = 252;
prtpreds(22).g = 101;
prtpreds(22).b = 197;

% 'hand_instructed_right_mem'
prtpreds(23).r = 185;
prtpreds(23).g = 143;
prtpreds(23).b = 209;

% 'hand_instructed_right_mov'
prtpreds(24).r = 154;
prtpreds(24).g = 161;
prtpreds(24).b = 210;

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


