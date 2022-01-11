function nemni_pl2_frd_spm_preproc_pipeline(protocol_file,runpath,jobfile_char)
% prerequisite: extrated niftis in folder structure. This function
% currently needs 5 EPI files and 1 Anatomical per session.

% MAKE SURE 
% to set a path for the buffer for the pipeline at the end of the function. It has to be
% hardcoded. Looping over many subjects can cause the RAM to fill up and
% Matlab stopps working, even though variables are overwritten (use memory and
% imem for diagnostics). Only 'clear all' fully clears the memory.
% 'clearvars -exept x' does not the job. 


% List of open inputs
% Named File Selector: File Set - cfg_files
% Named File Selector: File Set - cfg_files
% Named File Selector: File Set - cfg_files
% Named File Selector: File Set - cfg_files
% Named File Selector: File Set - cfg_files
% Coregister: Estimate: Source Image - cfg_files

%
%%

clear all

% protocol_file = 'Y:\MRI\Human\fMRI-reach-decision\Experiment\behavioral_data\protocols_v2.mat';
load(protocol_file)

%runpath = 'D:\MRI\Human\fMRI-reach-decision\test_subject';
%runpath = 'Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI';

%jobfile_char = 'Y:\Personal\Peter\Repos\bv_dag\nemni_pipeline\nemni_frd_spm_preproc_pipeline_job.m';

%%

tic; 
for u = 1:length(prot)
    
    for e = 1:length({prot(u).session.date})
        
        spm('Defaults','fMRI');
        spm_jobman('initcfg');
        
        toc;
        disp(['start running '  prot(u).name '_' prot(u).session(e).date])
        
        jobfile = {jobfile_char};
        
        clear inputs
        inputs = cell(6, 1);
        
        % Named File Selector: File Set - cfg_files
        inputs{1, 1} = cellstr(spm_select('FPList',[runpath filesep prot(u).name filesep prot(u).session(e).date filesep 'run01'], ...
            '^hum.*\.nii$'));
        inputs{2, 1} = cellstr(spm_select('FPList',[runpath filesep prot(u).name filesep prot(u).session(e).date filesep 'run02'], ...
            '^hum.*\.nii$'));
        inputs{3, 1} = cellstr(spm_select('FPList',[runpath filesep prot(u).name filesep prot(u).session(e).date filesep 'run03'], ...
            '^hum.*\.nii$'));
        inputs{4, 1} = cellstr(spm_select('FPList',[runpath filesep prot(u).name filesep prot(u).session(e).date filesep 'run04'], ...
            '^hum.*\.nii$'));
        inputs{5, 1} = cellstr(spm_select('FPList',[runpath filesep prot(u).name filesep prot(u).session(e).date filesep 'run05'], ...
            '^hum.*\.nii$'));
        % Coregister: Estimate: Source Image - cfg_files
        inputs{6, 1} = cellstr(spm_select('FPList',[runpath filesep prot(u).name filesep prot(u).session(e).date filesep 'anat'], ...
            '^hum.*\.nii$'));
                
        %%%
        spm_jobman('run', jobfile, inputs{:});
        %%%
        
        toc;
        disp(['finished running '  prot(u).name '_' prot(u).session(e).date])
        
        % pipeline buffer
        save('Y:\MRI\Human\fMRI-reach-decision\Experiment\buffer_for_pipeline.mat','prot', 'runpath','jobfile_char','u','e')
        %memory
        %inmem
        
        clear all
        %memory
        %inmem
        load('Y:\MRI\Human\fMRI-reach-decision\Experiment\buffer_for_pipeline.mat')
    end
end
