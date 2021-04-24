function ne_voi_select(voi_path,select,before_str,after_str)
% ne_voi_select('charm_level_6_tal_dil.voi',charm_sel,'_','-'); % sel is cell array of indexes

if nargin < 3,
    before_str = '_';
end
if nargin < 4,
    after_str = '_';
end

voi=xff(voi_path);
VOI = voi.VOI;
VOINames = voi.VOINames;
voi.VOI = [];

idx_sel = [];
for k = 1:length(select),
    temp = strfind(VOINames,[before_str num2str(select{k}) after_str]);
    idx = find(~cellfun(@isempty,temp));
	idx_sel = [idx_sel; idx];
end

voi.VOI = VOI(idx_sel);

voi.SaveAs([voi_path(1:end-4) '_sel.voi']);