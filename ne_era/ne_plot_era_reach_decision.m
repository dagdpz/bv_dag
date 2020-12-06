function dt = ne_plot_era_reach_decision(era_files,subject_name,runpath)

% opengl software % http://www.mathworks.com/matlabcentral/answers/101588
% ini_dir = pwd;

export = 1;

% %%
% if nargin > 1
%     era_settings_id = 'Human_reach_decision';
% end
% 
% run('ne_era_settings');


%% data1 = era.mean; %NrOfVOIs X NrOfCurves X NrOfTimePoints

%% load in data
tc = load(era_files{1}); 

%% get colors
colors = table();
for i = 1:length(tc.era.avg.Curve);
    te = table();
    
    name = char({tc.era.avg.Curve(i).Name});
    name_parts = strsplit(name,'_');
    
    te.name = {[name_parts{1} '_' name_parts{2} '_' name_parts{3}]};
    te.color = tc.era.avg.Curve(i).TimeCourseColor1;
    
    colors = [colors; te];
end

colors = sortrows(colors,1);
colors.color = colors.color/255;

%% load rest and concetinate
for e = 2:length(era_files)
   ttt = load(era_files{e}); 
   tc(e) = ttt;
end


%%
dt = table();
for v = 1:size(tc(1).era.mean,1) % loop over VIOs 
    
    voi_name = tc(1).era.voi(v).Name;

    
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
    dt.trigger = categorical(dt.trigger); 
    
    dt.upCI = dt.mean + 2*dt.sd; 
    dt.loCI = dt.mean - 2*dt.sd;
    
    %% Plot
    clear Gsu
    %figure ('Position', [100 100 1600 1000]);
    figure;
    Gsu = gramm('x',dt.time,'y',dt.mean,'ymin',dt.loCI,'ymax',dt.upCI','color',dt.name,'column',dt.eff,'row',dt.delay,'subset',dt.trigger == 'cue');
    Gsu.geom_interval('geom','area');
    Gsu.axe_property('Xlim',[-3 18],'Ylim',[-1.5 1.5]);
    Gsu.set_order_options('row',{'3','6','9','12','15'},'color',colors.name,'column',{'sac' 'reach'});
    Gsu.set_color_options('map',colors.color,'n_color',8,'n_lightness',1);
    Gsu.set_names('color','','row','','column','','x','time in seconds','y','PSC');
    Gsu.geom_vline('xintercept',0,'style','k-');
    Gsu.geom_hline('yintercept',0,'style','k--');
    Gsu.set_title([subject_name '_' voi_name]);
    
    
    Gsu.draw;
    
    height_hline = [-1.5 1.5];
    line([3 3],[height_hline(1) height_hline(2)] ,'Color','k','Parent',Gsu.facet_axes_handles(1));
    line([3 3],[height_hline(1) height_hline(2)] ,'Color','k','Parent',Gsu.facet_axes_handles(6));
    
    line([6 6],[height_hline(1) height_hline(2)] ,'Color','k','Parent',Gsu.facet_axes_handles(2));
    line([6 6],[height_hline(1) height_hline(2)] ,'Color','k','Parent',Gsu.facet_axes_handles(7));

    line([9 9],[height_hline(1) height_hline(2)] ,'Color','k','Parent',Gsu.facet_axes_handles(3));
    line([9 9],[height_hline(1) height_hline(2)] ,'Color','k','Parent',Gsu.facet_axes_handles(8));
    
    line([12 12],[height_hline(1) height_hline(2)] ,'Color','k','Parent',Gsu.facet_axes_handles(4));
    line([12 12],[height_hline(1) height_hline(2)] ,'Color','k','Parent',Gsu.facet_axes_handles(9));
    
    line([15 15],[height_hline(1) height_hline(2)] ,'Color','k','Parent',Gsu.facet_axes_handles(5));
    line([15 15],[height_hline(1) height_hline(2)] ,'Color','k','Parent',Gsu.facet_axes_handles(10));
    
    %% export
    if export
        %orient('tall');
        saveas(gcf, [runpath filesep subject_name '_' voi_name '_per_delay.pdf'], 'pdf');
        close(gcf);  
    end
    
    dt = table();


end