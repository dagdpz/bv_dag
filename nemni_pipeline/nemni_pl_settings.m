%% nemni_pl_settings
% set settings of nemni pipeline part 3

switch nemni_pl_settings_id
    
    case 'fmri_reach_decision'
        
        % general
        model_glm_name      = 'mat2prt_reach_decision_vardelay_forglm';
        model_avg_name      = 'mat2prt_reach_decision_vardelay_foravg';
        mat2prt_fct_handle_glm = @mat2prt_reach_decision_vardelay_forglm;
        mat2prt_fct_handle_avg = @mat2prt_reach_decision_vardelay_foravg;

        % sdm creation
        sdm_template        = 'Y:\Personal\Peter\Repos\bv_dag\nemni_pipeline\nemni_template_sdm_MCparams.sdm'; % easy way of getting the structure of the file to replace with actual respective mcparams

        % vtc creation
        nifti_pattern       = 's6wrhum_*.nii';
        TR                  = 900; 
        % mask source
        msk_source          = 'Y:\MRI\Human\mni_icbm152_t1_tal_nlin_sym_09a_mask_vtc.msk'; %low resolution mask

        % vtc temporal filter
        min_wavelength      = 128;
        
end

