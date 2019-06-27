function rename_dicom_flex(dicom_dir,varargin)
% rename dicom files in one directory (should contain only one series) according to the DICOM header, following default fields 
% (see below) and then optional fields
% e.g. 
% rename_dicom_flex('D:\MRI\Curius\20130125\2hauke\series25_uncombined','SliceLocation','Private_0051_100f')
% rename_dicom_flex('D:\MRI\Flaffus\20150512\0100','SliceLocation')
% Use resort_dicom2series to move different series to different directories
% Igor Kagan, 20130131

% Default fields
f(1).name = 'PatientID';
f(2).name = 'StudyDate';
f(3).name = 'SeriesNumber';
f(4).name = 'AcquisitionNumber';

if nargin > 1,
	for k=1:length(varargin),
		f(4+k).name = varargin{k}; 
	end
end



%%
ori_dir = pwd;
cd(dicom_dir);
d = dir;



if ~isempty(findstr([f.name],'SliceLocation')), % convert slice location to slice number
	disp('Retrieving slice order from SliceLocation field, please wait...'); 
	for k=3:length(d),
		info = dicominfo(d(k).name);
		slice_loc(k-2) = info.SliceLocation;
	end
	[~,~,slice_number] = unique(slice_loc);
else
	slice_number = zeros(1,length(d)-2);
end


for k=3:length(d),
	new_name = rename_dicom_flex_onefile(d(k).name,f,slice_number(k-2));
end



cd(ori_dir);





function new_name = rename_dicom_flex_onefile(dicom_file,f,slice_number)

info = dicominfo(dicom_file);

new_name = info.(f(1).name);

for k=2:length(f),
	if strcmp(f(k).name,'SliceLocation'),
		new_name = [new_name  '-' sprintf('%04d',slice_number)];
	else
		if ischar(info.(f(k).name)),
			new_name = [new_name  '-' strrep(info.(f(k).name),':','-')];
		else
			new_name = [new_name  '-' sprintf('%04d',round(info.(f(k).name)))];
		end
	end
end
new_name = [new_name '.dcm'];
movefile(dicom_file,new_name);
disp(['Renamed ' dicom_file ' -> ' new_name]);
