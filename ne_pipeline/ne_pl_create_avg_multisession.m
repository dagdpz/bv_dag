function avg = ne_pl_create_avg_multisession(basedir,session_list,avg_path,avg_add_name,prt2avg_script,session_settings_id, varargin)
% ne_pl_create_avg_multisession('Z:\MRI\Curius\',{'20140213' '20140214' '20140220' '20140221' '20140226' '20140304' '20140306'},'Z:\MRI\Curius\combined\microstim_20140213-20140306\PNM2014','combined_','ne_prt2avg_fixation_memory_microstim');
% create avg for multiple sessions
% This function does not work for avgs without outliers, since the information about outliers is not in prt files -> use NE_COMBINE_AVG instead

defpar = { ...
    'vtc_pattern', 'char', 'nonempty', '*spkern*.vtc'; ...		
    'prt_pattern', 'char', 'nonempty', '*.prt'; ...
};

if nargin > 6, % specified dynamic params
	params = checkstruct(struct(varargin{:}), defpar);
else
	params = checkstruct(struct, defpar); % take all default params
end

% create model path
ne_pl_session_settings;
if isempty(settings.model)
    settings.model = func2str(settings.prt.beh2prt_function_handle);
end
model_path = [avg_path filesep settings.model];

if ~exist(model_path, 'dir')
    [success,message] = mkdir(model_path);
    if ~success,
        disp(sprintf('ERROR: %s',message));
    end
end

% create avg
disp('---- creating avg');
n_sessions = length(session_list);
vtcs = [];
prts = [];
for k = 1:n_sessions,
	vtcs = [vtcs; findfiles([basedir filesep session_list{k}], params.vtc_pattern)];
    
    if isdir([basedir filesep session_list{k} filesep settings.model])
        prts = [prts; findfiles([basedir filesep session_list{k} filesep settings.model], params.prt_pattern)];
    else
        prts = [prts; findfiles([basedir filesep session_list{k}], params.prt_pattern)];
    end
    disp(['session ' session_list{k} ' processed']);
end
vtc_list  = strrep(vtcs,basedir,'');

[avg, avg_fullpath] = ne_pl_create_avg(basedir,avg_path,vtc_list,prts,prt2avg_script,avg_add_name);

% move avg to model path
[success, message] = movefile(avg_fullpath,model_path);
if ~success,
	disp(sprintf('ERROR: cannot move %s to %s: %s',avg_fullpath,model_path,message));
else
	disp(sprintf('%s moved to %s',avg_fullpath,model_path));
end