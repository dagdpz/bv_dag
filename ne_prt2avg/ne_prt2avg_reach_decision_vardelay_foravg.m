% ne_prt2avg_reach_decision_vardelay_foravg

% MAKE SURE CONDITIONS FIT THOSE IN PRT!
% conditions2take = {'saccade_choice_left_cue','saccade_choice_right_cue','saccade_instructed_left_cue','saccade_instructed_right_cue',...
%                    'reach_choice_left_cue','reach_choice_right_cue','reach_instructed_left_cue','reach_instructed_right_cue'};

conditions2take_all{1} = {'sac_choi_l_3_cue','sac_choi_r_3_cue','sac_instr_l_3_cue','sac_instr_r_3_cue',...
                      'reach_choi_l_3_cue','reach_choi_r_3_cue','reach_instr_l_3_cue','reach_instr_r_3_cue'};

conditions2take_all{2} = {'sac_choi_l_6_cue','sac_choi_r_6_cue','sac_instr_l_6_cue','sac_instr_r_6_cue',...
                      'reach_choi_l_6_cue','reach_choi_r_6_cue','reach_instr_l_6_cue','reach_instr_r_6_cue'};

conditions2take_all{3} = {'sac_choi_l_9_cue','sac_choi_r_9_cue','sac_instr_l_9_cue','sac_instr_r_9_cue',...
                      'reach_choi_l_9_cue','reach_choi_r_9_cue','reach_instr_l_9_cue','reach_instr_r_9_cue'};

conditions2take_all{4} = {'sac_choi_l_12_cue','sac_choi_r_12_cue','sac_instr_l_12_cue','sac_instr_r_12_cue',...
                      'reach_choi_l_12_cue','reach_choi_r_12_cue','reach_instr_l_12_cue','reach_instr_r_12_cue'};

conditions2take_all{5} = {'sac_choi_l_15_cue','sac_choi_r_15_cue','sac_instr_l_15_cue','sac_instr_r_15_cue',...
                      'reach_choi_l_15_cue','reach_choi_r_15_cue','reach_instr_l_15_cue','reach_instr_r_15_cue'};

delay_name = {'3' '6' '9' '12' '15'};

for e = 1:length(conditions2take_all)
    
    avg = xff('new:avg');
    
    %% SETTINGS
    avg_name = mfilename; % or something else
    
    conditions2take = conditions2take_all{e};
    
    avg.ProtocolTimeResolution = 'msec';
    avg.ResolutionOfDataPoints = 'Seconds';
    avg.NrOfTimePoints	= 31;
    avg.PreInterval		= 10;
    avg.PostInterval	= 20;
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
        avg.Curve(c).EventDuration = fix(mean(EventDuration));
    end
    
    
    avg.BackgroundColor = [0 0 0];
    avg.TextColor = [255 255 255];
    
    mAVG(e).avg = avg;
    mAVG(e).avg = [avg_name '_' delay_name{e}] ;
    
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

