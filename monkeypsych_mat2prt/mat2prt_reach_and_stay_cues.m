function prt_fname = mat2prt_reach_and_stay_cues(mat_file, run_name)

if nargin < 2,
    run_name = '';
end

[pathname,filename,ext] = fileparts(mat_file);

load('-mat', mat_file);

% LIST OF POTENTIAL PREDICTORS


PRED(1).name  = 'SUC_STAY_R';	        PRED(1).col  = [0 200 0];
PRED(2).name  = 'SUC_STAY_L';	        PRED(2).col  = [0 0 200];
PRED(3).name  = 'SUC_LL';               PRED(3).col  = [90 140 210];
PRED(4).name  = 'SUC_LR';               PRED(4).col  = [0 0 250];
PRED(5).name  = 'SUC_RL';               PRED(5).col  = [0 100 0];
PRED(6).name  = 'SUC_RR';               PRED(6).col  = [0 250 0];
PRED(7).name  = 'wr_hand_LL';           PRED(7).col  = [90 140 210];
PRED(8).name  = 'wr_hand_LR';           PRED(8).col  = [0 0 250];
PRED(9).name  = 'wr_hand_RL';           PRED(9).col  = [0 100 0];
PRED(10).name = 'wr_hand_RR';           PRED(10).col = [0 250 0];
PRED(11).name = 'UNSUC';                PRED(11).col =  [100 100 100];
PRED(12).name = 'REWARD';               PRED(12).col =  [255 255 0];


use_predictors = [1 2 3 4 5 6 7 8 9 10 11 12];
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
dist_from_center_x                = [trial.dist_from_center_x];
Trial_start_time_run              = [trial.Trial_start_time_run];
time_target_stim_appeared_run     = [trial.time_target_stim_appeared_run];
Trial_finish_time_run             = [trial.Trial_finish_time_run];
reward_time_run                   = [trial.reward_time_run];
wronghandrelease                  = [trial.wronghandrelease];

%% Indexes
data_factor = 1000;



for g= 1:(length(Trial)-1)
    Trial_restart_time_run(g) = Trial_start_time_run(g+1);
end


idx_suc_stay            = find(unsuccess==0);

idx_stay_R              = find(target==3 & unsuccess==0 & dist_from_center_x>=1);
idx_stay_L              = find(target==3 & unsuccess==0 & dist_from_center_x<=1);
idx_suc_LL              = find(unsuccess==0 & target==1 & dist_from_center_x<=-1);
idx_suc_LR              = find(unsuccess==0 & target==1 & dist_from_center_x>=1);
idx_suc_RL              = find(unsuccess==0 & target==2 & dist_from_center_x<=-1);
idx_suc_RR              = find(unsuccess==0 & target==2 & dist_from_center_x>=1);

idx_wr_hand_LL          = find(unsuccess==1 & target==1 & dist_from_center_x<=-1 & wronghandrelease ==2);
idx_wr_hand_LR          = find(unsuccess==1 & target==1 & dist_from_center_x>=1  & wronghandrelease ==2);
idx_wr_hand_RL          = find(unsuccess==2 & target==2 & dist_from_center_x<=-1 & wronghandrelease ==1);
idx_wr_hand_RR          = find(unsuccess==2 & target==2 & dist_from_center_x>=1  & wronghandrelease ==1);
idx_unsuc               = find(unsuccess~=0 & wronghandrelease ==0);

% Success trials right hemifield
if any(strcmp('SUC_STAY_R',{PRED(use_predictors).name}))    
    write_one_predictor_prt(fid,'SUC_STAY_R',round((time_target_stim_appeared_run(idx_stay_R)*data_factor))',round((time_target_stim_appeared_run(idx_stay_R)*data_factor))+650',PRED(1).col);    
end

% Success trials left hemifield
if any(strcmp('SUC_STAY_L',{PRED(use_predictors).name}))    
    write_one_predictor_prt(fid,'SUC_STAY_L',round((time_target_stim_appeared_run(idx_stay_L)*data_factor))',round((time_target_stim_appeared_run(idx_stay_L)*data_factor))+650',PRED(2).col);    
end

% Success trials left hemifield
if any(strcmp('SUC_LL',{PRED(use_predictors).name}))    
    write_one_predictor_prt(fid,'SUC_LL',round((time_target_stim_appeared_run(idx_suc_LL)*data_factor))',round((time_target_stim_appeared_run(idx_suc_LL)*data_factor))+900',PRED(3).col);    
end

% Success trials left hemifield
if any(strcmp('SUC_LR',{PRED(use_predictors).name}))    
    write_one_predictor_prt(fid,'SUC_LR',round((time_target_stim_appeared_run(idx_suc_LR)*data_factor))',round((time_target_stim_appeared_run(idx_suc_LR)*data_factor))+900',PRED(4).col);    
end

% Success trials left hemifield
if any(strcmp('SUC_RL',{PRED(use_predictors).name}))    
    write_one_predictor_prt(fid,'SUC_RL',round((time_target_stim_appeared_run(idx_suc_RL)*data_factor))',round((time_target_stim_appeared_run(idx_suc_RL)*data_factor))+900',PRED(5).col);    
end

% Success trials left hemifield
if any(strcmp('SUC_RR',{PRED(use_predictors).name}))    
    write_one_predictor_prt(fid,'SUC_RR',round((time_target_stim_appeared_run(idx_suc_RR)*data_factor))',round((time_target_stim_appeared_run(idx_suc_RR)*data_factor))+900',PRED(6).col);    
end

%%%%%%%%%%%%%%%

% Wrong hand trials left hemifield
if any(strcmp('wr_hand_LL',{PRED(use_predictors).name}))    
    write_one_predictor_prt(fid,'wr_hand_LL',round((time_target_stim_appeared_run(idx_wr_hand_LL)*data_factor))',round((time_target_stim_appeared_run(idx_wr_hand_LL)*data_factor))+900',PRED(7).col);    
end

% Wrong hand trials left hemifield
if any(strcmp('wr_hand_LR',{PRED(use_predictors).name}))    
    write_one_predictor_prt(fid,'wr_hand_LR',round((time_target_stim_appeared_run(idx_wr_hand_LR)*data_factor))',round((time_target_stim_appeared_run(idx_wr_hand_LR)*data_factor))+900',PRED(8).col);    
end

% Wrong hand trials left hemifield
if any(strcmp('wr_hand_RL',{PRED(use_predictors).name}))    
    write_one_predictor_prt(fid,'wr_hand_RL',round((time_target_stim_appeared_run(idx_wr_hand_RL)*data_factor))',round((time_target_stim_appeared_run(idx_wr_hand_RL)*data_factor))+900',PRED(9).col);    
end

% Wrong hand trials left hemifield
if any(strcmp('wr_hand_RR',{PRED(use_predictors).name}))    
    write_one_predictor_prt(fid,'wr_hand_RR',round((time_target_stim_appeared_run(idx_wr_hand_RR)*data_factor))',round((time_target_stim_appeared_run(idx_wr_hand_RR)*data_factor))+900',PRED(10).col);    
end

% Unsuccess trials
if any(strcmp('UNSUC',{PRED(use_predictors).name}))    
    write_one_predictor_prt(fid,'UNSUC',round((Trial_finish_time_run(idx_unsuc)*data_factor))-400',round((Trial_finish_time_run(idx_unsuc)*data_factor))',PRED(11).col);    
end

% Reward
if any(strcmp('REWARD',{PRED(use_predictors).name}))    
    write_one_predictor_prt(fid,'REWARD',round((reward_time_run(idx_suc_stay)*data_factor))-200',round((reward_time_run(idx_suc_stay)*data_factor))+200',PRED(12).col);    
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
