function idx = ne_voi_find_subset(full_voi_path,subset_voi_path,sort_hemi)

if ~isxff(full_voi_path),
	full_voi = xff(full_voi_path);
end

if ~isxff(subset_voi_path),
	subset_voi = xff(subset_voi_path);
end


if sort_hemi
    idx = [];
    H = {'_l','_r'};
    for h = [1 2]
    temp = cellfun(@(x) strfind(x(end-1:end),H{h}),full_voi.VOINames,'UniformOutput',0);
    idx_1 = find(~cellfun(@isempty,temp));
    idx_h = zeros(length(idx_1),1);
    
    temp = cellfun(@(x) strfind(x(end-1:end),H{h}),subset_voi.VOINames,'UniformOutput',0);
    idx_2 = find(~cellfun(@isempty,temp));
    
    v1 = full_voi.VOINames;
    v2 = subset_voi.VOINames;
    
    [C,IA,IB] = intersect(v1(idx_1),v2(idx_2));
    idx_h(IA) = 1;
    
    idx = [idx idx_h];
    end
    
else

    idx = zeros(full_voi.NrOfVOIs,1);
    [C,IA,IB] = intersect(full_voi.VOINames,subset_voi.VOINames);
    idx(IA) = 1;
end

% sprintf('%d\t%d\n',idx')
	