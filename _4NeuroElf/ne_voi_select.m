function ne_voi_select(voi_path,select)
% ne_voi_sort_RH_LH 


voi=xff(voi_path);
VOI = voi.VOI;
VOINames = voi.VOINames;
voi.VOI = [];

idx_sel = [];
for k = 1:length(select),
    temp = strfind(VOINames,['_' num2str(select{k}) '_']);
    idx = find(~cellfun(@isempty,temp));
	idx_sel = [idx_sel; idx];
end

voi.VOI = VOI(idx_sel);

voi.SaveAs([voi_path(1:end-4) '_sel.voi']);