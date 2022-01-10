function nii = ne_change_nii_header_resolution(nii_path,new_res,suffix)
% ne_change_nii_header_resolution - change nominal spatial resolution in the nii header
%
% requires NIFTI folder (e.g. 'Y:\Sources\NIFTI')'
% see also https://brainder.org/2012/09/23/the-nifti-file-format/

if nargin < 3,
    suffix = '';
end

nii = load_nii(nii_path);
pixdim = nii.hdr.dime.pixdim;
pixdim([2 3 4]) = new_res;
nii.hdr.dime.pixdim = pixdim;

save_nii(nii,[nii_path(1:end-4) suffix '.nii']);
