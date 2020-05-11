function ne_pl_process_one_session_3TUMG_part1(session_path, dicom_folder, series_order, anat, subj,session_settings_id,proc_steps_array,varargin)
% ne_pl_process_one_session_3TUMG_part1('Y:\MRI\Human\fMRI-reach-decision\Pilot\IVSK\20190620','dicom',[10 13 16 19 22],6,'IVSK','Human_reach_decision_pilot',{'create_fmr'});
% ne_pl_process_one_session_3TUMG_part1('F:\MRI\Curius\20140204','ani_0708',[7 8 9 12 13],10,'CU','Curius_microstim_20131129-now',{'all'});
% ne_pl_process_one_session_3TUMG_part1('F:\MRI\Curius\20140204','ani_0708',[7 8 9 12 13],10,'CU','Curius_microstim_20131129-now',{'all'},'MCparams','MCzparams');
% ne_pl_process_one_session_3TUMG_part1('F:\MRI\Curius\20140204','ani_0708',[7 8 9 12 13],10,'CU','Curius_microstim_20131129-now',{'create_prt'});
% ne_pl_process_one_session_3TUMG_part1('F:\MRI\Curius\20140204','ani_0708',[7 8 9 12 13],10,'CU','Curius_microstim_20131129-now',{'create_sdm'});
% ne_pl_process_one_session_3TUMG_part1('D:\MRI\Bacchus\20141106','ani_0834',[10 11 12 13 14 15 16],6,'BA','Bacchus_reach_and_stay_cues',{'set_confound_preds'},'fConfPred',4);


% uses NeuroElf pipeline

% Inputs required:
% 1) session_path
% 2) dicom_folder 
% 3) series order - functional EPI series
% 4) anat series (use 0 if no session anat)
% 5) subj (First two letters for monkey, 2 and 2 (Name / Family name) for human, CAPITAL
% 6) session_settings_id (see ne_pl_session_settings.m)
% 7) proc_steps_array % use {'all'} or any combination of {'step1...' 'step2...'}
%	'create_fmr'
%	'create_prt'
%	'preprocess_fmr'
%	'create_sdm'
%	'add_MC_sdm'
%	'run_QA'
%	'add_outliers_sdm'
%	'set_confound_preds'

if strcmp(proc_steps_array,'all'),
	proc_steps.create_fmr		= 0;
	proc_steps.create_prt		= 1;
	proc_steps.preprocess_fmr	= 0;
	proc_steps.create_sdm		= 1;
	proc_steps.add_MC_sdm		= 1;
	proc_steps.run_QA           = 0;
	proc_steps.add_outliers_sdm	= 1;
	proc_steps.set_confound_preds	= 0;
	
else
	proc_steps.create_fmr		= 0;
	proc_steps.create_prt		= 0;
	proc_steps.preprocess_fmr	= 0;
	proc_steps.create_sdm		= 0;
	proc_steps.add_MC_sdm		= 0;
	proc_steps.run_QA		= 0;
	proc_steps.add_outliers_sdm	= 0;
	proc_steps.set_confound_preds	= 0;
	
	temp = (strfind(proc_steps_array,'create_fmr')); if ~isempty([temp{:}]),		proc_steps.create_fmr = 1;		end
	temp = (strfind(proc_steps_array,'create_prt')); if ~isempty([temp{:}]),		proc_steps.create_prt = 1;		end	
	temp = (strfind(proc_steps_array,'preprocess_fmr')); if ~isempty([temp{:}]),		proc_steps.preprocess_fmr = 1;		end
	temp = (strfind(proc_steps_array,'create_sdm')); if ~isempty([temp{:}]),		proc_steps.create_sdm = 1;		end	
	temp = (strfind(proc_steps_array,'add_MC_sdm')); if ~isempty([temp{:}]),		proc_steps.add_MC_sdm = 1;		end
	temp = (strfind(proc_steps_array,'run_QA')); if ~isempty([temp{:}]),			proc_steps.run_QA = 1;			end
	temp = (strfind(proc_steps_array,'add_outliers_sdm')); if ~isempty([temp{:}]),		proc_steps.add_outliers_sdm = 1;	end
	temp = (strfind(proc_steps_array,'set_confound_preds')); if ~isempty([temp{:}]),	proc_steps.set_confound_preds = 1;	end
end
	
ne_pl_session_settings;

% default parameters, for dynamic params (i.e. those params might change from session to session, even for same dataset)
switch settings.Species
    
    case 'human'
        % default parameters, for dynamic params (i.e. those params might change from session to session, even for same dataset)
        defpar = { ...
            % 'behorder','double', 'nonempty', []; ...			% order of behavioral data files [1 file -> 1 series (run)]
            'behpattern', 'char', 'nonempty', '*_??.mat'; ...		% pattern of behavioral data files for creating PRTs, '*_timing.txt' | '*.mat'
            'PRTpattern','char', 'nonempty', '*.prt'; ...		% for creating SDMs, can be '*.prt' | '*_foravg.prt'
            'MCparams','char', 'nonempty', 'MCparams'; ...		% for adding motion correction parameters to SDM, can be 'MCparams' | 'MCzparams'
            'fConfPred','double','nonempty',0; ...			% first Confound Predictor in final SDMs for MDM
            'SDMpattern','char', 'nonempty', '*task*MCparams.sdm'; ...	% for setting confound predictors, can be '*task*MCparams.sdm' | '*task*outlier_preds.sdm'
            'beh2prt_function_handle','function_handle','deblank',''; ...  % if not empty, specify beh2prt_function_handle to override settings.prt.beh2prt_function_handle
            'model', 'char', 'deblank', '';... % for flexibility, e.g. during prt creation
            };
        
    case 'monkey'
        % default parameters, for dynamic params (i.e. those params might change from session to session, even for same dataset)
        defpar = { ...
            % 'behorder','double', 'nonempty', []; ...			% order of behavioral data files [1 file -> 1 series (run)]
            'behpattern', 'char', 'nonempty', '*_*.mat'; ...		% pattern of behavioral data files for creating PRTs, '*_timing.txt' | '*.mat'
            'PRTpattern', 'char', 'nonempty', '*.prt'; ...		% for creating SDMs, can be '*.prt' | '*_foravg.prt'
            'MCparams', 'char', 'nonempty', 'MCparams'; ...		% for adding motion correction parameters to SDM, can be 'MCparams' | 'MCzparams'
            'fConfPred', 'double', 'nonempty', 0; ...			% first Confound Predictor in final SDMs for MDM
            'SDMpattern', 'char', 'nonempty', '*task*MCparams.sdm'; ...	% for setting confound predictors, can be '*task*MCparams.sdm' | '*task*outlier_preds.sdm'
            'beh2prt_function_handle', 'function_handle', 'deblank', ''; ...  % if not empty, specify beh2prt_function_handle to override settings.prt.beh2prt_function_handle
            'model', 'char', 'deblank', '';... % for flexibility, e.g. during prt creation
            };
end

if nargin > 7, % specified dynamic params
	params = checkstruct(struct(varargin{:}), defpar);
else
	params = checkstruct(struct, defpar);
end

[~,session_name] = fileparts(session_path);

ori_dir = pwd;
dicom_path = [session_path filesep dicom_folder];
cd(session_path);

if isempty(settings.model) && ~isempty(settings.prt.beh2prt_function_handle)
    settings.model = func2str(settings.prt.beh2prt_function_handle);
end

if ~isempty(params.model), % override if model is provided as varargin
    settings.model = params.model;
end

model_path = [session_path filesep settings.model];
[success,message] = mkdir(model_path);
if ~success,
	disp(sprintf('ERROR: %s',message));
else
	disp(sprintf('Processing %s',settings.model));
end

% try
	
diary([model_path filesep 'ne_pl_process_one_session_3TUMG_part1.log']);
disp('======================================================================================');
[~, name] = system('hostname');
disp([datestr(now) ' @' name]);
disp(['session_path ',session_path]);
disp(['model_path ',model_path]);
disp(['dicom_folder ',dicom_folder]);
disp(['series_order ',mat2str(series_order)]);
disp(['anat ',mat2str(anat)]);
disp(['subj ',subj]);
disp(['session_settings_id ',session_settings_id]);
disp(['proc_steps_array' proc_steps_array]);
disp(['params:']);
disp(params);


save([model_path filesep 'session-settings.mat'],'settings');

if ~isempty(dicom_folder) % perform dicom file operations and create appropriate anat and runXX directories
    
    % determine if dicoms are zipped or not
    if exist([dicom_path '.zip'],'file') && ~exist(dicom_path,'dir') ,
        disp(['Unzipping ' [dicom_path '.zip']]);
        unzip([dicom_path '.zip']);
        % delete([dicom_path '.zip']);
    elseif exist([dicom_path '.tar.gz'],'file') && ~exist(dicom_path,'dir') ,
        disp(['Unpacking ' [dicom_path '.tar.gz']]);
        untar([dicom_path '.tar.gz']);
        % delete([dicom_path '.tar.gz']);
    end
    
    if exist([session_path filesep 'PaxHeader'],'dir'),
        rmdir('PaxHeader','s');
    end
    

% copy DICOMs to individual run folders (run01 run02 etc.)
for k = 1:length(series_order), % for each run
	run_name = ['run' num2str(k,'%02d')];
	[~,mess,~] = mkdir(session_path,run_name);
	if isempty(mess),
		movefile([dicom_path filesep '*-' sprintf('%04d',series_order(k)) '-*.dcm'],[session_path filesep run_name]);
%         movefile([dicom_path filesep '*-' sprintf('1%03d',series_order(k)) '-*.dcm'],[session_path filesep run_name]);
		disp([[session_path filesep run_name] ' created']);
	else
		disp([[session_path filesep run_name] ' already exists']);
	end
	
end 

if anat,
    [~,mess,~] = mkdir(session_path,'anat');
    if isempty(mess),
        movefile([dicom_path filesep '*-' sprintf('%04d',anat) '-*.dcm'],[session_path filesep 'anat']);
        %               movefile([dicom_path filesep '*-' sprintf('1%03d',anat) '-*.dcm'],[session_path filesep 'anat']);
        disp([[session_path filesep 'anat'] ' created']);
    else
        disp([[session_path filesep 'anat'] ' already exists']);
    end
    
end


d = dir(dicom_path);
if ~any([d(3:end).isdir]),
    resort_dicom2series(dicom_path);
end

end % of dicom operations


if proc_steps.create_fmr
    disp('---- creating fmr project for each run');
    for k = 1:length(series_order),
        run_name = ['run' num2str(k,'%02d')];
        fmr_fullpath = [session_path filesep run_name filesep subj '_' session_name '_' run_name '.fmr'];
        ne_pl_create_fmr([session_path filesep run_name],fmr_fullpath,session_settings_id);
        
    end
end

if proc_steps.create_prt
    disp('---- creating (and linking) prt to fmr');
    beh_files = dir([session_path filesep params.behpattern]);
    
    if length(series_order)~=length(beh_files),
        disp('ERROR: cannot match EPI series to behavioral files');
    else
        cd(session_path);
        for k = 1:length(beh_files), % for each run
            run_name = ['run' num2str(k,'%02d')];
            fmr_fullpath = [session_path filesep run_name filesep subj '_' session_name '_' run_name '.fmr'];
            if exist(fmr_fullpath,'file'),
                ne_pl_create_link_prt([session_path filesep beh_files(k).name], run_name, fmr_fullpath, model_path, session_settings_id, params.beh2prt_function_handle);
            else
                ne_pl_create_link_prt([session_path filesep beh_files(k).name], run_name, '', model_path, session_settings_id, params.beh2prt_function_handle);
            end
        end
    end
end

if proc_steps.preprocess_fmr
    disp('---- preprocessing fmr project for each run');
    for k = 1:length(series_order),
        run_name = ['run' num2str(k,'%02d')];
        fmr_fullpath = [session_path filesep run_name filesep subj '_' session_name '_' run_name '.fmr'];
        if k == 1,
            motion_correction_target_run = fmr_fullpath; % align to first volume of the first run
        end
        ne_pl_preprocess_fmr(fmr_fullpath,session_settings_id,motion_correction_target_run);
    end
end

if proc_steps.create_sdm
    disp('---- creating sdm for each run');
    prt_files = dir([model_path filesep params.PRTpattern]);
    if isempty(prt_files),
        disp('ERROR: cannot find prt files');
    else
        for k = 1:length(prt_files),
            ne_pl_create_sdm([model_path filesep prt_files(k).name],session_settings_id);
        end
    end
end

if proc_steps.add_MC_sdm
    disp('---- adding motion correction predictors to sdm');
    task_sdm_files = dir([model_path filesep '*_task.sdm']);
    MC_sdm_files = dir([session_path filesep '*' params.MCparams '.sdm']);
    if isempty(MC_sdm_files), % for older Caltech processing, try .rtc
        MC_sdm_files = dir([session_path filesep '*' params.MCparams '.rtc']);
    end
    
    if length(MC_sdm_files) ~= length(task_sdm_files),
        disp(sprintf('ERROR: cannot match task_sdm_files (%d) to MC_sdm_files (%d)',length(task_sdm_files),length(MC_sdm_files)));
    else
        for k = 1:length(task_sdm_files),
            ne_pl_add_pred_sdm([model_path filesep task_sdm_files(k).name],[session_path filesep MC_sdm_files(k).name]);
            
        end
    end
end


if proc_steps.run_QA
    disp('---- running QA');
    for k = 1:length(series_order),
        run_name = ['run' num2str(k,'%02d')];
        fmr_fullpath = [session_path filesep run_name filesep subj '_' session_name '_' run_name '.fmr'];
        ne_pl_qa(session_path,fmr_fullpath,run_name,session_settings_id);
        
    end
end

if proc_steps.add_outliers_sdm
    disp('---- adding outlier predictors to sdm');
    task_and_MC_sdm_files = dir([model_path filesep '*task*' params.MCparams '.sdm']);
    outlier_mat_files = dir([session_path filesep '*_outlier_volumes.mat']);
    if length(task_and_MC_sdm_files) ~= length(outlier_mat_files),
        disp(sprintf('ERROR: cannot match task and MC sdm files (%d) to outlier mat files (%d)',length(task_and_MC_sdm_files),length(outlier_mat_files)));
    else
        for k = 1:length(task_and_MC_sdm_files),
            ne_pl_add_pred_sdm([model_path filesep task_and_MC_sdm_files(k).name],[session_path filesep outlier_mat_files(k).name],0,'outlier_preds');
        end
    end
end


if proc_steps.set_confound_preds && params.fConfPred
    disp(['---- setting confound preds starting from ' num2str(params.fConfPred) ' in ' params.SDMpattern]);
    ne_xff_replace_param([model_path],1,0,params.SDMpattern,'FirstConfoundPredictor',params.fConfPred)
end

disp(['pipeline completed ' datestr(now)]);
disp('======================================================================================');
diary('off');
cd(ori_dir);

% catch ME
% 	disp(' ');
% 	disp(['EXECTUTION ERROR: ' ME.message])
% 	disp(['pipeline NOT completed !!! ' datestr(now)]);
% 	disp('======================================================================================');
% 	diary('off');
% 	cd(ori_dir);
% end

