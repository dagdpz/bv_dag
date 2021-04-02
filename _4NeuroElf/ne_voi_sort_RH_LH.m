function ne_voi_sort_RH_LH(voi_path)
% ne_voi_sort_RH_LH 

[pathstr, name] = fileparts(voi_path);

voi=xff(voi_path);

temp = cellfun(@(x) strfind(x(end-1:end),'_r'),voi.VOINames,'UniformOutput',0);

idx_r = find(~cellfun(@isempty,temp));
n_r = length(idx_r);

temp = cellfun(@(x) strfind(x(end-1:end),'_l'),voi.VOINames,'UniformOutput',0);
idx_l = find(~cellfun(@isempty,temp));
n_l = length(idx_l);

VOI = voi.VOI;
voi.VOI(1:n_r) = VOI(idx_r);
voi.VOI(n_r+1:n_r+n_l) = VOI(idx_l);

voi.SaveAs(voi_path);