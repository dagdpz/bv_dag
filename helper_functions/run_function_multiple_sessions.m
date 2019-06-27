function run_function_multiple_sessions(basepath,sessions,filename,function_handle,varargin)

% run_function_multiple_sessions('Y:\MRI\Human\Action Selection\Blocked',...
% 	{'RIME\20140313' 'VIRI\20140320' 'EDGR\20140320' 'THAN\20140320' 'EVPI\20140509' 'KRKA\20140521' 'VEGU\20140611' 'GESP\20140617' 'CHKO\20141015' 'MAKO\20141105' 'JUBR\20141105' 'ADAS\20141120' 'THTR\20141120' 'NIOE\20141120' 'CAHE\20141203'},...
% 	'ne_prt2avg_Humans_Poffenberger_no_outliers.avg',@ne_expand_basedir_avg);

% run_function_multiple_sessions('Y:\MRI\Human\Action Selection\Blocked',...
% 	{'RIME\20140313' 'VIRI\20140320' 'EDGR\20140320' 'THAN\20140320' 'EVPI\20140509' 'KRKA\20140521' 'VEGU\20140611' 'GESP\20140617' 'CHKO\20141015' 'MAKO\20141105' 'JUBR\20141105' 'ADAS\20141120' 'THTR\20141120' 'NIOE\20141120' 'CAHE\20141203'},...
% 	'ne_prt2avg_Humans_Poffenberger_no_outliers.avg',@ne_collapse_basedir_avg,1,'mod');

% Iterate over sessions
for s = 1:numel(sessions)
	function_handle([basepath filesep sessions{s} filesep filename],varargin{:});
end