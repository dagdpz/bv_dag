% ne_prt2avg_reach_decision_vardelay_foravg_mov

%% SETTINGS

% MAKE SURE CONDITIONS FIT THOSE IN PRT!
% conditions2take = {'saccade_choice_left_mov','saccade_choice_right_mov','saccade_instructed_left_mov','saccade_instructed_right_mov',...
%                    'reach_choice_left_mov','reach_choice_right_mov','reach_instructed_left_mov','reach_instructed_right_mov'};


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

delay_name = {'3' '6' '9' '12' '15'};
avg_name_base = mfilename;
avg_name_suffix = delay_name;

AverageBaselineFrom =  -2 - str2double(delay_name);
AverageBaselineTo   =   0 - str2double(delay_name);
PreInterval         =  13 + str2double(delay_name);
PostInterval        = repmat(3,1,length(conditions2take_all));

