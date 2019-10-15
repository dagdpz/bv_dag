function era = ne_sdm2era_prt(basedir,tc_file_list, prt_file_list, TOPLOT, era_config, conditions_config)
%NE_SDM2ERA_PRT			- convert any timecourse (MC sdm, any rtc, any mat) to era plot, using prt file(s)
% ne_sdm2era_prt(pwd,{'Gro2018-06-21_run01_task_GR_20180621_run01_MCparams.sdm'; 'Gro2018-06-21_run02_task_GR_20180621_run02_MCparams.sdm'},{'Gro2018-06-21_run01.prt'; 'Gro2018-06-21_run02.prt'}, 1);
% ne_sdm2era_prt(pwd,'*run01_MCparams.sdm','*run01.prt', 1); % only run01
% ne_sdm2era_prt(pwd,'*_MCparams.sdm','*.prt', 1); % all runs
% ne_sdm2era_prt(basedir,'*_MCparams.sdm','*.prt', 1, {'TR',900},{'cond_regexp','reach.+mov'});
% ne_sdm2era_prt(basedir,'*_MCparams.sdm','*.prt', 1, {'TR',900,'pred2take','MC'},{'cond_regexp','reach.+mov'});

% conditions_config
% e.g. {'cond_regexp','reach.+mov'}

% Similar to AVG::Average  - average time course according to AVG info
% BUT!!! Note: this function only works for Volume-based AVG files
%        since without the FMR/VTC/MTC the TR is unknown


era_config_def.TR			= 2000; % s
era_config_def.pre			= 10; % volumes
era_config_def.post			= 20; % volumes
era_config_def.baseline_start	= -3; % volumes
era_config_def.baseline_end		= -1; % volumes
era_config_def.baseline_mode	= 3; % 0 - raw data, 3 - %signal change trial baseline, see https://support.brainvoyager.com/documents/Functional_Statistics/Introduction/BaselineEventRelatedAveraging_v01.pdf
era_config_def.pred2take        = []; % [] - all, array of pred, or regexp string
    
if nargin < 4,
	TOPLOT = 0;
end

if nargin < 5,
    era_config = era_config_def;
    
elseif iscell(era_config),
        
    era_config_temp = struct(era_config{:});
    era_config = era_config_def;
    
    for fn = fieldnames(era_config_temp)'
        era_config.(fn{1}) = era_config_temp.(fn{1});
    end
	
end

if nargin < 6,
	conditions_config = [];
end


if isstr(tc_file_list)
	if strfind(tc_file_list,'*');
		[tc_file_list] = findfiles(basedir, tc_file_list, 'dirs=0', 'depth=1');
	end
end


if isstr(prt_file_list)
	if strfind(prt_file_list,'*');
		[prt_file_list] = findfiles(basedir, prt_file_list, 'dirs=0', 'depth=1');
	end
end


n_tc_files = length(tc_file_list);
n_prt_files = length(prt_file_list);
if n_tc_files~=n_prt_files,
	error('Not matched number of timecourse and prt files!');
end


% sdm format
%                FileVersion: 1
%                        RTC: [1x1 struct]
%             NrOfPredictors: 6
%             NrOfDataPoints: 450
%           IncludesConstant: 0
%     FirstConfoundPredictor: 1
%            PredictorColors: [6x3 double]
%             PredictorNames: [1x6 cell]
%                  SDMMatrix: [450x6 double]
%                  RTCMatrix: [450x0 double]
%                RunTimeVars: [1x1 struct]


% prt format
%            FileVersion: 2
%       ResolutionOfTime: 'msec'
%             Experiment: 'Gro2018-06-21_02'
%        BackgroundColor: 0 0 0
%              TextColor: 255 255 255
%        TimeCourseColor: 255 255 255
%        TimeCourseThick: 3
%     ReferenceFuncColor: 0 0 80
%     ReferenceFuncThick: 3
%      ParametricWeights: 0
%         NrOfConditions: 1
%                   Cond: [1x1 struct]
%            RunTimeVars: [1x1 struct]
% prt.Cond
% ans =
%     ConditionName: {'fixation microstim'}
%     NrOfOnOffsets: 15
%         OnOffsets: [15x2 double]
%           Weights: [15x0 double]
%             Color: [0 160 0]

sdm = xff(tc_file_list{1});
prt = xff(prt_file_list{1});

if ~isempty(era_config.pred2take),
    
    if isnumeric(era_config.pred2take),
        sdm.NrOfPredictors = length(era_config.pred2take);
    else
        pi = regexp(sdm.PredictorNames',era_config.pred2take);
        pii = find(cellfun(@(x) ~isempty(x), pi, 'UniformOutput', 1));
        sdm.NrOfPredictors = length(pii);
    end
    
end

if ~isempty(conditions_config),
    
    conditions_config = struct(conditions_config{:});
    
    ci = regexp(prt.ConditionNames',conditions_config.cond_regexp);
    cii = find(cellfun(@(x) ~isempty(x), ci, 'UniformOutput', 1));
    
    prt.NrOfConditions = length(cii);
    
end    


if TOPLOT,
	fs = 8; % FontSize
	n_s_cols = ceil(max([sdm.NrOfPredictors/3 1]));
	n_s_rows = ceil(sdm.NrOfPredictors/n_s_cols);
end

era(prt.NrOfConditions,sdm.NrOfPredictors).tc = [];


for c=1:prt.NrOfConditions, % for each prt condition
	
	for f = 1:n_tc_files, % for each TC file
		
		sdm = xff(tc_file_list{f});
		prt = xff(prt_file_list{f});
        
        if ~isempty(era_config.pred2take), % remove unwanted predictors
            sdm.NrOfPredictors = length(pii);
            sdm.PredictorColors = sdm.PredictorColors(pii,:);
            sdm.PredictorNames = sdm.PredictorNames(pii);
            sdm.SDMMatrix = sdm.SDMMatrix(:,pii);  
        end
		
        if ~isempty(conditions_config), % remove unwanted conditions
            prt.Cond = prt.Cond(cii);
        end
        
		triggers = round(prt.Cond(c).OnOffsets(:,1)/era_config.TR);
		triggers = triggers(triggers > era_config.pre & triggers + era_config.post < sdm.NrOfDataPoints );
		
		for t=1:length(triggers), % for each trigger, for all TC plots
			volumes2take = [triggers(t)-era_config.pre : triggers(t)+era_config.post];
			
			for p=1:sdm.NrOfPredictors,
				
				
				switch era_config.baseline_mode
					case 0 % raw timecourse
						era(c,p).tc = [era(c,p).tc  sdm.SDMMatrix(volumes2take,p)];
					case 3 % epoch based %signal change
						baseline_volumes = triggers(t) + era_config.baseline_start:triggers(t) + era_config.baseline_end;
						era(c,p).tc = [era(c,p).tc  100*(sdm.SDMMatrix(volumes2take,p) - mean(sdm.SDMMatrix(baseline_volumes,p)))/mean(sdm.SDMMatrix(baseline_volumes,p)) ];			
				end	
			end
			
		end
		
	end
	
	
	
	if TOPLOT,
		figure('Name',sprintf('%s %d runs %d events',prt.ConditionName{c},n_tc_files, size(era(c,p).tc,2) ));
		for p = 1:sdm.NrOfPredictors,
			subplot(n_s_rows,n_s_cols,p);
			if sum(sdm.PredictorColors(p,:))==255*3,
				sdm.PredictorColors(p,:) = [155 155 155]; % avoid white
			end
			if ~isempty(era(c,p).tc),		
				plot(era_config.TR/1000*[-era_config.pre:era_config.post],era(c,p).tc,'Color',sdm.PredictorColors(p,:)/255,'LineWidth',0.5); hold on;
				plot(era_config.TR/1000*[-era_config.pre:era_config.post],mean(era(c,p).tc,2),'k','Color',sdm.PredictorColors(p,:)/500,'LineWidth',2,'Marker','.');
				ig_add_zero_lines;
				title(sdm.PredictorNames{p},'Interpreter','none','FontSize',fs);
				xlabel('Time (s)','FontSize',fs);
				set(gca,'Xlim',era_config.TR/1000*([-era_config.pre era_config.post]));
			end
		end
		
	end % of if TOPLOT
	
end

