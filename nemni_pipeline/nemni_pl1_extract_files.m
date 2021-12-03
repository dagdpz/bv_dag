function nemni_pl1_extract_files (protocol_file, runpath, nifti_path_source_either,nifti_path_source_or)

clear all

if nargin < 4
    nifti_path_source_or = '';
end
    
%protocol_file = 'Y:\MRI\Human\fMRI-reach-decision\Experiment\behavioral_data\protocols_v2.mat';
load(protocol_file);

% runpath = 'D:\MRI\Human\fMRI-reach-decision\mni_Experiment';
% nifti_path_source_either = 'F:\MRT-Daten';
% nifti_path_source_or = 'F:\MRT-Daten-2';

for i = 1:length(prot) %loop subjects
    
    sessions = length(prot(i).session);
    
    for k = 1:sessions % loop sessions
        
        fo_names = dir(nifti_path_source_either);
        
        if any(strcmp (prot(i).session(k).hum,{fo_names.name})) % is current hum number in nifti_either?
            nifti_path_source = nifti_path_source_either;
        else
            nifti_path_source = nifti_path_source_or;
        end
        
        nemni_sort_nifti_into_folders(...
            nifti_path_source ,...                                  % nifti_path_source
            [runpath filesep prot(i).name filesep prot(i).session(k).date],... % session_path
            prot(i).session(k).hum,...                              % hum_nr
            [prot(i).session(k).epi.nr1],...                        % EPI number (first number))
            prot(i).session(k).T1.nr2);                             % anat
        
        
    end% loop sessions
end %loop subjects
    
