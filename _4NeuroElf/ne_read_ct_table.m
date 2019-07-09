function out = ne_read_ct_table(ct_table_path)
% read text file from ClusterTable output 


fid = fopen(ct_table_path,'rt');

% Loop through data file until we get a -1 indicating EOF
r = 0;
x = 0;
while(x~=(-1))
          x=fgetl(fid);
          r=r+1;
	  if r == 7 % 
		  x = 0; % continue
	  end
end

r = r-1;

frewind(fid);
fgetl(fid);
fgetl(fid);
fgetl(fid);
fgetl(fid);
fgetl(fid);
fgetl(fid);
fgetl(fid);
fgetl(fid);
fgetl(fid);

for v = 1:r-9, % header lines 1-9
       
	% 0   -2   17  |    26  | 42.838715 |  9.956798  | Cd
	str = fgetl(fid);
	s = regexp(str,' ','split');
	idx = find(~cellfun(@isempty,s));
	
	out(v).xyz = str2double ([s(idx(1)) s(idx(2)) s(idx(3))]);
	out(v).k =	str2double(s(idx(5)));
	out(v).peak =	str2double(s(idx(7)));
	out(v).mean =	str2double(s(idx(9)));
	div = strfind(str,'|');
	out(v).name =	str(div(end)+2:end);

end

fclose(fid);
