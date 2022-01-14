function ne_coregister_vtc(vtc_path,vtc_target,maskvmr,varargin)
% ne_coregister_vtc('BA_20170719_run01_st_mc_tf_spat_1_spkern_3-3-3_ave_cr.vtc','Y:\MRI\Bacchus\combined\vtc_per_run_ave_masked_5_stim_ds.vtc');

if nargin < 3,
    maskvmr = '';
end

if ~isxff(vtc_target),
    vtc_target = xff(vtc_target);
end

n = neuroelf;

vtc = xff(vtc_path);

if ~isempty(maskvmr)
    vtc = vtc.MaskWithVMR(maskvmr);
end

%       obj2        second xff object
%       opts        optional settings
%        .bbox      bounding box (TAL notation, default: -127 .. 128)
%        .grad      use gradient information instead (default: false)
%        .norm      normalize volumes to mid range (default: true)
%        .normrng   normalization range (default: 0.95)
%        .grid      resolution gridsize (mm, default: [4, 2])
%        .smoothsrc pre-smoothing kernel of source data in mm (default: 8)
%        .smoothtrg pre-smoothing kernel of target data in mm (default: 8)
%        .srcvol    source volume (default: 1)
%        .trgvol    target volume (default: 1)

m44 = vtc.Coregister(vtc_target,struct('grad',true,'norm',false,'grid',[2],'smoothsrc',6,'smoothtrg',6)); % it seems that transformation is already taking place here

m44 = eye(4);
trf = xff('new:TRF');
trf.TransformationType = 2;
trf.CoordinateSystem = 1;
trf.ExtraVMRTransf = 0;
trf.ExtraVMRTransfValues = eye(4);
trf.TFMatrix = m44;

vtct = vtc.ApplyTrf(trf);

vtct.SaveAs([vtc_path(1:end-4) '_cr.vtc']);
disp([vtc_path(1:end-4) '_cr.vtc created']);
vtc.ClearObject;
vtct.ClearObject;