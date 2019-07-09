function ne_xff_replace_param(session_path,search_main_path,search_subfolders,file_pattern,varargin)
% e.g. 
% ne_xff_replace_param('F:\MRI\Curius\20131016_H',0,1,'*.vtc','TR',2000); % look only in run0x 
% ne_xff_replace_param('D:\MRI\Bacchus\20141106',1,0,'*task*MCparams.sdm','FirstConfoundPredictor',7)


fc = 0;
if search_subfolders,
	% find folders in the session folder
	subfolders = findfiles(session_path, 'run*', 'dirs=1', 'depth=1');
	nsf = numel(subfolders);

	% create a cell array for VTC and PRT filenames
	files = cell(nsf, 1);

	% first pass: lookup files
	for fc = 1:nsf

		% look for specific files
		files{fc} = findfiles(subfolders{fc}, file_pattern);

	end
end

if search_main_path,
	files{fc+1} = findfiles(session_path,file_pattern);
end
	
	

% as we are sure that the number of files is correct for each subject
% we can simply create two large arrays with filenames
files = cat(1, files{:});


% iterate over found files
for fc = 1:numel(files)

	disp(['Modifying ' files{fc}]);
	% load xff-compatible file
	file = xff(files{fc});
	
	for k=1:2:(nargin-2)/2, % for each pair param/value
		param = varargin{k};
		value = varargin{k+1};
		file = setfield(file,param,value);
		
	end
	% save and clear VTC
	file.Save;
	file.ClearObject;

end