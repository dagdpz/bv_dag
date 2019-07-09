function ne_xff_session(session_path,file_pattern,findfiles_option,function_handle,varargin)
% wrapper for multiple xff file processing in one session 
% ne_xff_session('F:\MRI\Curius\20131016','*.prt',[],@ne_prt2sdm,'nvol',450,'prtr',2000,'rcond',[],'hpttp',3); % convert prt to sdm
% ne_xff_session('F:\MRI\Curius\20131016_H','*.vtc',[],@ne_filter_vtc,'','spat',1,'spkern',[2 2 2],'temp',1,'tempdct',3); % filter vtc
% ne_xff_session('F:\MRI\Curius\20131018','*.vtc',[],@ne_vtc_bounding_box); % show bounding box

fc = 0; % file counter
if 0 % if only search in subfolders
	% find folders in the session folder
	subfolders = findfiles(session_path, '*', 'dirs=1', 'depth=1');
	nsf = numel(subfolders);

	% create a cell array for filenames
	files = cell(nsf+1, 1);

	% first pass: lookup files
	for fc = 1:nsf
		files{fc} = findfiles(subfolders{fc}, file_pattern);
	end
end

% check session root folder
files{fc+1} = findfiles(session_path, file_pattern, findfiles_option);

files = cat(1, files{:});


% iterate over found files
for fc = 1:numel(files)

	disp(['Processing ' files{fc}]);
	function_handle(files{fc},varargin{:});
	

end