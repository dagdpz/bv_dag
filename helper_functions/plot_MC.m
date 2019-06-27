function plot_MC(basedir, plot_each)

if nargin < 2,
	plot_each = 1;
end

ini_dir = pwd;

if nargin < 1,
        basedir = uigetdir;
        if basedir == 0, return; end;
        
end

d = dir(basedir);

idx = find(cell2mat({d.isdir}));

MCP = [];
if length(idx) > 2  % exclude current and parent directory
        for i = 3:length(idx)
                cd([basedir filesep d(idx(i)).name]);
                fname_struct = dir('*_3DMC.rtc');
                if isempty(fname_struct)
                        fname_struct = dir('*_3DMC.sdm');
                end
                if ~isempty(fname_struct), 
                        mcp=plot_MC_onefile(fname_struct(1).name,plot_each);
                        MCP = [MCP; mcp];
                end
        end
end

figure;
plot(MCP);
title([basedir],'Interpreter','none');
legend('X t','Y t','Z t','X r','Y r','Z r',0);

cd(ini_dir);


% ---


