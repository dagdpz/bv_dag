function vtc = ne_realign_vtc(vtc_path,vtc_target,maskvmr,varargin)
% see fmriquality ->  perform motion correction

n = neuroelf;
fmridata_target = (permute(vtc_target.VTCData(:, :, :, :), [4, 2, 3, 1])); % removed single

vtc = xff(vtc_path);
vtc = vtc.MaskWithVMR(maskvmr);
fmridata = permute(vtc.VTCData(:, :, :, :), [4, 2, 3, 1]); % removed single



fmrisize = size(fmridata);
opts.res = vtc.Resolution(1, [1, 1, 1]);

trf = eye(4);
trf([1, 6, 11]) = opts.res;
trf(13:15) = 0.5 * (- (opts.res .* (1 + fmrisize(1:3)))');
[tfm, trp, fmridata] = ...
        n.rbalign(fmridata_target, fmridata, struct( ...
        'mask', [], 'robust', false,'trfv1', trf, 'trfv2', trf));

vtc.VTCData = permute(fmridata,[4,2,3,1]);
vtc.VTCData = uint16(vtc.VTCData);

vtc.SaveAs([vtc_path(1:end-4) '_ra.vtc']);
disp([vtc_path(1:end-4) '_ra.vtc']);
vtc.ClearObject;