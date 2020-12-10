function era = ne_era_frd_average_timecourses(era_files,trigger)

params.tc_interpolate = 100;


tc = load(era_files{1}); 

for e = 2:length(era_files)
   ttt = load(era_files{e}); 
   tc(e) = ttt;
end

for e = 1:length(era_files)
   [~, fname, ~ ] = fileparts(era_files{e});
   delay = strsplit(fname,'_');
   tc(e).del = delay{4};
   
   tc(e).raw_le = size(tc(e).era.raw(1,1).perievents,1);
end


%% data1 = era.mean; %NrOfVOIs X NrOfCurves X NrOfTimePoints

%% tc(1).era.raw; %NrofVIOs x NrofCurves

% find out which era file has smallest amount of data points
[~, ind ] = min([tc.raw_le]);
new_tc = tc(ind);
tc(ind) = [];

% concatenate
for i = 1:length(tc) % loop remaining era files
    for v = 1:size(tc(1).era.raw,1) % loop vois
        for c = 1:size(tc(1).era.raw,2) % loop curves 
            
            if strcmp('cue',trigger)
                tb_conc = tc(i).era.raw(v,c).perievents(1:new_tc.raw_le,:); % get raw form next era file, but only as long as shortest trial
            elseif strcmp('mov',trigger)
                star = tc(i).raw_le - new_tc.raw_le + 1;
                tb_conc = tc(i).era.raw(v,c).perievents(star:end,:);
            else 
                disp('ERROR: no such trigger, doh.')
            end
            
            new_tc.era.raw(v,c).perievents = [new_tc.era.raw(v,c).perievents tb_conc]; % concatenate 

       
        end
    end
end
%%

interpol.PreInterval            = new_tc.era.avg.PreInterval*1000/params.tc_interpolate;
interpol.PostInterval           = new_tc.era.avg.PostInterval*1000/params.tc_interpolate;
interpol.NrOfTimePoints         = interpol.PreInterval + interpol.PostInterval + 1;
interpol.AverageBaselineFrom    = new_tc.era.avg.AverageBaselineFrom*1000/params.tc_interpolate;
interpol.AverageBaselineTo      = new_tc.era.avg.AverageBaselineTo*1000/params.tc_interpolate;

for r = 1:size(tc(1).era.raw,1) % loop vios
    for c = 1:size(tc(1).era.raw,2) % loop curves
        [psc(r,c).perievents, mean_(r,c,:),se_(r,c,:),n_(r,c,:)] = mean_psc(new_tc.era.raw(r,c).perievents,interpol);
        
    end
end
        
new_tc.era.psc		= squeeze(psc);
new_tc.era.mean     = squeeze(mean_);
new_tc.era.se		= squeeze(se_);
new_tc.era.n_trials	= squeeze(n_);

era = new_tc;




function [psc,mean_,se_,n_] = mean_psc(perievents,interpol) %[psc,mean_,se_,n_] = mean_psc(perievents,avg)
% baselines = mean(perievents([avg.PreInterval+avg.AverageBaselineFrom:avg.PreInterval+avg.AverageBaselineTo]+1,:),1);
% baselines = repmat(baselines,avg.NrOfTimePoints,1);

baselines = mean(perievents([interpol.PreInterval+interpol.AverageBaselineFrom:interpol.PreInterval+interpol.AverageBaselineTo]+1,:),1);
baselines = repmat(baselines,interpol.NrOfTimePoints,1);

psc = 100*(perievents - baselines)./baselines; % in [%signal change]
psc = psc(:,~isnan(psc(1,:))); % remove NaNs

mean_ = mean(psc,2); % in % signal change
se_ = sterr(psc,2,1);
n_ = size(perievents,2);
if all(isnan(perievents)),
	n_= 0;
end




