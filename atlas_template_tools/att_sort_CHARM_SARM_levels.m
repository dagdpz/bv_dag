function att_sort_CHARM_SARM_levels(pathname, keyfile, subj, combine_and_split_hemispheres)
% keyfile: CHARMfull or SARMfull

max_level = max(keyfile.First_Level);


for lev = 1:max_level
    
    lev_dir = [pathname filesep 'level_' num2str(lev)];
    mkdir(lev_dir);
    
    % vois belonging to this level
    lev_idx = find(lev >= keyfile.First_Level & lev <= keyfile.Last_Level);
    
    n_files = 0;
    for f = 1:length(lev_idx),
        d = dir([pathname filesep subj '_' num2str(lev_idx(f)) '-*.voi']);
        if ~isempty(d),
            n_files = n_files + 1;
            copyfile([pathname filesep d.name], lev_dir);
        end
    end
    disp(sprintf('Copied %d files to %s',n_files,lev_dir));
    
    if combine_and_split_hemispheres,
        ne_combine_multiple_vois(findfiles(lev_dir,'*.voi'),[lev_dir filesep 'level_' num2str(lev) '.voi']);
        ne_split_voi_LH_RH([lev_dir filesep 'level_' num2str(lev) '.voi']);
    end
    
end



