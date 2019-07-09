function ne_convert_ct_tables_to_xls(ct_table_path, n_ct_tables, add_naming_dataset)
% convert txt file containing several cluster tables from NE to xls (separate sheets)

if nargin < 2,
	n_ct_tables = 1; 
end

if nargin < 3,
	add_naming_dataset = ''; % add a column with lobule/structure or something like that 
end

ct = ne_read_ct_tables(ct_table_path, n_ct_tables);
[pathstr, ct_name, ext] = fileparts(ct_table_path);

if ~isempty(add_naming_dataset),
	load(add_naming_dataset); % from Y:\Atlases\macaque\Calabrese2015, F:\Dropbox\Comonkey_exchange\Pulvinar_fMRI_paper\2017\ROI_analysis.mat
	Naming = D.Name;
	Level4 = D.Level4;
	N = 242 - D.N;
end

for t = 1:n_ct_tables,
	if ~isempty(add_naming_dataset)
		for n = 1:ct(t,1).nrows,
			name = deblank(ct(t,n).name);
			par_idx = strfind(name,' (');
			if ~isempty(par_idx)
				name = deblank(name(1:par_idx));
			end
			name = [name ' '];
			Naming_idx = find(~cellfun(@isempty,strfind(Naming, name)));
			
			if ~isempty(Naming_idx),
				Naming_region(t,n).naming = Level4{Naming_idx(1)};
				Naming_region(t,n).sort_code = N(Naming_idx(1));
				
			else
				Naming_region(t,n).naming = 'unknown';
				Naming_region(t,n).sort_code = 999;
			end
		end
		D = dataset({{Naming_region(t,1:ct(t,1).nrows).naming}', 'structure'},...
			{{ct(t,1:ct(t,1).nrows).name}', 'region'},...
			{[cell2mat({ct(t,1:ct(t,1).nrows).xyz}') [ct(t,1:ct(t,1).nrows).k]' [ct(t,1:ct(t,1).nrows).peak]' [ct(t,1:ct(t,1).nrows).mean]'], 'x', 'y', 'z', 'k', 't_peak', 't_mean'},...
			{{Naming_region(t,1:ct(t,1).nrows).sort_code}', 'sort_code'});

	else
		D = dataset({{ct(t,1:ct(t,1).nrows).name}', 'region'},...
		{[cell2mat({ct(t,1:ct(t,1).nrows).xyz}') [ct(t,1:ct(t,1).nrows).k]' [ct(t,1:ct(t,1).nrows).peak]' [ct(t,1:ct(t,1).nrows).mean]'], 'x', 'y', 'z', 'k', 't_peak', 't_mean'});
	end

	export(D,'XLSfile',[pathstr filesep ct_name '.xls'],'Sheet',sprintf('table %d',t));
end
