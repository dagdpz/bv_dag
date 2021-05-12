function tt_ges = ne_era_frd_periods_average_v2(era_files,windows,windows_name,end_aligned,per_trial)
%era_files = {'Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI\ANEL\mat2prt_reach_decision_vardelay_foravg\ANEL_era_cue_average_lh_no_outliers.mat'};
%era_files = {'Y:\MRI\Human\fMRI-reach-decision\Experiment\TEST_era_cue_average_lh_no_outliers.mat'};
% windows = [ 4    7];
% windows_name = {'early'};
% end_aligned= [0]; % if 0 it counts backwards from last entry of era.timeaxis
% per_trial = 0;
%%
% era_files = {...
%     'Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI\ANEL\mat2prt_reach_decision_vardelay_foravg\ANEL_era_cue_9_lh_no_outliers.mat';...
%     'Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI\ANEL\mat2prt_reach_decision_vardelay_foravg\ANEL_era_cue_12_lh_no_outliers.mat';...
%     'Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI\ANEL\mat2prt_reach_decision_vardelay_foravg\ANEL_era_cue_15_lh_no_outliers.mat'};
% windows = [ 4    7; 
%            -2 -0.5];% delay 9 -->  [7 8.5]
% windows_name = {'early','late'};
% end_aligned= [0 1]; % if 0 it counts backwards from last entry of era.timeaxis
% per_trial = 0;
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
    tc(e).hemi = prtz{5};
end

%%
tt = table();
tt_ges = table();

for d = 1:length(tc) % loop over era files
    
    for v = 1:size(tc(d).era.mean,1) % loop over VIOs
        
        voi_name = tc(d).era.voi(v).Name;
        
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
                
                if isempty(tc(d).era.psc(v,c).perievents)
                    continue;  
                end

                avg_per_trial = mean(tc(d).era.psc(v,c).perievents(idx,:),1)'; % mean for time interval/window

                if per_trial
                    temp.mean = avg_per_trial;
                else
                    temp.mean = mean(avg_per_trial);
                end
                
                temp.period = repmat(windows_name(w), length(temp.mean),1); 
  
                name_parts = strsplit(tc(d).era.avg.Curve(c).Name,'_');
                
                cond = [name_parts{1} '_' name_parts{2} '_' name_parts{3} '_' name_parts{4}];     
                temp.cond = repmat({cond},length(temp.mean),1);
                temp.eff  = repmat({name_parts{1}}, length(temp.mean),1);
                temp.choi = repmat({name_parts{2}}, length(temp.mean),1);
                temp.side = repmat({name_parts{3}}, length(temp.mean),1);                
                temp.delay = repmat({name_parts{4}}, length(temp.mean),1);  
                
                temp.subj = repmat({tc(d).subj}, length(temp.mean),1);  
                temp.voi = repmat({voi_name}, length(temp.mean),1);         
                temp.hemi = repmat({tc(d).hemi}, length(temp.mean),1);

                tt = [tt; temp];
                
  
                
            end
        end
    end 
    
    tt.period = categorical(tt.period);
    tt.cond = categorical(tt.cond);
    tt.eff = categorical(tt.eff);
    tt.choi = categorical(tt.choi);
    tt.side = categorical(tt.side);
    tt.delay = categorical(tt.delay);
    tt.subj = categorical(tt.subj);
    tt.hemi = categorical(tt.hemi);
    tt.voi = categorical(tt.voi);
    
    tt_ges = [tt_ges; tt];    
    

%%
    tt = table();
    
    
end % loop over era files


%% create shorter voi names
tt_ges.voi_short = cell(length(tt_ges.cond),1);
tt_ges.voi_short_hemi = cell(length(tt_ges.cond),1);
tt_ges.voi_number = cell(length(tt_ges.cond),1);

for i = 1:length(tt_ges.cond)
    name_parts = strsplit(char(cellstr(tt_ges.voi(i))),'_');
   
    tt_ges.voi_short(i)      = name_parts(2);
    tt_ges.voi_short_hemi(i) = {[name_parts{2} '_' name_parts{end}]};
    tt_ges.voi_number(i)     = name_parts(1);

end

tt_ges.voi_short      = categorical(tt_ges.voi_short);
tt_ges.voi_short_hemi = categorical(tt_ges.voi_short_hemi);
tt_ges.voi_number     = str2double(tt_ges.voi_number);
 
tt_ges.location = tt_ges.voi_number;
tt_ges.location(tt_ges.location>99) = tt_ges.location(tt_ges.location>99) - 100;

tt_ges.subj_period = findgroups(tt_ges.period,tt_ges.subj);








