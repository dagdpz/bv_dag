function ne_pl_process_one_session_3TUMG_part2(session_path, subj, session_settings_id, proc_steps_array, varargin)
% ne_pl_process_one_session_3TUMG_part2('Y:\MRI\Human\fMRI-reach-decision\Pilot\IVSK\20190620','IVSK','Human_reach_decision_pilot',{'all'},'prt2avg_script','ne_prt2avg_reach_decision_pilot','vmr_pattern','.vmr');
% ne_pl_process_one_session_3TUMG_part2('F:\MRI\Curius\20140204','CU','Curius_microstim_20131129-now',{'all'},'prt2avg_script','ne_prt2avg_fixation_memory_microstim');
% ne_pl_process_one_session_3TUMG_part2('D:\MRI\Bacchus\20141106','BA','Bacchus_reach_and_stay_cues',{'all'},'prt2avg_script','ne_prt2avg_Bacchus_reach_and_stay_cues','vtc_pattern','*spkern*.vtc','sdm_pattern','*MCparams_outlier_preds.sdm');
% ne_pl_process_one_session_3TUMG_part2('D:\MRI\Human.Caltech\IK\20100409','IK', 'Human_spatial_decision_Caltech',{'all'},'prt2avg_script','ne_prt2avg_human_decision_caltech','prt_pattern','*_foravg.prt','sdm_pattern','*MCparams_outlier_preds.sdm');


% uses NeuroElf pipeline

% Inputs required:
% 1) session_path
% 2) subj
% 3) session_settings_id
% 4) proc_steps_array % use {'all'} or any combination of {'step1...' 'step2...'}
%	'create_vtc'
%	'filter_vtc'
%	'create_ppi_sdms'
%	'create_avg'
%	'create_mdm'
%	'exclude_outliers_avg'
%	'create_glm'

if strcmp(proc_steps_array,'all'),
	
	proc_steps.create_vtc		= 0;
	proc_steps.filter_vtc		= 0;
	proc_steps.create_ppi_sdms	= 0; % special case for PPI
	proc_steps.create_avg		= 1;
    proc_steps.create_mdm		= 1;
	proc_steps.exclude_outliers_avg	= 1; % changed to 0 temporarily
	proc_steps.create_glm		= 1;
	
	
else
    
	proc_steps.create_vtc		= 0;
	proc_steps.filter_vtc		= 0;
	proc_steps.create_ppi_sdms	= 0;
	proc_steps.create_avg		= 0;
    proc_steps.create_mdm		= 0;
	proc_steps.exclude_outliers_avg	= 0;
	proc_steps.create_glm		= 0;
	
	temp = (strfind(proc_steps_array,'create_vtc')); if ~isempty([temp{:}]),		proc_steps.create_vtc = 1;		end
	temp = (strfind(proc_steps_array,'filter_vtc')); if ~isempty([temp{:}]),		proc_steps.filter_vtc = 1;		end
	temp = (strfind(proc_steps_array,'create_ppi_sdms')); if ~isempty([temp{:}]),	proc_steps.create_ppi_sdms = 1; end
	temp = (strfind(proc_steps_array,'create_avg')); if ~isempty([temp{:}]),		proc_steps.create_avg = 1;		end
    temp = (strfind(proc_steps_array,'create_mdm')); if ~isempty([temp{:}]),		proc_steps.create_mdm = 1;		end
	temp = (strfind(proc_steps_array,'exclude_outliers_avg')); if ~isempty([temp{:}]),	proc_steps.exclude_outliers_avg = 1;	end
	temp = (strfind(proc_steps_array,'create_glm')); if ~isempty([temp{:}]),		proc_steps.create_glm = 1;		end
	
end

% default parameters, for dynamic params (i.e. those params might change from session to session, even for same dataset)
defpar = { ...
    'model', 'char', 'deblank', '';... % for flexibility, e.g. during avg creation
	'vmr_pattern', 'char', 'nonempty',	'*ACPC*.vmr';... % for vtc creation, use '.vmr' for humans, '*ACPC.vmr' for monkeys
	'fmr_pattern', 'char', 'nonempty',	'*_tf.fmr';... % for vtc creation
	'vtc_pattern', 'char', 'nonempty',	'*spkern*.vtc'; ... % for AVG creation, MDM creation, and/or PPI
	'sdm_pattern', 'char', 'nonempty',	'*task*MCparams.sdm'; ... % for MDM creation, e.g. '*task_CU_*.sdm' or '*task*outlier_preds'
	'prt_pattern', 'char', 'nonempty',	'*.prt'; ... % for AVG creation and/or PPI
	'prt2avg_script','char', 'nonempty',	'ne_prt2avg_generic';... % for AVG creation
	'mdm_prefix', 'char', 'nonempty',	'session_'; ... % for generated MDM's file name
	'mdm_pattern', 'char', 'nonempty',	'*.mdm';... % for GLM computation
	'MCparams','char', 'nonempty', 'MCparams'; ...	% can be 'MCparams' | 'MCzparams', for adding motion correction parameters to PPI SDMs
	};

if nargin > 4, % specified dynamic params
	params = checkstruct(struct(varargin{:}), defpar);
else
	params = checkstruct(struct, defpar); % take all default params
end

[~,session_name] = fileparts(session_path);

ne_pl_session_settings;

if isempty(settings.model) % PN 20200518
    if ~isempty(settings.prt.beh2prt_function_handle)
        settings.model = func2str(settings.prt.beh2prt_function_handle);
    end
end

if ~isempty(params.model), % override if model is provided as varargin
    settings.model = params.model;
end

model_path = [session_path filesep settings.model];

diary([session_path filesep settings.model filesep 'ne_pl_process_one_session_3TUMG_part2.log']);
disp('======================================================================================');
[~, name] = system('hostname');
disp([datestr(now) ' @' name]);
disp(['session_path ',session_path]);
disp(['model_path ',model_path]);
disp(['subj ',subj]);
disp(['session_settings_id ',session_settings_id]);
disp(['proc_steps_array' proc_steps_array]);
disp(['params:']);
disp(params);


if proc_steps.create_vtc
	disp('---- creating vtc');
	vmr_fullname = findfiles([session_path filesep 'anat'],[subj params.vmr_pattern]);
	if ~isempty(vmr_fullname),
		ne_pl_create_vtcs(session_path,vmr_fullname{1},params.fmr_pattern,session_settings_id);
	else
		disp(['ERROR: cannot find VMR ' [subj params.vmr_pattern]]);
	end
end

if proc_steps.filter_vtc
	disp('---- filtering vtc');
	ne_xff_session(session_path, '*_tf.vtc',[],@ne_filter_vtc,'','spat',1,'spkern',settings.vtc_filter.spkern);
end

% PPI: create SDMs with PPI regressors
if proc_steps.create_ppi_sdms
    disp('---- creating PPI SDMs');
    vtcs = findfiles(session_path, params.vtc_pattern);
    prts = findfiles(model_path, params.prt_pattern);
    if isempty(prts),
        disp('ERROR: cannot find prt files');
    else
        for k = 1:length(prts),
            ne_pl_create_sdm(prts{k},session_settings_id,vtcs,k);
        end
    end
    
    if ~isempty(params.MCparams)
        disp('---- adding motion correction predictors to sdm');
        task_sdm_files = dir([model_path filesep '*_task_ppi*.sdm']);
        MC_sdm_files = dir([session_path filesep params.MCparams '.sdm']);
        
        if length(MC_sdm_files) ~= length(task_sdm_files),
            disp(sprintf('ERROR: cannot match task_sdm_files (%d) to MC_sdm_files (%d)',length(task_sdm_files),length(MC_sdm_files)));
        else
            for k = 1:length(task_sdm_files),
                ne_pl_add_pred_sdm([model_path filesep task_sdm_files(k).name],[session_path filesep MC_sdm_files(k).name]);
            end
        end
    end
end


if proc_steps.create_avg
	disp('---- creating avg');
	vtcs = findfiles(session_path, params.vtc_pattern,'depth=2');
	avg_basedir = strrep(session_path,session_name,'');
	vtc_list  = strrep(vtcs,avg_basedir,'');
	prts = findfiles(model_path, params.prt_pattern);
	ne_pl_create_avg(avg_basedir,model_path,vtc_list,prts,params.prt2avg_script);
end


if proc_steps.create_mdm
	disp('---- creating mdm');
	vtcs = findfiles(session_path, params.vtc_pattern,'depth=2');
	sdms = findfiles(model_path, params.sdm_pattern,'depth=1');
	ne_pl_create_mdm(model_path,[params.mdm_prefix session_name],vtcs,sdms,session_settings_id);
end

if proc_steps.exclude_outliers_avg
	disp('---- excluding outliers from avg');
	avg = findfiles(model_path, '*.avg');
	for a = 1:length(avg),
		if isempty(strfind(avg{a},'_no_outliers')),
			ne_pl_exclude_outliers_avg(session_path,avg{a});
		end
	end
end

if proc_steps.create_glm
	disp('---- computing GLM');
	mdm_file = findfiles(model_path, params.mdm_pattern);
	if length(mdm_file) == 1
		ne_pl_createMultiStudyGLM(model_path, ['session_' session_name], session_settings_id, mdm_file{1});
	elseif isempty(mdm_file)
		disp('ERROR: cannot find MDM');
	elseif length(mdm_file) > 1
		disp('ERROR: too many MDM files');
	end
end

disp(['pipeline completed ' datestr(now)]);
disp('======================================================================================');
diary('off');



