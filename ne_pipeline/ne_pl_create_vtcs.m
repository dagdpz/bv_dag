function ne_pl_create_vtcs(session_path,vmr_fullname,fmr_pattern,session_settings_id)
% uses vmr.CreateVTC method, works only for humans at the moment
% ne_pl_create_vtcs('D:\MRI\Human.Caltech\IK\20100409','D:\MRI\Human.Caltech\IK\20100409\anat\IK.vmr','*_tf.fmr','Human_spatial_decision_Caltech')

%  VMR::CreateVTC  - mimick BV's VTC creation
%  
%  FORMAT:       [vtc] = vmr.CreateVTC(fmr, afs, vtcfile, res, meth, bbox, dt);
%  
%  Input fields:
%  
%        fmr         FMR object to create VTC from
%        afs         cell array: alignment file objects ({ia, fa, acpc, tal})
%        vtcfile     filename of output VTC
%        res         resolution (default: 3)
%        meth        interpolation, 'cubic', 'lanczos3', {'linear'}, 'nearest'
%        bbox        2x3 bounding box (optional, default: small TAL box)
%        dt          datatype override (default: uint16, FV 2)
%  
%  Output fields:
%  
%        vtc         VTC object
       
run('ne_pl_session_settings');

ia_name = findfiles([session_path filesep 'run01'], '*IA*.trf');
fa_name = findfiles([session_path filesep 'run01'], '*FA*.trf');

if isempty(ia_name),
	disp('*IA*.trf'); return;
end
if isempty(fa_name),
	disp('*FA*.trf'); return;
end

vmr = xff(vmr_fullname);
ia = xff(ia_name{1});
fa = xff(fa_name{1});

tal = {};
acpc = {};
if strcmp(settings.vtc_create.space,'acpc') || strcmp(settings.vtc_create.space,'tal')
	acpc_name = findfiles([session_path filesep 'anat'], '*ACPC*.trf');
	acpc = {xff(acpc_name{1})};
end
if strcmp(settings.vtc_create.space,'tal')
	tal_name = findfiles([session_path filesep 'anat'], '*ACPC.tal');
	tal = {xff(tal_name{1})};
end

fmrs = findfiles(session_path, fmr_pattern);

% make a call to vmr.CreateVTC (will save VTC already!)
for k = 1:length(fmrs),
	fmr		= xff(fmrs{k});
	vtc_fullname	= strrep(fmr.FilenameOnDisk, '.fmr', ['.vtc']);
	vtc = vmr.CreateVTC(fmr, {ia, fa, acpc{:}, tal{:}}, vtc_fullname, ...
		settings.vtc_create.res, settings.vtc_create.meth, settings.vtc_create.bbox, settings.vtc_create.dt);
	disp(['Created ' vtc_fullname]);
end