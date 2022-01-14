function ne_era_frd_wrapper_group_level_creation_and_plot
% WHEN PLOTTING, USE MATLAB 2018 or sth around that for nicer looking plots
% and existing functions

%% what to do

create_era_exp_level_average =0;
plot_era_per_delay = 0;
plot_era_average = 0;

plot_era_DIFF_average = 0;
plot_era_DIFF_per_delay = 0;

create_periods = 0;
create_periods_DIFF = 1;
%%

load('Y:\MRI\Human\fMRI-reach-decision\Experiment\behavioral_data\protocols_v2.mat');
%prot = prot(strcmp('ANEL',{prot.name}));

%% settings
runpath = 'Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI';
%runpath = 'Y:\MRI\Human\fMRI-reach-decision\Experiment\testground\test averaging era subjects';

era_model_name = 'mat2prt_reach_decision_vardelay_foravg_MEM'; % place where era files are stored (not necessarily the same place where avg files are stored, not to confuse vois from cue and memory period)

era_outliers = '_no_outliers'; % ''
voi_side = {'lh', 'rh'}; % order has to fit with voi_name

%% stats average curves

periods_win     = [4 7];
periods_name    = {'early'};
periods_end_aligned  = [0]; % if 1 it counts backwards from last entry of era.timeaxis

periods_per_trial    = 0;

%% stats choice effect (DIFF) 

periods_diff_win            = [4  7;
                               -2 -0.5]; % e.g. delay 9 -->  [7 8.5]
periods_diff_name           = {'early','late'};
periods_diff_end_aligned    = [0 1]; % if 1 it counts backwards from last entry of era.timeaxis

diff_which_difference         = 'choi_instr'; % put only one combi into function --> has to fit with the name in era.diff.name
diff_average_which_conditions = {'sac_left','sac_right';'reach_left','reach_right'}; % has to fit with the name in era.diff.dat.cond --> columns are averaged, per row
diff_new_cond_name            = {'sac';'reach'}; % in rows, according to the rows in average_which_conditions



%% create era average across subjects

if create_era_exp_level_average
    
    trigger = {'cue', 'mov'};
    delay = {'3','6','9','12','15','average'};
    
    for d = 1:length(delay)
        
        for t = 1:length(trigger)
            
            for vs= 1:length(voi_side)
                
                for i = 1:length(prot)
                    
                    era_files{i} = [runpath filesep prot(i).name filesep era_model_name filesep prot(i).name '_era_' trigger{t} '_' delay{d} '_' voi_side{vs} era_outliers '.mat'];
                    
                end
                
                era = ne_era_frd_create_grp_level_files(era_files);
                
                save_folder = [runpath filesep era_model_name];
                if ~exist(save_folder)
                    mkdir(save_folder);
                end
                    
                save(         [save_folder filesep 'Exp_era_' trigger{t} '_' delay{d} '_'  voi_side{vs} era_outliers '.mat'] ,'era')
                disp(['saved ' save_folder filesep 'Exp_era_' trigger{t} '_' delay{d} '_'  voi_side{vs} era_outliers '.mat']);
           
            end
        end
    end
end
%% plotting eras average

if plot_era_average
    
    disp('+++++ processing plot_era_average');
    
    subject = 'Exp';
     
        for vs = 1:length(voi_side)

            era_files = findfiles([runpath filesep era_model_name],['*era*average*' voi_side{vs} '*' era_outliers '*.mat'],'depth=1');
            

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
        
        era_files = findfiles([runpath filesep era_model_name],['*era*' voi_side{vs} '*' era_outliers '*.mat'],'depth=1');
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
            
            era_files = findfiles([runpath filesep era_model_name],['*era*average*' voi_side{vs} '*' era_outliers '*.mat'],'depth=1');
            

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
        
        era_files = findfiles([runpath filesep era_model_name],['*era*' voi_side{vs} '*' era_outliers '*.mat'],'depth=1');
        era_files = era_files(find(cellfun(@isempty,strfind(era_files,'average')))); %discard average mats
        
        %era_files contains all cue and movement triggered delays (N=10)
        
        if ~exist([runpath filesep 'plots' filesep 'choice-instr'])
            mkdir([runpath filesep 'plots' filesep 'choice-instr']); 
        end
        
        ne_era_frd_plot_differences(era_files,subject,cond_diff,1,0,[runpath filesep 'plots' filesep 'choice-instr'],1)
        
    end
end

%% create statistics diff choice effect

if create_periods
    
    disp('+++++ processing create_periods');
    
    
    % get era files from the correct model folder of each subject
    era_files = {};
    for i = 1:length(prot)
        
       sub_era_files = findfiles([runpath filesep prot(i).name filesep era_model_name],['*era_cue*' era_outliers '*.mat'],'depth=1');
       era_files = {era_files; sub_era_files};
       
    end
    
    [tt] = ne_era_frd_periods(era_files,periods_win,periods_name,periods_end_aligned,periods_per_trial);

    
    if ~exist([runpath filesep 'stats'])
        mkdir([runpath filesep 'stats']);
    end

    save([runpath filesep 'stats' filesep 'Exp_era_period_average.mat'],'tt')
    writetable(tt,[runpath filesep 'stats' filesep 'Exp_era_period_average.csv'])    

end

%% create statistics diff choice effect

if create_periods_DIFF
    
    disp('+++++ processing create_periods_DIFF');
    
    % get era files from the correct model folder of each subject
    era_files = {};
    for i = 1:length(prot)
        
       sub_era_files = findfiles([runpath filesep prot(i).name filesep era_model_name],['*era_cue*' era_outliers '*.mat'],'depth=1');
       era_files = {era_files; sub_era_files};
       
    end
    
    era_files = era_files(find(cellfun(@isempty,strfind(era_files,'average')))); %discard average mats
    era_files = era_files(find(cellfun(@isempty,strfind(era_files,'cue_3')))); %discard 3 mats
    era_files = era_files(find(cellfun(@isempty,strfind(era_files,'cue_6')))); %discard 6 mats
    
    
    [tt,tt_no_del] = ne_era_frd_periods_diff(era_files,periods_diff_win,periods_diff_name,periods_diff_end_aligned,diff_which_difference,diff_average_which_conditions,diff_new_cond_name);

    
    if ~exist([runpath filesep 'stats'])
        mkdir([runpath filesep 'stats']);
    end

    save([runpath filesep 'stats' filesep 'Exp_era_period_diff_' which_difference '.mat'],'tt','tt_no_del')
    writetable(tt,[runpath filesep 'stats' filesep 'Exp_era_period_diff_' which_difference '.csv'])    
    writetable(tt_no_del,[runpath filesep 'stats' filesep 'Exp_era_period_diff_' which_difference '_no_delay.csv']) 
end
end
