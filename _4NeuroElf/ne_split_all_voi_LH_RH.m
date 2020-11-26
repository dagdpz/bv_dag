function ne_split_all_voi_LH_RH(voi_dir)

vois=dir([voi_dir filesep '*.voi']);
for i = 1:length(vois)
    ne_split_voi_LH_RH([voi_dir filesep vois(i).name]);
end