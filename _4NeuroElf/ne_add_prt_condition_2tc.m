function ne_add_prt_condition_2tc(prt_fullpath,cond_name,tc_time_axis,TR,varargin)
% add "cond_name" markers to tc_time_axis 
% ne_add_prt_condition_2tc('Bacchus_2014-11-06_run01.prt','reward','volumes',2000);

prt = xff(prt_fullpath);

ci = regexp(prt.ConditionNames,cond_name);
cond_idx = find(cellfun(@(x) ~isempty(x), ci, 'UniformOutput', 1));
    
% Previous version - does not support regular expression wildcards
% dummy = struct2cell(prt.Cond);
% cell_conditions = [dummy{1,:,:}]';
% cond_idx = find(~cellfun(@isempty,strfind(lower(cell_conditions),lower(cond_name))));

n_matching_cond = length(cond_idx);

ylim = get(gca,'Ylim');

if ~isempty(cond_idx),
	
	for k=1:n_matching_cond,
		onsets = prt.Cond(cond_idx(k)).OnOffsets(:,1); 

		switch prt.ResolutionOfTime
			case 'msec'
				if strcmp(tc_time_axis,'volumes'),
					onsets = onsets / TR;
				elseif strcmp(tc_time_axis,'seconds')
					onsets = onsets / 1000;
				end
		end
		% hold on; plot(onsets,ylim(1)*ones(size(onsets)),'kv',varargin{:});
        ig_add_multiple_vertical_lines(onsets,'Color',[0 0 0],'LineStyle',':');
    end
    
    title([settings.fmr_quality.plot_events ' added']);
end



