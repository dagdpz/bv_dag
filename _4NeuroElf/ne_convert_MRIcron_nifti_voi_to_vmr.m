function vmr_path = ne_convert_MRIcron_nifti_voi_to_vmr(nii_path,suffix,species)
% 
if nargin < 2,
    suffix = '';
end

if nargin < 3,
    species = 'monkey';
end

[pathstr, name, ext] = fileparts(nii_path);

if isempty(whos('global','n'))
    n = neuroelf;
else
    global n
end

if strcmp(species,'monkey'),
    vmr = n.importvmrfromanalyze(nii_path,'nearest',[0.001 0.999],0.5);
    vmr.VMRData = vmr.VMRData16/vmr.MaxOriginalValue*225; % make it white in BV (color value 225)
    
    bbb = [128 128 128; 383 383 383]; % corresponds to BV reframing from 512->256
    % bbb = [128 127 129; 383 382 384]; % corresponds to BV reframing from 512->256
    % order: y z x
    
    vmr.Reframe(bbb);
    
    vmr.FileVersion = 4;
    vmr.ReferenceSpace = 2; % APCP space
    
    vmr.OffsetX = 0;
    vmr.OffsetY = 0;
    vmr.OffsetZ = 0;
    vmr.FramingCube = 256;
    
    vmr.VoxResInTalairach = false;
    vmr.VoxResVerified = false;
    
else
    vmr = n.importvmrfromanalyze(nii_path,'cubic');
    vmr.VMRData = vmr.VMRData16/vmr.MaxOriginalValue*225; % make it white in BV (color value 225)
end


if isempty(pathstr)
    vmr_path = [name suffix '.vmr'];
else
    vmr_path = [pathstr filesep name suffix '.vmr'];
end

vmr.SaveAs(vmr_path);
disp(['Saved ' vmr_path]);