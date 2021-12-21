function ne_era_frd_wrapper_group_level_creation_and_plot
% WHEN PLOTTING, USE MATLAB 2018 or sth around that for nicer looking plots
% and existing functions

%% what to do

create_era_exp_level_average =0;
plot_era_per_delay = 0;
plot_era_average = 0;

plot_era_DIFF_average = 0;
plot_era_DIFF_per_delay = 1;

create_stats_average = 0;
create_stats_DIFF = 0;
%%

load('Y:\MRI\Human\fMRI-reach-decision\Experiment\behavioral_data\protocols_v2.mat');
%prot = prot(strcmp('ANEL',{prot.name}));

%% settings
runpath = 'Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI';
%runpath = 'Y:\MRI\Human\fMRI-reach-decision\Experiment\testground\test averaging era subjects';

era_outliers = '_no_outliers'; % ''
voi_side = {'lh', 'rh'}; % order has to fit with voi_name

%% stats average curves

windows_average      = [4 7];
windows_name_average = {'early'};
end_aligned_average  = [0]; % if 0 it counts backwards from last entry of era.timeaxis
per_trial_average    = 0 ;

%% stats choice effect (DIFF) 

windows_diff      = [4  7;
                    -2 -0.5];% delay 9 -->  [7 8.5]
windows_name_diff = {'early','late'};
end_aligned_diff  = [0 1]; % if 0 it counts backwards from last entry of era.timeaxis

which_difference_diff         = 'choi_instr'; % put only one combi into function --> has to fit with the name in era.diff.name
average_which_conditions_diff = {'sac_left','sac_right';'reach_left','reach_right'}; % has to fit with the name in era.diff.dat.cond --> columns are averaged, per row
new_cond_name_diff            = {'sac';'reach'}; % in rows, according to the rows in average_which_conditions



%% create era average across subjects

if create_era_exp_level_average
    
    trigger = {'cue', 'mov'};
    delay = {'3','6','9','12','15','average'};
    voi_side = {'lh', 'rh'};
    
    for d = 1:length(delay)
        
        for t = 1:length(trigger)
            
            for vs= 1:length(voi_side)
                
                for i = 1:length(prot)
                    
                    era_files{i} = [runpath filesep prot(i).name filesep 'mat2prt_reach_decision_vardelay_foravg' filesep prot(i).name '_era_' trigger{t} '_' delay{d} '_' voi_side{vs} era_outliers '.mat'];
                    
                end
                
                era = ne_era_frd_create_grp_level_files(era_files);

                save([runpath filesep 'mat2prt_reach_decision_vardelay_foravg' filesep 'Exp_era_' trigger{t} '_' delay{d} '_'  voi_side{vs} era_outliers '.mat'] ,'era')
                disp(['saved ' runpath filesep 'mat2prt_reach_decision_vardelay_foravg' filesep 'Exp_era_' trigger{t} '_' delay{d} '_'  voi_side{vs} era_outliers '.mat']);
           
            end
        end
    end
end
%% plotting eras average

if plot_era_average
    
    disp('+++++ processing plot_era_average');
    
    subject = 'Exp';
     
        for vs = 1:length(voi_side)

            era_files = findfiles([runpath filesep 'mat2prt_reach_decision_vardelay_foravg'],['*era*average*' voi_side{vs} '*' era_outliers '*.mat'],'depth=1');
            

            if ~exist([runpath filesep 'plots'])
                mkdir([runpath filesep 'plots']); %'Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI\plots'
            end
            
            ne_era_frd_plot_average(era_files,subject,1,1,[runpath filesep 'plots'])
            
        end
   
    
end

%% plotting eras per delay

if plot_era_per_delay
    
    disp('+++++ processing plot_era_per_delay');
    
    subject = 'Exp';
    
    for vs = 1:length(voi_side)
        
        era_files = findfiles([runpath filesep 'mat2prt_reach_decision_vardelay_foravg'],['*era*' voi_side{vs} '*' era_outliers '*.mat'],'depth=1');
        era_files = era_files(find(cellfun(@isempty,strfind(era_files,'average')))); %discard average mats
        
        %era_files contains all cue and movement triggered delays (N=10)
        
        if ~exist([runpath filesep 'plots'])
            mkdir([runpath filesep 'plots']);  
        end
        
        ne_era_frd_plot_per_delay(era_files,subject,1,[runpath filesep 'plots'])
        
    end
end

%% plotting eras DIFF average
if plot_era_DIFF_average
    
    disp('+++++ processing plot_era_DIFF_average');
    subject = 'Exp';
    cond_diff = {'choi', 'instr'}; % mind the format: left minus right, per row: cond_diff = {'choi', 'instr'; 'left', 'right';'reach' 'sac'};

        for vs = 1:length(voi_side)
            
            era_files = findfiles([runpath filesep 'mat2prt_reach_decision_vardelay_foravg'],['*era*average*' voi_side{vs} '*' era_outliers '*.mat'],'depth=1');
            

            if ~exist([runpath filesep 'plots' filesep 'choice-instr'])
                mkdir([runpath filesep 'plots' filesep 'choice-instr']); 
            end
            
            ne_era_frd_plot_differences(era_files,subject,cond_diff,0,1,[runpath filesep 'plots' filesep 'choice-instr'],1)
            
        end
   
    
end
%% plotting era DIFF per delay
if plot_era_DIFF_per_delay
    
    disp('+++++ processing plot_era_DIFF_per_delay');
    
    subject = 'Exp';
    cond_diff = {'choi', 'instr'}; % mind the format: left minus right, per row: cond_diff = {'choi', 'instr'; 'left', 'right';'reach' 'sac'};

    for vs = 1:length(voi_side)
        
        era_files = findfiles([runpath filesep 'mat2prt_reach_decision_vardelay_foravg'],['*era*' voi_side{vs} '*' era_outliers '*.mat'],'depth=1');
        era_files = era_files(find(cellfun(@isempty,strfind(era_files,'average')))); %discard average mats
        
        %era_files contains all cue and movement triggered delays (N=10)
        
        if ~exist([runpath filesep 'plots' filesep 'choice-instr'])
            mkdir([runpath filesep 'plots' filesep 'choice-instr']); 
        end
        
        ne_era_frd_plot_differences(era_files,subject,cond_diff,1,0,[runpath filesep 'plots' filesep 'choice-instr'],1)
        
    end
end

%% create statistics diff choice effect

if create_stats_average
    
    disp('+++++ processing create_stats_average');
    
    
    era_files = findfiles([runpath],['*era_cue_average*' era_outliers '*.mat'],'depth=3');

    [tt] = ne_era_frd_periods_average_v2(era_files,windows_average,windows_name_average,end_aligned_average,per_trial_average);

    
    if ~exist([runpath filesep 'stats'])
        mkdir([runpath filesep 'stats']);
    end

    save([runpath filesep 'stats' filesep 'Exp_era_period_average.mat'],'tt')
    writetable(tt,[runpath filesep 'stats' filesep 'Exp_era_period_average.csv'])    

end

%% create statistics diff choice effect

if create_stats_DIFF
    
    disp('+++++ processing create_stats_DIFF');
    
    
    era_files = findfiles([runpath],['*era_cue*' era_outliers '*.mat'],'depth=3');
    
    era_files = era_files(find(cellfun(@isempty,strfind(era_files,'average')))); %discard average mats
    era_files = era_files(find(cellfun(@isempty,strfind(era_files,'cue_3')))); %discard 3 mats
    era_files = era_files(find(cellfun(@isempty,strfind(era_files,'cue_6')))); %discard 6 mats
    
    
    [tt,tt_no_del] = ne_era_frd_stats_choice_signal(era_files,windows_diff,windows_name_diff,end_aligned_diff,which_difference_diff,average_which_conditions_diff,new_cond_name_diff);

    
    if ~exist([runpath filesep 'stats'])
        mkdir([runpath filesep 'stats']);
    end

    save([runpath filesep 'stats' filesep 'Exp_era_period_diff_' which_difference '.mat'],'tt','tt_no_del')
    writetable(tt,[runpath filesep 'stats' filesep 'Exp_era_period_diff_' which_difference '.csv'])    
    writetable(tt_no_del,[runpath filesep 'stats' filesep 'Exp_era_period_diff_' which_difference '_no_delay.csv']) 
end
end
