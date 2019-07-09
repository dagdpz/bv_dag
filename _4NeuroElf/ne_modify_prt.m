function ne_modify_prt(prt_fullname,mod_struct,suffix)

if nargin < 3,
	suffix = '_mod';
end

prt = xff(prt_fullname);

for k=1:length(mod_struct),
	idx_mod = strfind([prt.ConditionNames'],mod_struct(k).Name);
	idx_cond  = find(~cellfun(@isempty,idx_mod));
	
	if ~isempty(mod_struct(k).Name_start_index), % select only those conditions where Name starts from name_start_index
		idx_cond = idx_cond([idx_mod{idx_cond}]==mod_struct(k).Name_start_index);
	end
		
	for c = idx_cond, 
		if isfield(mod_struct(k),'OnOffsets')
			prt.Cond(c).OnOffsets(:,1) = prt.Cond(c).OnOffsets(:,1) + mod_struct(k).OnOffsets(1);
			prt.Cond(c).OnOffsets(:,2) = prt.Cond(c).OnOffsets(:,2) - mod_struct(k).OnOffsets(2);
			if mod_struct(k).OnOffsets(3)
				prt.Cond(c).OnOffsets(:,1) = prt.Cond(c).OnOffsets(:,2) - mod_struct(k).OnOffsets(3);
			elseif mod_struct(k).OnOffsets(4)
				prt.Cond(c).OnOffsets(:,2) = prt.Cond(c).OnOffsets(:,1) + mod_struct(k).OnOffsets(4);
			end
					
		end
		if isfield(mod_struct(k),'Color')
			prt.Cond(c).Color = mod_struct(k).Color;
		end			
		
	end
end
	
prt.SaveAs([prt_fullname(1:end-4) suffix '.prt']);
disp([prt_fullname(1:end-4) suffix '.prt saved']);
