function ne_plot_sdm(sdm_fullname,prt_fullname,TR,n_task_predictors)
% ne_plot_sdm('D:\MRI\Bacchus\20141106\Bacchus_2014-11-06_run01_task_BA_20141106_run01_MCparams_outlier_preds_6pred.sdm','D:\MRI\Bacchus\20141106\Bacchus_2014-11-06_run01.prt')

if nargin < 2,
	prt_fullname = '';
end

if nargin < 3,
	TR = 2000; % ms
end

sdm = xff(sdm_fullname);

if nargin < 4,
	n_task_predictors = sdm.FirstConfoundPredictor-1;
end

figure('Name',sdm_fullname,'Position',[100 100 1000 800]);

ha1 = subplot(2,1,1); hold on;
set(ha1,'ColorOrder',sdm.PredictorColors(1:n_task_predictors,:)/255);
plot([0:sdm.NrOfDataPoints-1]*TR/1000,sdm.SDMMatrix(:,1:n_task_predictors)); hold on;
legend(sdm.PredictorNames(1:n_task_predictors),'Interpreter','none');

plot([0:sdm.NrOfDataPoints-1]*TR/1000,sum(sdm.SDMMatrix(:,1:n_task_predictors),2),'k-','LineWidth',2); % sum of predictors


if ~isempty(prt_fullname),
	ylim = get(gca,'Ylim');
	prt = xff(prt_fullname);
	for k=1:prt.NrOfConditions,
		plot_one_condition(prt.Cond(k),ylim,TR);
	end
end
	
if sdm.NrOfPredictors>=sdm.FirstConfoundPredictor,
ha2 = subplot(2,1,2); hold on;
% set(ha2,'ColorOrder',sdm.PredictorColors(n_task_predictors+1:end,:)/255,'Color',[0.5 0.5 0.5]);
% set(ha2,'ColorOrder',jet(sdm.NrOfPredictors - n_task_predictors));
plot([0:sdm.NrOfDataPoints-1]*TR/1000,sdm.SDMMatrix(:,n_task_predictors+1:end));
xlabel('s');
legend(sdm.PredictorNames(n_task_predictors+1:end),'Interpreter','none');
end


function plot_one_condition(Cond,ylim,TR)
	
for k=1:Cond.NrOfOnOffsets,
	fill([Cond.OnOffsets(k,1) Cond.OnOffsets(k,1) Cond.OnOffsets(k,2) Cond.OnOffsets(k,2)]/1000, [ylim(1) ylim(2) ylim(2) ylim(1)],Cond.Color/255,'FaceColor',Cond.Color/255,'FaceAlpha',0.5,'EdgeAlpha',0); 
end

