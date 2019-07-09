function ne_plot_hrf_predictors_parametric(event_oo,varargin)
% ne_plot_hrf_predictors_parametric({[500 1000 1 100; 25500 26000 2 110;  45500 46000 10 120;]},'prtr',1000,'pnorm',true,'portho',true,'ortho',true); % 1 main, 2 parametric pred
% ne_plot_hrf_predictors_parametric({[500 1000 1; 25500 26000 2;  45500 46000 10]},'prtr',1000,'pnorm',true); % 1 main, 1 parametric pred
% ne_plot_hrf_predictors_parametric({[500 1000 1 100; 25500 26000 2 110;  45500 46000 10 120;],[12000 14000 1; 22000 24000 2]},'prtr',1000,'pnorm',true); % 2 main, 2 and 1 parametric pred


max_time = 150;	% s, max time to plot

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
    'beta',    'double', 'nonempty', ones(1,size(event_oo,2)); ...

    'ortho',   'logical','nonempty', false; ...       % orthogonalization
    'pnorm',   'logical','nonempty', true; ...        % param normalization
    'portho',  'logical','nonempty', false; ...       % param orthogon, only works if 'ortho' is true!
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
prt.NrOfConditions = size(event_oo,2);
cmap = lines(prt.NrOfConditions);

prt.ParametricWeights = size(event_oo{1},2) - 2; % 0, 1 or 2
prt.FileVersion = 3;

for k=1:prt.NrOfConditions,
	prt.Cond(k).ConditionName	= {['event ' num2str(k)]};
	prt.Cond(k).NrOfOnOffsets	= size(event_oo{k},1);
	prt.Cond(k).OnOffsets		= event_oo{k}(:,1:2);
	prt.Cond(k).Color		= cmap(k,:);
	
	n_parametric = size(event_oo{k},2) - 2;
	switch n_parametric,
		case 0
			prt.Cond(k).Weights = ones(size(event_oo{k},1),1);
		case 1
			prt.Cond(k).Weights = event_oo{k}(:,3);
		case 2
			prt.Cond(k).Weights = event_oo{k}(:,3:4);
	end
end


[sdm,hrf] = prt.CreateSDM(params);
    
figure('Name','HRF','Position',[100 100 1200 900]);
% plot using time axis in s
subplot(2,1,1)
plot([1:length(hrf)]/1000,hrf,'k-','LineWidth',2);
title(sprintf('HRF, hshape %s hpttp %d hnttp %d hpnr %d',params.hshape,params.hpttp,params.hnttp,params.hpnr));
grid on;

subplot(2,1,2)
% plot([0:length(sdm.SDMMatrix)-1]*params.prtr/1000,sum(repmat(params.beta,length(sdm.SDMMatrix),1).*sdm.SDMMatrix(:,1:end-1),2),'k-','LineWidth',2); hold on; % sum of predictors
n_nonparametric = 0;
n_parametric = 0;
for k = 1:sdm.FirstConfoundPredictor-1,
	% line(event_oo(k,:)/1000,[0 0],'Color',cmap(k,:),'LineWidth',5); 
	if isempty(strfind(sdm.PredictorNames{k},' x p')), % not parametric
		n_nonparametric = n_nonparametric + 1;
		n_parametric = 0;
		plot([0:length(sdm.SDMMatrix)-1]*params.prtr/1000,sdm.SDMMatrix(:,k),'k-o','Color',cmap(n_nonparametric,:)); hold on;
	else
		n_parametric = n_parametric + 1;
		plot([0:length(sdm.SDMMatrix)-1]*params.prtr/1000,sdm.SDMMatrix(:,k),'k:.','Color',cmap(n_nonparametric,:)/n_parametric); hold on;
	end
end



ylim = get(gca,'Ylim');

for k = 1:prt.NrOfConditions,
	for i = 1:prt.Cond(k).NrOfOnOffsets,
		line(event_oo{k}(i,1:2)/1000,[ylim(1) ylim(1)],'Color',cmap(k,:),'LineWidth',6); hold on;
	end
end

% title(sprintf('Predictors %s ms, TR %d ms',mat2str([event_oo(:,2) - event_oo(:,1)]'),params.prtr));
grid on;

set(get(gcf,'Children'),'Xlim',[0 max_time]); % restrict to max_time s

