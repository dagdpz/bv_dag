function [filelist, basedir_sessions] = ne_mdm_getSessionsPath(mdmpath, searchStr)
% filelist = ne_mdm_getSessionsPath('Y:\MRI\Bacchus\combined\_microstim_dPulv_20170202-20170224_4_2_150-250uA\BA_mat2prt_fixmemstim\combined_spkern_3-3-3.mdm',
% '\anat\*_ACPC.vmr'); % find in-plane vmrs

mdm = xff(mdmpath);

basedir_sessions = unique(cellfun(@(x) x(1:strfind(x, '\2')+8), mdm.XTC_RTC(:,1), 'UniformOutput',0));

filelist = '';
if ~isempty(searchStr)
    for s = 1:length(basedir_sessions),
            filelist(s) = findfiles([basedir_sessions{s} searchStr]);   
    end

    filelist = filelist';
end