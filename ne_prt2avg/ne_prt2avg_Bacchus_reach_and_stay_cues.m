% ne_prt2avg_Bacchus_reach_and_stay_cues 

%% SETTINGS
avg_name = mfilename; % or something else

% MAKE SURE CONDITIONS FIT THOSE IN PRT!
conditions2take = {'SUC_STAY_R','SUC_STAY_L','SUC_LL','SUC_LR','SUC_RL','SUC_RR', 'wr_hand_LL', 'wr_hand_LR', 'wr_hand_RL', 'wr_hand_RR', 'REWARD'};

avg.ProtocolTimeResolution = 'msec';
avg.ResolutionOfDataPoints = 'Seconds';
avg.NrOfTimePoints	= 13;
avg.PreInterval		= 4;
avg.PostInterval	= 8;
avg.BaselineMode	= 3;
avg.AverageBaselineFrom = -2;
avg.AverageBaselineTo	= 0;
avg.VariationBars = 'StdErr';

%% END OF SETTINGS, AUTOMATIC PART - MOST LIKELY NO NEED FOR CHANGES

avg.NrOfCurves		= length(conditions2take);


for c = 1:length(conditions2take),
	avg.Curve(c).Name = conditions2take{c};	
	avg.Curve(c).TimeCourseColor2 = [255 255 255];
	avg.Curve(c).TimeCourseThick= 3;
	avg.Curve(c).StdErrThick = 2;
	avg.Curve(c).PreIntervalColor = [192 192 192];
	avg.Curve(c).PostIntervalColor= [192 192 192];
	
	NrOfConditionEvents = 0;
	EventDuration = [];
	for r = 1:length(prt_list),
		
		prt = xff(prt_list{r});
		% find matching condition - by name
		idx_c_prt = find(strcmp(prt.ConditionNames,conditions2take{c}));
		avg.Curve(c).File(r).EventPointsInFile = r-1;
		avg.Curve(c).File(r).Points = prt.Cond(idx_c_prt).OnOffsets(:,1);
		EventDuration = [EventDuration; prt.Cond(idx_c_prt).OnOffsets(:,2) - prt.Cond(idx_c_prt).OnOffsets(:,1)];
		
		
		avg.Curve(c).TimeCourseColor1 = prt.Cond(idx_c_prt).Color;
		avg.Curve(c).StdErrColor  = prt.Cond(idx_c_prt).Color;
	end
	avg.Curve(c).EventDuration = mean(EventDuration);
end


avg.BackgroundColor = [0 0 0]; 
avg.TextColor = [255 255 255]; 
             
