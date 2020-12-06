function dt = ne_plot_era_reach_decision(era_files)

opengl software % http://www.mathworks.com/matlabcentral/answers/101588
ini_dir = pwd;


%run('ne_era_settings');

%% data1 = era.mean; %NrOfVOIs X NrOfCurves X NrOfTimePoints

%% load in data
tc = load(era_files{1}); 

for e = 2:length(era_files)
   ttt = load(era_files{e}); 
   tc(e) = ttt;
end

%%
dt = table();
for v = 1:size(tc(1).era.mean,1) % loop over VIOs 
    
    for d = 1:length(tc) % loop over delay files
        
        for c = 1:size(tc(d).era.mean,2) % loop over curves
        
            temp = table();
            temp.time = tc(d).era.timeaxis';
            temp.mean = squeeze(tc(d).era.mean(v,c,:)); % mean values
            temp.sd   = squeeze(tc(d).era.se(v,c,:));  % sd values
            
            name = char({tc(d).era.avg.Curve(c).Name});
            name_parts = strsplit(name,'_');
            
            
            temp.name =    repmat({[name_parts{1} '_' name_parts{2} '_' name_parts{3}]}, size(tc(d).era.mean,3),1); % curve name
            temp.delay =   repmat({name_parts{4}}, size(tc(d).era.mean,3),1); % delay
            temp.eff =     repmat({name_parts{1}}, size(tc(d).era.mean,3),1); % effector
            temp.choi =    repmat({name_parts{2}}, size(tc(d).era.mean,3),1); % choice - instructed  
            temp.side =    repmat({name_parts{3}}, size(tc(d).era.mean,3),1); % left - right
            temp.trigger = repmat({name_parts{5}}, size(tc(d).era.mean,3),1); % trigger point

            dt = [dt; temp];
        
        end
    end
    
    dt.name = categorical(dt.name);
    dt.delay = categorical(dt.delay);
    dt.eff  = categorical(dt.eff);
    dt.choi = categorical(dt.choi);
    dt.side = categorical(dt.side); 
    dt.trigger_point = categorical(dt.trigger); 
    
    dt.upCI = dt.mean + 1*dt.sd; 
    dt.loCI = dt.mean - 1*dt.sd;
    
    %% Plot
    figure;
    Gsu = gramm('x',dt.time,'y',dt.mean,'ymin',dt.loCI,'ymax',dt.upCI','color',dt.name,'row',dt.delay);
    Gsu.geom_interval('geom','area');
    Gsu.draw;
    
    
    
%     test_ges = table();
% for i = 1:8
%     test = table();
%     test.data = squeeze(era.mean(1,i,:));
%     test.ind = repmat(i,151,1);
%     test.time = era.timeaxis';
%     test_ges = [test_ges; test];
%     
% end


end