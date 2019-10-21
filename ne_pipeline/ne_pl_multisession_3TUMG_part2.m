function ne_pl_multisession_3TUMG_part2(basedir,session_list,dataset_path,dataset_name,avg_name,session_settings_id,proc_steps_array,varargin)
% uses NeuroElf pipeline
% this function is a wrapper to run multisession steps (currently tested for a single subject)
% uses:
% ne_pl_create_mdm_multisession(basedir,session_list,mdm_path,mdm_name,session_settings_id,varargin)
% ne_combine_avg(basedir,session_list,avg_name,avg_search_path,new_avg_name)
% ne_pl_createMultiStudyGLM(glm_path, glm_name, session_settings_id, mdm_file)
%
% ne_pl_multisession_3TUMG_part2('Y:\MRI\Human\fMRI-reach-decision\Pilot\MAPA',{'20*'},'','MAPA_combined','*no_outliers.avg','Human_reach_decision_pilot',{'all'},'sdm_pattern','*outlier_preds.sdm');

% Inputs required:
% 1) basedir
% 2) session_list
% 3) dataset_path (where to store resulting mdm, avg and glm files, typically [basedir filesep model_name]
%    - if full path is not specified, basedir will be appended in the beginning
% 4) dataset_name 
% 5) avg_name - names or patterns of avg files to combine
% 6) session_settings_id
% 7) proc_steps_array % use {'all'} or any combination of {'step1...' 'step2...'}
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
    'vtc_pattern', 'char', 'nonempty', '*spkern*.vtc'; ...		
    'sdm_pattern', 'char', 'nonempty', '*task_*_*.sdm'; ...
    'prt_pattern', 'char', 'nonempty', '*.prt'; ...
    'prt2avg_script','char', 'nonempty', 'ne_prt2avg_generic';...
    'mdm_pattern', 'char', 'nonempty', '*.mdm';...
};

if nargin > 7, % specified dynamic params
	params = checkstruct(struct(varargin{:}), defpar);
else
	params = checkstruct(struct, defpar); % take all default params
end

if isempty(strfind(dataset_path,basedir)), % not a full path
    dataset_path = [basedir filesep dataset_path];
end

run('ne_pl_session_settings');
if isempty(settings.model)
    settings.model = func2str(settings.prt.beh2prt_function_handle);
end

dataset_path = [dataset_path filesep settings.model];

if ~exist(dataset_path, 'dir')
    [success,message] = mkdir(dataset_path);
    if ~success,
        disp(sprintf('ERROR: %s',message));
    end
end

if proc_steps.create_mdm
ne_pl_create_mdm_multisession(basedir,session_list,dataset_path,dataset_name,session_settings_id,'vtc_pattern',params.vtc_pattern,'sdm_pattern',params.sdm_pattern);
end

if proc_steps.create_avg
% ne_pl_create_avg_multisession(basedir,session_list,dataset_path,filename,prt2avg_script,varargin); % does not support avg without outliers
disp('---- creating avg');
ne_combine_avg(basedir,session_list,avg_name,settings.model,[settings.model filesep dataset_name]);
end

if proc_steps.create_glm
disp('---- creating glm');    
mdm_file = findfiles(dataset_path, params.mdm_pattern);
ne_pl_createMultiStudyGLM(dataset_path, dataset_name, session_settings_id, mdm_file{1});
end
