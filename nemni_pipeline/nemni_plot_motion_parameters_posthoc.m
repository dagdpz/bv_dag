%% get motion parameters afterwards
% https://www.jiscmail.ac.uk/cgi-bin/webadmin?A2=spm;8b797981.1502


filt = ['^rp_*','.*\.txt$'];
b = spm_select([Inf],'any','Select realignment parameters',[],pwd,filt);
scaleme = [-3 3];
mydata = pwd;

for i = 1:size(b,1)
    
    [p nm e v] = spm_fileparts(b(i,:));
    
    printfig = figure;
    set(printfig, 'Name', ['Motion parameters: subject ' num2str(i) ], 'Visible', 'on');
    loadmot = load(deblank(b(i,:)));
    subplot(2,1,1);
    plot(loadmot(:,1:3));
    grid on;
    ylim(scaleme);  % enable to always scale between fixed values as set above
    title(['Motion parameters: shifts (top, in mm) and rotations (bottom, in dg)'], 'interpreter', 'none');
    subplot(2,1,2);
    plot(loadmot(:,4:6)*180/pi);
    grid on;
    ylim(scaleme);   % enable to always scale between fixed values as set above
    title(['Data from ' p], 'interpreter', 'none');
    mydate = date;
    motname = [mydata filesep 'motion_sub_' sprintf('%02.0f', i) '_' mydate '.png'];
    % print(printfig, '-dpng', '-noui', '-r100', motname);  % enable to print to file
    % close(printfig);   % enable to close graphic window
end;
