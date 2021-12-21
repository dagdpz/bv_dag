function era = ne_era_frd_create_grp_level_files(era_files)
% takes a bunch of era files and creates the mean and the se (dependent sample) from all
% individual means (mean of means and SE of that)
% prerequisite: equal trial length


tc = load(era_files{1});

for e = 2:length(era_files) % load and concetanate other files
    ttt = load(era_files{e});
    tc(e) = ttt;
end

for e = 1:length(era_files) % get subj name from first name part of file
    [~, fname, ~ ] = fileparts(era_files{e});
    delay = strsplit(fname,'_');
    tc(e).subj = delay{1};
    
end


%% data1 = era.mean; %NrOfVOIs X NrOfCurves X NrOfTimePoints
%% tc(1).era.raw; %NrofVIOs x NrofCurves

new_tc = tc(1); % create new tc

%%
% interpolated data
new_tc.era.psc = []; % make room for new psc
new_tc.era.mean = [];
new_tc.era.se = [];
new_tc.era.n = [];

[new_tc.era.psc( 1:size(tc(1).era.psc,1), 1:size(tc(1).era.psc,2)).perievents] = deal([]); %    n_rois X n_Curves

% downsampled data
new_tc.era.psc_ds = []; %downsampled data
new_tc.era.mean_ds = [];
new_tc.era.se_ds = [];
new_tc.era.n_ds = [];

[new_tc.era.psc_ds( 1:size(tc(1).era.psc,1), 1:size(tc(1).era.psc,2)).perievents] = deal([]); %    n_rois X n_Curves

% n trials per subject
new_tc.era.n_trials = [];
[new_tc.era.n_trials(1:length(tc),1).subj] = deal([]);

%% mean, se and ntrial for interpolated and ds_data
nan_subj = {};
for v = 1:size(tc(1).era.psc,1) % loop vois
    
    
    for c = 1:size(tc(1).era.psc,2) % loop curves
        
        
        for i = 1:length(tc) % loop subjects == era files
            
            tb_conc = squeeze(tc(i).era.mean(v,c,:)); % take mean of respective voi-curve combination and put it in tb_conc (which is going to be psc)
            tb_conc_ds = squeeze(tc(i).era.mean_ds(v,c,:));
            
            if isnan(tb_conc(1)) || isnan(tb_conc_ds(1))
                if v == 1 % will be same for all vois
                    nan_subj = [nan_subj tc(i).subj]; %which subjects do not have data for that condition?
                end
            else
                new_tc.era.psc(v,c).perievents = [new_tc.era.psc(v,c).perievents tb_conc]; % concatenate
                new_tc.era.psc_ds(v,c).perievents = [new_tc.era.psc_ds(v,c).perievents tb_conc_ds]; % concatenate
            end
            
            new_tc.era.n_trials(i).subj = tc(i).era.n_trials;
            
        end
        
        
        % create mean and se and n
        new_tc.era.mean(v,c,:) =  mean(new_tc.era.psc(v,c).perievents,2);
        new_tc.era.se(v,c,:)   = sterr(new_tc.era.psc(v,c).perievents,2,1);
        new_tc.era.n(v,c)      =  size(new_tc.era.psc(v,c).perievents,2);
        
        new_tc.era.mean_ds(v,c,:) = mean(new_tc.era.psc_ds(v,c).perievents,2);
        new_tc.era.se_ds(v,c,:)   = sterr(new_tc.era.psc_ds(v,c).perievents,2,1);
        new_tc.era.n_ds(v,c,:)    = size(new_tc.era.psc_ds(v,c).perievents,2);
        
        if v == 1 % write down which subjects do not have data for that condition
            new_tc.era.nan_counter(c).subj = nan_subj;
            new_tc.era.nan_counter(c).count = length(nan_subj);
            new_tc.era.nan_counter(c).cond = new_tc.era.avg.Curve(c).Name;
            nan_subj = {};
        end
        
        
    end
end



%% for difference curves

new_tc.era.diff = [];
nan_subj = {};

for d = 1:length(tc(1).era.diff)  % loop difference-conditions
    
    % copy names
    new_tc.era.diff(d).name        =  tc(1).era.diff(d).name; % choice-instr / left_right ...
    new_tc.era.diff(d).dat.cond    =  tc(1).era.diff(d).dat.cond; % sac_left / sac_right ...
    new_tc.era.diff(d).dat_ds.cond =  tc(1).era.diff(d).dat_ds.cond; % sac_left / sac_right ...
    
    % allocate for subject's individual diff timecourses
    [new_tc.era.diff(d).dat.psc(   1:size(tc(1).era.diff(1).dat.diff_mean,1), 1:size(tc(1).era.diff(1).dat.diff_mean,2)).perievents] = deal([]); %    n_rois X n_Curves
    [new_tc.era.diff(d).dat_ds.psc(1:size(tc(1).era.diff(1).dat.diff_mean,1), 1:size(tc(1).era.diff(1).dat_ds.diff_mean,2)).perievents] = deal([]); %    n_rois X n_Curves
    
    
    for v = 1:size(tc(1).era.diff(1).dat.diff_mean,1) % loop vois
        for c = 1:size(tc(1).era.diff(1).dat.diff_mean,2) % loop curves     
            for i = 1:length(tc) % loop subjects == era files
                
                tb_conc = squeeze(tc(i).era.diff(d).dat.diff_mean(v,c,:));
                tb_conc_ds = squeeze(tc(i).era.diff(d).dat_ds.diff_mean(v,c,:));
                
                if isnan(tb_conc(1)) || isnan(tb_conc_ds(1))
                    if v == 1 % will be same for all vois
                        nan_subj = [nan_subj tc(i).subj]; %which subjects do not have data for that condition?
                    end
                else
                    new_tc.era.diff(d).dat.psc(v,c).perievents =    [new_tc.era.diff(d).dat.psc(v,c).perievents tb_conc];
                    new_tc.era.diff(d).dat_ds.psc(v,c).perievents = [new_tc.era.diff(d).dat_ds.psc(v,c).perievents tb_conc_ds];
                    
                end
            end
            
            % interpolated data
            % n
            n_diff  = size(new_tc.era.diff(d).dat.psc(v,c).perievents,2);
            new_tc.era.diff(d).dat.n(v,c) = n_diff;
            
            
            % mean
            new_tc.era.diff(d).dat.diff_mean(v,c,:)    = mean(new_tc.era.diff(d).dat.psc(v,c).perievents,2);
            
            % SE of mean differences
            
            % dev_diff_sq = (x_diff - mean_diff)^2
            % SD_diff = sqrt((1/(n-1)) * sum(dev_diff_sq,2)
            % SE_diff = SD_diff /sqrt(n)
            
            dev_diff_sq = (new_tc.era.diff(d).dat.psc(v,c).perievents - squeeze(new_tc.era.diff(d).dat.diff_mean(v,c,:))).^2;
            SD_diff = sqrt((1/(n_diff-1)) * sum(dev_diff_sq,2));
            new_tc.era.diff(d).dat.diff_se  (v,c,:)   = SD_diff/sqrt(n_diff);
            
            % downsampled data
            % n
            n_diff_ds  = size(new_tc.era.diff(d).dat_ds.psc(v,c).perievents,2);
            new_tc.era.diff(d).dat_ds.n(v,c) = n_diff_ds;

            
            % mean
            new_tc.era.diff(d).dat_ds.diff_mean(v,c,:) = mean(new_tc.era.diff(d).dat_ds.psc(v,c).perievents,2);
            
            % SE of mean differences
            dev_diff_sq    = (new_tc.era.diff(d).dat_ds.psc(v,c).perievents - squeeze(new_tc.era.diff(d).dat_ds.diff_mean(v,c,:))).^2;
            SD_diff = sqrt((1/(n_diff_ds-1)) * sum(dev_diff_sq,2));
            new_tc.era.diff(d).dat_ds.diff_se  (v,c,:)   = SD_diff/sqrt(n_diff_ds);
            
            if v == 1 % write down which subjects do not have data for that condition
                new_tc.era.diff(d).nan_counter(c).subj = nan_subj;
                new_tc.era.diff(d).nan_counter(c).count = length(nan_subj);
                new_tc.era.diff(d).nan_counter(c).cond = new_tc.era.diff(d).dat.cond{c};
                nan_subj = {};
                
            end
            
        end
    end

end








%%


era.voi  = new_tc.era.voi;
era.avg  = new_tc.era.avg;
era.TR   = new_tc.era.TR;
era.psc  = new_tc.era.psc;
era.mean = new_tc.era.mean;
era.se   = new_tc.era.se;
era.n    = new_tc.era.n;
era.n_trials = new_tc.era.n_trials;
era.timeaxis = new_tc.era.timeaxis;
era.nan_counter = new_tc.era.nan_counter;

era.mean_ds = new_tc.era.mean_ds;
era.se_ds   = new_tc.era.se_ds;
era.n_ds    = new_tc.era.n_ds;
era.timeaxis_ds = new_tc.era.timeaxis_ds;

era.diff =  new_tc.era.diff;

era.subj = {tc.subj};















