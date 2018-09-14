function fmr = ne_pl_preprocess_fmr(fmr_fullpath,session_settings_id,motion_correction_target_run)

if nargin < 3,
	motion_correction_target_run = fmr_fullpath;
end

run('ne_pl_session_settings');
suffix = '';

fmr = xff(fmr_fullpath);


if ~isempty(settings.fmr_slicetiming.order),
	fmr = fmr.SliceTiming(settings.fmr_slicetiming);
	suffix = [suffix '_st'];
end

if ~isempty(settings.fmr_realign.totarget),
	settings.fmr_realign.totarget = {motion_correction_target_run settings.fmr_realign.totarget}; % add target run to target volume
	fmr = fmr.Realign(settings.fmr_realign);
	suffix = [suffix '_mc'];
	run_path = fileparts(fmr_fullpath);
	session_path  = fileparts(run_path);
	MCparam_files = dir([run_path filesep '*MC*params.sdm']);
	for k = 1:length(MCparam_files), % move MC sdm to session root
		movefile([run_path filesep MCparam_files(k).name],session_path);
	end
	ne_plot_MC_onefile([session_path filesep MCparam_files(1).name]);
	saveas(gcf, [session_path filesep MCparam_files(1).name(1:end-4) '.pdf'], 'pdf');
	close(gcf);
end

if settings.fmr_filter.spat || settings.fmr_filter.temp,
	fmr = fmr.Filter(settings.fmr_filter); 
	
	if settings.fmr_filter.spat,
		suffix = [suffix '_sf'];
	end
	if settings.fmr_filter.temp,
		suffix = [suffix '_tf'];
	end
end
	
fmr.SaveAs([fmr_fullpath(1:end-4) suffix '.fmr']);
disp([fmr_fullpath(1:end-4) suffix '.fmr saved']);