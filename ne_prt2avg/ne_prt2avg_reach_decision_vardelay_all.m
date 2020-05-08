% ne_prt2avg_reach_decision_vardelay_foravg_cue



scri = {'ne_prt2avg_reach_decision_vardelay_foravg_cue.m',...
        'ne_prt2avg_reach_decision_vardelay_foravg_mov.m',...
        'ne_prt2avg_reach_decision_vardelay_forglm.m'};

for s = 1:length(scri)
    
    run(scri{s})
    
    for e = 1:length(conditions2take_all)
        
        avg = xff('new:avg');
        
        %% SETTINGS
        % here, depending on delays, things change
        
        avg_name = [avg_name_base '_' avg_name_suffix{e}]; % or something else
        
        conditions2take = conditions2take_all{e};
        
        avg.ProtocolTimeResolution = 'msec';
        avg.ResolutionOfDataPoints = 'Seconds';
        avg.NrOfTimePoints	= PreInterval(e) + PostInterval(e) + 1;
        avg.PreInterval		= PreInterval(e);
        avg.PostInterval	= PostInterval(e);
        avg.BaselineMode	= 3;
        avg.AverageBaselineFrom = AverageBaselineFrom(e);
        avg.AverageBaselineTo	= AverageBaselineTo(e);
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
            avg.Curve(c).EventDuration = fix(mean(EventDuration));
        end
        
        
        avg.BackgroundColor = [0 0 0];
        avg.TextColor = [255 255 255];
        
        mAVG(e).avg = avg;
        mAVG(e).avg_name = avg_name ;
        
    end
end
% avg.Curve
% 1xN struct array with fields:
%     Name
%     NrOfConditionEvents
%     File
%     EventDuration
%     TimeCourseColor1
%     TimeCourseColor2
%     TimeCourseThick
%     StdErrColor
%     StdErrThick
%     PreIntervalColor
%     PostIntervalColor

