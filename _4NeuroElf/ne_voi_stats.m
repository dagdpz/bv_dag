function out = ne_voi_stats(voi_path, under_res)


voi = xff(voi_path);



for v = 1:voi.NrOfVOIs
    center(v,:) = mean(voi.VOI(v).Voxels)*under_res;
end

out.mean = mean(center);
out.std  = std(center);