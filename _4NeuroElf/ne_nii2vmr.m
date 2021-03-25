function ne_nii2vmr(nii_path,suffix)
% ne_nii2vmr('test_T1.nii');


if nargin < 2,
    suffix = '';
end


nii = xff(nii_path);
res = nii.ImgDim.PixSpacing(2); % x, assuming iso

n = neuroelf;
vmr = n.importvmrfromanalyze(nii_path, 'nearest', [0.001 0.999], res);

vmr.SaveAs([nii_path(1:end-4) suffix '.vmr']);