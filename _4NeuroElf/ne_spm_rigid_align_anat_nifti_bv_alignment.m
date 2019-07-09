function ne_spm_rigid_align_anat_nifti_bv_alignment(nifti2align_path,nifti_align2_path,varargin)
% uses spm
% see also:
% http://www-personal.umich.edu/~nichols/JohnsGems.html
% https://www.jiscmail.ac.uk/cgi-bin/webadmin?A2=spm;9196f5f5.1006

% nifti2align_path -> nifti_align2_path
vol_1 = spm_vol(nifti_align2_path); % reference
vol_2 = spm_vol(nifti2align_path);
x = spm_coreg(vol_2, vol_1);
M = spm_matrix(x);
spm_get_space(nifti2align_path, M*vol_2.mat);
% spm_get_space('civm_rhesus_v1_labels.NIH_0.5_256_mod.nii', M*vol_2.mat);

flags= struct('interp',5,'mask',1,'mean',0,'which',1,'wrap',[0 0 0]');
spm_reslice({nifti_align2_path; nifti2align_path}, flags);
% spm_reslice({nifti_align2_path; 'civm_rhesus_v1_labels.NIH_0.5_256_mod.nii'}, flags);

% T2_img = spm_read_vols(T2_vol);
% T2_img(T2_img < 0) = 0 ;
% spm_write_vols(T2, T2_img);