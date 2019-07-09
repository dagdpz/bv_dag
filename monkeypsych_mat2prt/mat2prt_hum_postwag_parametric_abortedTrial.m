function prt_fname = mat2prt_hum_postwag_parametric_abortedTrial(mat_file, run_name)

%%% Set predictors and predictors time points for human experiments related to Wagering project
% 
% prt_fname = mat2prt_hum(mat_file, run_name)
% mat2prt_hum_postwag_parametric_abortedTrial('Z:\MRI\Human\PWD\Pilotstudy\ALKR\20150420\ALKR_2fMRI4_2015-04-20_01.mat','')

if nargin < 2,
    run_name = '';
end

[pathname,filename,ext] = fileparts(mat_file);
load('-mat', mat_file);

% LIST OF POTENTIAL PREDICTORS
PRED(1).name  = 'Fixation';                               PRED(1).col  = [204 0 204];
PRED(2).name  = 'Sample';                                 PRED(2).col  = [255 255 255]; 
PRED(3).name  = 'Diff';                                   PRED(3).col  = [255 255 0];
PRED(4).name  = 'postcontrol';                            PRED(4).col  = [0 255 0];
PRED(5).name  = 'postwager';                              PRED(5).col  = [0 0 255];

PRED(6).name  = 'abortedTrials_Hand';                     PRED(6).col  = [255 128 0]; % orange
PRED(7).name  = 'abortedTrials_Eye';                      PRED(7).col  = [204 0 204]; % purple

use_predictors = 1:7;
NrofPreds	=  length(use_predictors);

if isempty(run_name)
    prt_fname = [pathname filesep filename  '.prt'];
else
    prt_fname = [pathname filesep filename(1:end-2) run_name '_Parametric.prt'];    
end


fid = fopen(prt_fname,'w'); % open prt file ..

% fill prt header info:
fprintf(fid,'\n');% n goes to the next line
fprintf(fid,'FileVersion:\t%d\n\n',3);
fprintf(fid,'ResolutionOfTime:\t%s\n\n','msec');
fprintf(fid,'Experiment:\t%s\n\n',filename); % original mat filename
fprintf(fid,'BackgroundColor:\t%d %d %d\n',0,0,0);
fprintf(fid,'TextColor:\t%d %d %d\n',255,255,255);
fprintf(fid,'TimeCourseColor:\t%d %d %d\n',255,255,255);
fprintf(fid,'TimeCourseThick:\t%d\n',3);
fprintf(fid,'ReferenceFuncColor:\t%d %d %d\n',0,0,80);
fprintf(fid,'ReferenceFuncThick:\t%d\n',3);
fprintf(fid,'ParametricWeights:\t%d\n',3);
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

DifficultyLevel         = abs(sample - nonsample);

RT_HighvsLow_wagering2 = Wager_time_decided_highvslow_2_run - Wager_start_time_wagering2_run;
RT_wagering2           = Wager_time_decided_wagering2_run   - Wager_start_time_wagering2_run;
Duration_oneTrial =  Trial_finish_time_run - Trial_start_time_run; 


%% Indexes
data_factor = 1000;

Hand = (unsuccess == 1  | unsuccess == 3 | unsuccess == 4 | unsuccess == 5 | unsuccess == 7 | unsuccess == 8);    % 1- too slow, 3-5 both buttons, 7-8 false hand use, 9 not choosen the correct cue

idx_Fix_allFixEvents = find(isnan(time_sample_appeared_run) == 0 );

%idx_Sam = find(unsuccess == 0 | unsuccess==2);
idx_Sam_allSampleEvents = find(isnan(Time_subject_got_sample_run) == 0);

idx_Diff_allDiffEvents = find(isnan(time_match_to_sample_selected_run) == 0); 
idx_Diff  = find(isnan(time_match_to_sample_selected_run) == 0 & ( DifficultyLevel == 1 |  DifficultyLevel == 2 |  DifficultyLevel == 3 |  DifficultyLevel == 4 |  DifficultyLevel == 5));
idx_Diff1 = find(isnan(time_match_to_sample_selected_run) == 0 & DifficultyLevel == 1);
idx_Diff2 = find(isnan(time_match_to_sample_selected_run) == 0 & DifficultyLevel == 2);
idx_Diff3 = find(isnan(time_match_to_sample_selected_run) == 0 & DifficultyLevel == 3);
idx_Diff4 = find(isnan(time_match_to_sample_selected_run) == 0 & DifficultyLevel == 4);
idx_Diff5 = find(isnan(time_match_to_sample_selected_run) == 0 & DifficultyLevel == 5);

idx_postC = find(wagering_or_controll_wagering2 == 1 & (unsuccess == 0 | unsuccess==2));
idx_postC_allControlEvents = find(wagering_or_controll_wagering2 == 1  & isnan(Wager_time_decided_highvslow_2_run) == 0 ) ;    

idx_postwager = find(wagering_or_controll_wagering2== 0 &  (unsuccess == 0 | unsuccess==2));
idx_postwager_allWagerEvents = find(wagering_or_controll_wagering2 == 0  & isnan(Wager_time_decided_highvslow_2_run) == 0 ) ;               
              
idx_postwager1 = find(wagering_or_controll_wagering2== 0 &  (isnan(Wager_time_decided_highvslow_2_run)== 0) & wager_choosen == 1 );
idx_postwager2 = find(wagering_or_controll_wagering2== 0 &  (isnan(Wager_time_decided_highvslow_2_run)== 0) & wager_choosen == 2 );
idx_postwager3 = find(wagering_or_controll_wagering2== 0 &  (isnan(Wager_time_decided_highvslow_2_run)== 0) & wager_choosen == 3 );
idx_postwager4 = find(wagering_or_controll_wagering2== 0 &  (isnan(Wager_time_decided_highvslow_2_run)== 0) & wager_choosen == 4 );
idx_postwager5 = find(wagering_or_controll_wagering2== 0 &  (isnan(Wager_time_decided_highvslow_2_run)== 0) & wager_choosen == 5 );
idx_postwager6 = find(wagering_or_controll_wagering2== 0 &  (isnan(Wager_time_decided_highvslow_2_run)== 0) & wager_choosen == 6 );


%% Aborted Trials 
idx_abortedTrial_all = find(unsuccess ~= 0 & unsuccess ~= 2);    
idx_abortedTrial_Hand = find(Hand & unsuccess == 9);
idx_abortedTrial_Eye = find(unsuccess == 6);  %idx_abortedTrial_Control_Eye idx_abortedTrial_duringM2S_Eye



%% Vector containing the parametric wights

parametric_Weight_Fixation = ones(length(idx_Fix_allFixEvents), 1); 
parametric_Weight_Fixation_abortedTrial_Hand = ones(length(idx_abortedTrial_duringFixation_Hand), 1); 
parametric_Weight_Fixation_abortedTrial_Eye = ones(length(idx_abortedTrial_duringFixation_Eye), 1); 

parametric_Weight_Sample = ones(length(idx_Sam_allSampleEvents), 1); 
parametric_Weight_Control = ones(length(idx_postC_allControlEvents), 1); 
parametric_Weight_Diff_Constant =  ones(length(idx_Diff_allDiffEvents), 1); 


Diff = [idx_Diff1 idx_Diff2 idx_Diff3 idx_Diff4 idx_Diff5];
Diff_weight1 = repmat(1,length(idx_Diff1),1) ;
Diff_weight2 = repmat(2,length(idx_Diff2),1) ;
Diff_weight3 = repmat(3,length(idx_Diff3),1) ;
Diff_weight4 = repmat(4,length(idx_Diff4),1) ;
Diff_weight5 = repmat(5,length(idx_Diff5),1) ;

Diff_weight = [Diff_weight1 ; Diff_weight2 ; Diff_weight3; Diff_weight4; Diff_weight5]'; 
Diff(2,:) =  Diff_weight;
[r,t]= sort(Diff(1,:));
g = Diff(2,:); 
for j = 1:length(Diff(1,:))
   Diff(2,j) = g(1,t(1,j)); 
end
parametric_Weight_Diff = Diff(2,:); 


%% postwagering - parametric Modulation
parametric_Weight_postWag_abortedTrial_Hand =  ones(length(idx_abortedTrial_Wag_Hand), 1); 
parametric_Weight_postWag_abortedTrial_Eye =  ones(length(idx_abortedTrial_Wag_Eye), 1); 

%% regressor parametric modulation: RT
PostWag_RT =idx_postwager; 
PostWag_RT(2,:) = RT_HighvsLow_wagering2(idx_postwager);
parametric_Weight_wagerRT = PostWag_RT(2,:); 
%% regressor parametric modulation: linear

PostWag = [idx_postwager1 idx_postwager2 idx_postwager3 idx_postwager4 idx_postwager5 idx_postwager6];
postwager_weight1 = repmat(1,length(idx_postwager1),1) ;
postwager_weight2 = repmat(2,length(idx_postwager2),1) ;
postwager_weight3 = repmat(3,length(idx_postwager3),1) ;
postwager_weight4 = repmat(4,length(idx_postwager4),1) ;
postwager_weight5 = repmat(5,length(idx_postwager5),1) ;
postwager_weight6 = repmat(6,length(idx_postwager6),1) ;

postwager_weight = [postwager_weight1 ; postwager_weight2 ; postwager_weight3; postwager_weight4; postwager_weight5; postwager_weight6]'; 
PostWag(2,:) =  postwager_weight;
[r,t]= sort(PostWag(1,:));


s = PostWag(2,:); 
for j = 1:length(PostWag(1,:))
   PostWag(2,j) = s(1,t(1,j)); 
end

parametric_Weight_Wager_linear = PostWag(2,:); 



%% regressor parametric modulation. u-shaped

PostWag = [idx_postwager1 idx_postwager2 idx_postwager3 idx_postwager4 idx_postwager5 idx_postwager6];
postwager_weight1 = repmat(1,length(idx_postwager1),1) ;
postwager_weight2 = repmat(0.5,length(idx_postwager2),1) ;
postwager_weight3 = repmat(0.25,length(idx_postwager3),1) ;
postwager_weight4 = repmat(0.25,length(idx_postwager4),1) ;
postwager_weight5 = repmat(0.5,length(idx_postwager5),1) ;
postwager_weight6 = repmat(1,length(idx_postwager6),1) ;

postwager_weight = [postwager_weight1 ; postwager_weight2 ; postwager_weight3; postwager_weight4; postwager_weight5; postwager_weight6]'; 
PostWag(2,:) =  postwager_weight;
[r,t]= sort(PostWag(1,:));


s = PostWag(2,:); 
for j = 1:length(PostWag(1,:))
   PostWag(2,j) = s(1,t(1,j)); 
end

parametric_Weight_Wager_uShaped = PostWag(2,:); 

%% Timing of events
%% Fixation
if any(strcmp('Fixation',{PRED(use_predictors).name}))    
    write_four_predictor_prt(fid,'Fixation',round((Trial_start_time_run(idx_Fix_allFixEvents)*data_factor))',round((Trial_start_time_run(idx_Fix_allFixEvents)*data_factor) + 200)', parametric_Weight_Fixation',parametric_Weight_Fixation',parametric_Weight_Fixation', PRED(1).col);    
end

%% Sample
if any(strcmp('Sample',{PRED(use_predictors).name})) 
    write_four_predictor_prt(fid,'Sample',round((time_sample_appeared_run(idx_Sam_allSampleEvents)*data_factor))',round((Time_subject_got_sample_run(idx_Sam_allSampleEvents)*data_factor))',parametric_Weight_Sample',parametric_Weight_Sample',parametric_Weight_Sample', PRED(2).col);    
end

%% match-to-Sample: Difficulty
if any(strcmp('Diff',{PRED(use_predictors).name})) 
    write_four_predictor_prt(fid,'Diff',round((time_matchtosample_appeared_run(idx_Diff)*data_factor))',round((time_matchtosample_appeared_run(idx_Diff)*data_factor) + 1120)', parametric_Weight_Diff', parametric_Weight_Diff_Constant', parametric_Weight_Diff_Constant', PRED(3).col);    
end

%%  Post_control & Post-wagering 
if any(strcmp('postcontrol',{PRED(use_predictors).name}))    
    write_four_predictor_prt(fid,'postcontrol',round((Wager_start_time_wagering2_run (idx_postC)*data_factor))',round((Wager_start_time_wagering2_run(idx_postC)*data_factor) + 1600)',parametric_Weight_Control',parametric_Weight_Control',parametric_Weight_Control', PRED(4).col);    
end
% postwagering
if any(strcmp('postwager',{PRED(use_predictors).name}))    
    write_four_predictor_prt(fid,'postwager',round((Wager_start_time_wagering2_run(idx_postwager)*data_factor))',round((Wager_start_time_wagering2_run(idx_postwager)*data_factor)+1600)',parametric_Weight_wagerRT' ,parametric_Weight_Wager_linear', parametric_Weight_Wager_uShaped', PRED(5).col);    
end

%% aborted Trials

if any(strcmp('abortedTrials_Hand',{PRED(use_predictors).name}))    
    write_four_predictor_prt(fid,'abortedTrials_Hand',round((Trial_finish_time_run(idx_abortedTrial_Hand)*data_factor)-900)', round((Trial_finish_time_run(idx_abortedTrial_duringFixation_Hand)*data_factor))', parametric_Weight_Fixation_abortedTrial_Hand',parametric_Weight_Fixation_abortedTrial_Hand',parametric_Weight_Fixation_abortedTrial_Hand', PRED(6).col);    
end
if any(strcmp('abortedTrials_Eye',{PRED(use_predictors).name}))    
    write_four_predictor_prt(fid,'abortedTrials_Eye',round((Trial_finish_time_run(idx_abortedTrial_Eye)*data_factor)-900)',round((Trial_finish_time_run(idx_abortedTrial_duringFixation_Eye)*data_factor))', parametric_Weight_Fixation_abortedTrial_Eye',parametric_Weight_Fixation_abortedTrial_Eye',parametric_Weight_Fixation_abortedTrial_Eye', PRED(7).col);    
end


%%%%%%%%%%%%%%


fclose(fid);

disp(['Protocol ' prt_fname ' saved']);

function write_one_predictor_prt(fid,pred_name,onsets,offsets,parametric_Weight ,col)
fprintf(fid,'%s\n',pred_name);
fprintf(fid,'%d\n',length(onsets)); 
for rep = 1:length(onsets) % for each repetition of one condition
	fprintf(fid,' %d\t%d\t%d\n',onsets(rep), offsets(rep), parametric_Weight(rep));
end

fprintf(fid,'Color: %d %d %d\n\n',col(1),col(2),col(3));


function write_four_predictor_prt(fid,pred_name,onsets,offsets, regressor2, regressor3, regressor4 ,col)
fprintf(fid,'%s\n',pred_name);
fprintf(fid,'%d\n',length(onsets)); 

for rep = 1:length(onsets) % for each repetition of one condition
	fprintf(fid,' %d\t%d\t%d\t%d\t%d\n',onsets(rep), offsets(rep), regressor2(rep), regressor3(rep), regressor4(rep));
end

fprintf(fid,'Color: %d %d %d \n\n',col(1),col(2),col(3));
