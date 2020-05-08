% ne_prt2avg_reach_decision_vardelay_forglm

%% SETTINGS

% MAKE SURE CONDITIONS FIT THOSE IN PRT!
% conditions2take = {'saccade_choice_left_cue','saccade_choice_right_cue','saccade_instructed_left_cue','saccade_instructed_right_cue',...
%                    'reach_choice_left_cue','reach_choice_right_cue','reach_instructed_left_cue','reach_instructed_right_cue'};

conditions2take_all = {'sac_choi_l_cue','sac_choi_r_cue','sac_instr_l_cue','sac_instr_r_cue',...
                      'reach_choi_l_cue','reach_choi_r_cue','reach_instr_l_cue','reach_instr_r_cue'};

avg_name_base = mfilename;
avg_name_suffix = '';

AverageBaselineFrom =  -2;
AverageBaselineTo   =   0;
PreInterval         =  13;
PostInterval        =  18;