function ne_nii2vmp(nii_path,suffix)
% ne_nii2vmp('sig_in_T1space.nii');


if nargin < 2,
    suffix = '';
end


nii = xff(nii_path);
res = nii.ImgDim.PixSpacing(2); % x, assuming iso

n = neuroelf;
vmr = n.importvmrfromanalyze(nii_path, 'nearest', [0.001 0.999], res);

vmp = n.newnatresvmp(vmr.BoundingBox.BBox, vmr.VoxResX);
vmp.Map.VMPData = vmr.VMRData;

vmp.SaveAs([nii_path(1:end-4) suffix '.vmp']);