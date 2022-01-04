function ne_era_frd_plot_differences(era_files,subject_name,cond_diff,plot_delaywise,plot_subjectwise,savepath,export)
% This function plots difference time courses between two conditions. So
% far only CHOICE - INSTRUCTED works! Subjectwise-plots work only for
% averaged delays (plot_delaywise == 0).

if plot_delaywise == 1
    plot_subjectwise = 0;
end


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
    
    colors = [colors; te];
end
clear te;
colors = sortrows(colors,1);
colors.color = colors.color/255;

colors_all = colors;
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
    tc(e).hemi = name_parts{5};
end

%%
for cnd = 1:size(cond_diff,1)
    
    diff_name = [cond_diff{cnd,1} '_' cond_diff{cnd,2}];
    diff_idx = find(strcmp(diff_name,{tc(1).era.diff.name}));
    
    dt = table();
    dsu = table();
    
    for v = 1:size(tc(1).era.mean,1) % loop over VOIs
        
        voi_name = tc(1).era.voi(v).Name;
        
        for d = 1:length(tc) % loop files
            
            for c = 1:size(tc(d).era.diff(diff_idx).dat.cond,2) % loop over conditions
                
                temp = table();
                temp.time = tc(d).era.timeaxis';
                temp.mean = squeeze(tc(d).era.diff(diff_idx).dat.diff_mean(v,c,:)); % mean values
                temp.se   = squeeze(tc(d).era.diff(diff_idx).dat.diff_se(v,c,:));  % sd values
                
                name = char(tc(d).era.diff(diff_idx).dat.cond{c});
                name_parts = strsplit(name,'_');
                
                
                temp.name =    repmat(tc(d).era.diff(diff_idx).dat.cond(c), size(tc(d).era.diff(diff_idx).dat.diff_mean,3),1); % curve name
                temp.cond_1 =  repmat({name_parts{1}}, size(tc(d).era.diff(diff_idx).dat.diff_mean,3),1); % cond_1
                temp.cond_2 =  repmat({name_parts{2}}, size(tc(d).era.diff(diff_idx).dat.diff_mean,3),1); % cond_1
                
                temp.delay =   repmat({tc(d).del},     size(tc(d).era.diff(diff_idx).dat.diff_mean,3),1); % delay
                temp.trigger = repmat({tc(d).trigger}, size(tc(d).era.diff(diff_idx).dat.diff_mean,3),1); % trigger point
                
                dt = [dt; temp];
                
                if plot_subjectwise
                    
                    temp_dsu = table();
                    n_trials         = size(tc(d).era.diff(diff_idx).dat.psc(v,c).perievents,2);
                    temp_dsu.mean = reshape(tc(d).era.diff(diff_idx).dat.psc(v,c).perievents,[],1);
                    temp_dsu.time = repmat(temp.time,n_trials,1);
                    
                    % some subjects have no trials, account for that by leaving
                    % those out
                    if tc(d).era.diff(diff_idx).nan_counter(c).count ~= 0
                        sbs = tc(d).era.subj(~ismember(tc(d).era.subj,tc(d).era.diff(diff_idx).nan_counter(c).subj));
                    else
                        sbs = tc(d).era.subj;
                    end
                    
                    temp_dsu.subj    = reshape(repmat(sbs,length(temp.time),1),[],1);
                    temp_dsu.name    = repmat({temp.name{1}}, length(temp_dsu.mean),1);
                    temp_dsu.delay   = repmat({tc(d).del},    length(temp_dsu.mean),1);
                    temp_dsu.trigger = repmat({tc(d).trigger},length(temp_dsu.mean),1);

                    temp_dsu.cond_1  = repmat({name_parts{1}},length(temp_dsu.mean),1);
                    temp_dsu.cond_2  = repmat({name_parts{2}},length(temp_dsu.mean),1);
                    
                    dsu = [dsu; temp_dsu];
                    
                end
                
            end % loop conditions
        end % loop files
        
        dt.name = categorical(dt.name);
        dt.delay = categorical(dt.delay);
        dt.trigger = categorical(dt.trigger);

        %  dt.eff  = categorical(dt.eff);
        %  dt.choi = categorical(dt.choi);
        %  dt.side = categorical(dt.side);
        %  dt.side = renamecats(dt.side,{'l','r'},{'left','right'});
        
        dt.upErr = dt.mean + dt.se;
        dt.loErr = dt.mean - dt.se;
        
        % when does diff cross 1 significantly
        s_diff = diff((dt.mean - (1.96 * dt.se))>0);
        s_diff = [0;s_diff];
        dt.ind = s_diff == 1;
        
        if plot_subjectwise
            
            dsu.name    = categorical(dsu.name);
            dsu.delay   = categorical(dsu.delay);
            dsu.trigger = categorical(dsu.trigger);
            dsu.subj    = categorical(dsu.subj);
        end
        %% move x axis for move for AVERAGED CURVES
        dt.time_shift = dt.time;
        dt.time_shift(dt.trigger == 'mov') = dt.time_shift(dt.trigger == 'mov') +9.2;
        
        if plot_subjectwise
            dsu.time_shift = dsu.time;
            dsu.time_shift(dsu.trigger == 'mov') = dsu.time_shift(dsu.trigger == 'mov') +9.2;
        end
        
        %% HARD CODED CHANGES - depends on which condition is subtracted
        % rename remaining two conditions
        dt.cond_1  = categorical(dt.cond_1);
        dt.cond_2  = categorical(dt.cond_2);
        dt.Properties.VariableNames([5 6]) = {'eff' 'side'};
        
        if plot_subjectwise
            dsu.cond_1 = categorical(dsu.cond_1);
            dsu.cond_2 = categorical(dsu.cond_2);
            dsu.Properties.VariableNames([7 8]) = {'eff' 'side'};
        end        
        
        % get colors whcih are different depending on which subtraction      
        colors = colors_all([1 2 5 6],:);
        colors.name(strcmp('reach_choi_l',colors.name)) =  {'reach_left'};
        colors.name(strcmp('reach_choi_r',colors.name)) =  {'reach_right'};
        colors.name(strcmp('sac_choi_l',colors.name))   =  {'sac_left'};
        colors.name(strcmp('sac_choi_r',colors.name))   =  {'sac_right'};
        
        
        
        
        %%
        if plot_delaywise == 0
            clear Gsu
            figure ('Position', [0 0 1300 1000]);
            
            % cue part
            Gsu(1,1) = gramm('x',dt.time_shift,'y',dt.mean,'ymin',dt.loErr,'ymax',dt.upErr','color',dt.name,'column',dt.eff,'subset',dt.time_shift >= -2 & dt.time_shift <= 7.2 & dt.trigger == 'cue');
            Gsu(1,1).geom_interval('geom','area');
            Gsu(1,1).axe_property('Xlim',[-2.5 12],'Ylim',[min(dt.loErr) max(dt.upErr)]);
            Gsu(1,1).axe_property('Ygrid','on','GridColor',[0.5 0.5 0.5],'XTick',[-2:2:12],'YTick',[floor(min(dt.loErr)):0.05:ceil(max(dt.upErr))]);
            Gsu(1,1).geom_polygon('x',{[0 0.2]},'color',[0.5 0.5 0.5]);
            
            Gsu(1,1).set_order_options('color',colors.name);
            Gsu(1,1).set_color_options('map',colors.color,'n_color',4,'n_lightness',1);
            Gsu(1,1).set_names('color','','row','','column','','x','time in seconds','y','PSC');
            
            Gsu(1,1).geom_vline('xintercept',[0 9.2],'style','k-');
            Gsu(1,1).geom_hline('yintercept',0,'style','k--');
            
            Gsu(1,1).set_title([subject_name '_' voi_name 'CHOI-INSTR_averaged']);
            
            % mov part
            Gsu(1,1).update('x',dt.time_shift,'y',dt.mean,'ymin',dt.loErr,'ymax',dt.upErr','color',dt.name,'column',dt.eff,'subset',dt.time_shift > 7.2 & dt.time_shift <= 11.5 & dt.trigger == 'mov');
            Gsu(1,1).geom_interval('geom','area');
            Gsu(1,1).set_layout_options('legend',false);
            
            
            % same figure, differently plotted CUE
            Gsu(2,1) = gramm('x',dt.time,'y',dt.mean,'ymin',dt.loErr,'ymax',dt.upErr','color',dt.name,'column',dt.side,'subset',dt.time >= -2 & dt.time_shift <= 7.2 & dt.trigger == 'cue');
            Gsu(2,1).geom_interval('geom','area');
            Gsu(2,1).axe_property('Xlim',[-2.5 12],'Ylim',[min(dt.loErr(dt.delay~='3')) max(dt.upErr(dt.delay~='3'))]);
            Gsu(2,1).set_order_options('color',colors.name); %'color',colors.name,
            Gsu(2,1).set_color_options('map',colors.color,'n_color',4,'n_lightness',1);
            Gsu(2,1).set_names('color','','row','','column','','x','time in seconds','y','PSC');
            Gsu(2,1).axe_property('Ygrid','on','GridColor',[0.5 0.5 0.5],'XTick',[-2:2:12],'YTick',[floor(min(dt.loErr)):0.05:ceil(max(dt.upErr))]);
            Gsu(2,1).geom_polygon('x',{[0 0.2]},'color',[0.5 0.5 0.5]);
            
            Gsu(2,1).geom_vline('xintercept',[0 9.2],'style','k-');
            Gsu(2,1).geom_hline('yintercept',0,'style','k--');
            Gsu(2,1).set_title([subject_name '_' voi_name 'CHOI-INSTR_averaged']);
            
            
            Gsu(2,1).update('x',dt.time_shift,'y',dt.mean,'ymin',dt.loErr,'ymax',dt.upErr','color',dt.name,'column',dt.side,'subset',dt.time_shift > 7.2 & dt.time_shift <= 11.5 & dt.trigger == 'mov');
            Gsu(2,1).geom_interval('geom','area');
            Gsu(2,1).set_layout_options('legend',false);
            
            Gsu.draw;
            
            
            ig_add_multiple_vertical_lines(dt.time(dt.ind & dt.trigger == 'cue' & dt.name == 'reach_left'),'Color',colors.color(1,:),'LineStyle','-.','Parent',Gsu(1,1).facet_axes_handles(1));
            ig_add_multiple_vertical_lines(dt.time(dt.ind & dt.trigger == 'cue' & dt.name == 'reach_left'),'Color',colors.color(1,:),'LineStyle','-.','Parent',Gsu(2,1).facet_axes_handles(1));
            
            ig_add_multiple_vertical_lines(dt.time(dt.ind & dt.trigger == 'cue' & dt.name == 'reach_right'),'Color',colors.color(2,:),'LineStyle','-.','Parent',Gsu(1,1).facet_axes_handles(1));
            ig_add_multiple_vertical_lines(dt.time(dt.ind & dt.trigger == 'cue' & dt.name == 'reach_right'),'Color',colors.color(2,:),'LineStyle','-.','Parent',Gsu(2,1).facet_axes_handles(2));
            
            ig_add_multiple_vertical_lines(dt.time(dt.ind & dt.trigger == 'cue' & dt.name == 'sac_left'),'Color',colors.color(3,:),'LineStyle','-.','Parent',Gsu(1,1).facet_axes_handles(2));
            ig_add_multiple_vertical_lines(dt.time(dt.ind & dt.trigger == 'cue' & dt.name == 'sac_left'),'Color',colors.color(3,:),'LineStyle','-.','Parent',Gsu(2,1).facet_axes_handles(1));
            
            ig_add_multiple_vertical_lines(dt.time(dt.ind & dt.trigger == 'cue' & dt.name == 'sac_right'),'Color',colors.color(4,:),'LineStyle','-.','Parent',Gsu(1,1).facet_axes_handles(2));
            ig_add_multiple_vertical_lines(dt.time(dt.ind & dt.trigger == 'cue' & dt.name == 'sac_right'),'Color',colors.color(4,:),'LineStyle','-.','Parent',Gsu(2,1).facet_axes_handles(2));
            
            
            %%
            if export == 1
                
                Gsu.export('file_name',[subject_name '_' voi_name 'CHOI-INSTR_averaged'],...
                    'export_path', savepath,...
                    'file_type','pdf');
                
            end
            
            %%
            
            if plot_subjectwise
                
                subset_dt =   (dt.time_shift <= 7.2 &  dt.trigger == 'cue' &  dt.time_shift >= -2) | (dt.time_shift > 7.2 &  dt.trigger == 'mov');
                subset_dsu = (dsu.time_shift <= 7.2 & dsu.trigger == 'cue' & dsu.time_shift >= -2) |(dsu.time_shift > 7.2 & dsu.trigger == 'mov');
                
                %% grey subjects, mean in color
                clear Gsu5
                figure ('Position', [100 100 1600 1000]);
                %figure;
                Gsu5 = gramm('x',dsu.time_shift,'y',dsu.mean,'group',findgroups(dsu.subj,dsu.trigger),'row',dsu.eff,'column',dsu.side,'subset',subset_dsu);
                Gsu5.geom_line();
                Gsu5.set_color_options('lightness',80,'chroma',0);
                Gsu5.geom_line();
                Gsu5.geom_vline('xintercept',[0 9.2],'style','k-');
                Gsu5.geom_hline('yintercept',0,'style','k--');
                Gsu5.geom_hline('yintercept',0,'style','k--');
                %Gsu5.axe_property('Xlim',[-3 17],'Ylim',[min(dt.loErr) max(dt.upErr)]);
                Gsu5.axe_property('Ygrid','on','GridColor',[0.5 0.5 0.5],'XTick',[-2:2:16],'YTick',[floor(min(dsu.mean)):0.2:ceil(max(dsu.mean))]);
                Gsu5.geom_polygon('x',{[0 0.2]},'color',[0.5 0.5 0.5]);
                Gsu5.set_names('color','','column','','row','','x','time in seconds','y','PSC');
                Gsu5.set_title([subject_name '_' voi_name 'CHOI-INSTR_averaged_subj_grey']);
                
                
                Gsu5.update('x',dt.time_shift,'y',dt.mean,'ymin',dt.loErr,'ymax',dt.upErr','color',dt.name,'group',dt.trigger,'row',dt.eff,'column',dt.side,'subset',subset_dt);
                Gsu5.geom_interval('geom','area');
                Gsu5.set_color_options('map',colors.color,'n_color',8,'n_lightness',1);
                Gsu5.set_order_options('color',colors.name);
                
                Gsu5.draw;
                
                
                ig_add_multiple_vertical_lines(dt.time(dt.ind & dt.trigger == 'cue' & dt.name == 'reach_left'), 'Color',colors.color(1,:),'LineStyle','-.','Parent',Gsu5.facet_axes_handles(1));
                ig_add_multiple_vertical_lines(dt.time(dt.ind & dt.trigger == 'cue' & dt.name == 'reach_right'),'Color',colors.color(2,:),'LineStyle','-.','Parent',Gsu5.facet_axes_handles(3));
                ig_add_multiple_vertical_lines(dt.time(dt.ind & dt.trigger == 'cue' & dt.name == 'sac_left'),   'Color',colors.color(3,:),'LineStyle','-.','Parent',Gsu5.facet_axes_handles(2));
                ig_add_multiple_vertical_lines(dt.time(dt.ind & dt.trigger == 'cue' & dt.name == 'sac_right'),  'Color',colors.color(4,:),'LineStyle','-.','Parent',Gsu5.facet_axes_handles(4));
                
                %% color subjects
                
                clear Gsu6
                figure ('Position', [100 100 1600 1000]);
                %figure;
                Gsu6 = gramm('x',dsu.time_shift,'y',dsu.mean,'color',dsu.subj,'group',dsu.trigger,'row',dsu.eff,'column',dsu.side,'subset',subset_dsu);
                Gsu6.geom_line();
                Gsu6.geom_line();
                Gsu6.geom_vline('xintercept',[0 9.2],'style','k-');
                Gsu6.geom_hline('yintercept',0,'style','k--');
                Gsu6.geom_hline('yintercept',0,'style','k--');
                %Gsu6.axe_property('Xlim',[-3 17],'Ylim',[min(dt.loErr) max(dt.upErr)]);
                Gsu6.axe_property('Ygrid','on','GridColor',[0.5 0.5 0.5],'XTick',[-2:2:16],'YTick',[floor(min(dsu.mean)):0.2:ceil(max(dsu.mean))]);
                Gsu6.geom_polygon('x',{[0 0.2]},'color',[0.5 0.5 0.5]);
                Gsu6.set_names('color','','column','','row','','x','time in seconds','y','PSC');
                Gsu6.set_title([subject_name '_' voi_name 'CHOI-INSTR_averaged_subj_color']);
                
                
                Gsu6.draw;
                
                %%
                if export == 1
                    
                    Gsu5.export('file_name',[subject_name '_' voi_name 'CHOI-INSTR_averaged_subj_grey'],...
                        'export_path', savepath,...
                        'file_type','pdf');
                    
                    Gsu6.export('file_name',[subject_name '_' voi_name 'CHOI-INSTR_averaged_subj_color'],...
                        'export_path', savepath,...
                        'file_type','pdf');    
                    
                end
                
            end %plot subjectwise
            
        elseif plot_delaywise == 1
            %% per delay plots 
            clear Gsu4
            figure ('Position', [0 0 1100 1000]);
            %figure;
            Gsu4 = gramm('x',dt.time,'y',dt.mean,'ymin',dt.loErr,'ymax',dt.upErr','color',dt.name,'column',dt.eff,'row',dt.delay,'subset',dt.time >= -2 & dt.trigger == 'cue');
            Gsu4.geom_interval('geom','area');
            Gsu4.axe_property('Xlim',[-2.5 15.2],'Ylim',[min(dt.loErr(dt.delay~='3' & dt.trigger=='cue')) max(dt.upErr(dt.delay~='3'& dt.trigger=='cue'))]);
            Gsu4.set_order_options('row',{'3','6','9','12','15'},'color',colors.name','column',{'sac' 'reach'});
            Gsu4.set_color_options('map',colors.color,'n_color',8,'n_lightness',1);
            Gsu4.set_names('color','','row','','column','','x','time in seconds','y','PSC');
            Gsu4.axe_property('Ygrid','on','GridColor',[0.5 0.5 0.5],'XTick',[-2:2:16],'YTick',[floor(min(dt.loErr)):0.1:ceil(max(dt.upErr))]);
            Gsu4.geom_polygon('x',{[0 0.2]},'color',[0.5 0.5 0.5]);
            
            Gsu4.geom_vline('xintercept',0,'style','k-');
            Gsu4.geom_hline('yintercept',0,'style','k--');
            Gsu4.set_title([subject_name '_' voi_name 'CHOI-INSTR_per_delay']);
            
            
            Gsu4.draw;
            
            y1 = min(dt.loErr(dt.delay~='3'));
            y2 = max(dt.upErr(dt.delay~='3')) - y1;
            
            % late periods
            rectangle('Position',[7, y1 1.5 y2],'FaceColor',[0.5,0.5,0.5,0.2],'EdgeColor',[1 1 1 0],'Parent',Gsu4.facet_axes_handles(3));
            rectangle('Position',[7, y1 1.5 y2],'FaceColor',[0.5,0.5,0.5,0.2],'EdgeColor',[1 1 1 0],'Parent',Gsu4.facet_axes_handles(8));

            rectangle('Position',[10, y1 1.5 y2],'FaceColor',[0.5,0.5,0.5,0.2],'EdgeColor',[1 1 1 0],'Parent',Gsu4.facet_axes_handles(4));
            rectangle('Position',[10, y1 1.5 y2],'FaceColor',[0.5,0.5,0.5,0.2],'EdgeColor',[1 1 1 0],'Parent',Gsu4.facet_axes_handles(9));

            rectangle('Position',[13, y1 1.5 y2],'FaceColor',[0.5,0.5,0.5,0.2],'EdgeColor',[1 1 1 0],'Parent',Gsu4.facet_axes_handles(5));
            rectangle('Position',[13, y1 1.5 y2],'FaceColor',[0.5,0.5,0.5,0.2],'EdgeColor',[1 1 1 0],'Parent',Gsu4.facet_axes_handles(10));

            for i = [3 8 4 9 5 10] % early periods           
                rectangle('Position',[4, y1 2.9 y2],'FaceColor',[0.5,0.5,0.5,0.2],'EdgeColor',[1 1 1 0],'Parent',Gsu4.facet_axes_handles(i));
            end
            
            height_hline = [-1.5 1.5];
           
            % move onsets
            line([3.2 3.2],[height_hline(1) height_hline(2)] ,'Color','k','Parent',Gsu4.facet_axes_handles(1));
            line([3.2 3.2],[height_hline(1) height_hline(2)] ,'Color','k','Parent',Gsu4.facet_axes_handles(6));
            
            line([6.2 6.2],[height_hline(1) height_hline(2)] ,'Color','k','Parent',Gsu4.facet_axes_handles(2));
            line([6.2 6.2],[height_hline(1) height_hline(2)] ,'Color','k','Parent',Gsu4.facet_axes_handles(7));
            
            line([9.2 9.2],[height_hline(1) height_hline(2)] ,'Color','k','Parent',Gsu4.facet_axes_handles(3));
            line([9.2 9.2],[height_hline(1) height_hline(2)] ,'Color','k','Parent',Gsu4.facet_axes_handles(8));
            
            line([12.2 12.2],[height_hline(1) height_hline(2)] ,'Color','k','Parent',Gsu4.facet_axes_handles(4));
            line([12.2 12.2],[height_hline(1) height_hline(2)] ,'Color','k','Parent',Gsu4.facet_axes_handles(9));
            
            line([15.2 15.2],[height_hline(1) height_hline(2)] ,'Color','k','Parent',Gsu4.facet_axes_handles(5));
            line([15.2 15.2],[height_hline(1) height_hline(2)] ,'Color','k','Parent',Gsu4.facet_axes_handles(10));
            
 
            %% move x axis for ALL move trials to align INDIVIDUAL DELAYS to movement onset
            dt_all = dt;
            dt.time_shift_2 = dt.time;
            dt.time_shift_2 (dt.trigger == 'mov') = dt.time_shift_2 (dt.trigger == 'mov') +15.2;
            dt(dt.time_shift_2 < 0 & dt.delay == '15' & dt.trigger == 'mov',:) = [];
            dt(dt.time_shift_2 < 3 & dt.delay == '12' & dt.trigger == 'mov',:) = [];
            dt(dt.time_shift_2 < 6 & dt.delay == '9'  & dt.trigger == 'mov',:) = [];

            %% NEW
    clear Gsu2
    figure ('Position', [100 100 1100 700]);
    Gsu2 = gramm('x',dt.time,'y',dt.mean,'ymin',dt.loErr,'ymax',dt.upErr','color',dt.name,'linestyle',dt.delay,'subset',dt.time >= -2 & dt.trigger == 'cue' & dt.delay ~= '3' & dt.delay ~= '6');
    Gsu2.geom_interval('geom','area');
    Gsu2.facet_wrap(dt.name,'ncols',2);

    %Gsu2.geom_line();
    Gsu2.axe_property('Xlim',[-3 16],'Ylim',[min(dt.loErr(dt.delay~='3' & dt.trigger=='cue')) max(dt.upErr(dt.delay~='3'& dt.trigger=='cue'))]);
    Gsu2.set_order_options('linestyle',{'15','12','9','6','3'});
    Gsu2.set_color_options('map',colors.color,'n_color',8,'n_lightness',1);
    Gsu2.set_names('color','','column','','row','','x','time/s','y','diff PSC','linestyle','');
    Gsu2.axe_property('Ygrid','on','GridColor',[0.5 0.5 0.5],'XTick',[-2:2:23],'YTick',[floor(min(dt.mean)-0.1):0.1:ceil(max(dt.mean)+0.1)]);
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
    %text(5.1,0.71,{'cue'},'Parent',Gsu2.facet_axes_handles(1),'Color','k','FontSize',11);

    %%
    % Movement triggered per delay
    clear Gsu3
    figure ('Position', [100 100 1100 700]);
    Gsu3 = gramm('x',dt.time_shift_2,'y',dt.mean,'ymin',dt.loErr,'ymax',dt.upErr','color',dt.name,'linestyle',dt.delay,'subset',dt.trigger == 'mov' & dt.delay ~= '3' & dt.delay ~= '6');
    Gsu3.geom_interval('geom','area');
    Gsu3.facet_wrap(dt.name,'ncols',2);
    %Gsu3.geom_line();
    Gsu3.axe_property('Xlim',[-1 16],'Ylim',[min(dt.mean(dt.delay ~= '3' & dt.delay ~= '6'))-0.1 max(dt.mean(dt.delay ~= '3' & dt.delay ~= '6'))+0.1]);
    Gsu3.set_order_options('linestyle',{'15','12','9','6','3'});
    Gsu3.set_color_options('map',colors.color,'n_color',8,'n_lightness',1);
    Gsu3.set_names('color','','column','','row','','x','time in seconds','y','PSC','linestyle','');
    Gsu3.axe_property('Ygrid','on','GridColor',[0.5 0.5 0.5],'XTick',[-2:2:23],'YTick',[floor(min(dt.mean)-0.2):0.1:ceil(max(dt.mean)+0.2)]);
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
    %text(12.9,0.71,{'mov'},'Parent',Gsu3.facet_axes_handles(1),'Color','k','FontSize',11);
         
            
            
           
            
            %% cue and movement aligned per dela
            only_long_del = dt.delay == '9' | dt.delay == '12' | dt.delay == '15' ;
            clear Gsu5
            figure ('Position', [100 100 1200 800]);
            %figure;
            Gsu5 = gramm('x',dt.time_shift,'y',dt.mean,'ymin',dt.loErr,'ymax',dt.upErr','color',dt.name,'column',dt.side,'row',dt.eff,'lightness',dt.delay,'subset',dt.time_shift >= -2 & dt.time_shift <= 7.2 & dt.trigger == 'cue' & only_long_del);
            Gsu5.geom_interval('geom','area');
            %Gsu5.geom_line();
            Gsu5.axe_property('Xlim',[-2.5 10.5],'Ylim',[(-0.1 + min(dt.loErr(only_long_del & dt.time_shift >= -2 & dt.time_shift <= 10.5))), (0.1 + max(dt.upErr(only_long_del & dt.time_shift >= -2 & dt.time_shift <= 10.5)))]);
            Gsu5.axe_property('Ygrid','on','GridColor',[0.5 0.5 0.5],'XTick',[-2:2:16],'YTick',[floor(min(dt.loErr))-0.1:0.2:ceil(max(dt.upErr))+0.1]);
            Gsu5.set_order_options('lightness',{'9','12','15'});


            %Gsu5.set_order_options('row',{'3','6','9','12','15'},'color',colors.name,'column',{'sac' 'reach'});
            %Gsu5.set_color_options('map',colors.color,'n_color',8,'n_lightness',1);
            Gsu5.set_names('color','','column','','row','','x','time in seconds','y','PSC','lightness','');
            Gsu5.geom_vline('xintercept',[0 9.2],'style','k-');
            Gsu5.geom_hline('yintercept',0,'style','k:');
            %Gsu5.geom_vline('xintercept',[4 7.1 7.3 8.5],'style','k--');
            Gsu5.set_title([subject_name '_' voi_name '_long_delays']);
            
            Gsu5.update('x',dt.time_shift,'y',dt.mean,'color',dt.name,'column',dt.side,'row',dt.eff,'lightness',dt.delay,'subset',dt.time_shift > 7.2  & dt.time_shift <= 10  & dt.trigger == 'mov' & only_long_del);
            Gsu5.geom_interval('geom','area');
            %Gsu5.geom_line();
            Gsu5.set_layout_options('legend',false);
            Gsu5.geom_vline('xintercept',[0 9.2],'style','k-');
            Gsu5.geom_hline('yintercept',0,'style','k:');
            %Gsu5.geom_polygon('x',{[0 0.2]},'color',[0.5 0.5 0.5]);
            Gsu5.geom_polygon('x',{[4 6.9]},'alpha',0.15,'color',[0.5 0.5 0.5]);
            Gsu5.geom_polygon('x',{[7 8.5]},'alpha',0.15,'color',[0.5 0.5 0.5]);

            Gsu5.draw;                
  
%%            
            
            if export == 1
                
                Gsu4.export('file_name',[subject_name '_' voi_name 'CHOI-INSTR_per_delay'],...
                    'export_path', savepath,...
                    'file_type','pdf');
                
                Gsu2.export('file_name',[subject_name '_' voi_name 'CHOI-INSTR_per_delay_align_cue'],...
                    'export_path', savepath,...
                    'file_type','pdf');
                
                Gsu3.export('file_name',[subject_name '_' voi_name 'CHOI-INSTR_per_delay_align_mov'],...
                    'export_path', savepath,...
                    'file_type','pdf');
                
                Gsu5.export('file_name',[subject_name '_' voi_name 'CHOI-INSTR_per_delay_area_longDel'],...
                    'export_path', savepath,...
                    'file_type','pdf');
            end
            
            
            
            
        
        end
        %%
        %disp('stop here')
        
        
        %%
        close all;
        
        dt = table();
        
        
        if plot_subjectwise
            dsu = table();
        end
    end
end

