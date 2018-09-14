function sdm = ne_pl_add_pred_sdm(sdm_fullpath,add_sdm_fullpath,Zscore,new_sdm_name_suffix)

if nargin < 3,
	Zscore = 0;
end
if nargin < 4,
	new_sdm_name_suffix = '';
end


sdm = ne_add_pred2sdm(sdm_fullpath,add_sdm_fullpath,Zscore,new_sdm_name_suffix);




