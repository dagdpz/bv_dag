function vtc = ne_average_multivol_vtc(vtc_path,suffix)
% ne_average_multivol_vtc - average multivolume vtc

if nargin < 2,
    suffix = '_ave';
end

vtc = xff(vtc_path);
if ~isxff(vtc, 'vtc')
    clearxffobjects({vtc});
    error('Not a VTC file!');
end

% compute the mean over time
mvtc = mean(vtc.VTCData);

vtc.NrOfVolumes = 1;

vtc.VTCData = mvtc;
vtc.SaveAs([vtc_path(1:end-4) suffix '.vtc']);
vtc.ClearObject;


