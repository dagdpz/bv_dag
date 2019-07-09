function ne_voi_flip_x(voi_path,suffix)
% copy existing voi(s) to the opposite hemisphere

if nargin < 2,
	suffix = '_flip_x';
end

[pathstr, name, ext] = fileparts(voi_path);

voi = xff(voi_path);

x_center = voi.OriginalVMRFramingCubeDim/2; % typically 128

for k = 1:voi.NrOfVOIs,
	
	if strcmp(voi.ReferenceSpace,'TAL'),
		voi.VOI(k).Voxels(:,1) = - voi.VOI(k).Voxels(:,1);
	else
		voi.VOI(k).Voxels(:,3) = x_center + x_center - voi.VOI(k).Voxels(:,3);
	end

	
	if ~isempty(strfind(voi.VOI(k).Name,'_l')),
		voi.VOI(k).Name = strrep(voi.VOI(k).Name,'_l','_r');
	elseif ~isempty(strfind(voi.VOI(k).Name,'_r')),
		voi.VOI(k).Name = strrep(voi.VOI(k).Name,'_r','_l');
	else
		voi.VOI(k).Name = [voi.VOI(k).Name,'_flip_x'];
	end
end

if isempty(pathstr)
	voi_path = [name suffix '.voi'];
else
	voi_path = [pathstr filesep name suffix '.voi'];
end

voi.SaveAs(voi_path);
disp(['Saved ' voi_path]);