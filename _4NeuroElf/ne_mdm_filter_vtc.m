function ne_mdm_filter_vtc(mdm_path,varargin)


mdm = xff(mdm_path);


for k = 1:mdm.NrOfStudies,
	ne_filter_vtc(mdm.XTC_RTC{k,1},'',varargin{:});
end