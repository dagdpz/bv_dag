function nemni_sort_nifti_into_folders(nifti_path_source,session_path,hum_nr,series_order,anat)
% this function takes unziped EPIs and anatomical per session, after Carsten's topup correction script, from <nifti_path_source>, 
% and puts them in <session_path> in new folder structure

% mni_sort_nifti_into_folders('D:\MRI\Human\fMRI-reach-decision\Carsten_folder','D:\MRI\Human\fMRI-reach-decision\mni_Experiment\JOOD\20200207','hum_14835',[6, 9, 12, 17, 20], 15)

% nifti_path_source --> substructure being <nifti_path_source\hum_number\nifti>

if series_order
    for m = 1:length(series_order) % loop through EPI runs
        
        % extracting EPIs
        run_name = ['run' num2str(m,'%02d')];
        [~,mess,~] = mkdir (session_path, run_name);
        
        if isempty(mess)
            disp([[session_path filesep run_name] ' created']);
            
            gzipfilename = [nifti_path_source filesep hum_nr filesep 'nifti' filesep...
                hum_nr '_'...
                sprintf('%04d',series_order(m)) '_'...
                'topupcorr.nii.gz'];  % '.nii.gz'];
            
            gunzip(gzipfilename,[session_path filesep run_name]);
            disp([gzipfilename ' unpacked']);
        else
            disp([[session_path filesep run_name] ' already exists']);
        end
        
    end
end

if anat
    % extracting anat
    [~,mess,~] = mkdir (session_path, 'anat');
    
    if isempty(mess)
        disp([[session_path filesep 'anat'] ' created']);
        
        gzipfilename = [nifti_path_source filesep hum_nr filesep 'nifti' filesep...
            hum_nr '_'...
            sprintf('%04d',anat)...
            '.nii.gz'];
        
        gunzip(gzipfilename,[session_path filesep 'anat']);
        disp([gzipfilename ' unpacked']);
    else
        disp([[session_path filesep 'anat'] ' already exists']);
    end
end

