function n = ne_vmp_count_significant_voxels(vmp_path, threshold)
% threshold: one value or [negative positive] pair

vmp = xff(vmp_path);

if numel(threshold) == 1,
    if threshold < 0,
        n = sum(sum(sum(vmp.Map.VMPData<threshold)));
    else
        n = sum(sum(sum(vmp.Map.VMPData>threshold)));
    end
else
    n(1) = sum(sum(sum(vmp.Map.VMPData<threshold(1))));
    n(2) = sum(sum(sum(vmp.Map.VMPData>threshold(2))));
end


% imagesc(squeeze(vmp.Map.VMPData(:,20,:))>2.75); % show voxels > 2.75 in an axial slice 20