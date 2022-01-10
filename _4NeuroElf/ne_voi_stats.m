function out = ne_voi_stats(voi_path, under_res)


voi = xff(voi_path);



for v = 1:voi.NrOfVOIs
    center(v,:) = mean(voi.VOI(v).Voxels)*under_res;
end

out.mean = mean(center);
out.std  = std(center);

fprintf('%.2f \t %.2f \t %.2f \n', out.mean(1), out.mean(2), out.mean(3));
fprintf('%.2f \t %.2f \t %.2f \n', out.std(1), out.std(2), out.std(3));
