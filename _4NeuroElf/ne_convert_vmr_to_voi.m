function voi_path = ne_convert_vmr_to_voi(vmr_path,color,voi_name,filename_suffix,species)

if nargin < 2,
	color = [250 128 128];
end

if nargin < 3
	voi_name = '';
end

if nargin < 4,
	filename_suffix = '';
end

if nargin < 5,
    species = 'monkey';
end

[pathstr, name, ext] = fileparts(vmr_path);
if isempty(voi_name),
	voi_name = name;
end

vmr = xff(vmr_path);

ind = find(vmr.VMRData > 0);
[iy,iz,ix] = ind2sub(size(vmr.VMRData),ind);

voi = xff('new:voi');

voi.FileVersion = 4;
voi.ReferenceSpace = 'ACPC';

if strcmp(species,'monkey'),
    voi.OriginalVMRResolutionX = 0.5;
    voi.OriginalVMRResolutionY = 0.5;
    voi.OriginalVMRResolutionZ = 0.5;
else
    voi.OriginalVMRResolutionX = 1;
    voi.OriginalVMRResolutionY = 1;
    voi.OriginalVMRResolutionZ = 1;
end
voi.SubjectVOINamingConvention = '<SUBJ>_<VOI>';
voi.NrOfVOIs = 1;
voi.VOI  = struct('Name',voi_name,'Color',color,'NrOfVoxels',length(iy),'Voxels',[iy-1 iz-1 ix-1]);


if isempty(pathstr)
	voi_path = [name filename_suffix '.voi'];
else
	voi_path = [pathstr filesep name filename_suffix '.voi'];
end

voi.SaveAs(voi_path);
disp(['Saved ' voi_path]);
voi.ClearObject;
vmr.ClearObject;