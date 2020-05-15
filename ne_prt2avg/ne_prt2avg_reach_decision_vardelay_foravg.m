function ne_prt2avg_reach_decision_vardelay_foravg
% ne_prt2avg_reach_decision_vardelay_foravg

% Depending on delays and timepoint of alignment, 3 different settings have
% to be made: A) GENERAL, B) CUE aligned C) MOV aligned


settings_for = {'cue','mov'};

t = 1;
for s = 1:length(settings_for)
    
    delay_name          = {'3' '6' '9' '12' '15'};
    avg_name_suffix = delay_name;
    avg_name_base   = ([mfilename '_' settings_for{s}]);
    
    % Settings here are seen relative to onset of cue, because the
    % baseline is defined before the cue for both, alignment to cue and
    % to movement. They will be repmat'ed and changed depending on
    % which delay in the respective cases below.
    
    AverageBaselineFrom =  -2;
    AverageBaselineTo   =   0;
    BaselineMode        =   3;
    PreInterval         =  13;
    PostInterval        =   3; % plus delay, see below
    ProtocolTimeResolution = 'msec';
    ResolutionOfDataPoints = 'Seconds';
    VariationBars       = 'StdErr';
    
    
    if strcmp('cue',settings_for(s))
        
        %% SETTINGS for CUE alignment
        
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
        
        
        % adding settings for different delays considering alignment to CUE, and baseline before CUE
        AverageBaselineFrom =  repmat(AverageBaselineFrom,length(conditions2take_all),1);
        AverageBaselineTo   =  repmat(AverageBaselineTo  ,length(conditions2take_all),1);
        PreInterval         =  repmat(PreInterval        ,length(conditions2take_all),1);
        PostInterval        =  (str2double(delay_name) + PostInterval)';
        NrOfTimePoints	    =  PreInterval + PostInterval + 1;
        
    elseif strcmp('mov',settings_for(s))
        
        
        %% SETTINGS for MOVEMENT alignment
        
        % MAKE SURE CONDITIONS FIT THOSE IN PRT!
        % conditions2take = {'saccade_choice_left_cue','saccade_choice_right_cue','saccade_instructed_left_cue','saccade_instructed_right_cue',...
        %                    'reach_choice_left_cue','reach_choice_right_cue','reach_instructed_left_cue','reach_instructed_right_cue'};
        
        conditions2take_all{1} = {'sac_choi_l_3_mov','sac_choi_r_3_mov','sac_instr_l_3_mov','sac_instr_r_3_mov',...
            'reach_choi_l_3_mov','reach_choi_r_3_mov','reach_instr_l_3_mov','reach_instr_r_3_mov'};
        
        conditions2take_all{2} = {'sac_choi_l_6_mov','sac_choi_r_6_mov','sac_instr_l_6_mov','sac_instr_r_6_mov',...
            'reach_choi_l_6_mov','reach_choi_r_6_mov','reach_instr_l_6_mov','reach_instr_r_6_mov'};
        
        conditions2take_all{3} = {'sac_choi_l_9_mov','sac_choi_r_9_mov','sac_instr_l_9_mov','sac_instr_r_9_mov',...
            'reach_choi_l_9_mov','reach_choi_r_9_mov','reach_instr_l_9_mov','reach_instr_r_9_mov'};
        
        conditions2take_all{4} = {'sac_choi_l_12_mov','sac_choi_r_12_mov','sac_instr_l_12_mov','sac_instr_r_12_mov',...
            'reach_choi_l_12_mov','reach_choi_r_12_mov','reach_instr_l_12_mov','reach_instr_r_12_mov'};
        
        conditions2take_all{5} = {'sac_choi_l_15_mov','sac_choi_r_15_mov','sac_instr_l_15_mov','sac_instr_r_15_mov',...
            'reach_choi_l_15_mov','reach_choi_r_15_mov','reach_instr_l_15_mov','reach_instr_r_15_mov'};
        
        
        % adding settings for different delays considering alignment to MOV, but baseline before CUE
        AverageBaselineFrom =  AverageBaselineFrom - str2double(delay_name);
        AverageBaselineTo   =  AverageBaselineTo   - str2double(delay_name);
        PreInterval         =  PreInterval         + str2double(delay_name);
        PostInterval        = repmat(PostInterval,1,length(conditions2take_all));
        NrOfTimePoints	    = PreInterval + PostInterval + 1;
        
        
    end
    %%
    
    for e = 1:length(conditions2take_all)
        
        avg = xff('new:avg');
        
        %% Settings imported from above
        % here, depending on delays, things change
        
        avg_name = [avg_name_base '_' avg_name_suffix{e}]; % or something else
        conditions2take = conditions2take_all{e};
        
        
        avg.ProtocolTimeResolution = ProtocolTimeResolution;
        avg.ResolutionOfDataPoints = ResolutionOfDataPoints;
        avg.BaselineMode	= BaselineMode;
        avg.VariationBars   = VariationBars;
        avg.NrOfTimePoints	= NrOfTimePoints(e);
        avg.PreInterval		= PreInterval(e);
        avg.PostInterval	= PostInterval(e);
        avg.AverageBaselineFrom = AverageBaselineFrom(e);
        avg.AverageBaselineTo	= AverageBaselineTo(e);
        
        
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
        
        mAVG(t).avg = avg;
        mAVG(t).avg_name = avg_name ;
        t = t +1;
    end % loop conditions2take_all
    
    
    
end %loop cue mov
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

end