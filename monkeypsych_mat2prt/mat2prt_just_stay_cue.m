function prt_fname = mat2prt_just_stay_cue(mat_file, run_name)

if nargin < 2,
    run_name = '';
end

[pathname,filename,ext] = fileparts(mat_file);

load('-mat', mat_file);

% LIST OF POTENTIAL PREDICTORS


PRED(1).name  = 'SUC_STAY_R';	        PRED(1).col  = [0 255 0];
PRED(2).name  = 'SUC_STAY_L';	        PRED(2).col  = [0 0 255];
PRED(3).name  = 'UNSUC_STAY';           PRED(3).col  = [255 0 0];
PRED(4).name = 'BACK TILL REWARD S';    PRED(4).col = [100 100 100];
PRED(5).name = 'BACK TILL REWARD U';    PRED(5).col = [255 255 0];


use_predictors = [1 2 3 4 5];
NrofPreds	=  length(use_predictors);

if isempty(run_name)
    prt_fname = [pathname filesep filename  '.prt'];
else
    prt_fname = [pathname filesep filename(1:end-2) run_name '.prt'];    
end


fid = fopen(prt_fname,'w'); % open prt file

% fill prt header info:
fprintf(fid,'\n');
fprintf(fid,'FileVersion:\t%d\n\n',2);
fprintf(fid,'ResolutionOfTime:\t%s\n\n','msec');
fprintf(fid,'Experiment:\t%s\n\n',filename); % original mat filename
fprintf(fid,'BackgroundColor:\t%d %d %d\n',0,0,0);
fprintf(fid,'TextColor:\t%d %d %d\n',255,255,255);
fprintf(fid,'TimeCourseColor:\t%d %d %d\n',255,255,255);
fprintf(fid,'TimeCourseThick:\t%d\n',3);
fprintf(fid,'ReferenceFuncColor:\t%d %d %d\n',0,0,80);
fprintf(fid,'ReferenceFuncThick:\t%d\n\n',3);
fprintf(fid,'NrOfConditions:\t%d\n\n',NrofPreds );

%% Extracting values from mat file

Trial                             = [trial.Trial];
unsuccess                         = [trial.unsuccess];
target                            = [trial.target];
toTargetRT                        = [trial.toTargetRT];
dist_from_center_x                = [trial.dist_from_center_x];
Trial_start_time_run              = [trial.Trial_start_time_run];
time_target_stim_appeared_run     = [trial.time_target_stim_appeared_run];
backRT_run                        = [trial.backRT_run];
Trial_finish_time_run             = [trial.Trial_finish_time_run];
reward_time_run                   = [trial.reward_time_run];



%% Indexes
data_factor = 1000;

idx_suc          = find(unsuccess==0);
idx_unsuc        = find(unsuccess~=0);

for g= 1:(length(Trial)-1)
    Trial_restart_time_run(g) = Trial_start_time_run(g+1);
end

idx_stay_R          = find(unsuccess==0 & dist_from_center_x>=1);
idx_stay_L          = find(unsuccess==0 & dist_from_center_x<=1);
idx_uns_stay        = find(unsuccess~=0 & ~isnan(time_target_stim_appeared_run));


idx_break_reward_time_run = find(unsuccess~=0 & isnan(reward_time_run)); % find trials that broke after backRT_run and before reward_time_run
Original_reward_time_run(idx_break_reward_time_run) = reward_time_run(idx_break_reward_time_run); %setting the original values of the reward_time_run
idx_break_target_appeared = find(unsuccess~=0 & isnan(time_target_stim_appeared_run)); % find trials that broke after start_trial and before time_target_stim_appeared_run????????????????????????????????????????????????
Original_time_target_stim_appeared_run(idx_break_target_appeared) = time_target_stim_appeared_run(idx_break_target_appeared); % setting the original values of the time_target_stim_appeared_run



%% TARGET APPEARED UNTIL BACKRT (12 conditions)

% SUCCESS BACKRT (4 conditions)___________________________________________________________________________________________________________________________________________________________________________

% Success trials left hand left hemifield
if any(strcmp('SUC_STAY_R',{PRED(use_predictors).name}))    
    write_one_predictor_prt(fid,'SUC_STAY_R',round((time_target_stim_appeared_run(idx_stay_R)*data_factor))',round((time_target_stim_appeared_run(idx_stay_R)*data_factor))+650',PRED(1).col);    
end

% Success trials left hand left hemifield
if any(strcmp('SUC_STAY_L',{PRED(use_predictors).name}))    
    write_one_predictor_prt(fid,'SUC_STAY_L',round((time_target_stim_appeared_run(idx_stay_L)*data_factor))',round((time_target_stim_appeared_run(idx_stay_L)*data_factor))+650',PRED(2).col);    
end

% Success trials right hand left hemifield
if any(strcmp('UNSUC_STAY',{PRED(use_predictors).name}))    
    write_one_predictor_prt(fid,'UNSUC_STAY',round((time_target_stim_appeared_run(idx_uns_stay)*data_factor))',round((time_target_stim_appeared_run(idx_uns_stay)*data_factor))+650',PRED(3).col);    
end


%% BACKRT UNTIL REWARD (2 conditions)

reward_time_run(idx_break_reward_time_run) = Trial_finish_time_run(idx_break_reward_time_run); % replace NaN by Trial_finish_time_run
idx_suc_back = find(unsuccess==0); % stay cue there is no backRT

% SUCCESS BACKRT UNTIL REWARD (1 condition)___________________________________________________________________________________________________________________________________________________________________________

if any(strcmp('BACK TILL REWARD S',{PRED(use_predictors).name}))    
    write_one_predictor_prt(fid,'BACK TILL REWARD S',round((time_target_stim_appeared_run(idx_suc_back)*data_factor))+651',round((reward_time_run(idx_suc_back)*data_factor))-1',PRED(4).col);    
end

% UNSUCCESS BACKRT UNTIL REWARD (1 condition)_________________________________________________________________________________________________________________________________________________________________________

if any(strcmp('BACK TILL REWARD U',{PRED(use_predictors).name}))    
    write_one_predictor_prt(fid,'BACK TILL REWARD U',round((time_target_stim_appeared_run(idx_unsuc)*data_factor))+651',round((reward_time_run(idx_unsuc)*data_factor))-1',PRED(5).col);    
end

fclose(fid);

disp(['Protocol ' prt_fname ' saved']);

function write_one_predictor_prt(fid,pred_name,onsets,offsets,col)
fprintf(fid,'%s\n',pred_name);
fprintf(fid,'%d\n',length(onsets)); 

for rep = 1:length(onsets) % for each repetition of one condition
	fprintf(fid,' %d\t%d\n',onsets(rep), offsets(rep));
end

fprintf(fid,'Color: %d %d %d\n\n',col(1),col(2),col(3));
