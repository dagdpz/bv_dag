function mdm = ne_pl_create_mdm(mdm_path,mdm_name,vtcs,sdms,session_settings_id,varargin)

run('ne_pl_session_settings');

if nargin > 5, % specified dynamic params, override settings.mdm
	params = struct(varargin{:});
	names = fieldnames(params);
	n_fields = length(names);
	for k=1:n_fields,
		if isfield(settings.mdm,names{k}),
			settings.mdm.(names{k}) = params.(names{k});
		end
	end
end


mdm = xff('new:mdm');
mdm.NrOfStudies		= length(vtcs);
mdm.XTC_RTC		= [vtcs(:), sdms(:)];
 
mdm.SeparatePredictors	= settings.mdm.seppred;
mdm.zTransformation	= settings.mdm.zTransformation;
mdm.PSCTransformation	= settings.mdm.PSCTransformation;
mdm.RFX_GLM		= settings.mdm.RFX_GLM;

mdm.SaveAs([mdm_path filesep mdm_name '.mdm']);
disp(sprintf('%s created', [mdm_path filesep mdm_name '.mdm']))