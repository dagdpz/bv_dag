function ne_mdm_copy_sessions(mdmpath,source, target, dir_patterns2exclude, file_patterns2exclude, patterns2include, verbose)
% ne_mdm_copy_sessions('combined_spkern_3-3-3.mdm','Y:\MRI\Bacchus', 'F:\MRI\Bacchus', 'dicom', '.dcm');

mdm = xff(mdmpath);

sessions_runs = cellfun(@(x) x(strfind(x, '\2')+1:strfind(x, '\2')+8), mdm.XTC_RTC(:,1), 'UniformOutput',0);
sessions = unique(sessions_runs);

for s = 1:length(sessions)
    source_folder = [source filesep sessions{s}];
    target_folder = [target filesep sessions{s}];
    
    disp([ ' -> ' target filesep sessions{s}]);
    ig_copy_dir_recursively(source_folder, target_folder, dir_patterns2exclude, file_patterns2exclude, patterns2include, verbose)

end
