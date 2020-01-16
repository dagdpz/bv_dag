function prt_fname = mat2prt_reach_decision_pilot_v3_vardelay(mat_file, run_name)
% Peter's thesis on reach decisions
% v2: added ITI and ABORT predictors
% v3: added variable delay

if nargin < 2,
    run_name = '';
end

% mat_file = ('Y:\Personal\Peter\Data\MAPA\20190808\MAPA_2019-08-08_03.mat')
% mat_file = ('Y:\Personal\Peter\Data\IVSK\20190620\IVSK2019-06-20_17.mat')
% run_name = '';

[pathname,filename,ext] = fileparts(mat_file);
load(mat_file, '-mat');

%% task timing parameters

cue_onset_delay = 0; %cue is roughly 200 ms long (sometimes 214, 213 etc.)
cue_offset_delay = 800;

% duration of memory period in ms, starting from 7 s after beginning of memory: -> [onset + 7000 onset, lasting 14000]
mem_3_onset_delay = 1000; % length: 1s
mem_3_offset_delay = -1000;

mem_6_onset_delay = 2500; % length: 2.5s
mem_6_offset_delay = -1000;

mem_9_onset_delay = 4000; % length: 4s
mem_9_offset_delay = -1000;

mem_12_onset_delay = 5500; %length: 5.5s
mem_12_offset_delay = -1000;

mem_15_onset_delay = 7000; % length: 7s
mem_15_offset_delay = -1000;

% [onset of state 9 onset of state 10 + 200 ms] (you add 200 ms
% because of estimated longer duration to reach the final destination in
% the target (state 10 starts when crossing the border of the target)
mov_onset_delay = 0;
mov_offset_delay = 200;


ITI_onset_delay = 0;
ITI_offset_delay = 0;

aborted_onset_delay = 0;
aborted_offset_delay = 0;
%% this is manual part - defining condition names and etc.

NrofPreds = 3*8*5+1+1; % 3 events of interest, 8 trial types, 5 delays + 1 ITI + 1 aborted


%% CHANGE "TRIAL" TO GET conditions

[trial.target_chosen] = deal([]); % preallocate trial.target_chosen
[trial.choice] = deal([]);
[trial.eff_name] = deal([]);
[trial([trial.effector]==3).eff_name] = deal({'sac'});
[trial([trial.effector]==4).eff_name] = deal({'reach'});
[trial.delay] = deal([]);


for k = 1 : length(trial)
    
    % defining, what choice trials are
    if trial(k).task.correct_choice_target == [1 2]
        trial(k).choice = {'choi'};
    elseif trial(k).task.correct_choice_target == 1
        trial(k).choice = {'instr'};
    end
    
    
    % target chosen
    if ~isnan(trial(k).target_selected)
        
        if trial(k).effector == 3 % get only saccade trials
            whichtarget = trial(k).target_selected(1); % here in saccade trials pic the number (can be 1 or 2) which is FIRST in target_selected (because it is for saccades)
            
            if       trial(k).eye.tar(whichtarget).pos(1) < 0
                trial(k).target_chosen = {'l'};
            elseif   trial(k).eye.tar(whichtarget).pos(1) > 0
                trial(k).target_chosen = {'r'};
            end
            
        elseif trial(k).effector == 4 % get only reach trials
            whichtarget = trial(k).target_selected(2); % here in reach trials pic the number (its value can be 1 or 2) which is SECOND in target_selected (because it is for reaches)
            
            if       trial(k).hnd.tar(whichtarget).pos(1) < 0
                trial(k).target_chosen = {'l'};
            elseif   trial(k).hnd.tar(whichtarget).pos(1) > 0
                trial(k).target_chosen = {'r'};
            end
        end % if for which effector
        
    else
        trial(k).target_chosen = {'none'};
        
    end  % if for chosen target
    
    % which delay
    switch trial(k).task.timing.mem_time_hold;
        
        case 3
            trial(k).delay = {'3'};
        case 6
            trial(k).delay = {'6'};
        case 9
            trial(k).delay = {'9'};    
        case 12
            trial(k).delay = {'12'};
        case 15
            trial(k).delay = {'15'};
            
    end
end


%% COLORS

% https://docplayer.org/docs-images/54/34504262/images/3-0.png
% https://www.rapidtables.com/web/color/RGB_Color.html
% https://pinetools.com/lighten-color

%% +++++ EYE/SACCADE ++++++

%% saccade CHOICE LEFT - red

% 'sac_choi_left_cue'
prtpreds(1).name = {'sac_choi_l_3_cue'};
prtpreds(1).r = 255;
prtpreds(1).g = 7;
prtpreds(1).b = 5;

% 'eye_choice_left_cue'
prtpreds(2).name = {'sac_choi_l_6_cue'};
prtpreds(2).r = 255;
prtpreds(2).g = 7;
prtpreds(2).b = 5;

% 'eye_choice_left_cue'
prtpreds(3).name = {'sac_choi_l_9_cue'};
prtpreds(3).r = 255;
prtpreds(3).g = 7;
prtpreds(3).b = 5;

% 'eye_choice_left_cue'
prtpreds(4).name = {'sac_choi_l_12_cue'};
prtpreds(4).r = 255;
prtpreds(4).g = 7;
prtpreds(4).b = 5;

% 'eye_choice_left_cue'
prtpreds(5).name = {'sac_choi_l_15_cue'};
prtpreds(5).r = 255;
prtpreds(5).g = 7;
prtpreds(5).b = 5;
%%
% 'eye_choice_left_mem'
prtpreds(6).name = {'sac_choi_l_3_mem'};
prtpreds(6).r = 255;
prtpreds(6).g = 7;
prtpreds(6).b = 5;

% 'eye_choice_left_mem'
prtpreds(7).name = {'sac_choi_l_6_mem'};
prtpreds(7).r = 255;
prtpreds(7).g = 7;
prtpreds(7).b = 5;

% 'eye_choice_left_mem'
prtpreds(8).name = {'sac_choi_l_9_mem'};
prtpreds(8).r = 255;
prtpreds(8).g = 7;
prtpreds(8).b = 5;

% 'eye_choice_left_mem'
prtpreds(9).name = {'sac_choi_l_12_mem'};
prtpreds(9).r = 255;
prtpreds(9).g = 7;
prtpreds(9).b = 5;

% 'eye_choice_left_mem'
prtpreds(10).name = {'sac_choi_l_15_mem'};
prtpreds(10).r = 255;
prtpreds(10).g = 7;
prtpreds(10).b = 5;


%%
% 'eye_choice_left_mov'
prtpreds(11).name = {'sac_choi_l_3_mov'};
prtpreds(11).r = 255;
prtpreds(11).g = 7;
prtpreds(11).b = 5;

% 'eye_choice_left_mov'
prtpreds(12).name = {'sac_choi_l_6_mov'};
prtpreds(12).r = 255;
prtpreds(12).g = 7;
prtpreds(12).b = 5;

% 'eye_choice_left_mov'
prtpreds(13).name = {'sac_choi_l_9_mov'};
prtpreds(13).r = 255;
prtpreds(13).g = 7;
prtpreds(13).b = 5;

% 'eye_choice_left_mov'
prtpreds(14).name = {'sac_choi_l_12_mov'};
prtpreds(14).r = 255;
prtpreds(14).g = 7;
prtpreds(14).b = 5;

% 'eye_choice_left_mov'
prtpreds(15).name = {'sac_choi_l_15_mov'};
prtpreds(15).r = 255;
prtpreds(15).g = 7;
prtpreds(15).b = 5;


%% saccade CHOICE RIGHT - orange

% 'eye_choice_right_cue'
prtpreds(16).name = {'sac_choi_r_3_cue'};
prtpreds(16).r = 254;
prtpreds(16).g = 142;
prtpreds(16).b = 14;

% 'eye_choice_right_cue'
prtpreds(17).name = {'sac_choi_r_6_cue'};
prtpreds(17).r = 254;
prtpreds(17).g = 142;
prtpreds(17).b = 14;

% 'eye_choice_right_cue'
prtpreds(18).name = {'sac_choi_r_9_cue'};
prtpreds(18).r = 254;
prtpreds(18).g = 142;
prtpreds(18).b = 14;

% 'eye_choice_right_cue'
prtpreds(19).name = {'sac_choi_r_12_cue'};
prtpreds(19).r = 254;
prtpreds(19).g = 142;
prtpreds(19).b = 14;

% 'eye_choice_right_cue'
prtpreds(20).name = {'sac_choi_r_15_cue'};
prtpreds(20).r = 254;
prtpreds(20).g = 142;
prtpreds(20).b = 14;


%%
% 'eye_choice_right_mem'
prtpreds(21).name = {'sac_choi_r_3_mem'};
prtpreds(21).r = 254;
prtpreds(21).g = 142;
prtpreds(21).b = 14;

% 'eye_choice_right_mem'
prtpreds(22).name = {'sac_choi_r_6_mem'};
prtpreds(22).r = 254;
prtpreds(22).g = 142;
prtpreds(22).b = 14;

% 'eye_choice_right_mem'
prtpreds(23).name = {'sac_choi_r_9_mem'};
prtpreds(23).r = 254;
prtpreds(23).g = 142;
prtpreds(23).b = 14;

% 'eye_choice_right_mem'
prtpreds(24).name = {'sac_choi_r_12_mem'};
prtpreds(24).r = 254;
prtpreds(24).g = 142;
prtpreds(24).b = 14;

% 'eye_choice_right_mem'
prtpreds(25).name = {'sac_choi_r_15_mem'};
prtpreds(25).r = 254;
prtpreds(25).g = 142;
prtpreds(25).b = 14;

%%
% 'eye_choice_right_mov'
prtpreds(26).name = {'sac_choi_r_3_mov'};
prtpreds(26).r = 254;
prtpreds(26).g = 142;
prtpreds(26).b = 14;

% 'eye_choice_right_mov'
prtpreds(27).name = {'sac_choi_r_6_mov'};
prtpreds(27).r = 254;
prtpreds(27).g = 142;
prtpreds(27).b = 14;

% 'eye_choice_right_mov'
prtpreds(28).name = {'sac_choi_r_9_mov'};
prtpreds(28).r = 254;
prtpreds(28).g = 142;
prtpreds(28).b = 14;

% 'eye_choice_right_mov'
prtpreds(29).name = {'sac_choi_r_12_mov'};
prtpreds(29).r = 254;
prtpreds(29).g = 142;
prtpreds(29).b = 14;

% 'eye_choice_right_mov'
prtpreds(30).name = {'sac_choi_r_15_mov'};
prtpreds(30).r = 254;
prtpreds(30).g = 142;
prtpreds(30).b = 14;


%% saccade INSTRUCTED LEFT - violett

% 'eye_instructed_left_cue'
prtpreds(31).name = {'sac_instr_l_3_cue'};
prtpreds(31).r = 124;
prtpreds(31).g = 0;
prtpreds(31).b = 195;

% 'eye_instructed_left_cue'
prtpreds(32).name = {'sac_instr_l_6_cue'};
prtpreds(32).r = 124;
prtpreds(32).g = 0;
prtpreds(32).b = 195;

% 'eye_instructed_left_cue'
prtpreds(33).name = {'sac_instr_l_9_cue'};
prtpreds(33).r = 124;
prtpreds(33).g = 0;
prtpreds(33).b = 195;

% 'eye_instructed_left_cue'
prtpreds(34).name = {'sac_instr_l_12_cue'};
prtpreds(34).r = 124;
prtpreds(34).g = 0;
prtpreds(34).b = 195;

% 'eye_instructed_left_cue'
prtpreds(35).name = {'sac_instr_l_15_cue'};
prtpreds(35).r = 124;
prtpreds(35).g = 0;
prtpreds(35).b = 195;


%%

% 'eye_instructed_left_mem'
prtpreds(36).name = {'sac_instr_l_3_mem'};
prtpreds(36).r = 124;
prtpreds(36).g = 0;
prtpreds(36).b = 195;

% 'eye_instructed_left_mem'
prtpreds(37).name = {'sac_instr_l_6_mem'};
prtpreds(37).r = 124;
prtpreds(37).g = 0;
prtpreds(37).b = 195;

% 'eye_instructed_left_mem'
prtpreds(38).name = {'sac_instr_l_9_mem'};
prtpreds(38).r = 124;
prtpreds(38).g = 0;
prtpreds(38).b = 195;

% 'eye_instructed_left_mem'
prtpreds(39).name = {'sac_instr_l_12_mem'};
prtpreds(39).r = 124;
prtpreds(39).g = 0;
prtpreds(39).b = 195;

% 'eye_instructed_left_mem'
prtpreds(40).name = {'sac_instr_l_15_mem'};
prtpreds(40).r = 124;
prtpreds(40).g = 0;
prtpreds(40).b = 195;


%%
% 'eye_instructed_left_mov'
prtpreds(41).name = {'sac_instr_l_3_mov'};
prtpreds(41).r = 124;
prtpreds(41).g = 0;
prtpreds(41).b = 195;

% 'eye_instructed_left_mov'
prtpreds(42).name = {'sac_instr_l_6_mov'};
prtpreds(42).r = 124;
prtpreds(42).g = 0;
prtpreds(42).b = 195;

% 'eye_instructed_left_mov'
prtpreds(43).name = {'sac_instr_l_9_mov'};
prtpreds(43).r = 124;
prtpreds(43).g = 0;
prtpreds(43).b = 195;

% 'eye_instructed_left_mov'
prtpreds(44).name = {'sac_instr_l_12_mov'};
prtpreds(44).r = 124;
prtpreds(44).g = 0;
prtpreds(44).b = 195;

% 'eye_instructed_left_mov'
prtpreds(45).name = {'sac_instr_l_15_mov'};
prtpreds(45).r = 124;
prtpreds(45).g = 0;
prtpreds(45).b = 195;

%% saccade INSTRUCTED RIGHT - pink

% 'eye_instructed_right_cue'
prtpreds(46).name = {'sac_instr_r_3_cue'};
prtpreds(46).r = 196;
prtpreds(46).g = 3;
prtpreds(46).b = 125;

% 'eye_instructed_right_cue'
prtpreds(47).name = {'sac_instr_r_6_cue'};
prtpreds(47).r = 196;
prtpreds(47).g = 3;
prtpreds(47).b = 125;

% 'eye_instructed_right_cue'
prtpreds(48).name = {'sac_instr_r_9_cue'};
prtpreds(48).r = 196;
prtpreds(48).g = 3;
prtpreds(48).b = 125;

% 'eye_instructed_right_cue'
prtpreds(49).name = {'sac_instr_r_12_cue'};
prtpreds(49).r = 196;
prtpreds(49).g = 3;
prtpreds(49).b = 125;

% 'eye_instructed_right_cue'
prtpreds(50).name = {'sac_instr_r_15_cue'};
prtpreds(50).r = 196;
prtpreds(50).g = 3;
prtpreds(50).b = 125;

%%
% 'eye_instructed_right_mem'
prtpreds(51).name = {'sac_instr_r_3_mem'};
prtpreds(51).r = 196;
prtpreds(51).g = 3;
prtpreds(51).b = 125;

% 'eye_instructed_right_mem'
prtpreds(52).name = {'sac_instr_r_6_mem'};
prtpreds(52).r = 196;
prtpreds(52).g = 3;
prtpreds(52).b = 125;

% 'eye_instructed_right_mem'
prtpreds(53).name = {'sac_instr_r_9_mem'};
prtpreds(53).r = 196;
prtpreds(53).g = 3;
prtpreds(53).b = 125;

% 'eye_instructed_right_mem'
prtpreds(54).name = {'sac_instr_r_12_mem'};
prtpreds(54).r = 196;
prtpreds(54).g = 3;
prtpreds(54).b = 125;

% 'eye_instructed_right_mem'
prtpreds(55).name = {'sac_instr_r_15_mem'};
prtpreds(55).r = 196;
prtpreds(55).g = 3;
prtpreds(55).b = 125;


%%
% 'eye_instructed_right_mov'
prtpreds(56).name = {'sac_instr_r_3_mov'};
prtpreds(56).r = 196;
prtpreds(56).g = 3;
prtpreds(56).b = 125;

% 'eye_instructed_right_mov'
prtpreds(57).name = {'sac_instr_r_6_mov'};
prtpreds(57).r = 196;
prtpreds(57).g = 3;
prtpreds(57).b = 125;

% 'eye_instructed_right_mov'
prtpreds(58).name = {'sac_instr_r_9_mov'};
prtpreds(58).r = 196;
prtpreds(58).g = 3;
prtpreds(58).b = 125;

% 'eye_instructed_right_mov'
prtpreds(59).name = {'sac_instr_r_12_mov'};
prtpreds(59).r = 196;
prtpreds(59).g = 3;
prtpreds(59).b = 125;

% 'eye_instructed_right_mov'
prtpreds(60).name = {'sac_instr_r_15_mov'};
prtpreds(60).r = 196;
prtpreds(60).g = 3;
prtpreds(60).b = 125;

%% +++++ HAND/REACH ++++++

% reach CHOICE LEFT - dark green

% 'hand_choice_left_cue'
prtpreds(61).name = {'reach_choi_l_3_cue'};
prtpreds(61).r = 0;
prtpreds(61).g = 142;
prtpreds(61).b = 91;

% 'hand_choice_left_cue'
prtpreds(62).name = {'reach_choi_l_6_cue'};
prtpreds(62).r = 0;
prtpreds(62).g = 142;
prtpreds(62).b = 91;

% 'hand_choice_left_cue'
prtpreds(63).name = {'reach_choi_l_9_cue'};
prtpreds(63).r = 0;
prtpreds(63).g = 142;
prtpreds(63).b = 91;

% 'hand_choice_left_cue'
prtpreds(64).name = {'reach_choi_l_12_cue'};
prtpreds(64).r = 0;
prtpreds(64).g = 142;
prtpreds(64).b = 91;

% 'hand_choice_left_cue'
prtpreds(65).name = {'reach_choi_l_15_cue'};
prtpreds(65).r = 0;
prtpreds(65).g = 142;
prtpreds(65).b = 91;


%%
% 'hand_choice_left_mem'
prtpreds(66).name = {'reach_choi_l_3_mem'};
prtpreds(66).r = 0;
prtpreds(66).g = 142;
prtpreds(66).b = 91;

% 'hand_choice_left_mem'
prtpreds(67).name = {'reach_choi_l_6_mem'};
prtpreds(67).r = 0;
prtpreds(67).g = 142;
prtpreds(67).b = 91;

% 'hand_choice_left_mem'
prtpreds(68).name = {'reach_choi_l_9_mem'};
prtpreds(68).r = 0;
prtpreds(68).g = 142;
prtpreds(68).b = 91;

% 'hand_choice_left_mem'
prtpreds(69).name = {'reach_choi_l_12_mem'};
prtpreds(69).r = 0;
prtpreds(69).g = 142;
prtpreds(69).b = 91;

% 'hand_choice_left_mem'
prtpreds(70).name = {'reach_choi_l_15_mem'};
prtpreds(70).r = 0;
prtpreds(70).g = 142;
prtpreds(70).b = 91;

%%

% 'hand_choice_left_mov'
prtpreds(71).name = {'reach_choi_l_3_mov'};
prtpreds(71).r = 0;
prtpreds(71).g = 142;
prtpreds(71).b = 91;

% 'hand_choice_left_mov'
prtpreds(72).name = {'reach_choi_l_6_mov'};
prtpreds(72).r = 0;
prtpreds(72).g = 142;
prtpreds(72).b = 91;

% 'hand_choice_left_mov'
prtpreds(73).name = {'reach_choi_l_9_mov'};
prtpreds(73).r = 0;
prtpreds(73).g = 142;
prtpreds(73).b = 91;

% 'hand_choice_left_mov'
prtpreds(74).name = {'reach_choi_l_12_mov'};
prtpreds(74).r = 0;
prtpreds(74).g = 142;
prtpreds(74).b = 91;

% 'hand_choice_left_mov'
prtpreds(75).name = {'reach_choi_l_15_mov'};
prtpreds(75).r = 0;
prtpreds(75).g = 142;
prtpreds(75).b = 91;

%% reach CHOICE RIGHT - light green

% 'hand_choice_right_cue'
prtpreds(76).name = {'reach_choi_r_3_cue'};
prtpreds(76).r = 138;
prtpreds(76).g = 202;
prtpreds(76).b = 0;

% 'hand_choice_right_cue'
prtpreds(77).name = {'reach_choi_r_6_cue'};
prtpreds(77).r = 138;
prtpreds(77).g = 202;
prtpreds(77).b = 0;

% 'hand_choice_right_cue'
prtpreds(78).name = {'reach_choi_r_9_cue'};
prtpreds(78).r = 138;
prtpreds(78).g = 202;
prtpreds(78).b = 0;

% 'hand_choice_right_cue'
prtpreds(79).name = {'reach_choi_r_12_cue'};
prtpreds(79).r = 138;
prtpreds(79).g = 202;
prtpreds(79).b = 0;

% 'hand_choice_right_cue'
prtpreds(80).name = {'reach_choi_r_15_cue'};
prtpreds(80).r = 138;
prtpreds(80).g = 202;
prtpreds(80).b = 0;


%%
% 'hand_choice_right_mem'
prtpreds(81).name = {'reach_choi_r_3_mem'};
prtpreds(81).r = 138;
prtpreds(81).g = 202;
prtpreds(81).b = 0;

% 'hand_choice_right_mem'
prtpreds(82).name = {'reach_choi_r_6_mem'};
prtpreds(82).r = 138;
prtpreds(82).g = 202;
prtpreds(82).b = 0;

% 'hand_choice_right_mem'
prtpreds(83).name = {'reach_choi_r_9_mem'};
prtpreds(83).r = 138;
prtpreds(83).g = 202;
prtpreds(83).b = 0;

% 'hand_choice_right_mem'
prtpreds(84).name = {'reach_choi_r_12_mem'};
prtpreds(84).r = 138;
prtpreds(84).g = 202;
prtpreds(84).b = 0;

% 'hand_choice_right_mem'
prtpreds(85).name = {'reach_choi_r_15_mem'};
prtpreds(85).r = 138;
prtpreds(85).g = 202;
prtpreds(85).b = 0;

%%
% 'hand_choice_right_mov'
prtpreds(86).name = {'reach_choi_r_3_mov'};
prtpreds(86).r = 138;
prtpreds(86).g = 202;
prtpreds(86).b = 0;

% 'hand_choice_right_mov'
prtpreds(87).name = {'reach_choi_r_6_mov'};
prtpreds(87).r = 138;
prtpreds(87).g = 202;
prtpreds(87).b = 0;

% 'hand_choice_right_mov'
prtpreds(88).name = {'reach_choi_r_9_mov'};
prtpreds(88).r = 138;
prtpreds(88).g = 202;
prtpreds(88).b = 0;

% 'hand_choice_right_mov'
prtpreds(89).name = {'reach_choi_r_12_mov'};
prtpreds(89).r = 138;
prtpreds(89).g = 202;
prtpreds(89).b = 0;

% 'hand_choice_right_mov'
prtpreds(90).name = {'reach_choi_r_15_mov'};
prtpreds(90).r = 138;
prtpreds(90).g = 202;
prtpreds(90).b = 0;

%% reach INSTRUCTED LEFT - dark blue

% 'hand_instructed_left_cue'
prtpreds(91).name = {'reach_instr_l_3_cue'};
prtpreds(91).r = 0;
prtpreds(91).g = 115;
prtpreds(91).b = 218;

% 'hand_instructed_left_cue'
prtpreds(92).name = {'reach_instr_l_6_cue'};
prtpreds(92).r = 0;
prtpreds(92).g = 115;
prtpreds(92).b = 218;

% 'hand_instructed_left_cue'
prtpreds(93).name = {'reach_instr_l_9_cue'};
prtpreds(93).r = 0;
prtpreds(93).g = 115;
prtpreds(93).b = 218;

% 'hand_instructed_left_cue'
prtpreds(94).name = {'reach_instr_l_12_cue'};
prtpreds(94).r = 0;
prtpreds(94).g = 115;
prtpreds(94).b = 218;

% 'hand_instructed_left_cue'
prtpreds(95).name = {'reach_instr_l_15_cue'};
prtpreds(95).r = 0;
prtpreds(95).g = 115;
prtpreds(95).b = 218;


%%
% 'hand_instructed_left_mem'
prtpreds(96).name = {'reach_instr_l_3_mem'};
prtpreds(96).r = 0;
prtpreds(96).g = 115;
prtpreds(96).b = 218;

% 'hand_instructed_left_mem'
prtpreds(97).name = {'reach_instr_l_6_mem'};
prtpreds(97).r = 0;
prtpreds(97).g = 115;
prtpreds(97).b = 218;

% 'hand_instructed_left_mem'
prtpreds(98).name = {'reach_instr_l_9_mem'};
prtpreds(98).r = 0;
prtpreds(98).g = 115;
prtpreds(98).b = 218;

% 'hand_instructed_left_mem'
prtpreds(99).name = {'reach_instr_l_12_mem'};
prtpreds(99).r = 0;
prtpreds(99).g = 115;
prtpreds(99).b = 218;

% 'hand_instructed_left_mem'
prtpreds(100).name = {'reach_instr_l_15_mem'};
prtpreds(100).r = 0;
prtpreds(100).g = 115;
prtpreds(100).b = 218;


%%
% 'hand_instructed_left_mov'
prtpreds(101).name = {'reach_instr_l_3_mov'};
prtpreds(101).r = 0;
prtpreds(101).g = 115;
prtpreds(101).b = 218;

% 'hand_instructed_left_mov'
prtpreds(102).name = {'reach_instr_l_6_mov'};
prtpreds(102).r = 0;
prtpreds(102).g = 115;
prtpreds(102).b = 218;

% 'hand_instructed_left_mov'
prtpreds(103).name = {'reach_instr_l_9_mov'};
prtpreds(103).r = 0;
prtpreds(103).g = 115;
prtpreds(103).b = 218;

% 'hand_instructed_left_mov'
prtpreds(104).name = {'reach_instr_l_12_mov'};
prtpreds(104).r = 0;
prtpreds(104).g = 115;
prtpreds(104).b = 218;

% 'hand_instructed_left_mov'
prtpreds(105).name = {'reach_instr_l_15_mov'};
prtpreds(105).r = 0;
prtpreds(105).g = 115;
prtpreds(105).b = 218;

%% reach INSTRUCTED RIGHT - light blue

% 'hand_instructed_right_cue'
prtpreds(106).name = {'reach_instr_r_3_cue'};
prtpreds(106).r = 0;
prtpreds(106).g = 190;
prtpreds(106).b = 240;

% 'hand_instructed_right_cue'
prtpreds(107).name = {'reach_instr_r_6_cue'};
prtpreds(107).r = 0;
prtpreds(107).g = 190;
prtpreds(107).b = 240;

% 'hand_instructed_right_cue'
prtpreds(108).name = {'reach_instr_r_9_cue'};
prtpreds(108).r = 0;
prtpreds(108).g = 190;
prtpreds(108).b = 240;

% 'hand_instructed_right_cue'
prtpreds(109).name = {'reach_instr_r_12_cue'};
prtpreds(109).r = 0;
prtpreds(109).g = 190;
prtpreds(109).b = 240;

% 'hand_instructed_right_cue'
prtpreds(110).name = {'reach_instr_r_15_cue'};
prtpreds(110).r = 0;
prtpreds(110).g = 190;
prtpreds(110).b = 240;


%%
% 'hand_instructed_right_mem'
prtpreds(111).name = {'reach_instr_r_3_mem'};
prtpreds(111).r = 0;
prtpreds(111).g = 190;
prtpreds(111).b = 240;

% 'hand_instructed_right_mem'
prtpreds(112).name = {'reach_instr_r_6_mem'};
prtpreds(112).r = 0;
prtpreds(112).g = 190;
prtpreds(112).b = 240;

% 'hand_instructed_right_mem'
prtpreds(113).name = {'reach_instr_r_9_mem'};
prtpreds(113).r = 0;
prtpreds(113).g = 190;
prtpreds(113).b = 240;

% 'hand_instructed_right_mem'
prtpreds(114).name = {'reach_instr_r_12_mem'};
prtpreds(114).r = 0;
prtpreds(114).g = 190;
prtpreds(114).b = 240;

% 'hand_instructed_right_mem'
prtpreds(115).name = {'reach_instr_r_15_mem'};
prtpreds(115).r = 0;
prtpreds(115).g = 190;
prtpreds(115).b = 240;


%%
% 'hand_instructed_right_mov'
prtpreds(116).name = {'reach_instr_r_3_mov'};
prtpreds(116).r = 0;
prtpreds(116).g = 190;
prtpreds(116).b = 240;

% 'hand_instructed_right_mov'
prtpreds(117).name = {'reach_instr_r_6_mov'};
prtpreds(117).r = 0;
prtpreds(117).g = 190;
prtpreds(117).b = 240;

% 'hand_instructed_right_mov'
prtpreds(118).name = {'reach_instr_r_9_mov'};
prtpreds(118).r = 0;
prtpreds(118).g = 190;
prtpreds(118).b = 240;

% 'hand_instructed_right_mov'
prtpreds(119).name = {'reach_instr_r_12_mov'};
prtpreds(119).r = 0;
prtpreds(119).g = 190;
prtpreds(119).b = 240;

% 'hand_instructed_right_mov'
prtpreds(120).name = {'reach_instr_r_15_mov'};
prtpreds(120).r = 0;
prtpreds(120).g = 190;
prtpreds(120).b = 240;


%%
% 'ITI'
prtpreds(121).name = {'ITI'};
prtpreds(121).r = 220;
prtpreds(121).g = 220;
prtpreds(121).b = 220;

% aborted trials
prtpreds(122).name = {'aborted'};
prtpreds(122).r = 128;
prtpreds(122).g = 128;
prtpreds(122).b = 128;

%% GET ONSETS AND OFFSETS AND PUT THEM IN PRTPREDS

eff = {'sac' 'reach'};
cho = {'choi' 'instr'};
sid = {'l' 'r'}; % leaving out none
del = {'3' '6' '9' '12' '15'};
pha = {'cue' 'mem' 'mov'};



% [prtpreds(1:NrofPreds).n_correct_trials] = deal([]); % empty array to be filled in cumulatively
[prtpreds(1:NrofPreds).onset] = deal([]);
[prtpreds(1:NrofPreds).offset] = deal([]);


for i = 1:length(eff)
    
    for k = 1:length(cho)
        
        for l = 1:length(sid)
            
            for d = 1:length(del)
            
            for m = 1:length(pha)
                
                
                % filter out all trials with respective combined condition
                temp = trial(...
                    [trial.success]       == 1      & ...
                    strcmp(eff(i),[trial.eff_name]) & ...
                    strcmp(cho(k),[trial.choice])   & ...
                    strcmp(del(d),[trial.delay])    & ...
                    strcmp(sid(l),[trial.target_chosen]) );
                
                % create temporary name out of loop inputs to compare with
                % hard coded name from prtpreds from above
                temp_name = cellstr(strcat(eff(i),'_', cho(k),'_',sid(l),'_',del(d),'_',pha(m)));
                temp_index = strcmp(temp_name,[prtpreds.name]);
                
                % get the onsets for the respective phase
                onset_times = [temp.states_onset];
                
                
                if     strcmp('cue',pha(m))
                    
                    if isempty(temp)
                        prtpreds(temp_index).onset  = [];
                        prtpreds(temp_index).offset = [];
                        
                    else
                        onset_idx = [temp.states] == 6;
                        offset_idx = [temp.states] == 7;
                        
                        prtpreds(temp_index).onset  = round(onset_times(onset_idx)*1000)  + cue_onset_delay;
                        prtpreds(temp_index).offset = round(onset_times(offset_idx)*1000) + cue_offset_delay;
                    end
                    
                    
                elseif strcmp('mem',pha(m))
                    
                    if isempty(temp)
                        prtpreds(temp_index).onset  = [];
                        prtpreds(temp_index).offset = [];
                        
                    else
                        onset_idx = [temp.states] == 7;
                        offset_idx = [temp.states] == 9;
                        
                        if strcmp('3',del(d))
                            prtpreds(temp_index).onset  = round(onset_times(onset_idx)*1000)  + mem_3_onset_delay;
                            prtpreds(temp_index).offset = round(onset_times(offset_idx)*1000) + mem_3_offset_delay;
                            
                        elseif strcmp('6',del(d))
                            prtpreds(temp_index).onset  = round(onset_times(onset_idx)*1000)  + mem_6_onset_delay;
                            prtpreds(temp_index).offset = round(onset_times(offset_idx)*1000) + mem_6_offset_delay;
                                                       
                        elseif strcmp('9',del(d))
                            prtpreds(temp_index).onset  = round(onset_times(onset_idx)*1000)  + mem_9_onset_delay;
                            prtpreds(temp_index).offset = round(onset_times(offset_idx)*1000) + mem_9_offset_delay;
                            
                        elseif strcmp('12',del(d))
                            prtpreds(temp_index).onset  = round(onset_times(onset_idx)*1000)  + mem_12_onset_delay;
                            prtpreds(temp_index).offset = round(onset_times(offset_idx)*1000) + mem_12_offset_delay;
                            
                        elseif strcmp('15',del(d))
                            prtpreds(temp_index).onset  = round(onset_times(onset_idx)*1000)  + mem_15_onset_delay;
                            prtpreds(temp_index).offset = round(onset_times(offset_idx)*1000) + mem_15_offset_delay;
                            
                        end
                    end
                    
                    
                elseif strcmp('mov',pha(m))
                    
                    if isempty(temp)
                        prtpreds(temp_index).onset  = [];
                        prtpreds(temp_index).offset = [];
                        
                    else
                        onset_idx = [temp.states] == 9;
                        offset_idx = [temp.states] == 10;
                        
                        prtpreds(temp_index).onset  = round(onset_times(onset_idx)*1000) + mov_onset_delay;
                        prtpreds(temp_index).offset = round(onset_times(offset_idx)*1000) + mov_offset_delay;
                    end
                    
                end %if state of which phase of the trial
                
                
            end % loop phase
            end % loop delay
        end % loop side of target (left/right)
    end % loop choice
end % loop effector


%temp = trial([trial.success] == 0);



%% Add ITI Onsets and Offsets

ITI_onset = [];
ITI_offset = [];

for i = 1:length(trial) %loop over trials to get the ITI (state 50) onsets and offsets
    
    ITI_samples = trial(i).tSample_from_time_start(trial(i).state == 50);
    
    ITI_onset  = [ITI_onset ITI_samples(1)]; % first one of ITI
    ITI_offset = [ITI_offset ITI_samples(end)]; % last one of ITI
    
end

% convert to mili seconds and add variable delay (see beginning of file)
prtpreds(strcmp('ITI',[prtpreds.name])).onset  = round(ITI_onset *1000) + ITI_onset_delay;
prtpreds(strcmp('ITI',[prtpreds.name])).offset = round(ITI_offset*1000) + ITI_offset_delay;


%% Add Aborted Onsets and Offsets

aborted_onset = [];
aborted_offset = [];
temp_aborted = trial([trial.success] == 0);

for i = 1:length(temp_aborted) % loop over unsuccessful trials to get the a vector with every timestamp from the trial, but not the ITI 
    
    aborted_cue = temp_aborted(i).states_onset(temp_aborted(i).states == 6);
    
    if isempty(aborted_cue) % if error occured before onset of the cue, no aborted trial has to be modeled, so skip it
        continue;
    end
    
    aborted_samples = temp_aborted(i).tSample_from_time_start(temp_aborted(i).state ~= 50);
    
    aborted_onset  = [aborted_onset aborted_cue]; 
    aborted_offset = [aborted_offset aborted_samples(end)]; % last one before ITI
    
end

% convert to mili seconds and add variable delay (see beginning of file)
prtpreds(strcmp('aborted',[prtpreds.name])).onset  = round(aborted_onset *1000) + aborted_onset_delay;
prtpreds(strcmp('aborted',[prtpreds.name])).offset = round(aborted_offset*1000) + aborted_offset_delay;



%%
for i = 1:length(prtpreds)
    prtpreds(i).name = char(prtpreds(i).name );
end


%% create PRT file

if isempty(run_name)
    prt_fname = [pathname filesep filename  '.prt'];
else
    prt_fname = [pathname filesep filename(1:end-2) run_name '.prt'];
end

fid = fopen(prt_fname,'w');

fprintf(fid,'\n');

fprintf(fid,'FileVersion:\t%d\n\n',3);

fprintf(fid,'ResolutionOfTime:\t%s\n\n','msec');

fprintf(fid,'Experiment:\t%s\n\n',filename);

fprintf(fid,'BackgroundColor:\t%d %d %d\n',0,0,0);
fprintf(fid,'TextColor:\t%d %d %d\n',255,255,255);
fprintf(fid,'TimeCourseColor:\t%d %d %d\n',255,255,255);
fprintf(fid,'TimeCourseThick:\t%d\n',3);
fprintf(fid,'ReferenceFuncColor:\t%d %d %d\n',0,0,80);
fprintf(fid,'ReferenceFuncThick:\t%d\n\n',3);

fprintf(fid,'NrOfConditions:\t%d\n\n',NrofPreds );


for cond = 1:NrofPreds,
    
    fprintf(fid,'%s\n',prtpreds(cond).name);
    fprintf(fid,'%d\n',length(prtpreds(cond).onset)); % (prtpreds(k).onset) = row with onset times of condition i (line 51)
    
    for rep = 1:length(prtpreds(cond).onset) % for each repetition of one condition
        fprintf(fid,' %d \t %d \n', (prtpreds(cond).onset(rep)), (prtpreds(cond).offset(rep)));
    end
    
    fprintf(fid,'Color: %d %d %d\n\n',prtpreds(cond).r, prtpreds(cond).g, prtpreds(cond).b);
end

fclose(fid);

disp(['Protocol ' prt_fname ' saved']);