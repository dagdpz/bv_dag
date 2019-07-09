function avg = ne_modify_avg(avg_fullname,new_avg_suffix,varargin)
% varargin: can be either struct, or list of fieldnames / values, as shown below:
% 'remove': removes conditions
% 'combine': combines conditions

% struct('remove', {'cond_name1'  'cond_name2'})
% struct('combine', {{'cond_name1' 'cond_name2'} {'cond_name3' 'cond_name4'}},'new_name',{'new1' 'new2'},'col',{[100 0 0] [0 100 0]})

% Example:
% mod = struct('combine', {{'mem_r' 'mem_r_srew'} {'mem_l' 'mem_l_srew'}},'new_name',{'mem_r_srew' 'mem_l_srew'},'col',{[150 100 0] [0 100 150]});
% ne_modify_avg('original_name.avg','modified',mod); 
% will combine mem_r and mem_r_srew to mem_r_srew, and will assign color [150 100 0]
% will combine mem_l and mem_l_srew to mem_l_srew, and will assign color [0 100 150]

if isempty(new_avg_suffix),
	new_avg_suffix = 'mod';
end

if ~isstruct(varargin{1}),
	mod = struct(varargin{:});
else
	mod = varargin{1};
end


avg = xff(avg_fullname);
avgm = avg;


fn = fieldnames(mod);

switch fn{1}

case 'remove'
	idx2remove = [];
		
	for c=1:avg.NrOfCurves,
		if ismember(avg.Curve(c).Name,{mod.remove}),
			avgm.NrOfCurves = avgm.NrOfCurves - 1;
			idx2remove = [idx2remove c];
		end
	end
	avgm.Curve(idx2remove) = [];
	

case 'combine'
	idx2remove = [];
	
	n_curves_init = avgm.NrOfCurves;
	n_combine = length(mod);
	Curve = avg.Curve;
	
	for g = 1:n_combine, % for each combine group
		
		NrOfConditionEvents = 0;
		for c = 1:length(mod(g).combine), % for each curve of this combine group
			idx_cond = find(strcmp({Curve.Name},mod(g).combine{c}));
			idx2remove = [idx2remove idx_cond];
			
			NrOfConditionEvents = NrOfConditionEvents + avg.Curve(idx_cond).NrOfConditionEvents;
			
			for f = 1:length(avg.Curve(idx_cond).File),
				if ~isempty(avg.Curve(idx_cond).File(f).EventPointsInFile),
					
					valid_file_idx = avg.Curve(idx_cond).File(f).EventPointsInFile + 1;
					
					avgm.Curve(n_curves_init+g).File(valid_file_idx).EventPointsInFile = valid_file_idx -1;
					
					if c == 1,
						avgm.Curve(n_curves_init+g).File(valid_file_idx).Points = avg.Curve(idx_cond).File(f).Points;
					else
						avgm.Curve(n_curves_init+g).File(valid_file_idx).Points = [avgm.Curve(n_curves_init+g).File(valid_file_idx).Points ; ...
						avg.Curve(idx_cond).File(f).Points];
					end
				end
			end
			
		end
		
		avgm.Curve(n_curves_init+g).NrOfConditionEvents = NrOfConditionEvents;
		avgm.Curve(n_curves_init+g).Name		= mod(g).new_name;
		
		avgm.Curve(n_curves_init+g).EventDuration	= avg.Curve(idx_cond).EventDuration;
		avgm.Curve(n_curves_init+g).TimeCourseColor1	= mod(g).col;
		avgm.Curve(n_curves_init+g).TimeCourseColor2	= avg.Curve(idx_cond).TimeCourseColor2;
		avgm.Curve(n_curves_init+g).TimeCourseThick	= avg.Curve(idx_cond).TimeCourseThick;
		avgm.Curve(n_curves_init+g).StdErrColor		= mod(g).col;
		avgm.Curve(n_curves_init+g).StdErrThick		= avg.Curve(idx_cond).StdErrThick;
		avgm.Curve(n_curves_init+g).PreIntervalColor	= avg.Curve(idx_cond).PreIntervalColor;
		avgm.Curve(n_curves_init+g).PostIntervalColor	= avg.Curve(idx_cond).PostIntervalColor;
		

	end
	
	% remove conditions that were combined
	avgm.Curve(idx2remove) = [];
	avgm.NrOfCurves = length(avgm.Curve);

end



avgm.SaveAs([avg_fullname(1:end-4) '_' new_avg_suffix '.avg']);
disp(['saved ' avg_fullname(1:end-4) '_' new_avg_suffix '.avg']);


