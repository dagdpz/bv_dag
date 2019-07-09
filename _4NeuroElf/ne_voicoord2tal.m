function voi = ne_voicoord2tal(voipath)
% Converts VOI coordinates from BrainVoyager reference space to Talairach reference space. 
% Example: voi = ne_voicoord2tal('D:\MRI\Curius\combined\microstim_20140122-20140226_5_3_250uA_nobaseline\11pred\microstim_20140122-20140226_5_3_250uA_nobaseline.voi');

voi = xff(voipath);
disp('---- converting VOI system coordinates to TAL coordinates')

if ~strcmp(voi.ReferenceSpace, 'TAL') % only convert if current reference space is not TAL
    
    n_vois = voi.NrOfVOIs;  
    voi.OriginalVMRResolutionX = 1;
    voi.OriginalVMRResolutionY = 1;
    voi.OriginalVMRResolutionZ = 1;
    
    for v = 1:n_vois
        talcoord = voi.TalCoords(v);
        voi.VOI(v).Voxels = talcoord;
    end
    
    voi.ReferenceSpace = 'TAL'; % update current reference space (now TAL)
    voi.SaveAs([voipath(1:end-4) '_tal.voi']);
    disp([voipath(1:end-4) '_tal.voi saved'])
    
else disp('---- VOI reference space is TAL already')
    
end