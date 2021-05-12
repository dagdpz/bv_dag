function tt = ne_era_frd_periods_average
%function tt = ne_era_frd_periods_average(era_files,windows,windows_name,end_aligned,save_path)

era_files = {...
    'Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI\ANEL\mat2prt_reach_decision_vardelay_foravg\ANEL_era_cue_9_lh_no_outliers.mat';...
    'Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI\ANEL\mat2prt_reach_decision_vardelay_foravg\ANEL_era_cue_12_lh_no_outliers.mat';...
    'Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI\ANEL\mat2prt_reach_decision_vardelay_foravg\ANEL_era_cue_15_lh_no_outliers.mat'};
windows = [ 4    7; 
           -2 -0.5];% delay 9 -->  [7 8.5]
windows_name = {'early','late'};
end_aligned= [0 1]; % if 0 it counts backwards from last entry of era.timeaxis

%%
tc = load(era_files{1}); 

for e = 2:length(era_files) % load and concetanate other files
   ttt = load(era_files{e}); 
   tc(e) = ttt;
end

for e = 1:length(era_files)
    [~, fname, ~ ] = fileparts(era_files{e});
    prtz = strsplit(fname,'_');
    tc(e).subj = prtz{1};
    tc(e).del = prtz{4};
    tc(e).raw_le = size(tc(e).era.psc(1,1).perievents,1);
end

%%
tt = table();
id_counter = 0;
for v = 1:size(tc(1).era.mean,1) % loop over VIOs

    voi_name = tc(1).era.voi(v).Name;
    
    for d = 1:length(tc) % loop over era files
     
        for c = 1:size(tc(d).era.mean,2) % loop over curve
            
            for w = 1:length(windows_name)
                
                if logical(end_aligned(w)) == 0
                    win_start = windows(w,1);
                    win_end   = windows(w,2);
                elseif logical(end_aligned(w)) == 1
                    win_start = tc(d).era.timeaxis(end) + windows(w,1);
                    win_end   = tc(d).era.timeaxis(end) + windows(w,2);
                end
                
                idx = tc(d).era.timeaxis >= win_start & tc(d).era.timeaxis < win_end;
                
                temp = table();
                
                temp.mean  = mean(tc(d).era.psc(v,c).perievents(idx,:),1)';
                temp.period = repmat(windows_name(w), length(temp.mean),1); 
  
                name_parts = strsplit(tc(d).era.avg.Curve(c).Name,'_');
                
                cond = [name_parts{1} '_' name_parts{2} '_' name_parts{3} '_' name_parts{4}];     
                temp.cond = repmat({cond},length(temp.mean),1);
                temp.eff  = repmat({name_parts{1}}, length(temp.mean),1);
                temp.choi = repmat({name_parts{2}}, length(temp.mean),1);
                temp.side = repmat({name_parts{3}}, length(temp.mean),1);                
                temp.delay = repmat({name_parts{4}}, length(temp.mean),1);  
                
                temp.subj = repmat({tc(d).subj}, length(temp.mean),1);  
                temp.voi = repmat(voi_name, length(temp.mean),1);         
                
                trial_id =  (1:length(temp.mean)) + id_counter;
                temp.trial_id = trial_id';
                
                if w == 2
                    if ~isempty(trial_id)
                        id_counter = trial_id(end);
                    end
                end
                
                tt = [tt; temp];
                
  
                
            end
        end
    end % loop over era files
    
    tt.period = categorical(tt.period);
    tt.cond = categorical(tt.cond);
    tt.eff = categorical(tt.eff);
    tt.choi = categorical(tt.choi);
    tt.side = categorical(tt.side);
    tt.delay = categorical(tt.delay);
    tt.subj = categorical(tt.subj);
    tt.trial_id = categorical(tt.trial_id);
    
    
    
    
    
    %disp('stop here')
%     save([save_path filesep 'Exp_era_period_average_' voi_name '.mat'] ,'tt')
%     disp([ 'saved ' save_path filesep 'Exp_era_period_average_' voi_name '.mat']);
%     
%     writetable(tt,[save_path filesep 'Exp_era_period_average_' voi_name '.csv'])
%     disp([ 'saved ' save_path filesep 'Exp_era_period_average_' voi_name '.csv']);
    
    %%
    
    
    
   
    tt = table();
    
    
end

%% THE QUESTION IS
% create one function with two options 1 row A) per trial B1) per comb. of
% conditions B2) per combination of trials averaging delays for each subject?

% or separate functions

% in one file? ... or in many?
 








