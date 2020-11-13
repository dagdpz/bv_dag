function nemni_pl3_prt_sdm_nifti
%% AFTER PREPROCESSING, BEFORE MODEL CREATION

% 1. copy behavioral files to mri files
% 2. PRT und SDM (task + MCparams) creation
% 3. change MCparams SDM with other motion correction
% 4. Transforming nii to VTC (change TR)
% 5. apply mask
% 6. DVARS
% 7. add outlier volumes to sdm
% 8. temporal filtering vtc

load('Y:\MRI\Human\fMRI-reach-decision\Experiment\behavioral_data\protocols_v2.mat');
% throwaway = strcmp('ANEL',{prot.name})|...
%              strcmp('ANRE',{prot.name})|...
%              strcmp('ANRI',{prot.name})|...
%              strcmp('CAST',{prot.name});
% prot(throwaway) = [];


%% settings
% general
runpath = 'Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI'; %folder containing subjects containing MRI data
runpath_behavioral = 'Y:\MRI\Human\fMRI-reach-decision\Experiment\behavioral_data'; %folder containing subjects containing BEHAVIORAL matfiles
session_settings_id = 'Human_reach_decision';

% sdm creation
sdm_template = 'Y:\MRI\Human\fMRI-reach-decision\Experiment\behavioral_data\template_sdm_MCparams.sdm';

% vtc creation
nifti_pattern = 's6wrhum_*.nii';

% mask source
msk_source = 'Y:\MRI\Human\mni_icbm152_t1_tal_nlin_sym_09a_mask_vtc.msk';
% vtc temporal filter
min_wavelength = 128;

%
old_dir = pwd;

%%
for i = 1:length(prot) %loop subjects
    
    sessions = length(prot(i).session);
    
    for k = 1:sessions % loop sessions
        
        netools = neuroelf;
        
        session_path = [runpath filesep ... % Y:\MRI\Human\fMRI-reach-decision\Experiment\CLSC\20200114
            prot(i).name filesep ...
            prot(i).session(k).date];
 
        model_path = [session_path filesep 'mat2prt_reach_decision_vardelay_forglm'];
        
        %% check existence and copying matfiles to folder
        for m = 1 : length(prot(i).session(k).epi) 
            
            runpath_beh = [runpath_behavioral filesep ... % Y:\MRI\Human\fMRI-reach-decision\Experiment\behavioral_data\CLSC\20200114\CLSC_2020-01-14_07.mat
                prot(i).name filesep ...
                prot(i).session(k).date filesep ...
                prot(i).session(k).epi(m).mat_file ];
                       
%             %runpath_beh = [runpath filesep ... % Y:\MRI\Human\fMRI-reach-decision\Experiment\behavioral_data\CLSC\20200114\CLSC_2020-01-14_07.mat
%             runpath_beh = ['Y:\MRI\Human\fMRI-reach-decision\Experiment' filesep ... % Y:\MRI\Human\fMRI-reach-decision\Experiment\behavioral_data\CLSC\20200114\CLSC_2020-01-14_07.mat
%                 'behavioral_data' filesep ...
%                 prot(i).name filesep ...
%                 prot(i).session(k).date filesep ...
%                 prot(i).session(k).epi(m).mat_file ];
            
            if ~(exist([session_path filesep prot(i).session(k).epi(m).mat_file],'file') == 2) % if it is not there already
                copyfile(runpath_beh,[session_path filesep])
            end
        end
        
        %% PRT creation
        disp('---- creating prt');
        
        beh_files = dir([session_path filesep '*_??.mat']);% PRT files
        series_order =  [prot(i).session(k).epi.nr1];     % number of EPIs
        
        % check if there are as many mat files as entries in protocoll file
        if length(series_order)~=length(beh_files), 
            disp('ERROR: cannot match EPI series to behavioral files');
        else
            
            % create folder if necessary
            if ~exist([session_path filesep 'mat2prt_reach_decision_vardelay_forglm'])
                mkdir([session_path filesep 'mat2prt_reach_decision_vardelay_forglm']);
            end
            
            
            cd(session_path);
            
            % loop through mat files
            for m = 1:length(beh_files),
                run_name = ['run' num2str(m,'%02d')]; % current run
                
                % create PRT
                prt_fullpath = mat2prt_reach_decision_vardelay_forglm([session_path filesep beh_files(m).name],run_name);         
                
                [success, message] = movefile(prt_fullpath,model_path);
                if ~success,
                    disp(sprintf('ERROR: cannot move %s to %s: %s',prt_fullpath,model_path,message));
                else
                    disp(sprintf('%s moved to %s',prt_fullpath,model_path));
                end
            end
        end
      
        cd(old_dir);
        
        %% task SDM creation
        disp('---- creating sdm for each run');
        
        prt_files = dir([model_path filesep '*.prt']);
        
        if isempty(prt_files),
            disp('ERROR: cannot find prt files');
        else
            for m = 1:length(prt_files),
                ne_pl_create_sdm([model_path filesep prt_files(m).name],session_settings_id);
            end
        end
        
        
        %% MCparams SDM creation
        disp('---- creating MCparams SDM');
        
        for m = 1:length([prot(i).session(k).epi.nr1]) % loop runs
            
            epi_path = [session_path filesep 'run0' num2str(m)'];
            
            % motion parameter file
            txt_name = dir(fullfile(epi_path,'*.txt'));
            txt_name = txt_name.name;
            txt_file = [epi_path filesep txt_name];
            
            % load sdm file
            clear sdm
            sdm = xff(sdm_template);
            
            % load mp parameters from txt file
            mp_txt = load(txt_file);
            
            % change mp params
            %mp_txt_orig = mp_txt;
            mp_txt(:,4:end) = mp_txt(:,4:end)*180/pi; % change rotation to degree
            mp_txt(:,[1,2,4,5]) = mp_txt(:,[1,2,4,5])*-1; %invert x and y coordinates (minus to plus)
            
            %             if 0 % plot both params
            %                 mp_sdm = (sdm.SDMMatrix(:,sdm.FirstConfoundPredictor:end-1));
            %
            %                 figure;
            %                 for a = 1:6
            %
            %                     subplot(2,3,a);
            %                     plot(1:length(mp_txt(:,a)),mp_txt(:,a)); hold on ; plot(1:length(mp_sdm(:,a)),mp_sdm(:,a),'r');
            %                     title(['Motion parameters: shifts (top, in mm) and rotations (bottom, in dg) from SPM (blue) and BV (red)']);
            %
            %                 end
            %             end
            
            % overwrite
            sdm.SDMMatrix(:,:) = mp_txt;
            
            % save
            sdm_name = [prot(i).name '_' prot(i).session(k).date '_' 'run0' num2str(m) '_MCparams'];
            sdm.SaveAs([session_path filesep sdm_name '.sdm']);
            
            ne_plot_MC_onefile([session_path filesep sdm_name '.sdm']);
            saveas(gcf, [session_path filesep sdm_name '.pdf'], 'pdf');
            close(gcf);
            
        end
        
        %% add MC to sdm
        disp('---- adding motion correction predictors to sdm');
        
        task_sdm_files = dir([model_path filesep '*_task.sdm']);
        MC_sdm_files = dir([session_path filesep '*_MCparams.sdm']);
        
        if length(MC_sdm_files) ~= length(task_sdm_files),
            disp(sprintf('ERROR: cannot match task_sdm_files (%d) to MC_sdm_files (%d)',length(task_sdm_files),length(MC_sdm_files)));
        else
            for m = 1:length(task_sdm_files),
                ne_pl_add_pred_sdm([model_path filesep task_sdm_files(m).name],[session_path filesep MC_sdm_files(m).name]);
                
            end
        end
        
        %% create vtc from nifti (+link prt) (+apply mask)
        disp('---- creating vtc from nifti');
        
        for m = 1:length([prot(i).session(k).epi.nr1]) % loop runs
            
            epi_path = [session_path filesep 'run0' num2str(m)'];
            
            % preprocessed nifti
            nifti_name = dir(fullfile(epi_path,nifti_pattern)); % s6wrhum_*.nii
            nifti_name = nifti_name.name;
            nifti_file =   [epi_path filesep nifti_name]; 
            
            % nifti --> vtc
            clear vtc
            vtc = netools.importvtcfromanalyze({nifti_file});
            vtc.TR = 900;
            
            % mask vtc
            msk = xff(msk_source);
            vtc.MaskWithMSK(msk);
          
            % add PRT to nifti
            vtc.NameOfLinkedPRT = [session_path filesep prt_files(m).name];
            
            % save
            vtc.SaveAs([epi_path filesep prot(i).name '_' prot(i).session(k).date '_run0' num2str(m) '.vtc']);   
            disp(['Saved ' [epi_path filesep prot(i).name '_' prot(i).session(k).date '_run0' num2str(m) '.vtc']]);

            
        end
        
        %% DVARS
        disp('---- running QA');
        
        for m = 1:length([prot(i).session(k).epi.nr1]) % loop runs
            
            % vtc path
            epi_path = [session_path filesep 'run0' num2str(m)'];
            vtc_name = dir(fullfile(epi_path,['*run0' num2str(m) '.vtc']));
            vtc_name = vtc_name.name;
            
            % apply QA function
            ne_pl_qa(session_path,[epi_path filesep vtc_name],['run0' num2str(m)],session_settings_id);
            
            
        end
        
        %% adding outlier predictors to sdm
        disp('---- adding outlier predictors to sdm');
        
        task_and_MC_sdm_files = dir([model_path filesep '*task*' '*MCparams.sdm']);
        outlier_mat_files = dir([session_path filesep '*_outlier_volumes.mat']);
        
        if length(task_and_MC_sdm_files) ~= length(outlier_mat_files),
            disp(sprintf('ERROR: cannot match task and MC sdm files (%d) to outlier mat files (%d)',length(task_and_MC_sdm_files),length(outlier_mat_files)));
        else
            for m = 1:length(task_and_MC_sdm_files),
                ne_pl_add_pred_sdm([model_path filesep task_and_MC_sdm_files(m).name],[session_path filesep outlier_mat_files(m).name],0,'outlier_preds');
            end
        end
        

        
        %% temporal filter
        disp('---- filtering vtc');
        
        for m = 1:length([prot(i).session(k).epi.nr1]) % loop runs
            
            epi_path = [session_path filesep 'run0' num2str(m)'];
            
            vtc_name = dir(fullfile(epi_path,['*run0' num2str(m) '.vtc']));
            vtc_name = vtc_name.name;
            
            clear vtc
            vtc = xff([epi_path filesep vtc_name]);
            
            % high pass filter vtc
            vtc.Filter(struct('temp',1,'tempdct',min_wavelength));
            vtc.SaveAs([epi_path filesep  vtc_name(1:end-4) '_tf.vtc']); 
            
             disp(['saved ' epi_path filesep  vtc_name(1:end-4) '_tf.vtc']);
        end
        
%%
    save('Y:\MRI\Human\fMRI-reach-decision\Experiment\buffer_for_pipeline.mat',...
        'prot',...
        'i',...
        'k',...
        'runpath',...
        'runpath_behavioral',...
        'session_settings_id',...
        'sdm_template',...
        'nifti_pattern',...
        'msk_source',...
        'min_wavelength',...
        'old_dir');
    %memory
    %inmem
    
    clear all
    
    load('Y:\MRI\Human\fMRI-reach-decision\Experiment\buffer_for_pipeline.mat')

    end
end
%%


