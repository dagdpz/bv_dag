function [avg, avg_fullpath] = ne_pl_create_avg(basedir,avg_path,vtc_list,prt_list,prt2avg_script,avg_add_name)

if nargin < 6,
	avg_add_name = ''; % no custom add-on to avg name (which comes from prt2avg_script)
end

avg = xff('new:avg');
% empty avg
%                FileVersion: 4
%               FuncDataType: 'VTC'
%     ProtocolTimeResolution: 'Volumes'
%     ResolutionOfDataPoints: 'Volumes'
%             NrOfTimePoints: 0
%                PreInterval: 0
%               PostInterval: 0
%                 NrOfCurves: 0
%                  NrOfFiles: 0
%              BaseDirectory: './'
%                  FileNames: [0x1 cell]
%                      Curve: [0x0 struct]
%            BackgroundColor: 0 0 0 
%                  TextColor: 255 255 255 
%               BaselineMode: 1
%        AverageBaselineFrom: -2
%          AverageBaselineTo: 0
%              VariationBars: 'StdErr'
%                RunTimeVars: [1x1 struct]
	       
run(prt2avg_script);

avg.NrOfFiles	= length(vtc_list);    
avg.BaseDirectory = strrep([basedir],'\','/');
avg.FileNames = strrep(vtc_list,'\','/');

avg_fullpath = [avg_path filesep avg_add_name avg_name '.avg'];
avg.SaveAs(avg_fullpath);
disp([avg_fullpath ' created']);


