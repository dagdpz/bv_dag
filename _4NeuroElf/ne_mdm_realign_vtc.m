function ne_mdm_realign_vtc(mdm_path,target,maskvmr,varargin)
% ne_mdm_realign_vtc('Y:\MRI\Bacchus\combined\_microstim_vPulv_20170719-20170817_all8_100uA\BA_mat2prt_fixmemstim\combined_spkern_3-3-3.mdm',...
%    'Y:\MRI\Bacchus\combined\vtc_per_run_ave_masked_5_stim_ds.vtc','Y:\MRI\Bacchus\BA_noclean_20140711_ACPC_brain_NE.vmr');

mdm = xff(mdm_path);
vtc_target = xff(target);
maskvmr = xff(maskvmr);

for k = 1:mdm.NrOfStudies,
    disp(['Processing ' num2str(k) ' of ' num2str(mdm.NrOfStudies) ' files...']);
	ne_realign_vtc(mdm.XTC_RTC{k,1},vtc_target,maskvmr,varargin{:});
end