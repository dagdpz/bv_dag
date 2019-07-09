function prt_fname = monkeypsych_dev_microstim_NO_pre_memory_NO_cue_0to9(timing_filename, run_name)
% write the prt file for BV from a block-design experiment,
% produced by monkeypsych_eye_microstim
% using the timing file created with the monkeypsych_dev_microstim_mat2txt
% data format: block per line: (1)trial number (2)task type (1. fixation,
% 3.memory) (3) microstim (4) success (5 - end) state onset.
% x = 10 for successful trials of type 1, x = 16 for successful trials of type 3


if nargin < 2,
    run_name = '';
end

[pathname,filename,ext] = fileparts(timing_filename);
data = dlmread(timing_filename, '\t');
n_blocks = size(data, 1); % you need to find number of blocks (i.e. rows) from data - hint: use command size

% data(data == 0) = NaN;
row_max = max(data, [], 2);

% this is manual part - defining condition names and etc.

NrofPreds = 14;

prtpreds(1).name = '1 fixation ';
prtpreds(1).r = 189;
prtpreds(1).g = 183;
prtpreds(1).b = 107;

prtpreds(2).name = '2 post fixation';
prtpreds(2).r = 218;
prtpreds(2).g = 165;
prtpreds(2).b = 32;

prtpreds(3).name = '3 fixation microstim';
prtpreds(3).r = 255;
prtpreds(3).g = 255;
prtpreds(3).b = 0;

prtpreds(4).name = '4 post fixation microstim';
prtpreds(4).r = 255;
prtpreds(4).g = 181;
prtpreds(4).b = 97;

prtpreds(5).name = '5 memory right';
prtpreds(5).r = 221;
prtpreds(5).g = 160;
prtpreds(5).b = 221;

prtpreds(6).name = '6 post memory right';
prtpreds(6).r = 188;
prtpreds(6).g = 143;
prtpreds(6).b = 143;

prtpreds(7).name = '7 memory right microstim';
prtpreds(7).r = 255;
prtpreds(7).g = 0;
prtpreds(7).b = 255;

prtpreds(8).name = '8 post-memory right microstim';
prtpreds(8).r = 165;
prtpreds(8).g = 42;
prtpreds(8).b = 42;

prtpreds(9).name = '9 memory left';
prtpreds(9).r = 176;
prtpreds(9).g = 224;
prtpreds(9).b = 230;

prtpreds(10).name = '10 post memory left';
prtpreds(10).r = 152;
prtpreds(10).g = 251;
prtpreds(10).b = 152;

prtpreds(11).name = '11 memory left microstim';
prtpreds(11).r = 30;
prtpreds(11).g = 144;
prtpreds(11).b = 255;

prtpreds(12).name = '12 post memory left microstim';
prtpreds(12).r = 0;
prtpreds(12).g = 255;
prtpreds(12).b = 0;

prtpreds(13).name = '13 reward';
prtpreds(13).r = 0;
prtpreds(13).g = 0;
prtpreds(13).b = 255;

prtpreds(14).name = '14 abort';
prtpreds(14).r = 255;
prtpreds(14).g = 0;
prtpreds(14).b = 0;

% [prtpreds(1:NrofPreds).n_correct_trials] = deal([]); % empty array to be filled in cumulatively
[prtpreds(1:NrofPreds).onset] = deal([]);
[prtpreds(1:NrofPreds).offset] = deal([]);

for i = 1:n_blocks,
    
    if data(i,2) == 1 && data(i,3) == 0 && data(i,4) > 0,
        % fixation, no microstim, successful
        
        cond = 1; % fixation
        % set onset / offset times
        prtpreds(cond).onset =  [prtpreds(cond).onset data(i,8)+10000]; % from cue onset
        prtpreds(cond).offset = [prtpreds(cond).offset data(i,8)+19000]; % to end of memory period
        
        cond = 2; % post fixation
        prtpreds(cond).onset =  [prtpreds(cond).onset data(i,8)+20000+1];
        prtpreds(cond).offset = [prtpreds(cond).offset data(i,8)+22000];
        
        cond = 13; % reward
        prtpreds(cond).onset =  [prtpreds(cond).onset data(i,10)];
        prtpreds(cond).offset = [prtpreds(cond).offset data(i,11)+5000];
        
    elseif data(i,2) == 1 && data(i,3) == 1 && data(i,4) > 0,
        % fixation, microstim, successful
        
        cond = 3; % fixation microstim
        % set onset / offset times
        prtpreds(cond).onset =  [prtpreds(cond).onset data(i,8)+10000]; % from cue onset
        prtpreds(cond).offset = [prtpreds(cond).offset data(i,8)+19000]; % to end of memory period
        
        cond = 4; % post fixation microstim
        prtpreds(cond).onset =  [prtpreds(cond).onset data(i,8)+20000+1];
        prtpreds(cond).offset = [prtpreds(cond).offset data(i,8)+22000];
        
        cond = 13; % reward
        prtpreds(cond).onset =  [prtpreds(cond).onset data(i,10)];
        prtpreds(cond).offset = [prtpreds(cond).offset data(i,11)+5000];
        
        
    elseif data(i,2) == 3 && data(i,5) > 0 && data(i,3) == 0 && data(i,4) > 0,
        % memory, right, no microstim, successful
        
        cond = 5; % memory right
        prtpreds(cond).onset =  [prtpreds(cond).onset data(i,10)]; % from beginning of memory period
        prtpreds(cond).offset = [prtpreds(cond).offset data(i,10)+9000]; % 1 sec before saccade
        
        cond = 6; % post memory right
        prtpreds(cond).onset =  [prtpreds(cond).onset data(i,14)]; % from target hold
        prtpreds(cond).offset = [prtpreds(cond).offset data(i,14)+2000];
        
        cond = 13; % reward
        prtpreds(cond).onset =  [prtpreds(cond).onset data(i,16)];
        prtpreds(cond).offset = [prtpreds(cond).offset data(i,17)+5000];
        
    elseif data(i,2) == 3 && data(i,5) > 0 && data(i,3) == 1 && data(i,4) > 0,
        % memory, right, microstim, successful
        
        cond = 7; % memory right microstim
        prtpreds(cond).onset =  [prtpreds(cond).onset data(i,10)]; % from beginning of memory period
        prtpreds(cond).offset = [prtpreds(cond).offset data(i,10)+9000]; % 1 sec before saccade
        
        cond = 8; % post memory right microstim
        prtpreds(cond).onset =  [prtpreds(cond).onset data(i,14)]; % from target hold
        prtpreds(cond).offset = [prtpreds(cond).offset data(i,14)+2000];
        
        cond = 13; % reward
        prtpreds(cond).onset =  [prtpreds(cond).onset data(i,16)];
        prtpreds(cond).offset = [prtpreds(cond).offset data(i,17)+5000];
        
        
    elseif data(i,2) == 3 && data(i,5) < 0 && data(i,3) == 0 && data(i,4) > 0,
        % memory, left, no microstim, successful
        
        cond = 9; % memory left
        prtpreds(cond).onset =  [prtpreds(cond).onset data(i,10)]; % from beginning of memory period
        prtpreds(cond).offset = [prtpreds(cond).offset data(i,10)+9000]; % 1 sec before saccade
        
        cond = 10; % post memory left
        prtpreds(cond).onset =  [prtpreds(cond).onset data(i,14)]; % from target hold
        prtpreds(cond).offset = [prtpreds(cond).offset data(i,14)+2000];
        
        cond = 13; % reward
        prtpreds(cond).onset =  [prtpreds(cond).onset data(i,16)];
        prtpreds(cond).offset = [prtpreds(cond).offset data(i,17)+5000];
        
    elseif data(i,2) == 3 && data(i,5) < 0 && data(i,3) == 1 && data(i,4) > 0,
        % memory, left, no microstim, successful
        
        cond = 11; % memory left microstim
        prtpreds(cond).onset =  [prtpreds(cond).onset data(i,10)]; % from beginning of memory period
        prtpreds(cond).offset = [prtpreds(cond).offset data(i,10)+9000]; % 1 sec before saccade
        
        cond = 12; % post memory left microstim
        prtpreds(cond).onset =  [prtpreds(cond).onset data(i,14)]; % from target hold
        prtpreds(cond).offset = [prtpreds(cond).offset data(i,14)+2000];
        
        cond = 13; % reward
        prtpreds(cond).onset =  [prtpreds(cond).onset data(i,16)];
        prtpreds(cond).offset = [prtpreds(cond).offset data(i,17)+5000];
        
    else
        cond = 14; % abort
        prtpreds(cond).onset =  [prtpreds(cond).onset data(i,6)];
        prtpreds(cond).offset = [prtpreds(cond).offset row_max(i)+5000];
    end
end


if isempty(run_name)
    prt_fname = [pathname filesep filename  '.prt'];
else
    prt_fname = [pathname filesep filename(1:end-10)  '_' run_name  '.prt'];
    
end

fid = fopen(prt_fname,'w');

fprintf(fid,'\n');

fprintf(fid,'FileVersion:\t%d\n\n',2);

fprintf(fid,'ResolutionOfTime:\t%s\n\n','msec');

fprintf(fid,'Experiment:\t%s\n\n',filename);

fprintf(fid,'BackgroundColor:\t%d %d %d\n',0,0,0);
fprintf(fid,'TextColor:\t%d %d %d\n',255,255,255);
fprintf(fid,'TimeCourseColor:\t%d %d %d\n',255,255,255);
fprintf(fid,'TimeCourseThick:\t%d\n',3);
fprintf(fid,'ReferenceFuncColor:\t%d %d %d\n',0,0,80);
fprintf(fid,'ReferenceFuncThick:\t%d\n\n',3);

fprintf(fid,'NrOfConditions:\t%d\n\n',NrofPreds );


for cond = 1:NrofPreds,
    
    fprintf(fid,'%s\n',prtpreds(cond).name);
    fprintf(fid,'%d\n',length(prtpreds(cond).onset)); % (prtpreds(k).onset) = row with onset times of condition i (line 51)
    
    for rep = 1:length(prtpreds(cond).onset) % for each repetition of one condition
        fprintf(fid,' %d \t %d \n', (prtpreds(cond).onset(rep)), (prtpreds(cond).offset(rep)));
    end
    
    fprintf(fid,'Color: %d %d %d\n\n',prtpreds(cond).r, prtpreds(cond).g, prtpreds(cond).b);
end

fclose(fid);

if 0
    disp(['Protocol ' prt_fname ' saved']);
end
