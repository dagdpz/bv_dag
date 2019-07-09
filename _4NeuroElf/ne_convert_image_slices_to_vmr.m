function vmr = ne_convert_image_slices_to_vmr(image_slices_path,image_slices_pattern,vmr_path,dim,SliceThickness)
% ne_convert_image_slices_to_vmr('Y:\MRI\Norman\20181214\dicom\0100\test','*.png','test.vmr',1,0.5);

if 0 % this part is for testing - split vmr to separate image slices
vmr = xff('NO1_20181214_STEREO_neurological.vmr');
dims = [vmr.DimY vmr.DimZ vmr.DimX]; % order: y z x
for sl = 1:dims(dim),
	switch dim
		case 1 % y
			slice = squeeze(vmr.VMRData(sl,:,:));
		case 2 % z
			slice = squeeze(vmr.VMRData(:,sl,:));
		case 3 % x
			slice = squeeze(vmr.VMRData(:,:,sl));
	end
	
	imwrite(slice,sprintf('sl_%03d.png',sl), 'png');
end
return;
end % end of testing part

cd(image_slices_path);
d = dir(image_slices_pattern);

[dim1 dim2] = size(imread(d(1).name));
n_slices = length(d);

switch dim
	case 1 % y
		VMRData = zeros(n_slices,dim1,dim2);
	case 2 % z
		VMRData = zeros(dim1,n_slices,dim2);
	case 3 % x
		VMRData = zeros(dim1,dim2,n_slices);
end
	
for sl = 1:n_slices,
	switch dim
		case 1 % y
			VMRData(sl,:,:) = imread(d(sl).name);
		case 2 % z
			VMRData(:,sl,:) = imread(d(sl).name);
		case 3 % x
			VMRData(:,:,sl) = imread(d(sl).name);
	end
end

% scale so max is 225 - white in BV
% VMRData = VMRData/max(max(max(VMRData)))*225;

vmr = xff('new:vmr');
vmr.VMRData = uint8(VMRData);

vmr.VMR8bit	= true;

vmr.FileVersion = 4;
vmr.ReferenceSpace = 2; % APCP space
vmr.VoxResX = 0.5;
vmr.VoxResY = 0.5;
vmr.VoxResZ = 0.5;

vmr.OffsetX = 0;
vmr.OffsetY = 0;
vmr.OffsetZ = 0;
vmr.FramingCube = 256;
vmr.SliceThickness = SliceThickness;
vmr.Convention = 2;
vmr.VoxResInTalairach = false;
vmr.VoxResVerified = false;




vmr.SaveAs(vmr_path);
disp(['Saved ' vmr_path]);
