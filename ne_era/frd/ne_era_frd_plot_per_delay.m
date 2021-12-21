function ne_era_frd_plot_per_delay(era_files,subject_name,export,savepath)
% plots subject level AND experiment level time course per delay (9, 12, 15 s)
% opengl software % http://www.mathworks.com/matlabcentral/answers/101588


if nargin < 4
    if export == 1
        disp('No saving location has been specified. ne_era_frd_plot_per_delay stops here.');
        return;
    elseif export == 0
        savepath = '';
    end
end



%% data1 = era.mean; %NrOfVOIs X NrOfCurves X NrOfTimePoints

%% load in first data file
tc = load(era_files{1}); 

%% get colors
colors = table();
for i = 1:length(tc.era.avg.Curve)
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


%% create which delays and trigger
for e = 1:length(era_files)
   [~, fname, ~ ] = fileparts(era_files{e});
   name_parts = strsplit(fname,'_');
   tc(e).del = name_parts{4};
   tc(e).trigger = name_parts{3};
   %tc(e).raw_le = size(tc(e).era.raw(1,1).perievents,1);
end


%%
dt = table();
for v = 1:size(tc(1).era.mean,1) % loop over VOIs 
    
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
    
    dt.upErr = dt.mean + dt.se; 
    dt.loErr = dt.mean - dt.se;
    
    %% Plot
    clear Gsu
    figure ('Position', [0 0 1100 1000]);
    %figure;
    Gsu = gramm('x',dt.time,'y',dt.mean,'ymin',dt.loErr,'ymax',dt.upErr','color',dt.name,'column',dt.eff,'row',dt.delay,'subset',dt.time >= -2 & dt.trigger == 'cue');
    Gsu.geom_interval('geom','area');
    Gsu.axe_property('Xlim',[-2.5 15.2],'Ylim',[min(dt.loErr(dt.delay~='3')) max(dt.upErr(dt.delay~='3'))]);
    Gsu.set_order_options('row',{'3','6','9','12','15'},'color',colors.name,'column',{'sac' 'reach'});
    Gsu.set_color_options('map',colors.color,'n_color',8,'n_lightness',1);
    Gsu.set_names('color','','row','','column','','x','time in seconds','y','PSC');
    Gsu.axe_property('Ygrid','on','GridColor',[0.5 0.5 0.5],'XTick',[-2:2:16],'YTick',[floor(min(dt.loErr)):0.2:ceil(max(dt.upErr))]);
    Gsu.geom_polygon('x',{[0 0.2]},'color',[0.5 0.5 0.5]);
    
    Gsu.geom_vline('xintercept',0,'style','k-');
    Gsu.geom_hline('yintercept',0,'style','k--');
    Gsu.set_title([subject_name '_' voi_name 'per_delay']);
    
    
    Gsu.draw;
    
    height_hline = [-1.5 1.5];
    line([3.2 3.2],[height_hline(1) height_hline(2)] ,'Color','k','Parent',Gsu.facet_axes_handles(1));
    line([3.2 3.2],[height_hline(1) height_hline(2)] ,'Color','k','Parent',Gsu.facet_axes_handles(6));
    
    line([6.2 6.2],[height_hline(1) height_hline(2)] ,'Color','k','Parent',Gsu.facet_axes_handles(2));
    line([6.2 6.2],[height_hline(1) height_hline(2)] ,'Color','k','Parent',Gsu.facet_axes_handles(7));

    line([9.2 9.2],[height_hline(1) height_hline(2)] ,'Color','k','Parent',Gsu.facet_axes_handles(3));
    line([9.2 9.2],[height_hline(1) height_hline(2)] ,'Color','k','Parent',Gsu.facet_axes_handles(8));
    
    line([12.2 12.2],[height_hline(1) height_hline(2)] ,'Color','k','Parent',Gsu.facet_axes_handles(4));
    line([12.2 12.2],[height_hline(1) height_hline(2)] ,'Color','k','Parent',Gsu.facet_axes_handles(9));
    
    line([15.2 15.2],[height_hline(1) height_hline(2)] ,'Color','k','Parent',Gsu.facet_axes_handles(5));
    line([15.2 15.2],[height_hline(1) height_hline(2)] ,'Color','k','Parent',Gsu.facet_axes_handles(10));
    
    %% CUE aligned plots, SEPERATE DELAYS (9, 12, 15)
    clear Gsu2
    figure ('Position', [0 0 1100 1500]);
    %figure;
    Gsu2 = gramm('x',dt.time,'y',dt.mean,'ymin',dt.loErr,'ymax',dt.upErr','color',dt.name,'linestyle',dt.delay,'subset',dt.time >= -2 & dt.trigger == 'cue' & dt.delay ~= '3' & dt.delay ~= '6');
    Gsu2.geom_interval('geom','area');
    Gsu2.facet_wrap(dt.name,'ncols',2);

    %Gsu2.geom_line();
    Gsu2.axe_property('Xlim',[-3 16],'Ylim',[min(dt.mean(dt.delay ~= '3' & dt.delay ~= '6'))-0.1 max(dt.mean(dt.delay ~= '3' & dt.delay ~= '6'))+0.1]);
    Gsu2.set_order_options('linestyle',{'15','12','9','6','3'});
    Gsu2.set_color_options('map',colors.color,'n_color',8,'n_lightness',1);
    Gsu2.set_names('color','','column','','row','','x','time in seconds','y','PSC','linestyle','');
    Gsu2.axe_property('Ygrid','on','GridColor',[0.5 0.5 0.5],'XTick',[-2:2:23],'YTick',[floor(min(dt.mean)-0.1):0.2:ceil(max(dt.mean)+0.1)]);
    %Gsu2.geom_polygon('x',{[0 0.2]},'color',[0.5 0.5 0.5]);   
    Gsu2.geom_polygon('x',{[4 7]},'color',[0.5 0.5 0.5]);

    
    Gsu2.geom_vline('xintercept',[9.2 12.2 15.2],'style','k:');
    Gsu2.geom_vline('xintercept',[0],'style','k-');
    %Gsu2.geom_vline('xintercept',3,'style','k--');
    Gsu2.geom_hline('yintercept',0,'style','k-');
    Gsu2.set_title([subject_name '_' voi_name ' cue aligned']);    

    %Gsu2.update('x',dt.time,'y',dt.mean,'color',dt.name,'column',dt.side,'row',dt.eff,'subset',dt.time >= 13 & dt.trigger == 'mov' & dt.delay ~= '3' & dt.delay ~= '6');
    %Gsu2.geom_interval('geom','area');

    %Gsu2.geom_line();
    %Gsu2.set_layout_options('legend',false);
    
    Gsu2.draw;
    text(5.1,0.71,{'cue'},'Parent',Gsu2.facet_axes_handles(1),'Color','k','FontSize',11);

    %% export
    if export
%         orient('tall');
%         saveas(gcf, [savepath filesep subject_name '_' voi_name 'per_delay.pdf'], 'pdf');
%         close(gcf);  
        Gsu.export('file_name',[subject_name '_' voi_name 'per_delay'],...
                 'export_path', savepath,...
                 'file_type','pdf');
             
        Gsu2.export('file_name',[subject_name '_' voi_name 'per_delay_align_cue'],...
                 'export_path', savepath,...
                 'file_type','pdf');             
             
             
        close all;           
    end
    
    
    %% move x axis for move
    
    dt.time (dt.trigger == 'mov') = dt.time (dt.trigger == 'mov') +15.2;
    dt(dt.time < 0 & dt.delay == '15' & dt.trigger == 'mov',:) = [];
    dt(dt.time < 3 & dt.delay == '12' & dt.trigger == 'mov',:) = [];
    dt(dt.time < 6 & dt.delay == '9'  & dt.trigger == 'mov',:) = [];
    
    %% Movement triggered per delay
    clear Gsu3
    figure ('Position', [0 0 1100 1500]);
    Gsu3 = gramm('x',dt.time,'y',dt.mean,'ymin',dt.loErr,'ymax',dt.upErr','color',dt.name,'linestyle',dt.delay,'subset',dt.trigger == 'mov' & dt.delay ~= '3' & dt.delay ~= '6');
    Gsu3.geom_interval('geom','area');
    Gsu3.facet_wrap(dt.name,'ncols',2);
    %Gsu3.geom_line();
    Gsu3.axe_property('Xlim',[-1 23],'Ylim',[min(dt.mean(dt.delay ~= '3' & dt.delay ~= '6'))-0.1 max(dt.mean(dt.delay ~= '3' & dt.delay ~= '6'))+0.1]);
    Gsu3.set_order_options('linestyle',{'15','12','9','6','3'});
    Gsu3.set_color_options('map',colors.color,'n_color',8,'n_lightness',1);
    Gsu3.set_names('color','','column','','row','','x','time in seconds','y','PSC','linestyle','');
    Gsu3.axe_property('Ygrid','on','GridColor',[0.5 0.5 0.5],'XTick',[-2:2:23],'YTick',[floor(min(dt.mean)-0.2):0.2:ceil(max(dt.mean)+0.2)]);
    Gsu3.geom_polygon('x',{[13 14.5]},'color',[0.5 0.5 0.5]);

    Gsu3.geom_vline('xintercept',[15],'style','k-');
    Gsu3.geom_vline('xintercept',[-0.2 2.8 5.8],'style','k:');
    %Gsu3.geom_vline('xintercept',3,'style','k--');
    Gsu3.geom_hline('yintercept',0,'style','k-');
    Gsu3.set_title([subject_name '_' voi_name ' mov aligned']);    
    
    %Gsu3.update('x',dt.time,'y',dt.mean,'color',dt.name,'column',dt.side,'row',dt.eff,'subset',dt.time >= 13 & dt.trigger == 'mov' & dt.delay ~= '3' & dt.delay ~= '6');
    %Gsu3.geom_interval('geom','area');

    %Gsu3.geom_line();
    %Gsu3.set_layout_options('legend',false);
    
    Gsu3.draw;
    text(12.9,0.71,{'mov'},'Parent',Gsu3.facet_axes_handles(1),'Color','k','FontSize',11);
         
    %%
    if export

        Gsu3.export('file_name',[subject_name '_' voi_name 'per_delay_align_mov'],...
                 'export_path', savepath,...
                 'file_type','pdf');             
             
             
        close all;           
    end
    
     
%% PLOT COMPARING DELAY PERIOD DERIVED BY CUE AND MOV TIRGGERED CURVES
    if 0    
    clear Gsu4
    figure ('Position', [0 0 1100 1500]);
    Gsu4(1,1) = gramm('x',dt.time,'y',dt.mean,'ymin',dt.loErr,'ymax',dt.upErr','color',dt.name,'group',dt.delay,'subset', dt.trigger == 'cue' & dt.delay ~= '3' & dt.delay ~= '6'& dt.delay ~= '9' & dt.delay ~= '12');
    Gsu4(1,1).geom_interval('geom','lines');
    Gsu4(1,1).facet_wrap(dt.name,'ncols',2);

    %Gsu4(1,1).geom_line();
    %Gsu4(1,1).axe_property('Xlim',[-3 18],'Ylim',[-1.5 1.5]);
    %Gsu4(1,1).set_order_options('row',{'3','6','9','12','15'},'color',colors.name,'column',{'sac' 'reach'});
    Gsu4(1,1).set_color_options('map',colors.color,'n_color',8,'n_lightness',1);
    Gsu4(1,1).set_names('color','','row','','column','','x','time in seconds','y','PSC');
    Gsu4(1,1).geom_vline('xintercept',[0 15],'style','k-');
    Gsu4(1,1).geom_hline('yintercept',0,'style','k--');
    Gsu4.set_title([subject_name '_' voi_name ' cue and mov triggered curve']);

    
    
    Gsu4(1,1).update('x',dt.time,'y',dt.mean,'color',dt.name,'group',dt.delay,'subset', dt.trigger == 'mov' & dt.delay ~= '3' & dt.delay ~= '6'& dt.delay ~= '9' & dt.delay ~= '12');
    %Gsu4(1,1).geom_line();
    Gsu4(1,1).geom_interval('geom','lines');
    %Gsu4(1,2).axe_property('Xlim',[-3 18],'Ylim',[-1.5 1.5]);
    %Gsu4(1,2).set_order_options('row',{'3','6','9','12','15'},'color',colors.name,'column',{'sac' 'reach'});
    %Gsu4(1,2).set_color_options('map',colors.color,'n_color',8,'n_lightness',1);
    %Gsu4(1,2).set_names('color','','row','','column','','x','time in seconds','y','PSC');
    %Gsu4(1,2).geom_vline('xintercept',0,'style','k-');
    %Gsu4(1,2).geom_hline('yintercept',0,'style','k--');
    Gsu4(1,1).set_line_options('styles',{'-.'});
    Gsu4.draw;

    end
%% EXPORT PLOTS
%         %% Plot
%     clear Gsu
%     figure ('Position', [0 0 800 400]);
%     %figure;
%     Gsu = gramm('x',dt.time,'y',dt.mean,'ymin',dt.loErr,'ymax',dt.upErr','color',dt.name,'column',dt.eff,'subset',dt.time >= -2 & dt.trigger == 'cue' & dt.delay == '12');
%     Gsu.geom_interval('geom','area');
%     Gsu.axe_property('Xlim',[-2.5 13],'Ylim',[-0.15 0.4]);
%     Gsu.set_order_options('row',{'3','6','9','12','15'},'color',colors.name,'column',{'sac' 'reach'});
%     Gsu.set_color_options('map',colors.color,'n_color',8,'n_lightness',1);
%     Gsu.set_names('color','','row','','column','','x','time/s','y','% BOLD change');
%     Gsu.axe_property('Ygrid','on','GridColor',[0.5 0.5 0.5],'XTick',[-2:2:16],'YTick',[floor(min(dt.loErr)):0.2:ceil(max(dt.upErr))]);
%     Gsu.geom_polygon('x',{[0 0.2]},'color',[0.5 0.5 0.5]);
% 
%     Gsu.geom_vline('xintercept',[0 12.2],'style','k-');
%     Gsu.geom_hline('yintercept',0,'style','k--');
%     Gsu.set_title([voi_name ' delay 12']);
%     Gsu.set_line_options('base_size',2);
%     Gsu.set_text_options('base_size', 12,'facet_scaling',0.9,'title_scaling',0.9,'big_title_scaling',1,'legend_scaling',0.8);
%     Gsu.set_layout_options('legend',false);
%     
%     
%     Gsu.draw;
%     
% %     height_hline = [-1.5 1.5];
% %     line([3.2 3.2],[height_hline(1) height_hline(2)] ,'Color','k','Parent',Gsu.facet_axes_handles(1));
% %     line([3.2 3.2],[height_hline(1) height_hline(2)] ,'Color','k','Parent',Gsu.facet_axes_handles(6));
% %     
% %     line([6.2 6.2],[height_hline(1) height_hline(2)] ,'Color','k','Parent',Gsu.facet_axes_handles(2));
% %     line([6.2 6.2],[height_hline(1) height_hline(2)] ,'Color','k','Parent',Gsu.facet_axes_handles(7));
% % 
% %     line([9.2 9.2],[height_hline(1) height_hline(2)] ,'Color','k','Parent',Gsu.facet_axes_handles(3));
% %     line([9.2 9.2],[height_hline(1) height_hline(2)] ,'Color','k','Parent',Gsu.facet_axes_handles(8));
% %     
% %     line([12.2 12.2],[height_hline(1) height_hline(2)] ,'Color','k','Parent',Gsu.facet_axes_handles(4));
% %     line([12.2 12.2],[height_hline(1) height_hline(2)] ,'Color','k','Parent',Gsu.facet_axes_handles(9));
% %     
% %     line([15.2 15.2],[height_hline(1) height_hline(2)] ,'Color','k','Parent',Gsu.facet_axes_handles(5));
% %     line([15.2 15.2],[height_hline(1) height_hline(2)] ,'Color','k','Parent',Gsu.facet_axes_handles(10));
% 
%     if 1
%         Gsu.export('file_name',['timecourse_delay_12_' voi_name],...
%             'export_path', 'Y:\Personal\Peter\Talk IMPRS',...
%             'file_type','png');
%     end
    
    
    
    %%
    dt = table();


end