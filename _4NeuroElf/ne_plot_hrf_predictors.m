function ne_plot_hrf_predictors(event_oo,varargin)
% ne_plot_hrf_predictors([0 100],'prtr',1000); % human (default), TR 1000 ms
% ne_plot_hrf_predictors([0 100],'prtr',2000); % human (default), TR 2000 ms
% ne_plot_hrf_predictors([0 100],'prtr',2000,'hpttp',3,'hnttp',10); % monkey, TR 2000 ms
% ne_plot_hrf_predictors([0 100],'prtr',1000,'hpttp',3,'hnttp',10); % monkey, TR 1000 ms
% ne_plot_hrf_predictors([0 1000; 1000 10000],'prtr',1000,'hpttp',3,'hnttp',10); % monkey, TR 1000 ms
% ne_plot_hrf_predictors([0 1000; 1000 5000; 5500 6500],'beta',[1 0.1 1],'prtr',1000,'hpttp',3,'hnttp',10); % monkey, TR 1000 ms % betas for each predictor

max_time = 30;	% s, max time to plot

%% relevant settings for converting prt to sdm (prt_CreateSDM.m)
%        params      1x1 struct with optional fields
%         .erlen     duration of event-related (0-length) stimuli (100ms)
%         .hshape    HRF shape to use ({'twogamma'}, 'boynton')
%         .hpttp     HRF time to peak for positive response (5)
%         .hnttp     HRF time to peak for negative response (15)
%         .hpnr      HRF positive/negative ratio (6)
%         .hons      HRF onset (0)
%         .hpdsp     HRF positive response dispersion (1)
%         .hndsp     HRF negative response dispersion (1)
%	  .nvol      number of volumes (data points, 30)
%         .prtr      TR (in ms, 2000)

% default parameters for HRF
defpar = { ...
    'hshape',  'char',   'nonempty', 'twogamma'; ...  % HRF type
    'hpttp',   'double', 'nonempty', 5; ...           % pos. time-to-peak
    'hnttp',   'double', 'nonempty', 15; ...          % neg. time-to-peak
    'hpnr',    'double', 'nonempty', 6; ...           % pos/neg ratio
    'hons',    'double', 'nonempty', 0; ...           % HRF onset
    'hpdsp',   'double', 'nonempty', 1; ...           % pos. dispersion
    'hndsp',   'double', 'nonempty', 1; ...           % neg. dispersion
    'nvol',    'double', 'nonempty', 30; ...	      % number of volumes
    'prtr',    'double', 'nonempty', 2000; ...        % TR (ms)
    'beta',    'double', 'nonempty', ones(1,size(event_oo,1)); ...
    };


if nargin > 2, % specified dynamic params
	params = checkstruct(struct(varargin{:}), defpar);
else
	params = checkstruct(struct, defpar);
end

params.rcond = [];
params.nvol = max_time/params.prtr;

% create dummy prt


prt = xff('new:prt'); 
prt.NrOfConditions = size(event_oo,1);
cmap = lines(prt.NrOfConditions);

prt.ParametricWeights = 0;
for k=1:prt.NrOfConditions,
	prt.Cond(k).ConditionName	= {['event ' num2str(k)]};
	prt.Cond(k).NrOfOnOffsets	= 1;
	prt.Cond(k).OnOffsets		= event_oo(k,:);
	prt.Cond(k).Color		= cmap(k,:);
end

[sdm,hrf] = prt.CreateSDM(params);
    
figure('Name','HRF','Position',[100 100 600 900]);
% plot using time axis in s
subplot(2,1,1)
plot([1:length(hrf)]/1000,hrf,'k-','LineWidth',2);
title(sprintf('HRF, hshape %s hpttp %d hnttp %d hpnr %d',params.hshape,params.hpttp,params.hnttp,params.hpnr));
grid on;

subplot(2,1,2)
plot([0:length(sdm.SDMMatrix)-1]*params.prtr/1000,sum(repmat(params.beta,length(sdm.SDMMatrix),1).*sdm.SDMMatrix(:,1:end-1),2),'k-','LineWidth',2); hold on; % sum of predictors
for k = 1:prt.NrOfConditions,
	% line(event_oo(k,:)/1000,[0 0],'Color',cmap(k,:),'LineWidth',5); 
	plot([0:length(sdm.SDMMatrix)-1]*params.prtr/1000,sdm.SDMMatrix(:,k),'k-o','Color',cmap(k,:)); hold on;
end


ylim = get(gca,'Ylim');

for k = 1:prt.NrOfConditions,
	line(event_oo(k,:)/1000,[ylim(1) ylim(1)],'Color',cmap(k,:),'LineWidth',6); hold on;
end

title(sprintf('Predictors %s ms, TR %d ms',mat2str([event_oo(:,2) - event_oo(:,1)]'),params.prtr));
grid on;

set(get(gcf,'Children'),'Xlim',[0 max_time]); % restrict to max_time s

