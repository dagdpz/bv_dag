function [psc,mean_psc,se_psc,n_trials] = ne_psc(perievents,baseline_samples,type)
% calculate % signal change (psc) from raw data

% perievents - each column: trial

if nargin < 3,
    type = 3; % epoch-based (BV avg 3)
end

n_samples = size(perievents,1);
n_trials = length(find(~isnan(perievents(1,:))));

baselines = mean(perievents(baseline_samples,:),1);

switch type 

    case 3 % individual baselines for each trial

        baselines = repmat(baselines,n_samples,1);

end

% psc = perievents;
psc = 100*(perievents - baselines)./baselines; % in [%signal change]
psc = psc(:,~isnan(psc(1,:))); % remove NaNs
if isempty(psc),
	psc = NaN(n_samples,1);
end

mean_psc = mean(psc,2);
se_psc = sterr(psc,2);

