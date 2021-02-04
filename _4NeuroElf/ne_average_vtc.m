function vtc = ne_average_vtc(vtc_path)
% ne_average_vtc - average multivolume vtc

vtc = xff(vtc_path);
if ~isxff(vtc, 'vtc')
    clearxffobjects({vtc});
    error('Not a VTC file!');
end

% compute the mean over time
mvtc = mean(vtc.VTCData);

vtc.NrOfVolumes = 1;

vtc.VTCData = mvtc;
vtc.SaveAs([vtc_path(1:end-4) '_ave.vtc']);


