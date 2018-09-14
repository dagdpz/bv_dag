function fmr = ne_pl_create_link_prt(beh_fullpath,run_name,fmr_fullpath,model_path,session_settings_id,beh2prt_function_handle)

if nargin < 6,
	beh2prt_function_handle = ''; % if empty, should come from ne_pl_session_settings
end

run('ne_pl_session_settings');

if isempty(beh2prt_function_handle),
	beh2prt_function_handle = settings.prt.beh2prt_function_handle;
end

prt_fullpath = beh2prt_function_handle(beh_fullpath,run_name);
disp([beh_fullpath ' converted to ' prt_fullpath]);

[session_path prt_filename] = fileparts(prt_fullpath);
[success, message] = movefile(prt_fullpath,model_path);
if ~success,
	disp(sprintf('ERROR: cannot move %s to %s: %s',prt_fullpath,model_path,message));
else
	disp(sprintf('%s moved to %s',prt_fullpath,model_path));
	
	if ~isempty(fmr_fullpath),
		fmr = xff(fmr_fullpath);
		fmr.ProtocolFile = prt_fullpath;
		fmr.Save;
	end
	
end