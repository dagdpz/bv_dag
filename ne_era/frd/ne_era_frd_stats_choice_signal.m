function [tt_ges,tt_ges_no_del] = ne_era_frd_stats_choice_signal(era_files,windows,windows_name,end_aligned,which_difference,average_which_conditions,new_cond_name)


% 
% era_files = {...
%     'Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI\ANEL\mat2prt_reach_decision_vardelay_foravg\ANEL_era_cue_9_lh_no_outliers.mat';...
%     'Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI\ANEL\mat2prt_reach_decision_vardelay_foravg\ANEL_era_cue_12_lh_no_outliers.mat';...
%     'Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI\ANEL\mat2prt_reach_decision_vardelay_foravg\ANEL_era_cue_15_lh_no_outliers.mat'};
% windows = [ 4    7;mean(tc(d).era.psc(v,c).perievents(idx,:),1)';
%     -2 -0.5];% delay 9 -->  [7 8.5] % includes first, but not last timepoints of windows
% windows_name = {'early','late'};
% end_aligned= [0 1]; % if 0 it counts backwards from last entry of era.timeaxis
% 
% which_difference = 'choi_instr'; % has to fit with the name in era.diff.name
% average_which_conditions = {'sac_left','sac_right';'reach_left','reach_right'}; % has to fit with the name in era.diff.dat.cond --> columns are averaged, per row
% new_cond_name = {'sac';'reach'}; % in rows, according to the rows in average_which_conditions
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
idiff = strcmp(which_difference,{tc(1).era.diff.name});

if isempty(average_which_conditions)
    new_cond_name = tc(1).era.diff(1).dat.cond(:);
end


for d = 1:length(tc) % loop over era files (subjects * delay)
    
    for v = 1:size(tc(d).era.diff(idiff).dat.diff_mean,1) % loop over VIOs
        
        voi_name = tc(d).era.voi(v).Name;
        
        diff_mean = [];
        if ~isempty(average_which_conditions) % if told to average, average ....
            for a = 1:size(average_which_conditions,1) % loop over curve
                
                icond = ismember(tc(d).era.diff(idiff).dat.cond,average_which_conditions(a,:));
                
                diff_mean = [diff_mean, squeeze(mean(tc(d).era.diff(idiff).dat.diff_mean(v,icond,:),2))]; % calculate mean according to rows in average_which_conditions and attach to diff_mean
            end
        else ...otherwise take all curves
                diff_mean = squeeze(tc(d).era.diff(idiff).dat.diff_mean(v,:,:))';
        end
        
        
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
            temp.diff = mean(diff_mean(idx,:),1)';
            temp.cond = new_cond_name(:);
            temp.period = repmat({windows_name{w}}, length(temp.diff),1);
            temp.diff_cond = repmat({which_difference}, length(temp.diff),1);
            temp.delay = repmat({tc(d).del}, length(temp.diff),1); 
            temp.subj = repmat({tc(d).subj}, length(temp.diff),1);
            temp.voi = repmat({voi_name}, length(temp.diff),1);
            temp.hemi = repmat({tc(d).hemi}, length(temp.diff),1);
            
            tt = [tt; temp];
            
            
        end % loop periods
    end % loop vois

tt.cond = categorical(tt.cond);
tt.period = categorical(tt.period);
tt.diff_cond = categorical(tt.diff_cond);
tt.delay = categorical(tt.delay);
tt.subj = categorical(tt.subj);
tt.hemi = categorical(tt.hemi);
tt.voi = categorical(tt.voi);          

tt_ges = [tt_ges; tt];


tt = table();


end % loop era files

%% create average for each delay
tt_ges_no_del = rowfun(@nanmean,tt_ges,'InputVariables',{'diff'},'GroupingVariable', {'subj','voi','cond','period'},'OutputVariableNames','diff');


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

%% create shorter voi names
tt_ges_no_del.hemi           = cell(length(tt_ges_no_del.cond),1);
tt_ges_no_del.voi_short      = cell(length(tt_ges_no_del.cond),1);
tt_ges_no_del.voi_short_hemi = cell(length(tt_ges_no_del.cond),1);
tt_ges_no_del.voi_number     = cell(length(tt_ges_no_del.cond),1);

for i = 1:length(tt_ges_no_del.cond)
    name_parts = strsplit(char(cellstr(tt_ges_no_del.voi(i))),'_');
   
    tt_ges_no_del.voi_short(i)      = name_parts(2);
    tt_ges_no_del.voi_short_hemi(i) = {[name_parts{2} '_' name_parts{end}]};
    tt_ges_no_del.voi_number(i)     = name_parts(1);
    
    tt_ges_no_del.hemi(i) = {[name_parts{end} 'h']};
    

end

tt_ges_no_del.voi_short      = categorical(tt_ges_no_del.voi_short);
tt_ges_no_del.voi_short_hemi = categorical(tt_ges_no_del.voi_short_hemi);
tt_ges_no_del.hemi           = categorical(tt_ges_no_del.hemi);
tt_ges_no_del.voi_number     = str2double(tt_ges_no_del.voi_number);

tt_ges_no_del.location = tt_ges_no_del.voi_number;
tt_ges_no_del.location(tt_ges_no_del.location>99) = tt_ges_no_del.location(tt_ges_no_del.location>99) - 100;

tt_ges_no_del.subj_period = findgroups(tt_ges_no_del.period,tt_ges_no_del.subj);

%%



