% ne_prt2avg_reach_decision_vardelay_foravg_cue

%% SETTINGS

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

delay_name      = {'3' '6' '9' '12' '15'};
avg_name_base   = mfilename;
avg_name_suffix = delay_name;

AverageBaselineFrom =  -2;
AverageBaselineTo   =   0;
PreInterval         =  13;
PostInterval        =   3;

AverageBaselineFrom =  repmat(AverageBaselineFrom,length(conditions2take_all),1);
AverageBaselineTo   =  repmat(AverageBaselineTo  ,length(conditions2take_all),1);
PreInterval         =  repmat(PreInterval        ,length(conditions2take_all),1);
PostInterval        =  str2double(delay_name) + PostInterval;

