function ne_mdm_add_suffix_vtc(mdm_path,suffix)
% ne_mdm_add_suffix_vtc('Y:\MRI\Bacchus\combined\_microstim_vPulv_20170719-20170817_all8_100uA\BA_mat2prt_fixmemstim\combined_spkern_3-3-3.mdm','_ra');


mdm = xff(mdm_path);
mdm.XTC_RTC = strrep(mdm.XTC_RTC,'.vtc',[suffix '.vtc']);
mdm.SaveAs([mdm_path(1:end-4) suffix '.mdm']);