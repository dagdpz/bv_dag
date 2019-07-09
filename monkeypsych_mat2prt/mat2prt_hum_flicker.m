function prt_fname = mat2prt_hum_flicker(mat_file, run_name)
 % updated 20150311
%%% Set predictors and predictors time points for monkey experiments related to Action Selection and Poffenberger Paradigm
% mat2prt_hum_flicker('C:\Users\kkaduk\Desktop\Kristin\KK_flicker_2015-02-27_03.mat','')
% mat2prt_hum_flicker('Z:\Kristin\Wagering\program_flicker\KK_flicker_2015-02-27_03.mat','')
% mat2prt_hum_flicker('Z:\MRI\Human\Flickering\EVPO\20150311\EVPO1_2015-03-11_01.mat','')


if nargin < 2,
    run_name = '';
end

[pathname,filename,ext] = fileparts(mat_file);

load('-mat', mat_file);

% LIST OF POTENTIAL PREDICTORS

% Blocked
PRED(1).name  = 'Success_Baseline';        PRED(1).col  = [255 255 255]; % white
PRED(2).name  = 'Success_Central';         PRED(2).col  = [255 255 0]; % yellow
PRED(3).name  = 'Success_Right';           PRED(3).col  = [0 255 0]; % green
PRED(4).name  = 'Success_Left';            PRED(4).col  = [0 0 250]; % blue
PRED(5).name  = 'Success_Both';            PRED(5).col  = [250 0 0]; % red
PRED(6).name  = 'Unsuccess';               PRED(6).col  = [100 100 100]; %gray

use_predictors = [1 2 3 4 5 6];
NrofPreds	=  length(use_predictors);

if isempty(run_name)
    prt_fname = [pathname  filesep filename  '.prt'];
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
success                           = [trial.success];
Cue                               = [trial.cue];
RunStartTime                      = [trial.RunStartTime];
RunFinishTime                     = [trial.RunFinishTime];
TrialStartTime                    = [trial.TrialStartTime];
start_time_baseline_run           = [trial.start_time_baseline_run];
finish_time_baseline_run          = [trial.finish_time_baseline_run]; 
start_time_cue_run                = [trial.start_time_cue_run];
finish_time_cue_run               = [trial.finish_time_cue_run];
grac_time                         = 0.4;

%% Indexes
data_factor = 1000;
idx_suc_Baseline         = find(success==1);
idx_suc_Central          = find(success==1 & Cue==1 );
idx_suc_Right            = find(success==1 & Cue==2 );
idx_suc_Left             = find(success==1 & Cue==3 );
idx_suc_Both             = find(success==1 & Cue==4 );
idx_unsuc                = find(success==0);

% Success trials baseline
if any(strcmp('Success_Baseline',{PRED(use_predictors).name}))    
    write_one_predictor_prt(fid,'Success_Baseline',round((start_time_baseline_run(idx_suc_Baseline)*data_factor))',round((finish_time_baseline_run(idx_suc_Baseline )*data_factor))',PRED(1).col);    
end

% Success trials Cue in central position
if any(strcmp('Success_Central',{PRED(use_predictors).name}))    
    write_one_predictor_prt(fid,'Success_Central',round((start_time_cue_run(idx_suc_Central )*data_factor))',round((finish_time_cue_run(idx_suc_Central)*data_factor))',PRED(2).col);    
end

% Success trials Cue in left position
if any(strcmp('Success_Left',{PRED(use_predictors).name}))    
    write_one_predictor_prt(fid,'Success_Left',round((start_time_cue_run(idx_suc_Left )*data_factor))',round((finish_time_cue_run  (idx_suc_Left )*data_factor))',PRED(4).col);    
end

% Success trials Cue in Right position
if any(strcmp('Success_Right',{PRED(use_predictors).name}))    
    write_one_predictor_prt(fid,'Success_Right',round((start_time_cue_run(idx_suc_Right)*data_factor))',round((finish_time_cue_run(idx_suc_Right)*data_factor))',PRED(3).col);    
end

if any(strcmp('Success_Both',{PRED(use_predictors).name}))    
    write_one_predictor_prt(fid,'Success_Both',round((start_time_cue_run(idx_suc_Both)*data_factor))',round(((finish_time_cue_run(idx_suc_Both)) *data_factor))',PRED(5).col);    
end
% Unsuccess trials 
if any(strcmp('Unsuccess',{PRED(use_predictors).name}))    
    write_one_predictor_prt(fid,'Unsuccess',round((TrialStartTime(idx_unsuc)*data_factor))',round(((RunFinishTime(idx_unsuc)) *data_factor))',PRED(6).col);    
end

%%%%%%%%%%%%%%%


fclose(fid);

disp(['Protocol ' prt_fname ' saved']);

function write_one_predictor_prt(fid,pred_name,onsets,offsets,col)
fprintf(fid,'%s\n',pred_name);
fprintf(fid,'%d\n',length(onsets)); 

for rep = 1:length(onsets) % for each repetition of one condition
	fprintf(fid,' %d\t%d\n',onsets(rep), offsets(rep));
end

fprintf(fid,'Color: %d %d %d\n\n',col(1),col(2),col(3));
