function avg = ne_collapse_basedir_avg(avg_fullname,n_levels2collapse,suffix)
% collapse basidir path so that filenames contain only unique parts of the path
% e.g. ne_collapse_basedir_avg('Y:\MRI\Human\Action Selection\Blocked\RIME\20140313\ne_prt2avg_Humans_Poffenberger_no_outliers.avg',2,'mod');
% will ADD "RIME/20140313" to filenames and REMOVE it from basedir: 
% "D:/MRI/Human/Action Selection/Blocked/RIME/20140313" --> "D:/MRI/Human/Action Selection/Blocked"

if nargin < 3,
	suffix = '';
end
	
avg = xff(avg_fullname);

s_basedir = regexp(avg.BaseDirectory, '/', 'split');
if isempty(s_basedir{end}),
	s_basedir = s_basedir(1:end-1);
end

n_parts = length(s_basedir);

add2filename = '';
for k = 1:n_levels2collapse,
	avg.BaseDirectory = strrep(avg.BaseDirectory,s_basedir{n_parts-n_levels2collapse+k},'');
	add2filename = [add2filename s_basedir{n_parts-n_levels2collapse+k} '/'];
end
avg.BaseDirectory = strrep(avg.BaseDirectory,'//','/');

for f=1:avg.NrOfFiles,
	avg.FileNames{f} = [add2filename avg.FileNames{f}];
end

avg.FileNames = strrep(avg.FileNames,'//','/');
avg.BaseDirectory = strrep(avg.BaseDirectory,'//','/');

avg.SaveAs([avg_fullname(1:end-4) '_' suffix '.avg']);
disp(['saved ' avg_fullname(1:end-4) '_' suffix '.avg']);

