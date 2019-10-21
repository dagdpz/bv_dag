function avg = ne_combine_avg(basedir,session_list,avg_name,avg_search_path,new_avg_name)
% combine several avg
% avg_name can be a fixed name or avg pattern (with '*')
% avg_search_path can be a model path 
% ne_combine_avg('D:\MRI\Human.Caltech\IK',{'20100409' '20100414'},'ne_prt2avg_human_decision_caltech.avg','test')
% ne_combine_avg('D:\MRI\Human.Caltech',{'IK\20100409' 'IK\20100414'},'ne_prt2avg_human_decision_caltech.avg','test')
% ne_combine_avg('D:\MRI\Human.Caltech',{'AI' 'AM' 'IK' 'KP' 'MW'},'*iers.avg','test.avg');
% ne_combine_avg('Y:\MRI\Human\fMRI-reach-decision\Pilot\LEHU',{'20190723' '20190724' '20190725_1' '20190725_2'},'*outliers.avg','mat2prt_reach_decision_pilot_v2',['mat2prt_reach_decision_pilot_v2' filesep 'combined_no_outliers.avg']);
% ne_combine_avg('Y:\MRI\Human\fMRI-reach-decision\Pilot\LEHU',{'20*'},'*outliers.avg','mat2prt_reach_decision_pilot_v2',['mat2prt_reach_decision_pilot_v2' filesep 'combined_no_outliers.avg']);
% ne_combine_avg('Y:\MRI\Human\fMRI-reach-decision\Pilot',{'LEHU' 'MAPA'},'combinedne_prt2avg_reach_decision_pilot.avg','mat2prt_reach_decision_pilot_v2',['test.avg']);

if nargin < 4,
	avg_search_path = '';
end

if nargin < 5,
	new_avg_name = '';
end

if length(session_list)==1 &&  ~isempty(strfind(session_list{1},'*')), % not a session list but matching pattern
    session_list = findfiles(basedir,session_list,struct('depth',1,'dirs',1));
    session_list = strrep(session_list,basedir,'');
    session_list = strrep(session_list,'\','');
    session_list = strrep(session_list,'/','');
end
    

avg_pattern = 0;
if ~isempty(strfind(avg_name,'*')), % not a name but matching pattern
	avg_pattern = avg_name;
	avg_name = findfiles([basedir filesep session_list{1} filesep avg_search_path],avg_pattern,struct('depth',1));
	avg_name = avg_name{1}; [dummy,avg_name,ext] = fileparts(avg_name); avg_name = [avg_name ext];
end

avg1 = xff([basedir filesep session_list{1} filesep avg_search_path filesep avg_name]);
avg = avg1; % new avg
avg.BaseDirectory = strrep(basedir,'\','/');

if ~strcmp(session_list{1},avg1.FileNames{1}(1:length(session_list{1}))), % filenames do not contain session name
    for f = 1:length(avg1.FileNames),
        avg.FileNames{f} = [session_list{1} filesep avg1.FileNames{f}];
    end
end

for k=2:length(session_list),
	if avg_pattern,
		avg_name = findfiles([basedir filesep session_list{k} filesep avg_search_path],avg_pattern,struct('depth',1));
		avg_name = avg_name{1}; [dummy,avg_name,ext] = fileparts(avg_name); avg_name = [avg_name ext];
	end
	avgk_fullname = [basedir filesep session_list{k} filesep avg_search_path filesep avg_name];
	avgk = xff(avgk_fullname);
	for c = 1:avg.NrOfCurves
		avg.Curve(c).NrOfConditionEvents = avg.Curve(c).NrOfConditionEvents + avgk.Curve(c).NrOfConditionEvents;
		for f=1:avgk.NrOfFiles,
			if avg.Curve(c).NrOfConditionEvents,
				avg.Curve(c).File(avg.NrOfFiles+f).EventPointsInFile = avg.NrOfFiles + avgk.Curve(c).File(f).EventPointsInFile;
				avg.Curve(c).File(avg.NrOfFiles+f).Points = avgk.Curve(c).File(f).Points;
            end
            if ~strcmp(session_list{k},avgk.FileNames{f}(1:length(session_list{k}))), % filenames do not contain session name
                if c == 1,
                    avgk.FileNames{f} = [session_list{k} filesep avgk.FileNames{f}];
                end
            end
		end
		
	end
	avg.FileNames = [avg.FileNames; avgk.FileNames];
	avg.NrOfFiles = avg.NrOfFiles + avgk.NrOfFiles;
end

% Make sure that basedir and FileNames together represent a valid path.
% This is important when combining different subjects.

for f=1:avg.NrOfFiles,
	s = regexp(avg.FileNames{f}, '/', 'split');
	idx_nonempty = find(~cellfun(@isempty,s));
	
	% find to which session the file belongs
	which_session = strfind(session_list,s{idx_nonempty(1)});
	idx_session = find(~cellfun(@isempty,which_session));
	
	if length(idx_session)==1 &&  ~strncmp(avg.FileNames{f},strrep(session_list{idx_session},'\','/'),length(session_list{idx_session})),
		% partial overlap of session_list and avg.FileNames{f}
		avg.FileNames{f} = strrep(avg.FileNames{f},[s{idx_nonempty(1)} '/'],[session_list{idx_session} '/']);
	end
	
	avg.FileNames{f} = strrep(avg.FileNames{f},'\','/');
end

if isempty(new_avg_name),
	new_avg_fullname	= [basedir filesep 'combined.avg'];
else
	new_avg_name		= strrep(new_avg_name,'.avg','');
    new_avg_fullname	= [basedir filesep new_avg_name '.avg'];
end

avg.SaveAs(new_avg_fullname);
disp(['saved ' new_avg_fullname]);


