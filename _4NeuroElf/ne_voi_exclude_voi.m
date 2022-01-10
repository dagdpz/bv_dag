function ne_voi_exclude_voi(voi_path,voi_path2exclude,new_voi_path)

if ~isxff(voi_path),
	voi = xff(voi_path);
end

if ~isxff(voi_path2exclude),
	voi2excl = xff(voi_path2exclude);
end

if nargin < 3,
	new_voi_path = [voi_path(1:end-4) '_excl.voi'];
end

for i = 1:voi.NrOfVOIs,
    for j = 1:voi2excl.NrOfVOIs,
        voi.VOI(i).Voxels = setdiff(voi.VOI(i).Voxels,voi2excl.VOI(j).Voxels,'rows');
    end
end

voi.SaveAs(new_voi_path);
	
	