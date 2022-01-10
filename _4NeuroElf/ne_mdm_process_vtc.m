function ne_mdm_process_vtc(mdm_path,varargin)
% ne_mdm_process_vtc('Y:\MRI\Bacchus\combined\_microstim_vPulv_20170719-20170817_all8_100uA\BA_mat2prt_fixmemstim\combined_spkern_3-3-3_ra.mdm');

mdm = xff(mdm_path);

for k = 1:mdm.NrOfStudies,
    disp(['Processing ' num2str(k) ' of ' num2str(mdm.NrOfStudies) ' files...']);
	% ne_realign_vtc(mdm.XTC_RTC{k,1},vtc_target,maskvmr,varargin{:});
    vtc = xff(mdm.XTC_RTC{k,1});
    vtc.VTCData = uint16(vtc.VTCData);
    vtc.Save;
    vtc.ClearObject;
end