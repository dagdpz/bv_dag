function ne_modify_voi_name(voi_path,oldsubstr,newsubstr)
% replace oldsubstr->newsubstr in voi name(s)
% or append a string to the beginning or the end of the name

voi = xff(voi_path);


for k = 1:voi.NrOfVOIs,
	
	if strcmp(oldsubstr,'BEGINNING'),
		voi.VOI(k).Name = [newsubstr voi.VOI(k).Name];
	elseif strcmp(oldsubstr,'ENDING')
		voi.VOI(k).Name = [voi.VOI(k).Name newsubstr];
	else % replace 
		voi.VOI(k).Name = strrep(voi.VOI(k).Name,oldsubstr,newsubstr);
	end
end

voi.SaveAs(voi_path);
disp(['Saved ' voi_path]);