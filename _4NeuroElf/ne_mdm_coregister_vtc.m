function ne_mdm_coregister_vtc(mdm_path,target,maskvmr,varargin)


mdm = xff(mdm_path);
vtc_target = xff(target);
maskvmr = xff(maskvmr);

for k = 1:mdm.NrOfStudies,
    disp(['Processing ' num2str(k) ' of ' num2str(mdm.NrOfStudies) ' files...']);
	ne_coregister_vtc(mdm.XTC_RTC{k,1},vtc_target,maskvmr,varargin{:});
end