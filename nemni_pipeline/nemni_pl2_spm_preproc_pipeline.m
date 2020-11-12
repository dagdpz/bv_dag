function nemni_pl2_spm_preproc_pipeline
% prerequisite: extrated niftis in folder structure

% List of open inputs
% Named File Selector: File Set - cfg_files
% Named File Selector: File Set - cfg_files
% Named File Selector: File Set - cfg_files
% Named File Selector: File Set - cfg_files
% Named File Selector: File Set - cfg_files
% Coregister: Estimate: Source Image - cfg_files

clear all
%load('D:\MRI\Human\fMRI-reach-decision\test_subject\JOOD_protocol.mat');
load('Y:\MRI\Human\fMRI-reach-decision\Experiment\behavioral_data\protocols_v2.mat');

%throwaway =  strcmp('JOOD_corr_estint4',{prot.name});% |  strcmp('JOOD',{prot.name}) ;
% throwaway =  strcmp('ANEL',{prot.name})  | ...
%              strcmp('ANRE',{prot.name})  | ...
%              strcmp('ANRI',{prot.name})  | ...
%              strcmp('CAST',{prot.name})  | ...
%              strcmp('CLSC',{prot.name})  | ...
%              strcmp('DAGU',{prot.name})  | ...
%              strcmp('ELRH',{prot.name})  | ...
%              strcmp('EVBO',{prot.name}) ;
% throwaway =  strcmp('FARA',{prot.name})  | ...
%              strcmp('HEGR',{prot.name})  | ...
%              strcmp('HESE',{prot.name})  | ...
%              strcmp('JAGE',{prot.name})  | ...
%              strcmp('JOOD',{prot.name})  | ...
%              strcmp('LAHI',{prot.name}) ;
% throwaway =  strcmp('LEKU',{prot.name})  | ...
%              strcmp('LIKU',{prot.name})  | ...
%              strcmp('LORU',{prot.name})  | ...
%              strcmp('LUAM',{prot.name})  | ...
%              strcmp('MABA',{prot.name})  | ...
%              strcmp('MABL',{prot.name})  | ...
%              strcmp('MARO',{prot.name})  | ...
%              strcmp('NORE',{prot.name})  | ...
%              strcmp('OLPE',{prot.name})  | ...
%              strcmp('PASC',{prot.name}) ;

%throwaway =  strcmp('JAKU',{prot.name});
%prot(~throwaway) = [];

%runpath = 'D:\MRI\Human\fMRI-reach-decision\test_subject';
runpath = 'D:\MRI\Human\fMRI-reach-decision\mni_Experiment';
%%

tic; 
for u = 1:length(prot)
    
    for e = 1:length({prot(u).session.date})
        
        spm('Defaults','fMRI');
        spm_jobman('initcfg');
        
        toc;
        disp(['start running '  prot(u).name '_' prot(u).session(e).date])
        
        jobfile = {'Y:\Personal\Peter\Repos\bv_dag\nemni_pipeline\nemni_spm_preproc_pipeline_job.m'};
        
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
        
        save('D:\MRI\Human\fMRI-reach-decision\mni_Experiment\buffer_for_pipeline.mat','prot', 'runpath','u','e')
        %memory
        %inmem
        
        clear all
        %memory
        %inmem
        load('D:\MRI\Human\fMRI-reach-decision\mni_Experiment\buffer_for_pipeline.mat')
    end
end
