function ne_avg_add_suffix_vtc(avg_path,suffix)
% ne_avg_add_suffix_vtc('Y:\MRI\Curius\combined\_microstim_20131129-20131218_2_tar_4_4_150-250uA_nobaseline\combined_spkern_3-3-3_ne_prt2avg_fixation_memory_microstim.avg','_cr');


avg = xff(avg_path);
avg.FileNames = strrep(avg.FileNames,'.vtc',[suffix '.vtc']);
avg.SaveAs([avg_path(1:end-4) suffix '.avg']);