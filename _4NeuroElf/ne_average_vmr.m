function avmr = ne_average_vmr(vmr_list, avmr_path)
% ne_average_vmr - average vmr
% vmr_list - cell array with list of VMR (objects or filenames)

vmr_list = {
'Y:\MRI\Bacchus\20170719\anat\BA_20170719_ACPC.vmr'
'Y:\MRI\Bacchus\20170802\anat\BA_20170802_ACPC.vmr'
'Y:\MRI\Bacchus\20170803\anat\BA_20170803_ACPC.vmr'
'Y:\MRI\Bacchus\20170804\anat\BA_20170804_ACPC.vmr'
'Y:\MRI\Bacchus\20170810\anat\BA_20170810_ACPC.vmr'
'Y:\MRI\Bacchus\20170811\anat\BA_20170811_ACPC.vmr'
'Y:\MRI\Bacchus\20170816\anat\BA_20170816_ACPC.vmr'
'Y:\MRI\Bacchus\20170817\anat\BA_20170817_ACPC.vmr'
};

n = neuroelf;
avmr = n.averagevmrs(vmr_list);

avmr.SaveAs(avmr_path);
disp([avmr_path ' saved']);


