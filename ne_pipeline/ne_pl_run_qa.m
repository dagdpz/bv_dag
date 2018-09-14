function [fq,outlier_volumes] = ne_pl_run_qa(run_path,n_slice,n_slices,n_skip, chan,analyze_tc,settings)
% uses ROI toolbox
% See also RUN_QA

% ne_pl_run_qa('D:\MRI\Curius\20130130\uncombined\0007',[],23,4,'Rx1');
% ne_pl_run_qa('D:\MRI\Curius\20130201\uncombined\0024',[],23,4,''); % mosaic
% ne_pl_run_qa('D:\MRI\Curius\20130201\uncombined\0024',[],23,4,'all'); % all channels one-by-one
% ne_pl_run_qa('/data/RECON/TEST_20130226/epi_00001/f.nii',10,30,0);

if nargin < 5,
	chan = {''}; % all channels, mosaic
elseif strcmpi(chan,'all'),
	chan = {'Rx1' 'Rx2' 'Rx3' 'Rx4'}; % 4-channel coil
else
	chan = {chan}; % separate channel
end

if nargin < 6,
	analyze_tc = 0;
end

ori_dir = pwd;


if ~isempty(findstr(run_path,'.nii')),
	
	[out,pixdim,rotate,dtype] = readnifti(run_path);
	I = permute(squeeze(out(:,:,n_slice,n_skip+1:end)),[2 1 3]);
	I = flipdim(I,1);
	info = [run_path ' sl. ' num2str(n_slice) ' of ' num2str(n_slices) ': ' num2str(size(out,4)-n_skip) ' images'];
	[fq] = series_var_map(I,n_skip,0,0,info,'');
	
	run_name = [strrep(run_path, filesep, '_') '_'];
	
	
elseif ~isempty(findstr(run_path,'.fmr')) %% || ~isempty(findstr(run_path,'.vtc')),
	
	I = ne_fmr_to_3Dmosaic(run_path);
	I = I(:,:,n_skip+1:end);
	n_images = size(I,3);
	info = [run_path ' sl. ' num2str(n_slice) ' of ' num2str(n_slices) ': ' num2str(n_images) ' images'];
	[fq] = series_var_map(I,n_skip,0,0,info,'');
	
	run_name = [strrep(run_path, filesep, '_') '_'];
	
	
else % DICOMs
	cd(run_path);
	
	for k=1:length(chan),
		
		[I,info] = read_slice_dicom_series(n_slice,n_slices,run_path,1,chan{k});
		[fq] = series_var_map(I,n_skip,0,0,info,'');
		
		run_name = [strrep(run_path, filesep, '_') '_' chan{k}];
		
		
	end
end


if analyze_tc,
	[out1] = ne_pl_roi_series(I,n_skip,info,'',1);
end

run_name = strrep(run_name, ':', '');
saveas(gcf, [run_name '.pdf'], 'pdf');



cd(ori_dir);