function vtc = ne_nii2vtc(nii_path,original_vtc_path)
% ne_nii2vtc - convert nii to vtc

if nargin < 2,
    original_vtc_path = '';
end

n = neuroelf;

% nii from afni or after saving with save_nii: 60 85 48 (X Y Z)
% vtc or NE-exported nii [85x48x60] when talorder false: Y Z X
% [NE-exported nii: talorder = true -> PixSpacing = 1, otherwise PixSpacing = -1 (default when exporting from NE GUI)]

nii = xff(nii_path);

% bvo = [2, 3, 1];
% xyzDim = nii.ImgDim.Dim(2:4);
% nii.ImgDim.Dim(2:4) = xyzDim(bvo);
% xyzPixSpacing = nii.ImgDim.PixSpacing(2:4);
% nii.ImgDim.PixSpacing(2:4) = xyzPixSpacing(bvo);
% nii.ImgDim.PixSpacing(1) = -1;
% nii.VoxelData = permute(single(nii.VoxelData),bvo);

if ~isempty(original_vtc_path),
    ori_vtc = xff(original_vtc_path);
    vtc = n.importvtcfromanalyze({nii_path},ori_vtc.BoundingBox.BBox,ori_vtc.Resolution);
    vtc.ReferenceSpace = ori_vtc.ReferenceSpace;
else
    vtc = n.importvtcfromanalyze({nii_path},[],2);
end
    

vtc.SaveAs([nii_path(1:end-4) '.vtc']);


