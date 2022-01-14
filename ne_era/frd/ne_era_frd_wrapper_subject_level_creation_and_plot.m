function ne_era_frd_wrapper_subject_level_creation_and_plot

%% what to do

create_era_per_delay    = 1;
create_delay_average    = 0; 
create_era_binned       = 0;
create_era_diff_timecourses = 0;

plot_era_per_delay      = 0;
plot_era_average        = 0;

%%

load('Y:\MRI\Human\fMRI-reach-decision\Experiment\behavioral_data\protocols_v2.mat');
%prot = prot(strcmp('ANRE',{prot.name}));

%% settings
%runpath = 'Y:\MRI\Human\fMRI-reach-decision\Experiment\testground\test averaging era subjects';
runpath         = 'Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI';

% +++++++ ERA CREATION +++++++
era_model_name = 'mat2prt_reach_decision_vardelay_foravg_MEM';% 'mat2prt_reach_decision_vardelay_foravg' % place where era files are stored (not necessarily the same place where avg files are stored, not to confuse vois from cue and memory period)

tc_interpolate  = 100;
avg_outliers    = '_no_outliers'; % '' '_no_outliers'  %% CHANGE HER FOR OUTLIER CONSIDERATION
mdm_pattern     = '_combined_no_outliers_glm_cue.mdm'; % '_combined_glm_cue.mdm' '_combined_no_outliers_glm_cue.mdm'   %% CHANGE HER FOR OUTLIER CONSIDERATION

%% +++++++ VOIs +++++++
% +++test+++
%voi_name = 'Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI\mat2prt_reach_decision_vardelay_forglm\test\test_r_tal.voi';

% +++CUE+++
% CUE all vois
% voi_name = {'Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI\mat2prt_reach_decision_vardelay_forglm\conjval choice more instr cue sac reach\conjval choice more instr cue sac reach_from_combined_atlas_l_tal.voi';...
%             'Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI\mat2prt_reach_decision_vardelay_forglm\conjval choice more instr cue sac reach\conjval choice more instr cue sac reach_from_combined_atlas_r_tal.voi'};

% CUE merged vois 
% voi_name        = {'Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI\mat2prt_reach_decision_vardelay_forglm\conjval choice more instr cue sac reach\conjval choice more instr cue sac reach_from_combined_atlas_l_tal_merged.voi';...
%                    'Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI\mat2prt_reach_decision_vardelay_forglm\conjval choice more instr cue sac reach\conjval choice more instr cue sac reach_from_combined_atlas_r_tal_merged.voi'};
% 
% voi_side        = {'lh', 'rh'}; % order has to fit with voi_name

% +++MEM+++
% MEM all vois
voi_location    = 'Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI\mat2prt_reach_decision_vardelay_forglm\memory period';
voi_name        = {[voi_location filesep 'memory_neg_from_combined_atlas_l_tal.voi'],...
                   [voi_location filesep 'memory_neg_from_combined_atlas_r_tal.voi'],...
                   [voi_location filesep 'memory_pos_from_combined_atlas_l_tal.voi'],...
                   [voi_location filesep 'memory_pos_from_combined_atlas_r_tal.voi']};
voi_side        = {'negLH', 'negRH','posLH', 'posRH'}; % order has to fit with voi_name

%% +++++++ Rest +++++++
era_outliers    = '_no_outliers'; % '' '_no_outliers'  %% CHANGE HER FOR OUTLIER CONSIDERATION
plot_outliers   = '_no_outliers'; % '' '_no_outliers'  %% CHANGE HER FOR OUTLIER CONSIDERATION

bin_size        = 5;
cond_diff       = {'choi', 'instr'};%{'choi', 'instr'; 'left', 'right';'reach' 'sac'}; % mind the format: left minus right, per row: cond_diff = {'choi', 'instr'; 'left', 'right';'reach' 'sac'};


%% creation of era files per separate delay

if create_era_per_delay
    
    disp('+++++ processing create_era_per_delay');
    
    trigger = {'cue', 'mov'};
    delay = {'3','6','9','12','15'};
    
    for i = 1:length(prot)
        
        subject = prot(i).name;
        
        for vs = 1:length(voi_name)
            
            for t = 1:length(trigger)
                
                for d = 1:length(delay)
                    
                    %[era] = ne_era_mdm_frd(voipath,avgpath,mdmpath,era_settings_id,varargin)
                    
                    %[era] = ne_era_mdm_frd(
                    % 'Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI\mat2prt_reach_decision_vardelay_forglm\test\test_r_tal.voi';
                    % 'Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI\ANEL\mat2prt_reach_decision_vardelay_foravg\ANEL_combined_avg_cue_3_no_outliers.avg',...
                    % 'Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI\ANEL\mat2prt_reach_decision_vardelay_forglm\ANEL_combined_no_outliers_glm_cue.mdm',...
                    % 'tc_interpolate',100);
                    
                    [era] = ne_era_mdm_frd(...
                        voi_name{vs},... %voi location
                        [runpath filesep subject filesep 'mat2prt_reach_decision_vardelay_foravg' filesep subject '_combined_avg_' trigger{t} '_' delay{d} avg_outliers '.avg'],...
                        [runpath filesep subject filesep 'mat2prt_reach_decision_vardelay_forglm' filesep subject mdm_pattern],...  % which mdm
                        'Human_reach_decision',...
                        'tc_interpolate',tc_interpolate);
                    
                    save_folder = [runpath filesep subject filesep era_model_name];
                    
                    if ~exist(save_folder)
                        mkdir(save_folder);
                    end
                    
                    save(         [save_folder filesep subject '_era_' trigger{t} '_' delay{d} '_' voi_side{vs} avg_outliers '.mat'],'era');
                    disp(['saved ' save_folder filesep subject '_era_' trigger{t} '_' delay{d} '_' voi_side{vs} avg_outliers '.mat'])
                    
                    
                    %             save('Y:\MRI\Human\fMRI-reach-decision\Experiment\buffer_for_pipeline.mat','prot', 'runpath','i','t','d','trigger','delay','avg_outliers','mdm_pattern','voi_name')
                    %
                    %             clear all
                    %
                    %             load('Y:\MRI\Human\fMRI-reach-decision\Experiment\buffer_for_pipeline.mat')
                    
                    
                end
            end
        end
    end
end

%% create era average

if create_delay_average
    
    disp('+++++ processing create_era_average');
    
    trigger = {'cue', 'mov'};
    delay = {'9','12','15'};
    
    for i = 1:length(prot)
        
        subject = prot(i).name;
        
        for vs = 1:length(voi_side)
            
            for t = 1:length(trigger)
                
                for d = 1:length(delay)
                    era_files{d} = [runpath filesep subject filesep era_model_name filesep subject '_era_' trigger{t} '_' delay{d} '_' voi_side{vs}  avg_outliers '.mat'];
                    % era_files = {...
                    %   'Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI\ANEL\mat2prt_reach_decision_vardelay_foravg\ANEL_era_cue_9_no_outliers.mat';...
                    %   'Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI\ANEL\mat2prt_reach_decision_vardelay_foravg\ANEL_era_cue_12_no_outliers.mat';...
                    %   'Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI\ANEL\mat2prt_reach_decision_vardelay_foravg\ANEL_era_cue_15_no_outliers.mat'};
                end
                
                era = ne_era_frd_create_averaged_delays(era_files,trigger{t},tc_interpolate);
                
                
                save([runpath filesep subject filesep era_model_name filesep subject '_era_' trigger{t} '_average_' voi_side{vs} era_outliers '.mat'] ,'era')
                % 'Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI\ANEL\mat2prt_reach_decision_vardelay_foravg\ANEL_era_cue_average_no_outliers.mat'
                disp(['saved ' runpath filesep subject filesep era_model_name filesep subject '_era_' trigger{t} '_average_' voi_side{vs} era_outliers '.mat']);
                
                
            end
        end
    end
end

%% binning data

if create_era_binned
    
    disp('+++++ processing create_era_binned');
    
    for i = 1:length(prot)
        
        era_files = findfiles([runpath filesep  prot(i).name filesep era_model_name],'*_era_*.mat','depth=1');
        
        for e = 1:length(era_files)
            
            era = ne_era_frd_downsample(era_files{e},bin_size);
            
            save(era_files{e},'era');
            %disp('saved ' era_files{e});
            
        end
    end
end

%% creating difference values. 

if create_era_diff_timecourses
    
    disp('+++++ processing create_era_diff_timecourses');
    
    for i = 1:length(prot)
        
        era_files = findfiles([runpath filesep  prot(i).name filesep era_model_name],'*_era_*.mat','depth=1');
        
        for e = 1:length(era_files)
            
            era = ne_era_frd_create_difference_timecourse(era_files{e},cond_diff,1);
            
            %save(era_files{e},'era');
            %disp('saved ' era_files{e});
            
        end
    end
    
end



%% plotting eras per delay
if plot_era_per_delay
    
     disp('+++++ processing plot_era_per_delay');
     
    for i = 1:length(prot)
        
        subject = prot(i).name;
        
        for vs = 1:length(voi_side)
            
            era_files = findfiles([runpath filesep subject filesep era_model_name],['*era*' voi_side{vs} '*' plot_outliers '*.mat'],'depth=1');
            era_files = era_files(find(cellfun(@isempty,strfind(era_files,'average')))); %discard average mats
            
            %era_files contains all cue and movement triggered delays (N=10)
            
            if ~exist([runpath filesep subject filesep 'plots'])
                mkdir([runpath filesep subject filesep 'plots']);  %'Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI\ANEL\plots'
            end
            
            ne_era_frd_plot_per_delay(era_files,subject,1,[runpath filesep subject filesep 'plots'])
            
        end
    end
end

%% plotting eras averages

if plot_era_average
    
    disp('+++++ processing plot_era_average');
    
    for i = 1:length(prot)
        
        subject = prot(i).name;
        
        for vs = 1:length(voi_side)
            
            era_files = findfiles([runpath filesep subject filesep era_model_name],['*era*average*' voi_side{vs} '*' plot_outliers '*.mat'],'depth=1');
            
            % era_files = {...
            %     'Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI\ANEL\mat2prt_reach_decision_vardelay_foravg\ANEL_era_mov_average_lh_no_outliers.mat',...
            %     'Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI\ANEL\mat2prt_reach_decision_vardelay_foravg\ANEL_era_cue_average_lh_no_outliers.mat',...
            %     'Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI\ANEL\mat2prt_reach_decision_vardelay_foravg\ANEL_era_mov_average_rh_no_outliers.mat',...           
            %     'Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI\ANEL\mat2prt_reach_decision_vardelay_foravg\ANEL_era_cue_average_rh_no_outliers.mat',};
            
            if ~exist([runpath filesep subject filesep 'plots'])
                mkdir([runpath filesep subject filesep 'plots']); %'Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI\ANEL\plots'
            end
            
            ne_era_frd_plot_average(era_files,subject,0,1,[runpath filesep subject filesep 'plots'])
            
        end
    end
    
end

disp('done');

