function ne_plot_era_action_selection_humans_RFX(task,map)

drive = 'D';

voipath = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI selection\'];
avgpath = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\AVG\Poffenberger_14_ne_prt2avg_Humans_Poffenberger_just_suc.avg'];

era_settings_id = 'Humans_Poffenberger';
run('ne_era_settings');

plot_summary     = 1; % 0 = inactive, 1 = active
CUD_mean_div_by_2= 1; % divide CUD mean by 2

if nargin<1
    task         = 1; % 1 = ASB, 2 = ASR,  3 = NAS
    map          = 1; % 1 = CUD, 2 = hand, 3 = space
end

means_plot       = 2; % 1 = plot means for CUDhand and CUDspace, 2 = plot means of hand and space

if task == 1
    if map == 1
        voi_mat{1}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASB_subjects\CUD_RIME_Action_selection_Blocked_14_no_outliers.mat'];
        voi_mat{2}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASB_subjects\CUD_VIRI_Action_selection_Blocked_14_no_outliers.mat'];
        voi_mat{3}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASB_subjects\CUD_EDGR_Action_selection_Blocked_14_no_outliers.mat'];
        voi_mat{4}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASB_subjects\CUD_EVPI_Action_selection_Blocked_14_no_outliers.mat'];
        voi_mat{5}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASB_subjects\CUD_THAN_Action_selection_Blocked_14_no_outliers.mat'];
        voi_mat{6}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASB_subjects\CUD_KRKA_Action_selection_Blocked_14_no_outliers.mat'];
        voi_mat{7}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASB_subjects\CUD_VEGU_Action_selection_Blocked_14_no_outliers.mat'];
        voi_mat{8}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASB_subjects\CUD_GESP_Action_selection_Blocked_14_no_outliers.mat'];
        voi_mat{9}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASB_subjects\CUD_CHKO_Action_selection_Blocked_14_no_outliers.mat'];
        voi_mat{10} = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASB_subjects\CUD_MAKO_Action_selection_Blocked_14_no_outliers.mat'];
        voi_mat{11} = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASB_subjects\CUD_JUBR_Action_selection_Blocked_14_no_outliers.mat'];        
        voi_mat{12} = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASB_subjects\CUD_ADAS_Action_selection_Blocked_14_no_outliers.mat'];
        voi_mat{13} = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASB_subjects\CUD_THTR_Action_selection_Blocked_14_no_outliers.mat'];
        voi_mat{14} = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASB_subjects\CUD_CAHE_Action_selection_Blocked_14_no_outliers.mat'];     
    elseif map == 2        
        voi_mat{1}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASB_subjects\hand_RIME_Action_selection_Blocked_14_no_outliers.mat'];
        voi_mat{2}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASB_subjects\hand_VIRI_Action_selection_Blocked_14_no_outliers.mat'];
        voi_mat{3}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASB_subjects\hand_EDGR_Action_selection_Blocked_14_no_outliers.mat'];
        voi_mat{4}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASB_subjects\hand_EVPI_Action_selection_Blocked_14_no_outliers.mat'];
        voi_mat{5}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASB_subjects\hand_THAN_Action_selection_Blocked_14_no_outliers.mat'];
        voi_mat{6}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASB_subjects\hand_KRKA_Action_selection_Blocked_14_no_outliers.mat'];
        voi_mat{7}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASB_subjects\hand_VEGU_Action_selection_Blocked_14_no_outliers.mat'];
        voi_mat{8}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASB_subjects\hand_GESP_Action_selection_Blocked_14_no_outliers.mat'];
        voi_mat{9}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASB_subjects\hand_CHKO_Action_selection_Blocked_14_no_outliers.mat'];
        voi_mat{10} = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASB_subjects\hand_MAKO_Action_selection_Blocked_14_no_outliers.mat'];
        voi_mat{11} = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASB_subjects\hand_JUBR_Action_selection_Blocked_14_no_outliers.mat'];        
        voi_mat{12} = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASB_subjects\hand_ADAS_Action_selection_Blocked_14_no_outliers.mat'];
        voi_mat{13} = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASB_subjects\hand_THTR_Action_selection_Blocked_14_no_outliers.mat'];
        voi_mat{14} = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASB_subjects\hand_CAHE_Action_selection_Blocked_14_no_outliers.mat'];
    else
        voi_mat{1}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASB_subjects\space_RIME_Action_selection_Blocked_14_no_outliers.mat'];
        voi_mat{2}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASB_subjects\space_VIRI_Action_selection_Blocked_14_no_outliers.mat'];
        voi_mat{3}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASB_subjects\space_EDGR_Action_selection_Blocked_14_no_outliers.mat'];
        voi_mat{4}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASB_subjects\space_EVPI_Action_selection_Blocked_14_no_outliers.mat'];
        voi_mat{5}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASB_subjects\space_THAN_Action_selection_Blocked_14_no_outliers.mat'];
        voi_mat{6}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASB_subjects\space_KRKA_Action_selection_Blocked_14_no_outliers.mat'];
        voi_mat{7}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASB_subjects\space_VEGU_Action_selection_Blocked_14_no_outliers.mat'];
        voi_mat{8}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASB_subjects\space_GESP_Action_selection_Blocked_14_no_outliers.mat'];
        voi_mat{9}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASB_subjects\space_CHKO_Action_selection_Blocked_14_no_outliers.mat'];
        voi_mat{10} = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASB_subjects\space_MAKO_Action_selection_Blocked_14_no_outliers.mat'];
        voi_mat{11} = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASB_subjects\space_JUBR_Action_selection_Blocked_14_no_outliers.mat'];        
        voi_mat{12} = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASB_subjects\space_ADAS_Action_selection_Blocked_14_no_outliers.mat'];
        voi_mat{13} = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASB_subjects\space_THTR_Action_selection_Blocked_14_no_outliers.mat'];
        voi_mat{14} = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASB_subjects\space_CAHE_Action_selection_Blocked_14_no_outliers.mat'];
    end
elseif task == 2
    if map == 1        
        voi_mat{1}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASR_subjects\CUD_RIME_Action_selection_Random_14_no_outliers.mat'];
        voi_mat{2}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASR_subjects\CUD_VIRI_Action_selection_Random_14_no_outliers.mat'];
        voi_mat{3}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASR_subjects\CUD_EDGR_Action_selection_Random_14_no_outliers.mat'];
        voi_mat{4}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASR_subjects\CUD_EVPI_Action_selection_Random_14_no_outliers.mat'];
        voi_mat{5}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASR_subjects\CUD_THAN_Action_selection_Random_14_no_outliers.mat'];
        voi_mat{6}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASR_subjects\CUD_KRKA_Action_selection_Random_14_no_outliers.mat'];
        voi_mat{7}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASR_subjects\CUD_VEGU_Action_selection_Random_14_no_outliers.mat'];
        voi_mat{8}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASR_subjects\CUD_GESP_Action_selection_Random_14_no_outliers.mat'];
        voi_mat{9}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASR_subjects\CUD_CHKO_Action_selection_Random_14_no_outliers.mat'];
        voi_mat{10} = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASR_subjects\CUD_MAKO_Action_selection_Random_14_no_outliers.mat'];
        voi_mat{11} = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASR_subjects\CUD_JUBR_Action_selection_Random_14_no_outliers.mat'];        
        voi_mat{12} = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASR_subjects\CUD_ADAS_Action_selection_Random_14_no_outliers.mat'];
        voi_mat{13} = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASR_subjects\CUD_THTR_Action_selection_Random_14_no_outliers.mat'];
        voi_mat{14} = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASR_subjects\CUD_CAHE_Action_selection_Random_14_no_outliers.mat'];       
    elseif map == 2        
        voi_mat{1}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASR_subjects\hand_RIME_Action_selection_Random_14_no_outliers.mat'];
        voi_mat{2}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASR_subjects\hand_VIRI_Action_selection_Random_14_no_outliers.mat'];
        voi_mat{3}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASR_subjects\hand_EDGR_Action_selection_Random_14_no_outliers.mat'];
        voi_mat{4}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASR_subjects\hand_EVPI_Action_selection_Random_14_no_outliers.mat'];
        voi_mat{5}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASR_subjects\hand_THAN_Action_selection_Random_14_no_outliers.mat'];
        voi_mat{6}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASR_subjects\hand_KRKA_Action_selection_Random_14_no_outliers.mat'];
        voi_mat{7}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASR_subjects\hand_VEGU_Action_selection_Random_14_no_outliers.mat'];
        voi_mat{8}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASR_subjects\hand_GESP_Action_selection_Random_14_no_outliers.mat'];
        voi_mat{9}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASR_subjects\hand_CHKO_Action_selection_Random_14_no_outliers.mat'];
        voi_mat{10} = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASR_subjects\hand_MAKO_Action_selection_Random_14_no_outliers.mat'];
        voi_mat{11} = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASR_subjects\hand_JUBR_Action_selection_Random_14_no_outliers.mat'];        
        voi_mat{12} = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASR_subjects\hand_ADAS_Action_selection_Random_14_no_outliers.mat'];
        voi_mat{13} = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASR_subjects\hand_THTR_Action_selection_Random_14_no_outliers.mat'];
        voi_mat{14} = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASR_subjects\hand_CAHE_Action_selection_Random_14_no_outliers.mat'];        
    else
        voi_mat{1}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASR_subjects\space_RIME_Action_selection_Random_14_no_outliers.mat'];
        voi_mat{2}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASR_subjects\space_VIRI_Action_selection_Random_14_no_outliers.mat'];
        voi_mat{3}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASR_subjects\space_EDGR_Action_selection_Random_14_no_outliers.mat'];
        voi_mat{4}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASR_subjects\space_EVPI_Action_selection_Random_14_no_outliers.mat'];
        voi_mat{5}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASR_subjects\space_THAN_Action_selection_Random_14_no_outliers.mat'];
        voi_mat{6}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASR_subjects\space_KRKA_Action_selection_Random_14_no_outliers.mat'];
        voi_mat{7}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASR_subjects\space_VEGU_Action_selection_Random_14_no_outliers.mat'];
        voi_mat{8}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASR_subjects\space_GESP_Action_selection_Random_14_no_outliers.mat'];
        voi_mat{9}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASR_subjects\space_CHKO_Action_selection_Random_14_no_outliers.mat'];
        voi_mat{10} = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASR_subjects\space_MAKO_Action_selection_Random_14_no_outliers.mat'];
        voi_mat{11} = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASR_subjects\space_JUBR_Action_selection_Random_14_no_outliers.mat'];        
        voi_mat{12} = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASR_subjects\space_ADAS_Action_selection_Random_14_no_outliers.mat'];
        voi_mat{13} = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASR_subjects\space_THTR_Action_selection_Random_14_no_outliers.mat'];
        voi_mat{14} = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\ASR_subjects\space_CAHE_Action_selection_Random_14_no_outliers.mat'];
    end
else
    if map == 1        
        voi_mat{1}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\NAS_subjects\CUD_RIME_Poffenberger_14_no_outliers.mat'];
        voi_mat{2}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\NAS_subjects\CUD_VIRI_Poffenberger_14_no_outliers.mat'];
        voi_mat{3}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\NAS_subjects\CUD_EDGR_Poffenberger_14_no_outliers.mat'];
        voi_mat{4}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\NAS_subjects\CUD_EVPI_Poffenberger_14_no_outliers.mat'];
        voi_mat{5}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\NAS_subjects\CUD_THAN_Poffenberger_14_no_outliers.mat'];
        voi_mat{6}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\NAS_subjects\CUD_KRKA_Poffenberger_14_no_outliers.mat'];
        voi_mat{7}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\NAS_subjects\CUD_VEGU_Poffenberger_14_no_outliers.mat'];
        voi_mat{8}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\NAS_subjects\CUD_GESP_Poffenberger_14_no_outliers.mat'];
        voi_mat{9}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\NAS_subjects\CUD_CHKO_Poffenberger_14_no_outliers.mat'];
        voi_mat{10} = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\NAS_subjects\CUD_MAKO_Poffenberger_14_no_outliers.mat'];
        voi_mat{11} = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\NAS_subjects\CUD_JUBR_Poffenberger_14_no_outliers.mat'];        
        voi_mat{12} = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\NAS_subjects\CUD_ADAS_Poffenberger_14_no_outliers.mat'];
        voi_mat{13} = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\NAS_subjects\CUD_THTR_Poffenberger_14_no_outliers.mat'];
        voi_mat{14} = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\NAS_subjects\CUD_CAHE_Poffenberger_14_no_outliers.mat'];       
    elseif map == 2        
        voi_mat{1}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\NAS_subjects\hand_RIME_Poffenberger_14_no_outliers.mat'];
        voi_mat{2}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\NAS_subjects\hand_VIRI_Poffenberger_14_no_outliers.mat'];
        voi_mat{3}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\NAS_subjects\hand_EDGR_Poffenberger_14_no_outliers.mat'];
        voi_mat{4}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\NAS_subjects\hand_EVPI_Poffenberger_14_no_outliers.mat'];
        voi_mat{5}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\NAS_subjects\hand_THAN_Poffenberger_14_no_outliers.mat'];
        voi_mat{6}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\NAS_subjects\hand_KRKA_Poffenberger_14_no_outliers.mat'];
        voi_mat{7}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\NAS_subjects\hand_VEGU_Poffenberger_14_no_outliers.mat'];
        voi_mat{8}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\NAS_subjects\hand_GESP_Poffenberger_14_no_outliers.mat'];
        voi_mat{9}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\NAS_subjects\hand_CHKO_Poffenberger_14_no_outliers.mat'];
        voi_mat{10} = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\NAS_subjects\hand_MAKO_Poffenberger_14_no_outliers.mat'];
        voi_mat{11} = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\NAS_subjects\hand_JUBR_Poffenberger_14_no_outliers.mat'];        
        voi_mat{12} = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\NAS_subjects\hand_ADAS_Poffenberger_14_no_outliers.mat'];
        voi_mat{13} = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\NAS_subjects\hand_THTR_Poffenberger_14_no_outliers.mat'];
        voi_mat{14} = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\NAS_subjects\hand_CAHE_Poffenberger_14_no_outliers.mat'];      
    else
        voi_mat{1}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\NAS_subjects\space_RIME_Poffenberger_14_no_outliers.mat'];
        voi_mat{2}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\NAS_subjects\space_VIRI_Poffenberger_14_no_outliers.mat'];
        voi_mat{3}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\NAS_subjects\space_EDGR_Poffenberger_14_no_outliers.mat'];
        voi_mat{4}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\NAS_subjects\space_EVPI_Poffenberger_14_no_outliers.mat'];
        voi_mat{5}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\NAS_subjects\space_THAN_Poffenberger_14_no_outliers.mat'];
        voi_mat{6}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\NAS_subjects\space_KRKA_Poffenberger_14_no_outliers.mat'];
        voi_mat{7}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\NAS_subjects\space_VEGU_Poffenberger_14_no_outliers.mat'];
        voi_mat{8}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\NAS_subjects\space_GESP_Poffenberger_14_no_outliers.mat'];
        voi_mat{9}  = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\NAS_subjects\space_CHKO_Poffenberger_14_no_outliers.mat'];
        voi_mat{10} = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\NAS_subjects\space_MAKO_Poffenberger_14_no_outliers.mat'];
        voi_mat{11} = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\NAS_subjects\space_JUBR_Poffenberger_14_no_outliers.mat'];        
        voi_mat{12} = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\NAS_subjects\space_ADAS_Poffenberger_14_no_outliers.mat'];
        voi_mat{13} = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\NAS_subjects\space_THTR_Poffenberger_14_no_outliers.mat'];
        voi_mat{14} = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\VOI mat\NAS_subjects\space_CAHE_Poffenberger_14_no_outliers.mat'];        
    end
end

for subj = 1:14
    
    load(voi_mat{subj})
    
    %% ANOVA
    varnames            = settings.varnames;
    levnames            = settings.levnames;
    settings.params_era = era.params;
    
    data_anova = struct2cell(era.RA);
    data_anova = squeeze(data_anova(1,:,:));
    
    data_anova_2take = data_anova(:,settings.conditions2take);
    
    data1_ra = []; data2_ra = [];
    
    for v = 1:size(era.RA,1)
        %anova(v) = nway_anova(data_anova_2take(v,:), settings.assignment, varnames, levnames);
        
        %anova(v) = nway_anova(data_anova_2take(v,:), settings.assignment, varnames, levnames);
        
        ra1_voi  = [era.RA(v,:).ra_mean];
        data1_ra = [data1_ra; ra1_voi]; % mean for each VOI
        ra2_voi  = [era.RA(v,:).ra_se];
        data2_ra = [data2_ra; ra2_voi]; % se for each VOI
        
        data_anova_subj(subj,v,1) = mean(data_anova{v,1});
        data_anova_subj(subj,v,2) = mean(data_anova{v,2});
        data_anova_subj(subj,v,3) = mean(data_anova{v,3});
        data_anova_subj(subj,v,4) = mean(data_anova{v,4});
    end % for each VOI
    
end % for each subject

S  = repmat(1:14,1,4)';

F1 = [repmat(1,1,28)'; repmat(2,1,28)'];

F2 = [repmat(1,1,14)'; repmat(2,1,14)'; repmat(1,1,14)'; repmat(2,1,14)'];

FACTNAMES = {'Hand', 'Space', 'Hand x Space'};

for v = 1:size(era.RA,1)    
    
    Y  = [data_anova_subj(:,v,1); data_anova_subj(:,v,2); data_anova_subj(:,v,3); data_anova_subj(:,v,4)];
    
    if v <2
        table_for_kristin = [Y,S,F1,F2];
    end
    
    stats = rm_anova2(Y,S,F1,F2,FACTNAMES);
    
    anova(v).p = [stats{[2:4],6}]';
    
%     % post-hoc comparisons for ANOVA
%     [comparisons,means,hh,names] = multcompare(anova(v).stats, 'Dimension',1:numel(anova(v).stats.nlevels),'CType','lsd', 'Alpha', settings.alpha_post_hoc_t, 'Display','off');
%     
%     condition_numbers = settings.condition_numbers;
%     for i = 1:size(comparisons,1),
%         [h,p] = ttest2(data_anova_subj(:,v,condition_numbers(comparisons(i,1))), data_anova_subj(:,v,condition_numbers(comparisons(i,2))) );
%         comparisons(i,6) = p;
%     end
%     compare(v).comparisons = comparisons;
%     compare(v).means = means;
end



%% plot summary

left_hemi_pattern = 'LH_';
Area = {era.voi.Name}';

for v = 1:size(data_anova,1)
    
    RH_a(v,:) = [NaN NaN NaN]; RH_p(v,:) = [1 1 1];
    LH_a(v,:) = [NaN NaN NaN]; LH_p(v,:) = [1 1 1];
    
    Area_n          = Area{v};
    idx_under_lines = strfind(Area{v},'_');
    Area_n          = Area_n([(1:3) idx_under_lines(end)+1:end]);
    Area{v}         = Area_n;
    
    if ~isempty(strfind(Area{v},left_hemi_pattern)),
        hemi = 0;
    else
        hemi = 1;
    end
    
    % LL LR RL RR
    
    if CUD_mean_div_by_2
        voi_data(v).a(1) = mean([data_anova_subj(:,v,2); data_anova_subj(:,v,3)]) - mean([data_anova_subj(:,v,1); data_anova_subj(:,v,4)]); % CUD all
    else
        voi_data(v).a(1) = (mean(data_anova_subj(:,v,2))+ mean(data_anova_subj(:,v,3))) - (mean(data_anova_subj(:,v,1))+ mean(data_anova_subj(:,v,4))); % CUD all
    end

    [h,p_ttest] = ttest([data_anova_subj(:,v,2); data_anova_subj(:,v,3)],[data_anova_subj(:,v,1); data_anova_subj(:,v,4)]);
    
    p_ttest_v(v).p_ttest = p_ttest;
    
    if means_plot == 1 
        if hemi==0 % LH
            voi_data(v).a(2) = mean(data_anova_subj(:,v,3)) - mean(data_anova_subj(:,v,4)); % contralateral hand  RL - RR
            voi_data(v).a(3) = mean(data_anova_subj(:,v,2)) - mean(data_anova_subj(:,v,4)); % contralateral space LR - RR
        else       % RH
            voi_data(v).a(2) = mean(data_anova_subj(:,v,2)) - mean(data_anova_subj(:,v,1)); % contralateral hand  LR - LL
            voi_data(v).a(3) = mean(data_anova_subj(:,v,3)) - mean(data_anova_subj(:,v,1)); % contralateral space RL - LL
        end        
    else               
        if hemi==0 % LH
            voi_data(v).a(2) = mean([data_anova_subj(:,v,3); data_anova_subj(:,v,4)]) - mean([data_anova_subj(:,v,1); data_anova_subj(:,v,2)]); % HAND
            voi_data(v).a(3) = mean([data_anova_subj(:,v,2); data_anova_subj(:,v,4)]) - mean([data_anova_subj(:,v,1); data_anova_subj(:,v,3)]); % SPACE
        else       % RH
            voi_data(v).a(2) = mean([data_anova_subj(:,v,1); data_anova_subj(:,v,2)]) - mean([data_anova_subj(:,v,3); data_anova_subj(:,v,4)]); % HAND
            voi_data(v).a(3) = mean([data_anova_subj(:,v,1); data_anova_subj(:,v,3)]) - mean([data_anova_subj(:,v,2); data_anova_subj(:,v,4)]); % SPACE
        end
    end
    
    voi_data(v).p 	= 	anova(v).p; % space, hand, interaction
    
    % special case - remove significance for negative response amplitudes
    if all([ mean(data_anova{v,1})  mean(data_anova{v,2})  mean(data_anova{v,3})  mean(data_anova{v,4})]<0),
        voi_data(v).p(3) = [1];
    end
    
    if hemi==0 % LH
        LH_a(v,:) = voi_data(v).a;
        LH_p(v,:) = voi_data(v).p;
    else % RH
        RH_a(v,:) = voi_data(v).a;
        RH_p(v,:) = voi_data(v).p; % hand | space | interaction
    end
    
    Area{v}         = Area_n(4:end);
    
end

RH_LH_separation = find(isnan(LH_a(:,1)));

area_col =  [];

if map == 1,
    color_plot = [.8 .8 .8];
elseif map == 2,
    color_plot = [.9 .9 .9];
else
    color_plot = [1 1 1];
end

if (length(LH_a)/2) > RH_LH_separation(end)
    length_plot_areas = length(LH_a)-RH_LH_separation(end);
    length_plot_areas = 30/length_plot_areas;
    position_plots = [0 0 400 800/length_plot_areas];
else
    length_plot_areas = RH_LH_separation(end);
    length_plot_areas = 30/length_plot_areas;
    position_plots = [0 0 400 800/length_plot_areas];
end

if plot_summary
    ig_figure('Position',position_plots);
    subplot(1,2,1)
    plot_barh(LH_a(RH_LH_separation(end)+1:end,:),Area(RH_LH_separation(end)+1:end),area_col,LH_p(RH_LH_separation(end)+1:end,:));
    set(gca,'Color',color_plot)
    subplot1 = get(gca,'Position');
    set(gca,'Position',[.2 subplot1(2) subplot1(3) subplot1(4)]);
    if ~isempty(strfind(voipath,'CUD')),xlabel('%BOLD change difference');end,
    title('Left Hemisphere','FontSize',16);
    subplot(1,2,2)
    plot_barh(RH_a(1:RH_LH_separation(end),:),Area(1:RH_LH_separation(end)),area_col,RH_p(1:RH_LH_separation(end),:));
    set_axes_equal_lim;
    set(gca,'Color',color_plot);
    subplot2 = get(gca,'Position');
    set(gca,'Position',[.65 subplot2(2) subplot2(3) subplot2(4)]);
    if ~isempty(strfind(voipath,'CUD')),xlabel('%BOLD change difference');end,
    title('Right Hemisphere','FontSize',16);
end

if task == 1
    save_task = 'ASB';
elseif task == 2
    save_task = 'ASR';
else
    save_task = 'NAS';
end

if map == 1
    save_map = 'CUD';
elseif map == 2
    save_map = 'hand';
else
    save_map = 'space';
end

name_task_map = [drive ':\MRI\Human\Action Selection\combined\Actual analysis\RFX_psc\RFX_psc_' save_task '_' save_map];

save(name_task_map,'data_anova_subj')

save table_for_kristin table_for_kristin 
xlswrite('C:\Users\c.moreir\Desktop\table_for_kristin',table_for_kristin,'table_for_kristin');
disp(['file ' name_task_map ' saved']); 


function plot_barh(a,areas,col,p)

% SET THIS
dist = 0.025; % distance between significance markers
sig_col = [0 1 0; 1 0 0; 0 0 0]; % hand | space | interaction

if nargin < 4,
    p = [];
end

sig = p<0.05;

n = length(a);

h = barh(a,1,'grouped'); hold on;

ytick = [1:n];
set(gca,'YTick',ytick,'YTickLabel',areas,'FontSize',12,'Ydir','reverse','Ylim',[0 n+1]);
set(gca,'Xlim',[-0.17 0.1]);

if ~isempty(col), colormap(col); end;

cmap = gray(3);
colormap(cmap(1:3,:));

xlim = get(gca,'xlim');
for k = 1:n,
    for i = 1:size(p,2),
        if sig(k,i), plot(xlim(2)+i*dist,ytick(k),'ko','MarkerSize',7,'MarkerEdgeColor',sig_col(i,:),'MarkerFaceColor',sig_col(i,:)); end
    end
end

set(gca,'Xlim',[xlim(1) xlim(2)+(size(p,2)+1)*dist]);


