function nemni_pl3_prt_sdm_nifti
%% AFTER PREPROCESSING, BEFORE MODEL CREATION

% 0. PRT und SDM creation
% 1. Transforming nii to VTC
% 2. change TR
% 3. change MCparams SDM with other motion correction


load('D:\MRI\Human\fMRI-reach-decision\test_subject\JOOD_protocol.mat');
throwaway = strcmp('JOODcorr',{prot.name});

prot(~throwaway) = [];


%% settings
% general
runpath = 'D:\MRI\Human\fMRI-reach-decision\test_subject';
session_settings_id = 'Human_reach_decision';

% sdm creation
sdm_template = 'Y:\MRI\Human\fMRI-reach-decision\Experiment\behavioral_data\template_sdm_MCparams.sdm';

% vtc creation
nifti_pattern = 's8wrhum_*.nii';
% vtc temporal filter
min_wavelength = 60;

%%
old_dir = pwd;
netools = neuroelf;

for i = 1:length(prot) %loop subjects
    
    sessions = length(prot(i).session);
    
    for k = 1:sessions % loop sessions
        
        session_path = [runpath filesep ... % Y:\MRI\Human\fMRI-reach-decision\Experiment\CLSC\20200114
            prot(i).name filesep ...
            prot(i).session(k).date];
        
        %% check existence and copying matfiles to folder
        for m = 1 : length(prot(i).session(k).epi) 
            
            %runpath_beh = [runpath filesep ... % Y:\MRI\Human\fMRI-reach-decision\Experiment\behavioral_data\CLSC\20200114\CLSC_2020-01-14_07.mat
            runpath_beh = ['Y:\MRI\Human\fMRI-reach-decision\Experiment' filesep ... % Y:\MRI\Human\fMRI-reach-decision\Experiment\behavioral_data\CLSC\20200114\CLSC_2020-01-14_07.mat
                'behavioral_data' filesep ...
                prot(i).name filesep ...
                prot(i).session(k).date filesep ...
                prot(i).session(k).epi(m).mat_file ];
            
            if ~(exist([session_path filesep prot(i).session(k).epi(m).mat_file],'file') == 2) % if it is not there already
                copyfile(runpath_beh,[session_path filesep])
            end
        end
        
        %% PRT creation
  
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
            
            model_path = [session_path filesep 'mat2prt_reach_decision_vardelay_forglm'];
            
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
        prt_files = dir([model_path filesep '*.prt']);
        
        if isempty(prt_files),
            disp('ERROR: cannot find prt files');
        else
            for m = 1:length(prt_files),
                ne_pl_create_sdm([model_path filesep prt_files(m).name],session_settings_id);
            end
        end
        
        
        %% MCparams SDM creation
        
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
            sdm_name = [prot(i).name '_' prot.session(k).date '_' 'run0' num2str(m) '_MCparams.sdm'];
            sdm.SaveAs([session_path filesep sdm_name]);
            
        end
        
        %% add MC to sdm
        task_sdm_files = dir([model_path filesep '*_task.sdm']);
        MC_sdm_files = dir([session_path filesep '*_MCparams.sdm']);
        
        if length(MC_sdm_files) ~= length(task_sdm_files),
            disp(sprintf('ERROR: cannot match task_sdm_files (%d) to MC_sdm_files (%d)',length(task_sdm_files),length(MC_sdm_files)));
        else
            for m = 1:length(task_sdm_files),
                ne_pl_add_pred_sdm([model_path filesep task_sdm_files(m).name],[session_path filesep MC_sdm_files(m).name]);
                
            end
        end
        
        %% create vtc from nifti (+link prt)
       
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
            
            % high pass filter vtc
            vtc.Filter(struct('temp',1,'tempdct',min_wavelength);
            
            % add PRT to nifti
            vtc.NameOfLinkedPRT = [session_path filesep prt_files(m).name];
            
            % save
            vtc.SaveAs([epi_path filesep prot(i).name '_' prot(i).session(k).date '_run0' num2str(m) '_preproc_tf.vtc']);            

        end
        

    end
end
%%
