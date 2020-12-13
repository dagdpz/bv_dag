function ne_wrapper_creation_and_plot_era_reach_decision

clear all
load('Y:\MRI\Human\fMRI-reach-decision\Experiment\behavioral_data\protocols_v2.mat');
prot = prot(strcmp('ANEL',{prot.name}));

%% settings
runpath = 'Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI';
avg_outliers = '_no_outliers'; % ''                                            %% CHANGE HER FOR OUTLIER CONSIDERATION
mdm_pattern = '_combined_no_outliers_glm_cue.mdm'; % '_combined_glm_cue.mdm'   %% CHANGE HER FOR OUTLIER CONSIDERATION
voi_name = 'Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI\mat2prt_reach_decision_vardelay_forglm\test\test_r_tal.voi';

%% creation of era files per separate delay

trigger = {'cue', 'mov'};
delay = {'3','6','9','12','15'};

for i = length(prot)
    
    subject = prot(i).name;
    
    for t = 1:length(trigger)
        
        for d = 1:length(delay)
            
            [era] = ne_era_mdm_frd(...
                voi_name,... %voi location         'Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI\mat2prt_reach_decision_vardelay_forglm\test\test_r_tal.voi',...
                [runpath filesep subject filesep 'mat2prt_reach_decision_vardelay_foravg' filesep subject '_combined_avg_' trigger{t} '_' delay{d} avg_outliers '.avg'],...      'Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI\ANEL\mat2prt_reach_decision_vardelay_foravg\ANEL_combined_avg_cue_3_no_outliers.avg',...
                [runpath filesep subject filesep 'mat2prt_reach_decision_vardelay_forglm' filesep subject mdm_pattern],...  % which mdm    'Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI\ANEL\mat2prt_reach_decision_vardelay_forglm\ANEL_combined_no_outliers_glm_cue.mdm',...
                'Human_reach_decision',...
                'tc_interpolate',100);
            
            
            save([runpath filesep subject filesep 'mat2prt_reach_decision_vardelay_foravg' filesep subject '_era_' trigger{t} '_' delay{d} avg_outliers '.mat'],'era');
            disp(['saved ' runpath filesep subject filesep 'mat2prt_reach_decision_vardelay_foravg' filesep subject '_era_' trigger{t} '_' delay{d} avg_outliers '.mat'])
            
            
%             save('Y:\MRI\Human\fMRI-reach-decision\Experiment\buffer_for_pipeline.mat','prot', 'runpath','i','t','d','trigger','delay','avg_outliers','mdm_pattern','voi_name')
% 
%             clear all
%     
%             load('Y:\MRI\Human\fMRI-reach-decision\Experiment\buffer_for_pipeline.mat')

            
        end
    end
end

%% plotting eras per delay TO BE CONTINUED

trigger = {'cue', 'mov'};
delay = {'3','6','9','12','15'};

for i = 1:length(prot)
    
     subject = prot(i).name;    
     
     era_files = findfiles([runpath filesep subject filesep 'mat2prt_reach_decision_vardelay_foravg'],'*era*');



era_files = {...
    'Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI\ANEL\mat2prt_reach_decision_vardelay_foravg\ANEL_era_cue_3_no_outliers.mat';...
    'Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI\ANEL\mat2prt_reach_decision_vardelay_foravg\ANEL_era_cue_6_no_outliers.mat';...
    'Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI\ANEL\mat2prt_reach_decision_vardelay_foravg\ANEL_era_cue_9_no_outliers.mat';...
    'Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI\ANEL\mat2prt_reach_decision_vardelay_foravg\ANEL_era_cue_12_no_outliers.mat';...
    'Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI\ANEL\mat2prt_reach_decision_vardelay_foravg\ANEL_era_cue_15_no_outliers.mat'};


ne_plot_era_reach_decision(era_files,subject_name,runpath)






     
end

