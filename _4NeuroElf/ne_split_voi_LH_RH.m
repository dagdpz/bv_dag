function ne_split_voi_LH_RH(voi_path)

[path, name] = fileparts(voi_path);

lvoi=xff(voi_path);
rvoi=xff(voi_path);

lvoi.VOI.Voxels(lvoi.VOI.Voxels(:,3)<lvoi.OriginalVMRFramingCubeDim/2,:)=[];
lvoi.VOI.Name = [name '_L'];
rvoi.VOI.Voxels(rvoi.VOI.Voxels(:,3)>rvoi.OriginalVMRFramingCubeDim/2,:)=[];
rvoi.VOI.Name = [name '_R'];


lvoi.SaveAs([path filesep name '_L.voi']);
disp('Saved left hemisphere')
rvoi.SaveAs([path filesep name '_R.voi']);
disp('Saved right hemisphere')

