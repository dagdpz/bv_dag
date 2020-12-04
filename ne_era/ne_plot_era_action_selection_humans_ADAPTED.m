function [era, anova, settings, compare] = ne_plot_era_action_selection_humans_ADAPTED(voipath,avgpath,mdmpath,era_settings_id,save_figure,varargin)
% [era, anova, settings] = ne_plot_era(voipath,avgpath,mdmpath,era_settings_id,{'.png','.ai'},'plot_graphics','tc');
% mat_anova = 'D:\MRI\Curius\combined\microstim_20140122-20140226_5_3_250uA_nobaseline\11pred\era_anova\era_anova_memory.mat';

opengl software % http://www.mathworks.com/matlabcentral/answers/101588
ini_dir = pwd;

% default parameters, for dynamic params (i.e. those params might change from session to session, even for same dataset)
defpar = { ...
    'plot_graphics', 'char', '', 'tc'; ... % '' | 'tc' | 'bars' | 'both'
    'open_figure', 'double', 'nonempty', 1; ...
    % 'save_figure', 'char',   '', ''; ... % '.png' | '.pdf' | '.ai' | '.eps' % implemented as save_figure input
    'load_mat', 'char', '', ''; ... % load era_anova.mat containing a structure (era_anova) with all outputs from ne_era_mdm.m
    'save_mat', 'char', '', ''; ... % save era_anova.mat containing a structure (era_anova) with all outputs from ne_era_mdm.m
    % 'do_anova','double', 'nonempty', 0; ...
    %'plot_summary','double','nonempty', 0; ...
    };

if nargin > 6, % specified dynamic params
    params = checkstruct(struct(varargin{:}), defpar);
elseif nargin == 6, % struct is specified
    params = varargin{1};
else
    params = checkstruct(struct, defpar); % take all default params
end

run('ne_era_settings');

%% load AVG with plotting parameters
avg = xff(avgpath);
settings.ResolutionOfDataPoints	= avg.ResolutionOfDataPoints;
settings.NrOfTimePoints		    = avg.NrOfTimePoints;
settings.PreInterval            = avg.PreInterval;
settings.PostInterval           = avg.PostInterval;
settings.NrOfCurves             = avg.NrOfCurves;
settings.NrOfFiles              = avg.NrOfFiles;
settings.AverageBaselineFrom	= avg.AverageBaselineFrom;
settings.AverageBaselineTo      = avg.AverageBaselineTo;
settings.BaselineMode           = avg.BaselineMode;
temp                            = avg.Curve;
settings.NrOfConditionEvents	= [temp.NrOfConditionEvents];
settings.CurveName              = {temp.Name};
colors_curves                   = [temp.TimeCourseColor1];
settings.TimeCourseColorR = colors_curves(1:3:end);
settings.TimeCourseColorG = colors_curves(2:3:end);
settings.TimeCourseColorB = colors_curves(3:3:end);
colors_stderr            = [temp.StdErrColor]; % note: field name might change if you use standard deviation instead of standard error
settings.StdDevErrColorR = colors_stderr(1:3:end);
settings.StdDevErrColorG = colors_stderr(2:3:end);
settings.StdDevErrColorB = colors_stderr(3:3:end);
settings.TimeCourseThick = [temp.TimeCourseThick];
settings.StdDevErrThick = [temp.StdErrThick]; % note: field name might change if you use standard deviation instead of standard error

%% get time course data and mean response amplitudes

if isempty(params.load_mat)
    era = ne_era_mdm(voipath,avgpath,mdmpath,era_settings_id);
    if ~isempty(params.save_mat),
        save(params.save_mat,'era');
        disp(['saved era to ' params.save_mat]);
    end
else 
    load(params.load_mat);
    disp(['loaded era from ' params.load_mat]);
    settings.ra_bins_sec = era.params.ra_bins_sec;
end


% data_anova_2take = [];
% if params.do_anova,
%     %% ANOVA
%     if ~isempty(settings.assignment)
%         varnames = settings.varnames;
%         levnames = settings.levnames;
%         
%         data_anova = struct2cell(era.RA);
%         data_anova = squeeze(data_anova(1,:,:));
%         
%         if isfield(settings,'conditions2take'),
%             % settings.assignment = settings.assignment(settings.conditions2take,:);
%             data_anova_2take = data_anova(:,settings.conditions2take);
%         else
%             data_anova_2take = data_anova;
%         end
%         
%         for v = 1:size(era.RA,1)
%             anova(v) = nway_anova(data_anova_2take(v,:), settings.assignment, varnames, levnames);
%         end
%     else anova = [];
%     end
%     
% end

timeaxis = era.timeaxis;
settings.params_era = era.params;

data1 = era.mean; %NrOfVOIs X NrOfCurves X NrOfTimePoints
data2 = era.se;

data1_ra = []; 
data2_ra = [];
for v = 1:size(era.RA,1)
    ra1_voi = [era.RA(v,:).ra_mean];
    data1_ra = [data1_ra; ra1_voi]; % mean for each VOI
    ra2_voi = [era.RA(v,:).ra_se];
    data2_ra = [data2_ra; ra2_voi]; % se for each VOI
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
%     if ~isempty(settings.plot_diff)
%         tstat(v).n_trials = settings.NrOfConditionEvents;
%         tstat(v).timeaxis = timeaxis;
%         
%         tstat(v).ttest_h = zeros(length(timeaxis),settings.NrOfCurves);
%         tstat(v).ttest_p = zeros(length(timeaxis),settings.NrOfCurves);
%         for d=1:size(settings.plot_diff,1)
%             for t = 1:settings.NrOfTimePoints
%                 % [h,p,ci,stats] = ttest2(era.psc(v,settings.plot_diff{d,1}).perievents(t,:), era.psc(v,settings.plot_diff{d,2}).perievents(t,:));
%                 
%                 comparing_cond1 = [];
%                 comparing_cond2 = [];
%                 
%                 for i = 1:length([settings.plot_diff{d}{1}{:}]),
%                     comparing_cond1 = [comparing_cond1 era.psc(v,settings.plot_diff{d}{1}{i}).perievents(t,:)];
%                 end
%                 for i = 1:length([settings.plot_diff{d}{2}{:}]),
%                     comparing_cond2 = [comparing_cond2 era.psc(v,settings.plot_diff{d}{2}{i}).perievents(t,:)];
%                 end
%                 
%                 [h,p,ci,stats] = ttest2(comparing_cond1, comparing_cond2);
%                 ttest_h(t,:) = h;
%                 ttest_p(t,:) = p;
%                 ttest_ci(t,:) = ci;
%                 ttest_t(t,:) = stats;
%             end
%             tstat(v).ttest_h(:,settings.plot_diff{d}{1}{1}) = ttest_h;
%             tstat(v).ttest_p(:,settings.plot_diff{d}{1}{1}) = ttest_p;
%             tstat(v).ttest_ci(1:settings.NrOfTimePoints,1:size(ttest_ci,2),settings.plot_diff{d}{1}{1}) = ttest_ci; % NrOfTimePoints X 2 (lower and upper end of CI) X Number of differences
%             tstat(v).ttest_t(:,settings.plot_diff{d}{1}{1}) = ttest_t;
%         end
%     end
    
    % post-hoc comparisons for ANOVA
    
    %     basedir = fileparts(voipath);
    %     if isempty(strfind(basedir, '_rest_'))
    
    if size(data_anova_2take,2) > 1 && ~isempty(anova) % only if there are more than two conditions
        [comparisons,means,hh,names] = multcompare(anova(v).stats, 'Dimension',1:numel(anova(v).stats.nlevels),'CType','lsd', 'Alpha', settings.alpha_post_hoc_t, 'Display','off');
        
        if 1 % for older MATLAB versions (< ...), multcompare returns 5 columns, 6 column - p-value - is missing
            % replace by ttest2
            condition_numbers = settings.condition_numbers;
            for i = 1:size(comparisons,1),
                [h,p] = ttest2( data_anova{v,condition_numbers(comparisons(i,1))}, data_anova{v,condition_numbers(comparisons(i,2))} );
                comparisons(i,6) = p;
            end
        end
        compare(v).comparisons = comparisons;
        compare(v).means = means;
    else
        comparisons = [];
        compare = [];
    end
    
    if ~isempty(params.plot_graphics)
        %% plotting
        
        if ~isempty(settings.plot_diff), % plot difference between (some) curves, or sums of some curves
            for d=1:size(settings.plot_diff,1)
                D(d,:) = sum( data1(v,[settings.plot_diff{d}{1}{:}],:), 2) - sum( data1(v,[settings.plot_diff{d}{2}{:}],:), 2);
                c(1,d) = settings.plot_diff{d}{1}{1};
                
                if isfield(settings,'plot_diff_color'), % replace avg colors with custom colors
                    dummy = num2cell(settings.plot_diff_color(d,:)*255);
                    [settings.TimeCourseColorR(c(1,d)) settings.TimeCourseColorG(c(1,d)) settings.TimeCourseColorB(c(1,d))] = dummy{:};
                end
                
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
                    
                    %plot(timeaxis,squeeze(data1(i,:)),'Color',[settings.TimeCourseColorR(i) settings.TimeCourseColorG(i) settings.TimeCourseColorB(i)]/255,'LineWidth',settings.TimeCourseThick(i)/1.5);
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
            
            ig_set_axes_equal_lim(ha,'Ylim');
            if ~isempty(settings.Ylim)
                set_all_axes('Ylim',settings.Ylim);
            end
            
            for k = 1:N_subplots_h*N_subplots_v,
                set(gcf,'CurrentAxes',ha(k));
                
                ylim = get(gca,'Ylim');
                for ii = 1:length(settings.marked_intervals);
                    line([settings.marked_intervals(ii) settings.marked_intervals(ii)],[ylim(1) ylim(2)],'Color',[0.5   0.5   0.5]);
                end
                
                if settings.plot_baseline,
                    line([settings.AverageBaselineFrom settings.AverageBaselineTo],[ylim(1) ylim(1)],'Color',[0.7 0.7 0.7],'LineWidth',10);
                end
                
                if settings.plot_ra_bins
                    line([settings.ra_bins_sec(1) settings.ra_bins_sec(end)],[ylim(1) ylim(1)],'Color',[0.4 0.4 0.4],'LineWidth',10);
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
            else
                xticklabel = settings.CurveName;
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
            if ~isempty(settings.Ylim),
                set(gca,'Xlim',[0 settings.NrOfCurves+1],'XTick',[1:settings.NrOfCurves],'Ylim',settings.Ylim,'YTick', settings.Ytick,'TickDir','out','XTickLabel',xticklabel,'box','off');
            else
                set(gca,'Xlim',[0 settings.NrOfCurves+1],'XTick',[1:settings.NrOfCurves],'TickDir','out','XTickLabel',xticklabel,'box','off');
            end
            
            ylabel(['Mean ' settings.ylabel],'Interpreter','none','HorizontalAlignment','center');
            title([{era.voi(v).Name} ' - RA bins_sec: ' num2str(settings.ra_bins_sec)],'Interpreter','none','HorizontalAlignment','center');
            
            if ~isempty(params.load_mat)
                % add ANOVA data
                offset_text = 0;
                ylim = get(gca,'Ylim');
                for e = 1:length(anova(v).p) % number of main/interaction effects
                    text(0.5,ylim(2)-((ylim(2)-ylim(1))/10+offset_text),sprintf('F(%s)=%0.3f, p=%0.4f', anova(v).table{1+e,1},anova(v).table{1+e,6},anova(v).table{1+e,7}),'FontSize',8)
                    offset_text = offset_text+(ylim(2)-ylim(1))/10;
                end
                text(0.5,ylim(2)-((ylim(2)-ylim(1))/10+offset_text),sprintf('alpha_t = %e',settings.alpha_post_hoc_t),'FontSize',8)
                
                condition_numbers = settings.condition_numbers; % numbering of conditions is different in barplot and post-hoc comparisons
                if ~isempty(comparisons)
                    offset_line = 0;
                    for comp = 1:size(comparisons,1)
                        if comparisons(comp,6) <= settings.alpha_post_hoc_t
                            idx_max = find(means(comparisons(comp,1:2),1) == max(means(comparisons(comp,1:2),1)));
                            idx_max = comparisons(comp, idx_max);
                            x_line = condition_numbers(comparisons(comp,1:2));
                            line(x_line, repmat([means(idx_max,1) + means(idx_max,2) + offset_line+ 0.01],1,2), 'Color', 'k')
                            text(sum(x_line)/2, means(idx_max,1) + means(idx_max,2) + offset_line + 0.02, '*','FontSize',settings.font_size_text)
                            offset_line = offset_line + 0.05;
                        end
                    end
                end
                hold off
            else
                anova = [];
            end
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
                
                if isfield(settings,'font_size_axes'),
                    fsa = settings.font_size_axes;
                else
                    fsa = 14;
                end
                
                set(ax,'FontSize',fsa,'FontName','Arial');
                
                for k = 1:length(ax),
                    tx = [get(ax(k),'xlabel'); get(ax(k),'ylabel'); get(ax(k),'title');];
                    % set(tx,'FontSize',8,'FontName','Arial');
                    set(tx,'FontSize',fsa,'FontName','Arial');
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
    end % of if plotting
    
end % for each VOI

if params.plot_summary
    
    left_hemi_pattern = 'LH_';
    
    Area = {era.voi.Name}';
    
    for v = 1:size(data_anova,1)
        
        RH_a(v,:) = [NaN NaN NaN]; RH_p(v,:) = [1 1 1];
        LH_a(v,:) = [NaN NaN NaN]; LH_p(v,:) = [1 1 1];
        
        Area_n          = Area{v};
        idx_under_lines = strfind(Area{v},'_');
        Area_n          = Area_n([(1:3) idx_under_lines(end)+1:end]);
        Area{v}         = Area_n;
        
        if ~isempty(strfind(Area{v},left_hemi_pattern)),
            hemi = 0;
        else
            hemi = 1;
        end
        
        % implement later as mfile:
        % order of conditions
        % LL LR RL RR
        
        voi_data(v).a(1) = mean([data_anova{v,2} data_anova{v,3}]) - mean([data_anova{v,1} data_anova{v,4}]); % CUD all
        
        if hemi==0 % LH
            voi_data(v).a(2) = mean(data_anova{v,3}) - mean(data_anova{v,4}); % contralateral hand RL - RR
            voi_data(v).a(3) = mean(data_anova{v,2}) - mean(data_anova{v,4}); % contralateral space LR - RR
        else % RH
            voi_data(v).a(2) = mean(data_anova{v,2}) - mean(data_anova{v,1}); % contralateral hand LR - LL
            voi_data(v).a(3) = mean(data_anova{v,3}) - mean(data_anova{v,1}); % contralateral space RL - LL
        end
                
        voi_data(v).p 	= 	anova(v).p; % space, hand, interaction
        
        % special case - remove significance for negative response amplitudes
        if all([ mean(data_anova{v,1})  mean(data_anova{v,2})  mean(data_anova{v,3})  mean(data_anova{v,4})]<0),
            voi_data(v).p(3) = [1];
        end
        
        if hemi==0 % LH
            LH_a(v,:) = voi_data(v).a;
            LH_p(v,:) = voi_data(v).p;
        else % RH
            RH_a(v,:) = voi_data(v).a;
            RH_p(v,:) = voi_data(v).p; % hand | space | interaction
        end
        
        Area{v}         = Area_n(4:end);
        
    end
 
    RH_LH_separation = find(isnan(LH_a(:,1)));
    
    area_col =  [];
    
    if ~isempty(strfind(voipath,'CUD')),
        color_plot = [.8 .8 .8];
    elseif ~isempty(strfind(voipath,'hand')),
        color_plot = [.9 .9 .9];
    else
        color_plot = [1 1 1];
    end
    
    if (length(LH_a)/2) > RH_LH_separation(end)
        length_plot_areas = length(LH_a)-RH_LH_separation(end);
        length_plot_areas = 30/length_plot_areas;
        position_plots = [0 0 400 800/length_plot_areas];
    else
        length_plot_areas = RH_LH_separation(end);
        length_plot_areas = 30/length_plot_areas;
        position_plots = [0 0 400 800/length_plot_areas];
    end
  
    ig_figure('Position',position_plots);  
    subplot(1,2,1)
    plot_barh(LH_a(RH_LH_separation(end)+1:end,:),Area(RH_LH_separation(end)+1:end),area_col,LH_p(RH_LH_separation(end)+1:end,:));
    set(gca,'Color',color_plot)   
    subplot1 = get(gca,'Position');
    set(gca,'Position',[.2 subplot1(2) subplot1(3) subplot1(4)]);
    if ~isempty(strfind(voipath,'CUD')),xlabel('%BOLD change difference');end,
    title('Left Hemisphere','FontSize',16);
    subplot(1,2,2)
    plot_barh(RH_a(1:RH_LH_separation(end),:),Area(1:RH_LH_separation(end)),area_col,RH_p(1:RH_LH_separation(end),:));
    set_axes_equal_lim;
    set(gca,'Color',color_plot);
    subplot2 = get(gca,'Position');
    set(gca,'Position',[.65 subplot2(2) subplot2(3) subplot2(4)]);
    if ~isempty(strfind(voipath,'CUD')),xlabel('%BOLD change difference');end,
    title('Right Hemisphere','FontSize',16);
    
end % of if plot summary


cd(ini_dir);


function plot_barh(a,areas,col,p)

% SET THIS
dist = 0.025; % distance between significance markers
sig_col = [0 1 0; 1 0 0; 0 0 0]; % hand | space | interaction

if nargin < 4,
    p = [];
end

sig = p<0.05;

n = length(a);

h = barh(a,1,'grouped'); hold on;

ytick = [1:n];
set(gca,'YTick',ytick,'YTickLabel',areas,'FontSize',12,'Ydir','reverse','Ylim',[0 n+1]);
set(gca,'Xlim',[-0.17 0.1]);

if ~isempty(col), colormap(col); end;

cmap = gray(3);
colormap(cmap(1:3,:));

xlim = get(gca,'xlim');
for k = 1:n,
    for i = 1:size(p,2),
        if sig(k,i), plot(xlim(2)+i*dist,ytick(k),'ko','MarkerSize',7,'MarkerEdgeColor',sig_col(i,:),'MarkerFaceColor',sig_col(i,:)); end
    end
end

set(gca,'Xlim',[xlim(1) xlim(2)+(size(p,2)+1)*dist]);


