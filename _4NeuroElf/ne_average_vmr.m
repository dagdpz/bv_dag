function avmr = ne_average_vmr(vmr_list, avmr_path)
% ne_average_vmr - average vmr
% vmr_list - cell array with list of VMR (objects or filenames), e.g. from ne_mdm_getSessionsPath
% ne_average_vmr(filelist,'Y:\MRI\Bacchus\combined\_microstim_dPulv_20170202-20170224_4_2_150-250uA\BA_mat2prt_fixmemstim\2021\T2_inplane_ACPC.vmr');


% this approach not really working - for NE GUI only?
%{
n = neuroelf;
avmr = n.averagevmrs(vmr_list);
%}

N = length(vmr_list);

avmr = xff(vmr_list{1});
avmr.VMRData = avmr.VMRData/N;

for f = 2:length(vmr_list),
    vmr = xff(vmr_list{f});
    avmr.VMRData = avmr.VMRData + vmr.VMRData/N;
end

avmr.SaveAs(avmr_path);
disp([avmr_path ' saved']);


