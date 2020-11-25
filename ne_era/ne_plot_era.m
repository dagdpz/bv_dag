function [era, anova, settings, compare] = ne_plot_era(voipath,avgpath,mdmpath,era_settings_id,save_figure,varargin)
% [era, anova, settings] = ne_plot_era(voipath,avgpath,mdmpath,era_settings_id,{'.png','.ai'},'plot_graphics','tc');
% mat_anova = 'D:\MRI\Curius\combined\microstim_20140122-20140226_5_3_250uA_nobaseline\11pred\era_anova\era_anova_memory.mat';

opengl software % http://www.mathworks.com/matlabcentral/answers/101588
ini_dir = pwd;

% default parameters, for dynamic params (i.e. those params might change from session to session, even for same dataset)
defpar = { ...
        'plot_graphics', 'char', '', 'tc'; ... % '' | 'tc' | 'bars' | 'both'
        'open_figure', 'double', 'nonempty', 1; ...
        'save_figure', 'char',   '', ''; ... % '.png' | '.pdf' | '.ai' | '.eps'
        'mat_anova', 'char', '', '';... % era_anova.mat containing a structure (era_anova) with all outputs from ne_era_new.m
        };

if nargin > 5, % specified dynamic params
        params = checkstruct(struct(varargin{:}), defpar);
elseif nargin == 5, % struct is specified
        params = varargin{1};
else
        params = checkstruct(struct, defpar); % take all default params
end

run('ne_era_settings');

%% load AVG with plotting parameters
avg = xff(avgpath);
settings.ResolutionOfDataPoints	= avg.ResolutionOfDataPoints;
settings.NrOfTimePoints		= avg.NrOfTimePoints;
settings.PreInterval		= avg.PreInterval;
settings.PostInterval		= avg.PostInterval;
settings.NrOfCurves		= avg.NrOfCurves;
settings.NrOfFiles		= avg.NrOfFiles;
settings.AverageBaselineFrom	= avg.AverageBaselineFrom;
settings.AverageBaselineTo	= avg.AverageBaselineTo;
settings.BaselineMode		= avg.BaselineMode;
temp				= avg.Curve;
settings.NrOfConditionEvents	= [temp.NrOfConditionEvents];
settings.CurveName = {temp.Name};
colors_curves = [temp.TimeCourseColor1];
settings.TimeCourseColorR = colors_curves(1:3:end);
settings.TimeCourseColorG = colors_curves(2:3:end);
settings.TimeCourseColorB = colors_curves(3:3:end);
colors_stderr = [temp.StdErrColor]; % note: field name might change if you use standard deviation instead of standard error
settings.StdDevErrColorR = colors_stderr(1:3:end);
settings.StdDevErrColorG = colors_stderr(2:3:end);
settings.StdDevErrColorB = colors_stderr(3:3:end);
settings.TimeCourseThick = [temp.TimeCourseThick];
settings.StdDevErrThick = [temp.StdErrThick]; % note: field name might change if you use standard deviation instead of standard error

%% get time course data and mean response amplitudes

if isempty(params.mat_anova)
    [era, anova, timeaxis, params_era] = ne_era_new(voipath,avgpath,mdmpath,era_settings_id);   
else load(params.mat_anova)
    era = era_anova.era;
    timeaxis = era_anova.timeaxis;
    params_era = era_anova.params_era;
    anova = era_anova.anova;
end

settings.params_era = params_era;

data1 = era.mean; %NrOfVOIs X NrOfCurves X NrOfTimePoints
data2 = era.se;

data1_ra = []; data2_ra = [];
for v = 1:size(era.RA,1)
    ra1_voi = [era.RA(v,:).ra_mean];
    data1_ra = [data1_ra; ra1_voi];
    ra2_voi = [era.RA(v,:).ra_se];
    data2_ra = [data2_ra; ra2_voi];
end

if ~isempty(settings.select_curves), % select subset of curves
    data1 = data1(:,settings.select_curves,:);
    data2 = data2(:,settings.select_curves,:);
    settings.CurveName = settings.CurveName(settings.select_curves);
    settings.NrOfCurves = length(settings.select_curves);
    settings.TimeCourseColorR = settings.TimeCourseColorR(settings.select_curves);
    settings.TimeCourseColorG = settings.TimeCourseColorG(settings.select_curves);
    settings.TimeCourseColorB = settings.TimeCourseColorB(settings.select_curves);
    settings.StdDevErrColorR = settings.StdDevErrColorR(settings.select_curves);
    settings.StdDevErrColorG = settings.StdDevErrColorG(settings.select_curves);
    settings.StdDevErrColorB = settings.StdDevErrColorB(settings.select_curves);
    settings.TimeCourseThick = settings.TimeCourseThick(settings.select_curves);
    settings.StdDevErrThick = settings.StdDevErrThick(settings.select_curves);
end

if settings.arbitrary_shift ~= 0,
    data1 = data1 + settings.arbitrary_shift;
end

if ~isempty(settings.normalize_bins),
    max_change = max(max(data1(:,:,settings.normalize_bins))); % for normalization
else
    max_change = 1;
end

% loop through all VOIs
for v = 1:size(data1,1)
    %% simple t tests
    % comparison of conditions for each time point of time course as specified in settings.plot_diff
    if ~isempty(settings.plot_diff)
        tstat(v).n_trials = settings.NrOfConditionEvents;
        tstat(v).timeaxis = timeaxis;

        tstat(v).ttest_h = zeros(length(timeaxis),settings.NrOfCurves);
        tstat(v).ttest_p = zeros(length(timeaxis),settings.NrOfCurves);
        for d=1:size(settings.plot_diff,1)
            for t = 1:settings.NrOfTimePoints             
                [h,p,ci,stats] = ttest2(era.psc(v,settings.plot_diff{d,1}).perievents(t,:), era.psc(v,settings.plot_diff{d,2}).perievents(t,:));                                               
                ttest_h(t,:) = h;
                ttest_p(t,:) = p;
                ttest_ci(t,:) = ci;
                ttest_t(t,:) = stats;
            end
            tstat(v).ttest_h(:,settings.plot_diff{d,1}) = ttest_h;
            tstat(v).ttest_p(:,settings.plot_diff{d,1}) = ttest_p;
            tstat(v).ttest_ci(1:settings.NrOfTimePoints,1:size(ttest_ci,2),settings.plot_diff{d,1}) = ttest_ci; % NrOfTimePoints X 2 (lower and upper end of CI) X Number of differences
            tstat(v).ttest_t(:,settings.plot_diff{d,1}) = ttest_t;
        end
    end
      
    % post-hoc comparisons for ANOVA
    
%     basedir = fileparts(voipath);
%     if isempty(strfind(basedir, '_rest_'))

    if size(era.n_trials,2) > 2 % only if there are more than two conditions 
        [comparisons,means] = multcompare(anova(v).stats, 'Dimension',1:numel(anova(v).stats.nlevels),'CType','lsd', 'Alpha', settings.alpha_post_hoc_t, 'Display','off');
        compare(v).comparisons = comparisons;
        compare(v).means = means;
    else
        comparisons = [];
        compare = [];
    end
    
    if isempty(params.plot_graphics), return; end
    
    %% plotting
    
    if ~isempty(settings.plot_diff), % plot difference between (some) curves
        for d=1:size(settings.plot_diff,1)
            D(d,:) = data1(v,settings.plot_diff{d,1},:) - data1(v,settings.plot_diff{d,2},:);
            c(1,d) = settings.plot_diff{d,1};
        end
        settings.errorbars_type = 0; % cannot plot error for difference
        data1(v,c(1,:),:) = D;
        settings.NrOfCurves = size(settings.plot_diff,1);
        
    else
        c(1,:) = 1:settings.NrOfCurves;
    end
    
    
    hf = [];
    
    % plot time courses
    if (strcmp(params.plot_graphics,'tc') || strcmp(params.plot_graphics,'both')),
        
        if params.open_figure
            hf_tc = figure('Color','w','Name',era.voi(v).Name);
            hf = [hf hf_tc];
        end
        
        settings.marked_intervals = [0 settings.MarkedIntervals];
        
        N_subplots_h = 1;
        N_subplots_v = 1;
        
        
        if isempty(settings.errorbar_rgb),
            for i = 1:settings.NrOfCurves
                settings.errorbar_rgb = [settings.errorbar_rgb; [settings.TimeCourseColorR(c(1,i))/255 settings.TimeCourseColorG(c(1,i))/255 settings.TimeCourseColorB(c(1,i))/255]];
            end
        end
        
        for k = 1:N_subplots_h*1,
            if N_subplots_h*N_subplots_v > 1,
                subplot(N_subplots_v,N_subplots_h,k);
            end
            
            r = ceil(k/N_subplots_h); % row
            
            
            for i = c(k,:),
                if settings.errorbars_type,
                    if settings.errorbars_type == 1 % patch
                        % patch([2.8 2.8 4.45 4.45], [0 3.05 3.05 0], -eps*ones(1,4), [1 .9 .9])
                        patch([timeaxis fliplr(timeaxis)],[(squeeze(data1(v,i,:))+squeeze(data2(v,i,:)))' fliplr((squeeze(data1(v,i,:))-squeeze(data2(v,i,:)))')],-eps*ones(1,2*length(timeaxis)),'r','EdgeColor','none','FaceColor',settings.errorbar_rgb(i,:),'FaceAlpha',settings.error_patch_FaceAlpha); hold on;
                    elseif settings.errorbars_type == 2, % line
                        line([timeaxis fliplr(timeaxis)],[(squeeze(data1(v,i,:))+squeeze(data2(v,i,:)))' fliplr((squeeze(data1(v,i,:))-squeeze(data2(v,i,:)))')],'Color',settings.errorbar_rgb(i,:),'LineWidth',settings.StdDevErrThick(i)/2,'LineStyle','--'); hold on;
                    elseif settings.errorbars_type == 3, % errorbar
                        he = errorbar(timeaxis,squeeze(data1(v,i,:)),squeeze(data2(v,i,:))); hold on;
                        set(he,'Color',settings.errorbar_rgb(i,:),'LineWidth',settings.StdDevErrThick(i));
                    end
                end
                
            end
            
            offset_star = 0;
            for i = c(k,:),
                
                plot(timeaxis,squeeze(data1(v,i,:)),'Color',[settings.TimeCourseColorR(i) settings.TimeCourseColorG(i) settings.TimeCourseColorB(i)]/255,'LineWidth',settings.TimeCourseThick(i)/1.5);
                
                if settings.plot_symbols;
                    hold on; plot(timeaxis,squeeze(data1(v,i,:)),'o','MarkerSize',6,'MarkerFaceColor',[settings.TimeCourseColorR(i) settings.TimeCourseColorG(i) settings.TimeCourseColorB(i)]/255,'MarkerEdgeColor',[settings.TimeCourseColorR(i) settings.TimeCourseColorG(i) settings.TimeCourseColorB(i)]/255,'LineWidth',settings.TimeCourseThick(i)/1.5);
                    
                end
                %                 if settings.plot_diff && i==c(k,end),
                %                         cla;
                %                         hold on; plot(timeaxis,D);
                %                 end
                
                hold on;
                line([timeaxis(1) timeaxis(end)],[0 0],'Color',[0 0 0],'LineStyle','--');
                
                % plot significance
                if ~isempty(settings.plot_diff) && settings.plot_significance
                    offset_star = offset_star+0.04;
                    t_x = timeaxis(tstat(v).ttest_h(:,i) == 1);
                    t_x = t_x(t_x >= settings.plot_significance_period(1) & t_x <= settings.plot_significance_period(end));
                    t_y = ones(length(t_x),1)*(settings.Ylim(2)-0.2);
                    hold on;
                    text(t_x,t_y+offset_star,'*', 'Color', [settings.TimeCourseColorR(i) settings.TimeCourseColorG(i) settings.TimeCourseColorB(i)]/255, 'FontSize', settings.font_size_text);
                end
                
            end
            
            if settings.do_stats % stat. analysis
                do_tc_stats(out,name1);
            end
            
            % title(sprintf('%s',subtitle{k}),'Interpreter','none');
            
            set(gca,'Xlim',[min(timeaxis)-settings.offset_xaxis max(timeaxis)+settings.offset_xaxis],'YTick', settings.Ytick, 'box','off');
            % legend('Fix', 'Fix-Stim', 'SaccR', 'SaccR-Stim', 'MemL', 'MemL-Stim')
            % legend boxoff
            
            
        end
        
        ha = get(gcf,'Children');
        set(ha,'Layer','top','TickDir','out');
        
        set_axes_equal_lim(ha,'Ylim');
        if ~isempty(settings.Ylim)
            set_all_axes('Ylim',settings.Ylim);
        end
        
        for k = 1:N_subplots_h*N_subplots_v,
            set(gcf,'CurrentAxes',ha(k));
            
            ylim = get(gca,'Ylim');
            for ii = 1:length(settings.marked_intervals);
                line([settings.marked_intervals(ii) settings.marked_intervals(ii)],[ylim(1) ylim(2)],'Color',[  0.5   0.5   0.5]);
            end
            
            if settings.plot_baseline,
                line([settings.AverageBaselineFrom settings.AverageBaselineTo],[ylim(1) ylim(1)],'Color',[0.7 0.7 0.7],'LineWidth',10);
            end
            
            if settings.plot_ra_bins
                %                         line([settings.ra_bins(1) settings.ra_bins(end)]-settings.PreInterval,[ylim(1) ylim(1)],'Color',[1 0.5 0.5],'LineWidth',10);
                %                         line([settings.ra_bins_sec(1) settings.ra_bins_sec(end)],[ylim(1) ylim(1)],'Color',[0.4 0.4 0.4],'LineWidth',10);
                line([3 6.5],[ylim(1) ylim(1)],'Color',[0.6 0.6 0.6],'LineWidth',10);
                line([6.5 10],[ylim(1) ylim(1)],'Color',[0 0 0],'LineWidth',10);
            end
            
        end
        
        if exist('hpatch'),
            ylim = get(gca,'Ylim');
            set(hpatch,'Ydata',[ylim(1) ylim(2) ylim(2) ylim(1)]);
        end
        
        if N_subplots_h*N_subplots_v > 1
            mlabel(settings.xlabel,settings.ylabel,era.voi(v).Name,'Interpreter','none','HorizontalAlignment','left');
        else
            xlabel(settings.xlabel,'Interpreter','none','HorizontalAlignment','center');
            ylabel(settings.ylabel,'Interpreter','none','HorizontalAlignment','center');
            htitle = get(gca,'title');
            title({era.voi(v).Name},'Interpreter','none','HorizontalAlignment','center');
            % title({era.voi(v).Name sprintf('\t') get(htitle,'string')},'Interpreter','none','HorizontalAlignment','center');
        end      
        hold off           
    end
    
    % plot bars
    if strcmp(params.plot_graphics,'bars') || strcmp(params.plot_graphics,'both'),
        if ~isempty(settings.xticklabel)
            xticklabel = settings.xticklabel;
        else xticklabel = settings.CurveName;
        end
        
        if params.open_figure
            hf_bar = figure('Color','w','Name',[era.voi(v).Name '_bars'],'PaperPositionMode','auto');
            hf = [hf hf_bar];
        end
        
        for i = 1:settings.NrOfCurves
            color_map(i,:) =  [settings.TimeCourseColorR(i) settings.TimeCourseColorG(i) settings.TimeCourseColorB(i)]/255;
            h = bar(i,data1_ra(v,i)); hold on;
            set(h,'Facecolor',color_map(i,:));
        end
        errorbar([1:settings.NrOfCurves],data1_ra(v,:),data2_ra(v,:),'.','Marker','none','Color',[0 0 0]);
        set(gca,'Xlim',[0 settings.NrOfCurves+1],'XTick',[1:settings.NrOfCurves],'Ylim',settings.Ylim,'YTick', settings.Ytick,'TickDir','out','XTickLabel',xticklabel,'box','off');
        ylabel(['Mean ' settings.ylabel],'Interpreter','none','HorizontalAlignment','center');
        title([{era.voi(v).Name} ' - RA bins_sec: ' num2str(settings.ra_bins_sec)],'Interpreter','none','HorizontalAlignment','center');
        
        % add ANOVA data
        offset_text = 0;
        ylim = get(gca,'Ylim');
        for e = 1:length(anova(v).p) % number of main/interaction effects
         text(0.5,ylim(2)-(0.1+offset_text),sprintf('F(%s)=%0.3f, p=%0.4f', anova(v).table{1+e,1},anova(v).table{1+e,6},anova(v).table{1+e,7}),'FontSize',8)
         offset_text = offset_text+0.1;
        end
        text(0.5,ylim(2)-(0.1+offset_text),sprintf('alpha_t = %e',settings.alpha_post_hoc_t),'FontSize',8)
                
        condition_numbers = settings.condition_numbers; % numbering of conditions is different in barplot and post-hoc comparisons     
        if ~isempty(comparisons)
            offset_line = 0;
            for comp = 1:size(comparisons,1)
                if comparisons(comp,6) <= settings.alpha_post_hoc_t
                    idx_max = find(means(comparisons(comp,1:2),1) == max(means(comparisons(comp,1:2),1)));
                    idx_max = comparisons(comp, idx_max);
                    x_line = condition_numbers(comparisons(comp,1:2));
                    line(x_line, repmat([means(idx_max,1) + means(idx_max,2) + offset_line+ 0.01],1,2), 'Color', 'k')
                    text(sum(x_line)/2, means(idx_max,1) + means(idx_max,2) + offset_line + 0.02, '*')
                    offset_line = offset_line + 0.05;
                end
            end
        end
        hold off
    end
    
    %% save figure
    if ~isempty(save_figure) && params.open_figure       
        
        
        for f = 1:length(hf),
            add_name = '';
            if strfind(get(hf(f),'Name'),'bars'),
                add_name = ['_bars' settings.name_appendix];
            end
            
            if ~isempty(settings.plot_diff)
                add_name = [add_name '_diff'];
            end
            
            ax = get(hf(f),'Children');
            % set(ax,'FontSize',8,'FontName','Arial');
            set(ax,'FontSize',16,'FontName','Arial');
            
            for k = 1:length(ax),
                tx = [get(ax(k),'xlabel'); get(ax(k),'ylabel'); get(ax(k),'title');];
                % set(tx,'FontSize',8,'FontName','Arial');
                set(tx,'FontSize',16,'FontName','Arial');
            end
            
            % set(gcf,'PaperPositionMode','auto','Position',[100 100 800 300]);
            % set(gcf,'PaperPositionMode','auto','Position',[100 100 420 350]);
            set(hf(f),'PaperPositionMode','auto');
            
            for form = 1:length(save_figure)
                
                newdir = [fileparts(avgpath) filesep 'figures_' save_figure{form}(2:end) '_NE'];
                if ~exist(newdir,'dir')
                    [~,mess,~] = mkdir(newdir);
                    disp([newdir ' created']);
                end
                
                switch save_figure{form}
                    case '.png'
                        print(hf(f),'-dpng','-r0',[newdir filesep era.voi(v).Name add_name '.png']);
                    case '.pdf'
                        saveas(hf(f),[newdir filesep era.voi(v).Name add_name '.pdf'],'pdf');
                    case '.ai'
                        set(hf(f),'Renderer','Painters');
                        print(hf(f),'-depsc',[newdir filesep era.voi(v).Name add_name '.ai']);
                    case '.eps'
                        set(hf(f),'Renderer','Painters');
                        print(hf(f),'-dpsc2',[newdir filesep era.voi(v).Name add_name '.eps']);
                end
                
                disp(['Saved ' newdir filesep era.voi(v).Name add_name save_figure{form}]);
                
            end
        end
    end
end % for each VOI

cd(ini_dir);

