function ne_split_voi_LH_RH(voi_path)

[path, name] = fileparts(voi_path);

lvoi=xff(voi_path);
rvoi=xff(voi_path);

for i = 1:length(lvoi.VOI)
    lvoi.VOI(i).Voxels(lvoi.VOI(i).Voxels(:,3)<lvoi.OriginalVMRFramingCubeDim/2,:)=[];
    lvoi.VOI(i).Name = [lvoi.VOI(i).Name '_L'];
    rvoi.VOI(i).Voxels(rvoi.VOI(i).Voxels(:,3)>rvoi.OriginalVMRFramingCubeDim/2,:)=[];
    rvoi.VOI(i).Name = [rvoi.VOI(i).Name '_R'];
end
lvoi.SaveAs([path filesep name '_L.voi']);
disp(['Saved ' name '_L'])
rvoi.SaveAs([path filesep name '_R.voi']);
disp(['Saved ' name '_R'])
