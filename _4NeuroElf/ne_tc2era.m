function out = ne_tc2era(basedir, tc_file_pattern, avg_fullname, TR, tc_file_pattern_exclude, conditions_config)
% convert any timecourse (MC sdm, any rtc, any mat) to era plot

% Similar to AVG::Average  - average time course according to AVG info
% BUT!!! Note: this function only works for Volume-based AVG files
%        since without the FMR/VTC/MTC the TR is unknown

if nargin < 5,
	tc_file_pattern_exclude = '';
end

if nargin < 6,
	conditions_config = [];
end

[files , n_files] = findfiles(basedir, tc_file_pattern, 'dirs=0', 'depth=1');

if ~isempty(tc_file_pattern_exclude),
	include_idx	= find(~cellfun(@isempty,strfind(files,tc_file_pattern_exclude)));
	files		= files(include_idx);
	n_files		= length(files);
end

avg = xff(avg_fullname);

if strcmp(lower(avg.ResolutionOfDataPoints),'volumes'),
	avg.PreInterval		= avg.PreInterval*TR/1000;
	avg.PostInterval	= avg.PostInterval*TR/1000;
end
	



for f = 1:n_files, % for each file
	
	TC = get_tc(files{f});
	n_volumes = length(TC);
	
	run_marker_idx = strfind(files{f},'run');
	run_marker = files{f}(run_marker_idx:run_marker_idx+4); % e.g. 'run01'
	
	file_idx = find(~cellfun(@isempty,strfind(avg.FileNames,run_marker))); % index of this run in avg
	
	for c=1:avg.NrOfCurves, % for each avg condition
		triggers = round(avg.Curve(c).File(file_idx).Points/TR);
		triggers = triggers(find(triggers > avg.PreInterval && triggers + avg.PostInterval < n_volumes ));
		
		for t=1:length(triggers), % for each trigger, for all TC plots
			volumes2take = [triggers(t)-avg.PreInterval : triggers(t)+avg.PostInterval];
		
			era = TC(volumes2take,:);
			
		end
		
	end
	
	
	
end

