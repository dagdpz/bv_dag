function vmr_path = ne_convert_MRIcron_nifti_to_vmr(nii_path)

[pathstr, name, ext] = fileparts(nii_path);

n = neuroelf;
vmr = n.importvmrfromanalyze(nii_path,'cubic',[0.001 0.999],0.5);

bbb = [128 128 128; 383 383 383]; % corresponds to BV reframing from 512->256
vmr.Reframe(bbb);

vmr.FileVersion = 4;
vmr.ReferenceSpace = 2; % should be in APCP space

vmr.OffsetX = 0;
vmr.OffsetY = 0;
vmr.OffsetZ = 0;
vmr.FramingCube = 256;

vmr.VoxResInTalairach = false;
vmr.VoxResVerified = false;

if isempty(pathstr)
	vmr_path = [name '.vmr'];
else
	vmr_path = [pathstr filesep name '.vmr'];
end

vmr.SaveAs(vmr_path);
disp(['Saved ' vmr_path]);