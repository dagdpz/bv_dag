function ne_pl_multisession_3TUMG_part2(basedir,session_list,subj,dataset_path,filename,prt2avg_script,session_settings_id,proc_steps_array,varargin)
% uses NeuroElf pipeline

% Inputs required:
% 1) session_path
% 2) subj
% 3) session_settings_id
% 4) proc_steps_array % use {'all'} or any combination of {'step1...' 'step2...'}
%	'create_mdm'
%	'create_avg'
%   'create_glm'

if strcmp(proc_steps_array,'all'),
	proc_steps.create_mdm		= 1;
	proc_steps.create_avg		= 1;
    proc_steps.create_glm       = 1;

else
	proc_steps.create_mdm		= 0;
	proc_steps.create_avg		= 0;
    proc_steps.create_glm		= 0;
	
	temp = (strfind(proc_steps_array,'create_mdm')); if ~isempty([temp{:}]),	proc_steps.create_mdm = 1; end
	temp = (strfind(proc_steps_array,'create_avg')); if ~isempty([temp{:}]),	proc_steps.create_avg = 1; end
    temp = (strfind(proc_steps_array,'create_glm')); if ~isempty([temp{:}]),	proc_steps.create_glm = 1; end

end

% default parameters, for dynamic params (i.e. those params might change from session to session, even for same dataset)
defpar = { ...
    'vtc_pattern', 'char', 'nonempty', '*.vtc'; ...		
    'sdm_pattern', 'char', 'nonempty', ['*task_' subj '_*.sdm']; ...
    'prt_pattern', 'char', 'nonempty', '*.prt'; ...
    'prt2avg_script','char', 'nonempty', 'ne_prt2avg_generic';...
    'mdm_pattern', 'char', 'nonempty', '*.mdm';...
};

if nargin > 8, % specified dynamic params
	params = checkstruct(struct(varargin{:}), defpar);
else
	params = checkstruct(struct, defpar); % take all default params
end

run('ne_pl_session_settings');

if proc_steps.create_mdm
disp('---- creating mdm');
ne_pl_create_mdm_multisession(basedir,session_list,dataset_path,filename,varargin);
end

if proc_steps.create_avg
disp('---- creating avg');
ne_pl_create_avg_multisession(basedir,session_list,dataset_path,filename,prt2avg_script,varargin);
end

if proc_steps.create_glm
disp('---- computing GLM');
mdm_file = findfiles(dataset_path, params.mdm_pattern);
ne_pl_createMultiStudyGLM(dataset_path, filename, session_settings_id, mdm_file);
end


end