function ne_add_voi_name_from_ct_table(voi, ct_table_path)

if ~isxff(voi),
	voi = xff(voi);
end

ct = ne_read_ct_table(ct_table_path);

if voi.NrOfVOIs ~= length(ct),
	disp('Non-matching number of vois in voi and ct, exiting!');
	return;
end

for v = 1:voi.NrOfVOIs,
	voi.VOI(v).Name = [voi.VOI(v).Name '_' ct(v).name];	
end

voi.Save;


