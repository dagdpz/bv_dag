function out = ne_read_ct_tables(ct_table_path, n_ct_tables)
% read text file from ClusterTable output, containing several tables
% tables should be separated by ***exactly two empty lines***! BASTA!

% e.g. ne_convert_ct_tables_to_xls('F:\Dropbox\Comonkey_exchange\Pulvinar_fMRI_paper\2017\Redrik\RFX_difference_maps\RE_lPULVcan1_RFX_instructed_cue.txt',4,'F:\Dropbox\Comonkey_exchange\Pulvinar_fMRI_paper\2017\ROI_analysis.mat');


if nargin < 2,
	n_ct_tables = 1; 
end

fid = fopen(ct_table_path,'rt');

% Loop through data file until we get a -1 indicating EOF
rt(1:n_ct_tables) = deal(0); % number of entries in each table
t = 1; % table number
x = 0;
previous_line_empty = 0;
r = 0;
while(x~=(-1))
          x=fgetl(fid);
          r=r+1;
	  if isempty(x), % empty line
		  x = 0; % continue
		  if previous_line_empty, % separating 2 lines between tables
			  rt(t) = r - 2 - 9;
			  t = t + 1;
			  r = 0;
		  end
		  previous_line_empty = 1;
	  else
		  previous_line_empty = 0;
	  end
end

rt(t) = r - 1 - 9; % last table

frewind(fid);

for t = 1:n_ct_tables,
	header_str1 = fgetl(fid);
	header_str2 = fgetl(fid);
	header_str3 = fgetl(fid);
	header_str4 = fgetl(fid);
	header_str5 = fgetl(fid);
	header_str6 = fgetl(fid);
	fgetl(fid);
	fgetl(fid);
	fgetl(fid);
	
	out(t,1).header = [header_str1 sprintf('\n') header_str2 sprintf('\n') header_str3 sprintf('\n') header_str4 sprintf('\n') header_str5 sprintf('\n') header_str6];
	out(t,1).nrows = rt(t);
	
	for v = 1:rt(t),

		% 0   -2   17  |    26  | 42.838715 |  9.956798  | Cd
		str = fgetl(fid);
		s = regexp(str,' ','split');
		idx = find(~cellfun(@isempty,s));

		out(t,v).xyz = str2double ([s(idx(1)) s(idx(2)) s(idx(3))]);
		out(t,v).k =	str2double(s(idx(5)));
		out(t,v).peak =	str2double(s(idx(7)));
		out(t,v).mean =	str2double(s(idx(9)));
		div = strfind(str,'|');
		out(t,v).name =	str(div(end)+2:end);

	end
	
	if t~=n_ct_tables,
		fgetl(fid);
		fgetl(fid);
	end
end
fclose(fid);
