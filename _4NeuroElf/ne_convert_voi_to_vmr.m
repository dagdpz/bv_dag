function vmr_path = ne_convert_voi_to_vmr(voi_path,secondary_vmr_path,filename_suffix)

if nargin < 3,
	filename_suffix = '_voi';
end

[pathstr, name, ext] = fileparts(voi_path);

vmr2 = xff(secondary_vmr_path);
voi = xff(voi_path);

if voi.NrOfVOIs == 1,

	% works only with non-TAL coordinates (no negative values)!
	if strcmp(voi.ReferenceSpace,'TAL'),
		voi_voxels = voi.BVCoords(1);
	else
		voi_voxels = voi.VOI(1).Voxels;
	end

	idx = sub2ind(size(vmr2.VMRData),voi_voxels(:,1)+1,voi_voxels(:,2)+1,voi_voxels(:,3)+1);

	vmr2.VMRData = zeros(size(vmr2.VMRData));
	vmr2.VMRData(idx) = 255;

	if isempty(pathstr)
		vmr_path = [name filename_suffix '.vmr'];
	else
		vmr_path = [pathstr filesep name filename_suffix '.vmr'];
	end

	vmr2.SaveAs(vmr_path);
	disp(['Saved ' vmr_path]);
else % split VOI to several VMRs
	disp('not yet implemented');
end
	
	