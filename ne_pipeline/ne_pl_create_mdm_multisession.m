function mdm = ne_pl_create_mdm_multisession(basedir,session_list,mdm_path,mdm_name,session_settings_id,varargin)
% create mdm for multiple sessions
% ne_pl_create_mdm_multisession('Z:\MRI\Curius',{'20140213' '20140214' '20140220' '20140221' '20140226' '20140304' '20140306'},'Z:\MRI\Curius\combined\microstim_20140213-20140306\PNM2014','Curius_microstim_20131129-now','combined');
% ne_pl_create_mdm_multisession('Y:\MRI\Human\fMRI-reach-decision\Pilot\LEHU',{'20190723' '20190724' '20190725_1' '20190725_2'},...
% 'Y:\MRI\Human\fMRI-reach-decision\Pilot\LEHU','test','Human_reach_decision_pilot', 'sdm_pattern','*_outlier_preds.sdm');


defpar = { ...
    'model', 'char', 'deblank', ''; ... % for flexibility, e.g. during avg creation % PN 20200518
    'vtc_pattern', 'char', 'nonempty', '*spkern*.vtc'; ...		
    'sdm_pattern', 'char', 'nonempty', '*task_*_*.sdm'; ...
};

if nargin > 5, % specified dynamic params
	params = checkstruct(struct(varargin{:}), defpar);
else
	params = checkstruct(struct, defpar); % take all default params
end

if length(session_list)==1 &&  ~isempty(strfind(session_list{1},'*')), % not a session list but matching pattern
    session_list = findfiles(basedir,session_list,struct('depth',1,'dirs',1));
    session_list = strrep(session_list,basedir,'');
    session_list = strrep(session_list,'\','');
    session_list = strrep(session_list,'/','');
end

% make sure mdm_path contains model_path
run('ne_pl_session_settings');
if isempty(settings.model)
    if ~isempty(settings.prt.beh2prt_function_handle)
        settings.model = func2str(settings.prt.beh2prt_function_handle);
    end
end

if ~isempty(params.model) 
    settings.model = params.model;
end


if isempty(strfind(mdm_path,settings.model)),
    mdm_path = [mdm_path filesep settings.model];
end

if ~exist(mdm_path, 'dir')
    [success,message] = mkdir(mdm_path);
    if ~success,
        disp(sprintf('ERROR: %s',message));
    end
end

% create mdm
disp('---- creating mdm');
n_sessions = length(session_list);
vtcs = [];
sdms = [];
session_names = ['combined'];
for k = 1:n_sessions,
	v = findfiles([basedir filesep  session_list{k}], params.vtc_pattern,'depth=2');
    vtcs = [vtcs; v(:)];
    
    if exist([basedir filesep session_list{k} filesep settings.model], 'dir')
        s = findfiles([basedir filesep session_list{k} filesep settings.model], params.sdm_pattern,'depth=1');
    else
        s = findfiles([basedir filesep session_list{k}], params.sdm_pattern,'depth=1');
    end
    
	sdms = [sdms; s(:)];
	session_names = [session_names '_' session_list{k}];
    disp(['session ' session_list{k} ' processed']);
end

if isempty(mdm_name),
	mdm_name = session_names;
end

mdm = ne_pl_create_mdm(mdm_path,mdm_name,vtcs,sdms,session_settings_id,varargin{:});




