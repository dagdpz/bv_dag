function move_one_series_dicom(session_path,series,series_folder_name)
% move_one_series_dicom('D:\MRI\Curius\20121109',103,'T2_15_16_17');

ori_dir = pwd;
cd(session_path);
mkdir(session_path,series_folder_name);
movefile(['*-' sprintf('%04d',series) '-*.dcm'],[session_path filesep series_folder_name]);
disp([[session_path filesep series_folder_name] ' created.']);
cd(ori_dir);