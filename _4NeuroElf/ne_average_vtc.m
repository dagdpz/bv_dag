function avtc = ne_average_vtc(vtc_list, avtc_path)
% ne_average_vtc - average vtc
% vtc_list - cell array with list of VTC (objects or filenames)


N = length(vtc_list);

avtc = xff(vtc_list{1});
avtc.VTCData = avtc.VTCData/N;

for f = 2:length(vtc_list),
    vtc = xff(vtc_list{f});
    avtc.VTCData = avtc.VTCData + vtc.VTCData/N;
end

avtc.SaveAs(avtc_path);
disp([avtc_path ' saved']);