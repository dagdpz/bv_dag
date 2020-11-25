function ne_mdm_add_subj_prefix_vtc(basedir,mdm_path,per_session_or_run,copy_files)

% ne_mdm_add_subj_prefix_vtc('Y:\MRI\Curius','combined_spkern_3-3-3.mdm','per_session',1)
% ne_mdm_add_subj_prefix_vtc('Y:\MRI\Curius','combined_spkern_3-3-3.mdm','per_run',1)

if nargin < 4,
    copy_files = 1;
end

mdm = xff(mdm_path);

n_runs = size(mdm.XTC_RTC,1);

if n_runs > 100,
    prefix_format = '%03d';
else
    prefix_format = '%02d';
end

prevSession = '';
addPrefix = 0;
for r = 1:n_runs,
    
    vtc_path = mdm.XTC_RTC{r,1};
    sep_idx = strfind(vtc_path,'\');
    idx_ = strfind(vtc_path,'_');
    
    sep_idx_last = sep_idx(end);
    idx1_ = idx_(idx_ > sep_idx_last);
    idx1_ = idx1_(1); % first '_' after last '\'
    
    Subj = vtc_path(sep_idx_last+1:idx1_-1);
    Session = vtc_path(length(basedir)+2:length(basedir)+2+7); % fix this later for non-8-digit sessions
    

    switch per_session_or_run
        case 'per_session'
            
                if ~strcmp(Session,prevSession),
                    addPrefix = addPrefix + 1;
                    prevSession = Session;
                end
                new_vtc_path = strrep(vtc_path,[Subj '_'],[Subj sprintf(prefix_format,addPrefix) '_']);
            
        case 'per_run'
                addPrefix = addPrefix + 1;
                new_vtc_path = strrep(vtc_path,[Subj '_'],[Subj sprintf(prefix_format,addPrefix) '_']);
            
    end
    
    mdm.XTC_RTC{r,1} = new_vtc_path;
    
    if copy_files
        [success,message] = copyfile(vtc_path,new_vtc_path);
    else % move
        [success,message] = ig_movefile(vtc_path,new_vtc_path);  
    end
    
    if success
        disp([vtc_path '->' new_vtc_path]);
    else
        disp(message);
    end
        
    
end

mdm.RFX_GLM = 1;
disp(['Saving ' mdm_path(1:end-4) '_RFX_' per_session_or_run '.mdm']);
mdm.SaveAs([mdm_path(1:end-4) '_RFX_' per_session_or_run '.mdm']);