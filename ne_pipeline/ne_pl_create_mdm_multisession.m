function mdm = ne_pl_create_mdm_multisession(basedir,session_list,mdm_path,mdm_name,session_settings_id,varargin)
% ne_pl_create_mdm_multisession('Z:\MRI\Curius',{'20140213' '20140214' '20140220' '20140221' '20140226' '20140304' '20140306'},'Z:\MRI\Curius\combined\microstim_20140213-20140306\PNM2014','Curius_microstim_20131129-now','combined');
% create mdm for multiple sessions

defpar = { ...
    'vtc_pattern', 'char', 'nonempty', '*spkern*.vtc'; ...		
    'sdm_pattern', 'char', 'nonempty', '*task_*_*.sdm'; ...
};

if nargin > 5, % specified dynamic params
	params = checkstruct(struct(varargin{:}), defpar);
else
	params = checkstruct(struct, defpar); % take all default params
end

% create model path
ne_pl_session_settings;
if isempty(settings.model)
    settings.model = func2str(settings.prt.beh2prt_function_handle);
end
model_path = [mdm_path filesep settings.model];

if ~exist(model_path, 'dir')
    [success,message] = mkdir(model_path);
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
        s = findfiles([basedir filesep session_list{k} filesep settings.model], params.sdm_pattern,'depth=1'); %%KK
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

% move mdm to model path
[success, message] = movefile([mdm_path filesep mdm_name '.mdm'],model_path);
if ~success,
	disp(sprintf('ERROR: cannot move %s to %s: %s',[mdm_path filesep mdm_name '.mdm'],model_path,message));
else
	disp(sprintf('%s moved to %s',[mdm_path filesep mdm_name '.mdm'],model_path));
end





