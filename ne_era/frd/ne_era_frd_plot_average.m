function ne_era_frd_plot_average(era_files,subject_name,plot_subjectwise,export,savepath)
% plots subject level AND experiment level time course averages (averaged
% 9, 12, 15 s delay)
% opengl software % http://www.mathworks.com/matlabcentral/answers/101588

if nargin < 5
    if export == 1
        disp('No saving location has been specified. ne_era_frd_plot_average stops here.');
        return;
    elseif export == 0
        savepath = '';
    end
end


%% data1 = era.mean; %NrOfVOIs X NrOfCurves X NrOfTimePoints

%% load in data
tc = load(era_files{1});

%% get colors
colors = table();
for i = 1:length(tc.era.avg.Curve)
    te = table();
    
    name = char({tc.era.avg.Curve(i).Name});
    name_parts = strsplit(name,'_');
    
    te.name = {[name_parts{1} '_' name_parts{2} '_' name_parts{3}]};
    te.color = tc.era.avg.Curve(i).TimeCourseColor1;
    te.choi =  {name_parts{2}};
    te.eff = {name_parts{1}};
    te.side = {name_parts{3}};
    
    colors = [colors; te];
end
clear te;
colors = sortrows(colors,1);
colors.color = colors.color/255;
% save('Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI\curve_colors.mat','colors');

colors_diff = colors;
colors_diff = colors_diff(find(cellfun(@isempty,strfind(colors.name,'_r'))),:); %discard average mats

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
    %tc(e).raw_le = size(tc(e).era.raw(1,1).perievents,1);
end


%%
dt = table();
dsu = table();
for v = 1:size(tc(1).era.mean,1) % loop over VIOs
    
    voi_name = tc(1).era.voi(v).Name;
    
    for d = 1:length(tc) % loop over era files
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
            
            if plot_subjectwise
                
                temp_dsu = table();
                n_trials = size(tc(d).era.psc(v,c).perievents,2);
                temp_dsu.mean = reshape(tc(d).era.psc(v,c).perievents,[],1);
                temp_dsu.time = repmat(temp.time,n_trials,1);
                
                % some subjects have no trials, account for that by leaving
                % those out
                if tc(d).era.nan_counter(c).count ~= 0
                    sbs = tc(d).era.subj(~ismember(tc(d).era.subj,tc(d).era.nan_counter(c).subj));
                else
                    sbs = tc(d).era.subj;
                end
                
                temp_dsu.subj    = reshape(repmat(sbs,length(temp.time),1),[],1);
                temp_dsu.name    = repmat({temp.name{1}}, length(temp_dsu.mean),1);
                temp_dsu.delay   = repmat({name_parts{4}},length(temp_dsu.mean),1);
                temp_dsu.eff     = repmat({name_parts{1}},length(temp_dsu.mean),1);
                temp_dsu.choi    = repmat({name_parts{2}},length(temp_dsu.mean),1);
                temp_dsu.side    = repmat({name_parts{3}},length(temp_dsu.mean),1);
                temp_dsu.trigger = repmat({name_parts{5}},length(temp_dsu.mean),1);
                
                dsu = [dsu; temp_dsu];
                
            end
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
    
    if plot_subjectwise
        
        dsu.name = categorical(dsu.name);
        dsu.delay = categorical(dsu.delay);
        dsu.eff  = categorical(dsu.eff);
        dsu.choi = categorical(dsu.choi);
        dsu.side = categorical(dsu.side);
        dsu.side = renamecats(dsu.side,{'l','r'},{'left','right'});
        dsu.trigger = categorical(dsu.trigger);
        dsu.subj = categorical(dsu.subj);
    end
    
    %% move x axis for move
    dt.time_shift = dt.time;
    dt.time_shift(dt.trigger == 'mov') = dt.time_shift(dt.trigger == 'mov') +9.2;
    
    %% real plot
    clear Gsu2
    figure ('Position', [100 100 1200 800]);
    %figure;
    Gsu2(1,1)= gramm('x',dt.time,'y',dt.mean,'ymin',dt.loCI,'ymax',dt.upCI','color',dt.name,'subset',dt.time >= -2 & dt.trigger == 'cue');
    Gsu2(1,1).geom_interval('geom','area');
    %Gsu2(1,1).geom_line();
    Gsu2(1,1).axe_property('Xlim',[-2.5 7.2],'Ylim',[min(dt.mean)-0.2 max(dt.mean)+0.2]);
    
    Gsu2(1,1).axe_property('Ygrid','on','YTick',[floor(min(dt.mean)-0.2):0.1:ceil(max(dt.mean)+0.2)],'XTick',[-2:1:7]);
    Gsu2(1,1).set_color_options('map',colors.color,'n_color',8,'n_lightness',1);
    Gsu2(1,1).set_names('color','','column','','row','','x','time in seconds','y','PSC');
    Gsu2(1,1).geom_vline('xintercept',0,'style','k-');
    Gsu2(1,1).geom_hline('yintercept',0,'style','k--');
    Gsu2(1,1).set_layout_options('legend',false);
    Gsu2(1,1).geom_polygon('x',{[0 0.2]},'color',[0.5 0.5 0.5]);
    
    Gsu2(1,2) = gramm('x',dt.time,'y',dt.mean,'ymin',dt.loCI,'ymax',dt.upCI','color',dt.name,'subset',dt.time >= -2 & dt.trigger == 'mov');
    Gsu2(1,2).geom_interval('geom','area');
    %Gsu2(1,2).geom_line();
    Gsu2(1,2).axe_property('Xlim',[-2.5 7.2],'Ylim',[min(dt.mean)-0.2 max(dt.mean)+0.2]);
    
    Gsu2(1,2).set_names('color','','column','','row','','x','time in seconds','y','');
    Gsu2(1,2).set_color_options('map',colors.color,'n_color',8,'n_lightness',1);
    Gsu2(1,2).geom_vline('xintercept',0,'style','k-');
    Gsu2(1,2).geom_hline('yintercept',0,'style','k--');
    Gsu2(1,2).axe_property('YTickLabel','','Ygrid','on','YTick',[floor(min(dt.mean)-0.2):0.1:ceil(max(dt.mean)+0.2)],'XTick',[-2:1:7]);
    
    Gsu2(1,2).set_layout_options('legend_position',[0.18 0.61 0.2 0.3]);
    
    Gsu2.set_title([subject_name '_' voi_name 'averaged']);
    Gsu2.draw;
    

    
    %% real plot separated by side + effector
    clear GSu3
    figure ('Position', [100 100 1600 1000]);
    %figure;
    GSu3 = gramm('x',dt.time_shift,'y',dt.mean,'ymin',dt.loCI,'ymax',dt.upCI','color',dt.name,'column',dt.side,'row',dt.eff,'subset',dt.time_shift >= -2 & dt.time_shift <= 7 & dt.trigger == 'cue');
    GSu3.geom_interval('geom','area');
    %GSu3.geom_line();
    GSu3.axe_property('Xlim',[-3 17],'Ylim',[min(dt.loCI) max(dt.upCI)]);
    GSu3.axe_property('Ygrid','on','GridColor',[0.5 0.5 0.5],'XTick',[-2:2:16],'YTick',[floor(min(dt.loCI))-0.1:0.2:ceil(max(dt.upCI))+0.1]);
    
    %GSu3.set_order_options('row',{'3','6','9','12','15'},'color',colors.name,'column',{'sac' 'reach'});
    GSu3.set_color_options('map',colors.color,'n_color',8,'n_lightness',1);
    GSu3.set_names('color','','column','','row','','x','time in seconds','y','PSC');

    GSu3.geom_hline('yintercept',0,'style','k-');
    GSu3.set_title([subject_name '_' voi_name 'averaged']);
    
    GSu3.update('x',dt.time_shift,'y',dt.mean,'color',dt.name,'column',dt.side,'row',dt.eff,'subset',dt.time_shift > 7 & dt.trigger == 'mov');
    GSu3.geom_interval('geom','area');
    %GSu3.geom_line();
    GSu3.set_layout_options('legend',false);
    GSu3.geom_hline('yintercept',0,'style','k-');
    GSu3.geom_vline('xintercept',[0 9.2],'style','k-');
    GSu3.geom_polygon('x',{[4 7]},'color',[0.5 0.5 0.5]);
    GSu3.geom_polygon('x',{[7.1 8.5]},'color',[0.5 0.5 0.5]);
    GSu3.draw;
    
     %text(5.1,0.65,{'cue'},'Parent',GSu3.facet_axes_handles(1),'Color','k','FontSize',12.5);
     %text(7.25,0.65,{'mov'},'Parent',GSu3.facet_axes_handles(1),'Color','k','FontSize',12.5);

    %% export
    if export
        %         %orient('tall');
        %         saveas(gcf, [savepath filesep subject_name '_' voi_name 'averaged.pdf'], 'pdf');
        %         close(gcf);
        Gsu2.export('file_name',[subject_name '_' voi_name 'averaged'],...
            'export_path', savepath,...
            'file_type','pdf');
        
        GSu3.export('file_name',[subject_name '_' voi_name 'averaged_subplots'],...
            'export_path', savepath,...
            'file_type','pdf');
        
        close all;
    end
    
    %%
    if plot_subjectwise
        %%
        dsu.time_shift = dsu.time;
        dsu.time_shift(dsu.trigger == 'mov') = dsu.time_shift(dsu.trigger == 'mov') +9.2;
        
        %%
        
        subset_dt =   (dt.time_shift <= 7.2 &  dt.trigger == 'cue' &  dt.time_shift >= -2) | (dt.time_shift > 7.2 &  dt.trigger == 'mov');
        subset_dsu = (dsu.time_shift <= 7.2 & dsu.trigger == 'cue' & dsu.time_shift >= -2) |(dsu.time_shift > 7.2 & dsu.trigger == 'mov');
        
        uni_eff = unique(colors.eff);
        
        for i = 1:length(uni_eff)
            
            clear Gsu5
            figure ('Position', [100 100 1600 1000]);
            %figure;
            Gsu5 = gramm('x',dsu.time_shift,'y',dsu.mean,'group',findgroups(dsu.subj,dsu.trigger),'row',dsu.side,'column',dsu.choi,'subset',subset_dsu & dsu.eff == uni_eff{i});
            Gsu5.geom_line();
            Gsu5.set_color_options('lightness',80,'chroma',0);
            Gsu5.geom_line();
            Gsu5.geom_vline('xintercept',[0 9.2],'style','k-');
            Gsu5.geom_hline('yintercept',0,'style','k--');
            Gsu5.geom_hline('yintercept',0,'style','k--');
            %Gsu5.axe_property('Xlim',[-3 17],'Ylim',[min(dt.loCI) max(dt.upCI)]);
            Gsu5.axe_property('Ygrid','on','GridColor',[0.5 0.5 0.5],'XTick',[-2:2:16],'YTick',[floor(min(dsu.mean))-0.1:0.2:ceil(max(dsu.mean))+0.1]);
            Gsu5.geom_polygon('x',{[0 0.2]},'color',[0.5 0.5 0.5]);
            Gsu5.set_names('color','','column','','row','','x','time in seconds','y','PSC');
            Gsu5.set_title([subject_name '_' voi_name 'averaged_overlayed_' uni_eff{i}]);
            
            
            Gsu5.update('x',dt.time_shift,'y',dt.mean,'ymin',dt.loCI,'ymax',dt.upCI','color',dt.name,'group',dt.trigger,'row',dt.side,'column',dt.choi,'subset',subset_dt & dt.eff == uni_eff{i});
            Gsu5.geom_interval('geom','area');
            Gsu5.set_color_options('map',colors.color(strcmp(uni_eff{i},colors.eff),:),'n_color',8,'n_lightness',1);
            Gsu5.set_order_options('color',colors.name(strcmp(uni_eff{i},colors.eff),:));
            
            Gsu5.draw;
            
            %%
            
            clear Gsu6
            figure ('Position', [100 100 1600 1000]);
            %figure;
            Gsu6 = gramm('x',dsu.time_shift,'y',dsu.mean,'color',dsu.subj,'group',dsu.trigger,'row',dsu.side,'column',dsu.choi,'subset',subset_dsu & dsu.eff == uni_eff{i});
            Gsu6.geom_line();
            Gsu6.geom_line();
            Gsu6.geom_vline('xintercept',[0 9.2],'style','k-');
            Gsu6.geom_hline('yintercept',0,'style','k--');
            Gsu6.geom_hline('yintercept',0,'style','k--');
            %Gsu6.axe_property('Xlim',[-3 17],'Ylim',[min(dt.loCI) max(dt.upCI)]);
            Gsu6.axe_property('Ygrid','on','GridColor',[0.5 0.5 0.5],'XTick',[-2:2:16],'YTick',[floor(min(dsu.mean))-0.1:0.2:ceil(max(dsu.mean))+0.1]);
            Gsu6.geom_polygon('x',{[0 0.2]},'color',[0.5 0.5 0.5]);
            Gsu6.set_names('color','','column','','row','','x','time in seconds','y','PSC');
            Gsu6.set_title([subject_name '_' voi_name 'averaged_subjectwise_' uni_eff{i}]);
            
            
            Gsu6.draw;
            
            %
            if export
                
                Gsu5.export('file_name',[subject_name '_' voi_name 'averaged_overlayed_' uni_eff{i}],...
                    'export_path', savepath,...
                    'file_type','pdf');
                
                Gsu6.export('file_name',[subject_name '_' voi_name 'averaged_subjectwise_' uni_eff{i}],...
                    'export_path', savepath,...
                    'file_type','pdf')
                close all;
                
            end
            
            
        end %loop reach saccade
    end %if subjectwise
      
    
    %% EXPORT PLOT FOR IMPRS PRESENTATION
 if 0   
        %% real plot separated by side + effector
    clear GSu3
    figure ('Position', [100 100 800 500]);
    %figure;
    GSu3 = gramm('x',dt.time_shift,'y',dt.mean,'ymin',dt.loCI,'ymax',dt.upCI','color',dt.name,'column',dt.side,'row',dt.eff,'subset',dt.time_shift >= -2 & dt.time_shift <= 7.2 & dt.trigger == 'cue');
    GSu3.geom_interval('geom','area');
    %GSu3.geom_line();
    %GSu3.axe_property('Xlim',[-3 17],'Ylim',[min(dt.loCI) max(dt.upCI)]);
    GSu3.axe_property('Xlim',[-3 17],'Ylim',[-0.05 0.7]);
    GSu3.axe_property('Ygrid','on','GridColor',[0.5 0.5 0.5],'XTick',[0:4:16],'YTick',[floor(min(dt.loCI))-0.1:0.2:ceil(max(dt.upCI))+0.1]);
    
    %GSu3.set_order_options('row',{'3','6','9','12','15'},'color',colors.name,'column',{'sac' 'reach'});
    GSu3.set_color_options('map',colors.color,'n_color',8,'n_lightness',1);
    GSu3.set_names('color','','column','','row','','x','time/s','y','% BOLD change');
   % GSu3.set_title([voi_name]);
    
        GSu3.set_title(['left 8BM']);
    GSu3.set_line_options('base_size',2);
    GSu3.set_text_options('base_size', 15,'facet_scaling',0.9,'title_scaling',0.9,'big_title_scaling',1,'legend_scaling',0.8);
    GSu3.set_layout_options('legend',true);
    
    GSu3.update('x',dt.time_shift,'y',dt.mean,'color',dt.name,'column',dt.side,'row',dt.eff,'subset',dt.time_shift > 7.4 & dt.trigger == 'mov');
    GSu3.geom_interval('geom','area');
    %GSu3.geom_line();
    GSu3.set_layout_options('legend',false);
    GSu3.geom_polygon('x',{[0 0.2]},'color',[0.5 0.5 0.5]);
    GSu3.geom_vline('xintercept',[0 9.2],'style','k-');

   
    GSu3.set_line_options('base_size',2);
    
    %GSu3(1,1).geom_polygon('x',{[4 6.9]},'color',[0.5 0.5 0.5]);   
    GSu3.draw;


    line([-3 17],[0 0] ,'Color','k','LineStyle','--','Parent',GSu3.facet_axes_handles(1));
    line([-3 17],[0 0] ,'Color','k','LineStyle','--','Parent',GSu3.facet_axes_handles(2));
    line([-3 17],[0 0] ,'Color','k','LineStyle','--','Parent',GSu3.facet_axes_handles(3));
    line([-3 17],[0 0] ,'Color','k','LineStyle','--','Parent',GSu3.facet_axes_handles(4));
    
    
    if export
        GSu3.export('file_name',['timecourse_' voi_name],...
            'export_path', 'Y:\Personal\Peter\writing up',...
            'file_type','jpg');
        close all
    end
    
    %% Example plot with periods as polygons
    
%%
    clear GSu3
    figure ('Position', [100 100 1200 720]);
    %figure;
    GSu3 = gramm('x',dt.time_shift,'y',dt.mean,'ymin',dt.loCI,'ymax',dt.upCI','color',dt.name,'subset',dt.time_shift >= -2 & dt.time_shift <= 6.9 & dt.trigger == 'cue');  
    GSu3.geom_interval('geom','area');
    %GSu3.geom_line();
    GSu3.axe_property('Xlim',[-3 17],'Ylim',[min(dt.loCI) max(dt.upCI)]);
    GSu3.axe_property('Ygrid','on','GridColor',[0.5 0.5 0.5],'XTick',[-2:2:16],'YTick',[floor(min(dt.loCI))-0.1:0.2:ceil(max(dt.upCI))+0.1]);
    
    %GSu3.set_order_options('row',{'3','6','9','12','15'},'color',colors.name,'column',{'sac' 'reach'});
    GSu3.set_color_options('map',colors.color,'n_color',8,'n_lightness',1);
    GSu3.set_names('color','','column','','row','','x','time/s','y','% BOLD change');
    %GSu3.set_title([voi_name]);
    GSu3.set_title('left SCEF');
    GSu3.set_line_options('base_size',2);
    GSu3.set_text_options('base_size', 12,'facet_scaling',0.9,'title_scaling',0.9,'big_title_scaling',1,'legend_scaling',0.8);
    
    GSu3.update('x',dt.time_shift,'y',dt.mean,'color',dt.name,'subset',dt.time_shift > 6.9 & dt.trigger == 'mov');
    GSu3.geom_interval('geom','area');
    %GSu3.geom_line();
    GSu3.set_layout_options('legend',false);
    
    GSu3.geom_vline('xintercept',[0 9.2],'style','k-');

    GSu3.set_line_options('base_size',2);
    
    %GSu3.geom_polygon('x',{[0 0.5]},'color',[0.5 0.5 0.5]);
    GSu3.geom_polygon('x',{[4 6.9]},'color',[0.5 0.5 0.5]);
    GSu3.geom_polygon('x',{[7 8.4]},'color',[0.5 0.5 0.5]);
    %GSu3(1,1).geom_polygon('x',{[4 6.9]},'color',[0.5 0.5 0.5]);   
    GSu3.draw;

    %text(75.3,47,{'Important' 'event'},'Parent',g.facet_axes_handles(1),'FontName','Courier');

    %line([-3 17],[0 0] ,'Color','k','LineStyle','--','Parent',GSu3.facet_axes_handles(1));
    %line([-3 17],[0 0] ,'Color','k','LineStyle','--','Parent',GSu3.facet_axes_handles(2));
    %line([-3 17],[0 0] ,'Color','k','LineStyle','--','Parent',GSu3.facet_axes_handles(3));
    %line([-3 17],[0 0] ,'Color','k','LineStyle','--','Parent',GSu3.facet_axes_handles(4));
    
    
    if export
        GSu3.export('file_name',['timecourse_exampleplot' voi_name],...
            'export_path', 'Y:\Personal\Peter\writing up',...
            'file_type','jpg');
    end
    
end  % if 0 
    %%
    dt = table();
    
    if plot_subjectwise
        dsu = table();
    end
    
    
end