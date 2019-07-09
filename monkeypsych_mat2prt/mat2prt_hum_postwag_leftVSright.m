function prt_fname = mat2prt_hum_postwag_leftVSright(mat_file, run_name)

%%% Set predictors and predictors time points for human experiments related to Wagering project
% 
% prt_fname = mat2prt_hum(mat_file, run_name)
% mat2prt_hum_postwag_leftVSright('Z:\MRI\Human\PWD\ALKR\20150410\SeperationForHands\ALKR_fMRI2_2015-04-10_02.mat','')

if nargin < 2,
    run_name = '';
end

[pathname,filename,ext] = fileparts(mat_file);

load('-mat', mat_file);

% LIST OF POTENTIAL PREDICTORS

PRED(1).name   = 'DL_WL';           PRED(1).col  = [0 0 255];
PRED(2).name   = 'DR_WR';           PRED(2).col  = [0 255 0];
PRED(3).name   = 'DL_WR';           PRED(3).col  = [255 255 0];
PRED(4).name   = 'DR_WL';           PRED(4).col  = [255 0 0];
%PRED(5).name   = 'abortedHand';     PRED(5).col  = [255 153 255];
%PRED(6).name   = 'abortedEye';      PRED(6).col  = [153 255 255];


use_predictors = 1:4;
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
right_match_to_sample          = [trial.right_match_to_sample]; %% which had were used for  1 = right, 0 = left
ms_side                        = [trial.ms_side];  %where the match-to-sample is presented:ms_side == 1
high_wager_right_post          = [trial.high_wager_right_post]; % wager_high is right = 1, wager_low is right = 0
instructed_cue                 = [trial.instructed_cue];
% side_low_wager                 = [trial.side_low_wager]; % side_low_wager == 3, means that the low wagers are presented on the right side  , 1- low wager on the left side    

Trial_start_time_run                 = [trial.Trial_start_time_run];
time_sample_appeared_run             = [trial.time_sample_appeared_run];
Time_subject_got_sample_run          = [trial.Time_subject_got_sample_run];
time_matchtosample_appeared_run      = [trial.time_matchtosample_appeared_run] ;              
time_match_to_sample_selected_run    = [trial.time_match_to_sample_selected_run];
Wager_start_time_wagering2_run       = [trial.Wager_start_time_wagering2_run] ;
Wager_time_decided_highvslow_2_run   = [trial.Wager_time_decided_highvslow_2_run];
Wager_time_decided_wagering2_run     = [trial.Wager_time_decided_wagering2_run];
Trial_finish_time_run                = [trial.Trial_finish_time_run] ;


DifficultyLevel         = abs(sample - nonsample);

%% Indexes
data_factor = 1000;

Hand = (unsuccess == 1  | unsuccess == 3 | unsuccess == 4 | unsuccess == 5 | unsuccess == 7 | unsuccess == 8);    % 1- too slow, 3-5 both buttons, 7-8 false hand use, 9 not choosen the correct cue

idx_abortedTrial__Hand =  find(isnan(Trial_finish_time_run)& Hand); 
idx_abortedTrial_Eye =  find(isnan(Trial_finish_time_run) & unsuccess == 6 ); 

idx_WR = (high_wager_right_post == 1 & (wager_choosen == 4 | wager_choosen == 5 | wager_choosen == 6))|...
    (high_wager_right_post == 0 & (wager_choosen == 1 | wager_choosen == 2 | wager_choosen == 3));

idx_WL = ((high_wager_right_post == 1 & (wager_choosen == 1 | wager_choosen == 2 | wager_choosen == 3)) |...
    (high_wager_right_post == 0 & (wager_choosen == 4 | wager_choosen == 5 | wager_choosen == 6)));


idx_DL_WL = find((unsuccess == 0 | unsuccess==2) & right_match_to_sample == 0 & idx_WL);
idx_DR_WR = find((unsuccess == 0 | unsuccess==2) & right_match_to_sample == 1 & idx_WR);
idx_DL_WR = find((unsuccess == 0 | unsuccess==2) & right_match_to_sample == 0 & idx_WR);
idx_DR_WL = find((unsuccess == 0 | unsuccess==2) & right_match_to_sample == 1 & idx_WL);


%% Sample

if any(strcmp('DL_WL',{PRED(use_predictors).name})) 
    write_one_predictor_prt(fid,'DL_WL',round((time_matchtosample_appeared_run(idx_DL_WL)*data_factor))',round((time_matchtosample_appeared_run(idx_DL_WL)*data_factor) + 1120)',PRED(1).col);    
end

if any(strcmp('DR_WR',{PRED(use_predictors).name})) 
    write_one_predictor_prt(fid,'DR_WR',round((time_matchtosample_appeared_run(idx_DR_WR)*data_factor))',round((time_matchtosample_appeared_run(idx_DR_WR)*data_factor) + 1120)',PRED(2).col);    
end

if any(strcmp('DL_WR',{PRED(use_predictors).name})) 
    write_one_predictor_prt(fid,'DL_WR',round((time_matchtosample_appeared_run(idx_DL_WR)*data_factor))',round((time_matchtosample_appeared_run(idx_DL_WR)*data_factor) + 1120)',PRED(3).col);    
end

if any(strcmp('DR_WL',{PRED(use_predictors).name}))    
    write_one_predictor_prt(fid,'DR_WL',round((time_matchtosample_appeared_run(idx_DR_WL)*data_factor))',round((time_matchtosample_appeared_run(idx_DR_WL)*data_factor) + 1120)',PRED(4).col);    
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
