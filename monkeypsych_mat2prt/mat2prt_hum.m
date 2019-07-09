function prt_fname = mat2prt_hum(mat_file, run_name)

%%% Set predictors and predictors time points for monkey experiments related to Action Selection and Poffenberger Paradigm

if nargin < 2,
    run_name = '';
end

[pathname,filename,ext] = fileparts(mat_file);

load('-mat', mat_file);

% LIST OF POTENTIAL PREDICTORS

PRED(1).name  = 'TAR_BACK_SLL';         PRED(1).col  = [90 140 210];
PRED(2).name  = 'TAR_BACK_SLR';         PRED(2).col  = [0 0 250];
PRED(3).name  = 'TAR_BACK_SRL';         PRED(3).col  = [0 100 0];
PRED(4).name  = 'TAR_BACK_SRR';         PRED(4).col  = [0 250 0];
PRED(5).name  = 'TAR_BACK_WLL';         PRED(5).col  = [90 140 210];
PRED(6).name  = 'TAR_BACK_WLR';         PRED(6).col  = [0 0 250];
PRED(7).name  = 'TAR_BACK_WRL';         PRED(7).col  = [0 100 0];
PRED(8).name  = 'TAR_BACK_WRR';         PRED(8).col  = [0 250 0];
PRED(9).name  = 'Generic_unsuccess';    PRED(9).col  =  [100 100 100];
PRED(10).name = 'REWARD';               PRED(10).col =  [255 255 0];


use_predictors = [1 2 3 4 5 6 7 8 9];
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

idx_suc            = find(unsuccess==0);

idx_suc_LL              = find(unsuccess==0 & target==1 & dist_from_center_x<=-1);
idx_suc_LR              = find(unsuccess==0 & target==1 & dist_from_center_x>=1);
idx_suc_RL              = find(unsuccess==0 & target==2 & dist_from_center_x<=-1);
idx_suc_RR              = find(unsuccess==0 & target==2 & dist_from_center_x>=1);

idx_wr_hand_LL          = find(unsuccess==1 & target==1 & dist_from_center_x<=-1 & wronghandrelease ==2);
idx_wr_hand_LR          = find(unsuccess==1 & target==1 & dist_from_center_x>=1  & wronghandrelease ==2);
idx_wr_hand_RL          = find(unsuccess==2 & target==2 & dist_from_center_x<=-1 & wronghandrelease ==1);
idx_wr_hand_RR          = find(unsuccess==2 & target==2 & dist_from_center_x>=1  & wronghandrelease ==1);
idx_unsuc               = find(unsuccess~=0 & wronghandrelease ==0);

% Success trials left hemifield
if any(strcmp('TAR_BACK_SLL',{PRED(use_predictors).name}))    
    write_one_predictor_prt(fid,'TAR_BACK_SLL',round((time_target_stim_appeared_run(idx_suc_LL)*data_factor))',round((time_target_stim_appeared_run(idx_suc_LL)*data_factor))+900',PRED(1).col);    
end

% Success trials left hemifield
if any(strcmp('TAR_BACK_SLR',{PRED(use_predictors).name}))    
    write_one_predictor_prt(fid,'TAR_BACK_SLR',round((time_target_stim_appeared_run(idx_suc_LR)*data_factor))',round((time_target_stim_appeared_run(idx_suc_LR)*data_factor))+900',PRED(2).col);    
end

% Success trials left hemifield
if any(strcmp('TAR_BACK_SRL',{PRED(use_predictors).name}))    
    write_one_predictor_prt(fid,'TAR_BACK_SRL',round((time_target_stim_appeared_run(idx_suc_RL)*data_factor))',round((time_target_stim_appeared_run(idx_suc_RL)*data_factor))+900',PRED(3).col);    
end

% Success trials left hemifield
if any(strcmp('TAR_BACK_SRR',{PRED(use_predictors).name}))    
    write_one_predictor_prt(fid,'TAR_BACK_SRR',round((time_target_stim_appeared_run(idx_suc_RR)*data_factor))',round((time_target_stim_appeared_run(idx_suc_RR)*data_factor))+900',PRED(4).col);    
end

%%%%%%%%%%%%%%%

% Wrong hand trials left hemifield
if any(strcmp('TAR_BACK_WLL',{PRED(use_predictors).name}))    
    write_one_predictor_prt(fid,'TAR_BACK_WLL',round((time_target_stim_appeared_run(idx_wr_hand_LL)*data_factor))',round((time_target_stim_appeared_run(idx_wr_hand_LL)*data_factor))+900',PRED(5).col);    
end

% Wrong hand trials left hemifield
if any(strcmp('TAR_BACK_WLR',{PRED(use_predictors).name}))    
    write_one_predictor_prt(fid,'TAR_BACK_WLR',round((time_target_stim_appeared_run(idx_wr_hand_LR)*data_factor))',round((time_target_stim_appeared_run(idx_wr_hand_LR)*data_factor))+900',PRED(6).col);    
end

% Wrong hand trials left hemifield
if any(strcmp('TAR_BACK_WRL',{PRED(use_predictors).name}))    
    write_one_predictor_prt(fid,'TAR_BACK_WRL',round((time_target_stim_appeared_run(idx_wr_hand_RL)*data_factor))',round((time_target_stim_appeared_run(idx_wr_hand_RL)*data_factor))+900',PRED(7).col);    
end

% Wrong hand trials left hemifield
if any(strcmp('TAR_BACK_WRR',{PRED(use_predictors).name}))    
    write_one_predictor_prt(fid,'TAR_BACK_WRR',round((time_target_stim_appeared_run(idx_wr_hand_RR)*data_factor))',round((time_target_stim_appeared_run(idx_wr_hand_RR)*data_factor))+900',PRED(8).col);    
end

% Unsuccess trials
if any(strcmp('Generic_unsuccess',{PRED(use_predictors).name}))    
    write_one_predictor_prt(fid,'Generic_unsuccess',round((Trial_finish_time_run(idx_unsuc)*data_factor))-400',round((Trial_finish_time_run(idx_unsuc)*data_factor))',PRED(9).col);    
end

% Reward
if any(strcmp('REWARD',{PRED(use_predictors).name}))    
    write_one_predictor_prt(fid,'REWARD',round((reward_time_run(idx_suc)*data_factor))-200',round((reward_time_run(idx_suc)*data_factor))+200',PRED(10).col);    
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
