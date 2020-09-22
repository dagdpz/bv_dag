function nemni_pl1_extract_files


clear all

load('Y:\MRI\Human\fMRI-reach-decision\Experiment\behavioral_data\protocols_v2.mat');

%throwaway =  strcmp('ANEL',{prot.name})| strcmp('ANRE',{prot.name})| strcmp('ANRI',{prot.name})| strcmp('CAST',{prot.name})| strcmp('CLSC',{prot.name})| strcmp('DAGU',{prot.name})| strcmp('ELRH',{prot.name})| strcmp('EVBO',{prot.name})| strcmp('FARA',{prot.name})| strcmp('HEGR',{prot.name})| strcmp('HESE',{prot.name});
throwaway =  strcmp('JOOD',{prot.name});

prot(~throwaway) = [];


runpath = 'D:\MRI\Human\fMRI-reach-decision\mni_Experiment';
nifti_path_source_either = 'F:\MRT-Daten';
nifti_path_source_or = 'F:\MRT-Daten-2';

for i = 1:length(prot) %loop subjects
    
    sessions = length(prot(i).session);
    
    for k = 1:sessions % loop sessions
        
        fo_names = dir(nifti_path_source_either);
        
        if any(strcmp (prot(i).session(k).hum,{fo_names.name})) % is current hum number in nifti_either?
            nifti_path_source = nifti_path_source_either;
        else
            nifti_path_source = nifti_path_source_or;
        end
        
        mni_sort_nifti_into_folders(...
            nifti_path_source ,...                                  % nifti_path_source
            [runpath filesep prot(i).name filesep prot(i).session(k).date],... % session_path
            prot(i).session(k).hum,...                              % hum_nr
            [prot(i).session(k).epi.nr1],...                        % EPI number (first number))
            prot(i).session(k).T1.nr2);                             % anat
        
        
    end% loop sessions
end %loop subjects
    
