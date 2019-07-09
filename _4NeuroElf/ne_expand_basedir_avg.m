function avg = ne_expand_basedir_avg(avg_fullname)
% expland basidir path so that filenames contain only unique parts of the path
% e.g. ne_expand_basedir_avg('Y:\MRI\Human\Action Selection\Blocked\RIME\20140313\ne_prt2avg_Humans_Poffenberger.avg');
% will remove "20140313" from filenames and append it to basedir: "D:/MRI/Human/Action Selection/Blocked/RIME/20140313"

avg = xff(avg_fullname);

for f=1:avg.NrOfFiles,
	avg.FileNames{f} = strrep(avg.FileNames{f},'\','/');
	s(f,:) = regexp(avg.FileNames{f}, '/', 'split');	
end

for k=1:size(s,2)-1,
	u = unique(s(:,k));
	if length(u) == 1,
		avg.BaseDirectory = [avg.BaseDirectory '/' u{1}];
		avg.FileNames = strrep(avg.FileNames,[unique(s(:,k)) '/'],'');
	end
end

avg.FileNames = strrep(avg.FileNames,'//','/');
avg.BaseDirectory = strrep(avg.BaseDirectory,'//','/');

avg.SaveAs(avg_fullname);
disp(['saved ' avg_fullname]);

