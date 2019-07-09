function prt_fname = mat2prt_hum_postwag_allLevels(mat_file, run_name)

%%% Set predictors and predictors time points for human experiments related to Wagering project
% 
% prt_fname = mat2prt_hum(mat_file, run_name)
% mat2prt_hum_postwag('Z:\MRI\Human\PWD\RIIN\20150412\RIIN_fMRI1_2015-04-12_01.mat','')

if nargin < 2,
    run_name = '';
end

[pathname,filename,ext] = fileparts(mat_file);

load('-mat', mat_file);

% LIST OF POTENTIAL PREDICTORS
PRED(1).name  = 'Fixation';     PRED(1).col  = [204 0 204];
PRED(2).name  = 'Sample';       PRED(2).col  = [255 255 255]; % white
PRED(3).name  = 'succ';         PRED(3).col  = [0 255 0]; %green
PRED(4).name  = 'unsucc';       PRED(4).col  = [255 0 0]; %red
PRED(5).name  = 'Diff1';         PRED(5).col  = [153 0 0]; % dark red
PRED(6).name  = 'Diff2';         PRED(6).col  = [255 136 0];% orange
PRED(7).name  = 'Diff3';         PRED(7).col  = [255 255 0];% yellow
PRED(8).name  = 'Diff4';         PRED(8).col  = [55 255 51];% light green
PRED(9).name  = 'Diff5';         PRED(9).col  = [0 153 100];% dark green

PRED(10).name  = 'postcontrol';       PRED(10).col  = [153 76 0]; % brown

PRED(11).name  = 'postwager1';         PRED(11).col  = [250 0 0]; %red
PRED(12).name  = 'postwager2';         PRED(12).col  = [120 0 0]; % purple
PRED(13).name  = 'postwager3';         PRED(13).col  = [ 80 0 0]; % pink
PRED(14).name  = 'postwager4';         PRED(14).col  = [0 80 0]; % light blue
PRED(15).name  = 'postwager5';         PRED(15).col  = [0 120 0]; % blue
PRED(16).name  = 'postwager6';         PRED(16).col  = [0 255 0]; % dark blue

% further predictors with success_wager

use_predictors = 1:16;
NrofPreds	=  length(use_predictors);

if isempty(run_name)
    prt_fname = [pathname filesep filename  '.prt'];
else
    prt_fname = [pathname filesep filename(1:end-2) run_name '.prt'];    
end


fid = fopen(prt_fname,'w'); % open prt file ..

% fill prt header info:
fprintf(fid,'\n');% n goes to the next line
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


Trial                          = [trial.Trial];
unsuccess                      = [trial.unsuccess];
sample                         = [trial.sample];
nonsample                      = [trial.nonsample];
value_choosen                  = [trial.value_choosen];% money value
wager_choosen                  = [trial.wager_choosen];
wagering_or_controll_wagering2 = [trial.wagering_or_controll_wagering2]; % 0 = wager, 1 = control
right_match_to_sample          = [trial.right_match_to_sample]; % 1 = right, 0 = left
high_wager_right_post          = [trial.high_wager_right_post]; % wager_high is right = 1, wager_low is right = 0
instructed_cue                 = [trial.instructed_cue]; 

Trial_start_time_run                 = [trial.Trial_start_time_run];
time_sample_appeared_run             = [trial.time_sample_appeared_run];
Time_subject_got_sample_run          = [trial.Time_subject_got_sample_run];
time_matchtosample_appeared_run      = [trial.time_matchtosample_appeared_run] ;              
time_match_to_sample_selected_run    = [trial.time_match_to_sample_selected_run];
Wager_start_time_wagering2_run       = [trial.Wager_start_time_wagering2_run] ;
Wager_time_decided_highvslow_2_run   = [trial.Wager_time_decided_highvslow_2_run];
Wager_time_decided_wagering2_run     = [trial.Wager_time_decided_wagering2_run];
Trial_finish_time_run                = [trial.Trial_finish_time_run] ;

RT_HighvsLow_wagering2 = Wager_time_decided_highvslow_2_run - Wager_start_time_wagering2_run;
RT_wagering2           = Wager_time_decided_wagering2_run   - Wager_start_time_wagering2_run;
DifficultyLevel         = abs(sample - nonsample);

%% Indexes
data_factor = 1000;
idx_Fix_allFixEvents = find(isnan(time_sample_appeared_run) == 0 ); 
idx_Sam_allSampleEvents = find(isnan(Time_subject_got_sample_run) == 0); 

idx_suc       = find(unsuccess == 0);
idx_unsuc     = find(unsuccess == 2);
idx_Diff  = find(isnan(time_match_to_sample_selected_run) == 0 & ( DifficultyLevel == 1 |  DifficultyLevel == 2 |  DifficultyLevel == 3 |  DifficultyLevel == 4 |  DifficultyLevel == 5));
idx_Diff1 = find(isnan(time_match_to_sample_selected_run) == 0 & DifficultyLevel == 1);
idx_Diff2 = find(isnan(time_match_to_sample_selected_run) == 0 & DifficultyLevel == 2);
idx_Diff3 = find(isnan(time_match_to_sample_selected_run) == 0 & DifficultyLevel == 3);
idx_Diff4 = find(isnan(time_match_to_sample_selected_run) == 0 & DifficultyLevel == 4);
idx_Diff5 = find(isnan(time_match_to_sample_selected_run) == 0 & DifficultyLevel == 5);


idx_postC_allControlEvents = find(wagering_or_controll_wagering2 == 1  & isnan(Wager_time_decided_wagering2_run) == 0 ) ;    

idx_postwager_allWagerEvents = find(wagering_or_controll_wagering2 == 0  & isnan(Wager_time_decided_wagering2_run) == 0 ) ;               
           
idx_postwager1 = find(wagering_or_controll_wagering2== 0 &  (isnan(Wager_time_decided_wagering2_run)== 0) & wager_choosen == 1 );
idx_postwager2 = find(wagering_or_controll_wagering2== 0 &  (isnan(Wager_time_decided_wagering2_run)== 0) & wager_choosen == 2 );
idx_postwager3 = find(wagering_or_controll_wagering2== 0 &  (isnan(Wager_time_decided_wagering2_run)== 0) & wager_choosen == 3 );
idx_postwager4 = find(wagering_or_controll_wagering2== 0 &  (isnan(Wager_time_decided_wagering2_run)== 0) & wager_choosen == 4 );
idx_postwager5 = find(wagering_or_controll_wagering2== 0 &  (isnan(Wager_time_decided_wagering2_run)== 0) & wager_choosen == 5 );
idx_postwager6 = find(wagering_or_controll_wagering2== 0 &  (isnan(Wager_time_decided_wagering2_run)== 0) & wager_choosen == 6 );
                  

%% Fixation
if any(strcmp('Fixation',{PRED(use_predictors).name}))    
    write_one_predictor_prt(fid,'Fixation',round((Trial_start_time_run(idx_Fix_allFixEvents)*data_factor))',round((Trial_start_time_run(idx_Fix_allFixEvents)*data_factor) + 200)', PRED(1).col);    
end

%% DifficultyLevel .. match-to-sample
%Success trials for Difficulty 1
if any(strcmp('Sample',{PRED(use_predictors).name})) 
    write_one_predictor_prt(fid,'Sample',round((time_sample_appeared_run(idx_Sam_allSampleEvents)*data_factor))',round((Time_subject_got_sample_run(idx_Sam_allSampleEvents)*data_factor))',PRED(2).col);    
end


if any(strcmp('succ',{PRED(use_predictors).name})) 
    write_one_predictor_prt(fid,'succ',round((time_matchtosample_appeared_run (idx_suc)*data_factor))',round((time_matchtosample_appeared_run(idx_suc)*data_factor) + 1120)',PRED(3).col);    
end

if any(strcmp('unsucc',{PRED(use_predictors).name})) 
    write_one_predictor_prt(fid,'unsucc',round((time_matchtosample_appeared_run (idx_unsuc)*data_factor))',round((time_matchtosample_appeared_run(idx_unsuc)*data_factor) + 1120)',PRED(4).col);    
end

% Difficulty 1
if any(strcmp('Diff1',{PRED(use_predictors).name})) 
    write_one_predictor_prt(fid,'Diff1',round((time_matchtosample_appeared_run (idx_Diff1)*data_factor))',round((time_matchtosample_appeared_run(idx_Diff1)*data_factor) + 1120)',PRED(5).col);    
end
%Difficulty 2
if any(strcmp('Diff2',{PRED(use_predictors).name})) 
    write_one_predictor_prt(fid,'Diff2',round((time_matchtosample_appeared_run (idx_Diff2)*data_factor))',round((time_matchtosample_appeared_run(idx_Diff2)*data_factor) + 1120)',PRED(6).col);    
end
%Difficulty 3
if any(strcmp('Diff3',{PRED(use_predictors).name})) 
    write_one_predictor_prt(fid,'Diff3',round((time_matchtosample_appeared_run (idx_Diff3)*data_factor))',round((time_matchtosample_appeared_run(idx_Diff3)*data_factor) + 1120)',PRED(7).col);    
end
%Difficulty 4
if any(strcmp('Diff4',{PRED(use_predictors).name})) 
    write_one_predictor_prt(fid,'Diff4',round((time_matchtosample_appeared_run (idx_Diff4)*data_factor))',round((time_matchtosample_appeared_run(idx_Diff4)*data_factor) + 1120)',PRED(8).col);    
end
%Difficulty 5
if any(strcmp('Diff5',{PRED(use_predictors).name})) 
    write_one_predictor_prt(fid,'Diff5',round((time_matchtosample_appeared_run (idx_Diff5)*data_factor))',round((time_matchtosample_appeared_run(idx_Diff5)*data_factor) + 1120)',PRED(9).col);    
end

%%  Post_control & Post-wagering 
if any(strcmp('postcontrol',{PRED(use_predictors).name}))    
    write_one_predictor_prt(fid,'postcontrol',round((Wager_start_time_wagering2_run(idx_postC_allControlEvents)*data_factor))',round((Wager_start_time_wagering2_run(idx_postC_allControlEvents)*data_factor)+1600)',PRED(10).col);    
end

%% postwagering
if any(strcmp('postwager1',{PRED(use_predictors).name}))    
    write_one_predictor_prt(fid,'postwager1',round((Wager_start_time_wagering2_run (idx_postwager1)*data_factor))',round((Wager_start_time_wagering2_run(idx_postwager1 )*data_factor) +1600)',PRED(11).col);    
end
if any(strcmp('postwager2',{PRED(use_predictors).name}))    
    write_one_predictor_prt(fid,'postwager2',round((Wager_start_time_wagering2_run (idx_postwager2)*data_factor))',round((Wager_start_time_wagering2_run(idx_postwager2)*data_factor) +1600)',PRED(12).col);    
end
if any(strcmp('postwager3',{PRED(use_predictors).name}))    
    write_one_predictor_prt(fid,'postwager3',round((Wager_start_time_wagering2_run (idx_postwager3)*data_factor))',round((Wager_start_time_wagering2_run(idx_postwager3)*data_factor) +1600)',PRED(13).col);    
end
if any(strcmp('postwager4',{PRED(use_predictors).name}))    
    write_one_predictor_prt(fid,'postwager4',round((Wager_start_time_wagering2_run (idx_postwager4)*data_factor))',round((Wager_start_time_wagering2_run(idx_postwager4)*data_factor) +1600)',PRED(14).col);    
end
if any(strcmp('postwager5',{PRED(use_predictors).name}))    
    write_one_predictor_prt(fid,'postwager5',round((Wager_start_time_wagering2_run (idx_postwager5)*data_factor))',round((Wager_start_time_wagering2_run(idx_postwager5)*data_factor)+1600)',PRED(15).col);    
end
if any(strcmp('postwager6',{PRED(use_predictors).name}))    
    write_one_predictor_prt(fid,'postwager6',round((Wager_start_time_wagering2_run (idx_postwager6)*data_factor))',round((Wager_start_time_wagering2_run(idx_postwager6)*data_factor)+ 1600)',PRED(16).col);    
end

%%%%%%%%%%%%%%


fclose(fid);

disp(['Protocol ' prt_fname ' saved']);

function write_one_predictor_prt(fid,pred_name,onsets,offsets,col)
fprintf(fid,'%s\n',pred_name);
fprintf(fid,'%d\n',length(onsets)); 

for rep = 1:length(onsets) % for each repetition of one condition
	fprintf(fid,' %d\t%d\n',onsets(rep), offsets(rep));
end

fprintf(fid,'Color: %d %d %d\n\n',col(1),col(2),col(3));
