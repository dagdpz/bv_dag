function ne_link_prt2vtc(session_path,prt_path,vtcfpattern,prtfpattern)
% links prt to vtc in all session runs

if nargin < 2,
	prt_path = ''; % same as session path
end
if nargin < 3,
	vtcfpattern = '*.vtc';
end
if nargin < 4,
	prtfpattern = '*.prt';
end


% find folders in the session folder
subfolders = findfiles(session_path, 'run*', 'dirs=1', 'depth=1');
nsf = numel(subfolders);

% create a cell array for VTC and PRT filenames
vtcfiles = cell(nsf, 1);
prtfiles = findfiles([session_path filesep prt_path], prtfpattern);

% first pass: lookup files
for fc = 1:nsf
	
	% look for VTC and PRT files
	vtcfiles{fc} = findfiles(subfolders{fc}, vtcfpattern);
	
	% ensure that the number is the same
	%     if numel(vtcfiles{fc}) ~= numel(prtfiles{fc})
	%         error('Number of found files mismatch.');
	%     end
end

% as we are sure that the number of files is correct for each subject
% we can simply create two large arrays with filenames
vtcfiles = cat(1, vtcfiles{:});
% prtfiles = cat(1, prtfiles{:});

% NOTE: AT THIS PLACE, IT IS POSSIBLE TO ADD CODE TO EITHER
% - CHECK THE INTEGRITY OF FILES
% - PERFORM SOME PROCESS WITH THE PRT CONTENT AND RE-SAVE
% - ALTER THE VTC DATA AND RE-SAVE
% - etc...

% iterate over found files
for fc = 1:numel(vtcfiles)

	disp(['Linking ' prtfiles{fc} ' to ' vtcfiles{fc}]);
	% load VTC file
	vtc = xff(vtcfiles{fc});
	
	% link protocol
	vtc.NrOfLinkedPRTs = 1;
	vtc.NameOfLinkedPRT = strrep(prtfiles{fc},'\','/');
	% save and clear VTC
	vtc.Save;
	vtc.ClearObject;

end