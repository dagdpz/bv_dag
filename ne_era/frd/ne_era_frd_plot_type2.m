function ne_era_frd_plot_type2(era_files,subject_name,runpath)

% opengl software % http://www.mathworks.com/matlabcentral/answers/101588
% ini_dir = pwd;

export = 0;

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
clear te;
colors = sortrows(colors,1);
colors.color = colors.color/255;

%% load rest and concetinate
for e = 2:length(era_files)
   ttt = load(era_files{e}); 
   tc(e) = ttt;
end

%% create names
for e = 1:length(era_files)
   [~, fname, ~ ] = fileparts(era_files{e});
   name_parts = strsplit(fname,'_');
   tc(e).del = name_parts{4};
   tc(e).trigger = name_parts{3};
   tc(e).raw_le = size(tc(e).era.raw(1,1).perievents,1);
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
            temp.se   = squeeze(tc(d).era.se(v,c,:));  % sd values
            
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
    dt.side = renamecats(dt.side,{'l','r'},{'left','right'});
    dt.trigger = categorical(dt.trigger); 
    
    dt.upCI = dt.mean + dt.se; 
    dt.loCI = dt.mean - dt.se;
    
   

    
    %% real plot
    clear Gsu2
    %figure ('Position', [100 100 1600 1000]);
    figure;
    Gsu2(1,1)= gramm('x',dt.time,'y',dt.mean,'ymin',dt.loCI,'ymax',dt.upCI','color',dt.name,'subset',dt.time >= -2 & dt.trigger == 'cue');
    Gsu2(1,1).geom_interval('geom','area');
    %Gsu2(1,1).geom_line();
    Gsu2(1,1).axe_property('Xlim',[-2.5 7],'Ylim',[min(dt.mean)-0.2 max(dt.mean)+0.2]);

    Gsu2(1,1).set_color_options('map',colors.color,'n_color',8,'n_lightness',1);
    Gsu2(1,1).set_names('color','','column','','row','','x','time in seconds','y','PSC');
    Gsu2(1,1).geom_vline('xintercept',0,'style','k-');
    Gsu2(1,1).geom_hline('yintercept',0,'style','k--');
    Gsu2(1,1).set_layout_options('legend',false);
    Gsu2(1,1).axe_property('Ygrid','on');
    
    Gsu2(1,2) = gramm('x',dt.time,'y',dt.mean,'ymin',dt.loCI,'ymax',dt.upCI','color',dt.name,'subset',dt.time >= -2 & dt.trigger == 'mov');
    Gsu2(1,2).geom_interval('geom','area');
    %Gsu2(1,2).geom_line();
    Gsu2(1,2).axe_property('Xlim',[-2.5 7],'Ylim',[min(dt.mean)-0.2 max(dt.mean)+0.2]);

    Gsu2(1,2).set_names('color','','column','','row','','x','time in seconds','y','');
    Gsu2(1,2).set_color_options('map',colors.color,'n_color',8,'n_lightness',1);
    Gsu2(1,2).geom_vline('xintercept',0,'style','k-');
    Gsu2(1,2).geom_hline('yintercept',0,'style','k--');
    Gsu2(1,2).axe_property('YTickLabel','','Ygrid','on');
    
    Gsu2(1,2).set_layout_options('legend_position',[0.3 0.7 0.2 0.2]);

    Gsu2.set_title([subject_name '_' voi_name]);   
    Gsu2.draw;
    
    
    
     %% move x axis for move
    
     dt.time (dt.trigger == 'mov') = dt.time (dt.trigger == 'mov') +9; 
    
    %% real plot separated by side + effector
    clear GSu3
    %figure ('Position', [100 100 1600 1000]);
    figure;
    GSu3 = gramm('x',dt.time,'y',dt.mean,'ymin',dt.loCI,'ymax',dt.upCI','color',dt.name,'column',dt.side,'row',dt.choi,'subset',dt.trigger == 'cue');
    GSu3.geom_interval('geom','area');
    %GSu3.geom_line();
    GSu3.axe_property('Xlim',[-3 17],'Ylim',[min(dt.mean)-0.2 max(dt.mean)+0.2]);
    %GSu3.set_order_options('row',{'3','6','9','12','15'},'color',colors.name,'column',{'sac' 'reach'});
    GSu3.set_color_options('map',colors.color,'n_color',8,'n_lightness',1);
    GSu3.set_names('color','','column','','row','','x','time in seconds','y','PSC');
    GSu3.geom_vline('xintercept',[0 9],'style','k-');
    GSu3.geom_hline('yintercept',0,'style','k--');
    GSu3.geom_hline('yintercept',0,'style','k--');
    GSu3.set_title([subject_name '_' voi_name]);    
    
    GSu3.update('x',dt.time,'y',dt.mean,'color',dt.name,'column',dt.side,'row',dt.choi,'subset',dt.time > 7 & dt.trigger == 'mov');
    GSu3.geom_interval('geom','area');
    %GSu3.geom_line();
    GSu3.set_layout_options('legend',false);
    
    GSu3.draw;
     
    
    
    
  
%     
    %% export
    if export
        %orient('tall');
        saveas(gcf, [runpath filesep subject_name '_' voi_name '_averaged.pdf'], 'pdf');
        close(gcf);  
    end
    
    dt = table();


end