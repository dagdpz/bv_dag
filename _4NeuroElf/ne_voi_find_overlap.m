function ne_voi_find_overlap(voi_path,voi_pairs,new_voi_path)

if ~isxff(voi_path),
	voi = xff(voi_path);
end

if nargin < 3,
	new_voi_path = [voi_path(1:end-4) '_overlap.voi'];
end


N_o = 0;
for k = 1:length(voi_pairs),
	voi_o = intersect(voi.VOI(voi_pairs(k,1)).Voxels,voi.VOI(voi_pairs(k,2)).Voxels,'rows');
	if ~isempty(voi_o),
		N_o = N_o + 1;
		VOI_o(N_o).Name = [voi.VOI(voi_pairs(k,1)).Name '__' voi.VOI(voi_pairs(k,2)).Name];
		VOI_o(N_o).Color = voi.VOI(voi_pairs(k,1)).Color;
		VOI_o(N_o).NrOfVoxels = length(voi_o);
		VOI_o(N_o).Voxels = voi_o;
	end
end

voi.NrOfVOIs = N_o;
voi.VOI = VOI_o;

voi.SaveAs(new_voi_path);
disp(sprintf('Found %d overlaps in %d pairs of vois, saving as %s',N_o,length(voi_pairs),new_voi_path));
	
	