function [nline]=ne_plot_MC_onefile(fname,DO_PLOT)

if nargin < 2
	DO_PLOT = 1;
end

dirname = pwd;

fid=fopen(fname,'r+');

if strcmp(fname(end-3:end),'.rtc'),

        % read first 6 lines
        fgetl(fid);
        fgetl(fid);
        fgetl(fid);
        fgetl(fid);
        fgetl(fid);
        fgetl(fid);

else % .sdm
        % read first 6 lines
        fgetl(fid);
        fgetl(fid);
        fgetl(fid);
        fgetl(fid);
        fgetl(fid);
        fgetl(fid);
        fgetl(fid);
        fgetl(fid);
        fgetl(fid);
end
        

k = 1;
while 1
        tline = fgetl(fid);
        if ~ischar(tline), break, end
        nline(k,:) = str2num(tline);
        k = k + 1;
end

if DO_PLOT
	
	figure;
	plot(nline);
	title([dirname ' | ' fname],'Interpreter','none');
	legend('X t','Y t','Z t','X r','Y r','Z r',0);

end

fclose(fid);