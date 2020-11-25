function [out,stat]=ne_plot_era_onefile_avg(fname,era_settings_id,avg_path,varargin)
% ne_plot_era_onefile_avg('CU_FEF_r.dat','Curius_microstim_20131129-now','20130814-20131009_eb.avg');
% ne_plot_era_onefile_avg('CU_FEF_r.dat','Curius_microstim_20131129-now','20130814-20131009_eb.avg','plot_graphics','both');
% ne_plot_era_onefile_avg('Z:\MRI\Curius\combined\microstim_20140213-20140306\PNM2014\test.dat','Curius_microstim_20131129-now','','plot_graphics','both');
% ne_plot_era_onefile_avg('Z:\MRI\Curius\combined\microstim_20140213-20140306\PNM2014\test.dat','Curius_microstim_20131129-now','Z:\MRI\Curius\combined\microstim_20140213-20140306\PNM2014\combined_ne_prt2avg_fixation_memory_microstim.avg','plot_graphics','both');
% ne_plot_era_onefile_avg('Z:\MRI\Curius\combined\microstim_20140213-20140226_6_tar_5_3\CU_pulv_r.dat','Curius_microstim_20131129-now','Z:\MRI\Curius\combined\microstim_20140213-20140226_6_tar_5_3\combined_spkern_3-3-3_ne_prt2avg_fixation_memory_microstim.avg','plot_graphics','both','save_figure','.ai');
% ne_plot_era_onefile_avg('D:\Lydia Gibson\Lab_Retreat_2014\CU_MT_r.dat','Curius_microstim_20131129-now','D:\Lydia Gibson\Lab_Retreat_2014\combined_spkern_3-3-3_ne_prt2avg_fixation_memory.avg','plot_graphics','tc');


if nargin < 3,
        avg_path = '';
end

opengl software % http://www.mathworks.com/matlabcentral/answers/101588

ini_dir = pwd;

% default parameters, for dynamic params (i.e. those params might change from session to session, even for same dataset)
defpar = { ...
        'plot_graphics', 'char', '', 'tc'; ... % '' | 'tc' | 'bars' | 'both'
        'open_figure', 'double', 'nonempty', 1; ...
        'save_figure', 'char',   '', ''; ... % '.png' | '.pdf' | '.ai' | '.eps'
        };

if nargin > 4, % specified dynamic params
        params = checkstruct(struct(varargin{:}), defpar);
elseif nargin == 4, % struct is specified
        params = varargin{1};
else
        params = checkstruct(struct, defpar); % take all default params
end


run('ne_era_settings');


if ~isempty(avg_path), % some info coming from avg file, overwriting the era_settings
        avg = xff(avg_path);
        settings.ResolutionOfDataPoints	= avg.ResolutionOfDataPoints;
        settings.NrOfTimePoints		= avg.NrOfTimePoints;
        settings.PreInterval		= avg.PreInterval;
        settings.PostInterval		= avg.PostInterval;
        settings.NrOfCurves		= avg.NrOfCurves;
        settings.NrOfFiles		= avg.NrOfFiles;
        temp				= avg.Curve;
        settings.NrOfConditionEvents	= [temp.NrOfConditionEvents];
        settings.CurveName = {temp.Name};
        settings.BaselineMode		= avg.BaselineMode;
        settings.AverageBaselineFrom	= avg.AverageBaselineFrom;
        settings.AverageBaselineTo	= avg.AverageBaselineTo;
end


if iscell(fname), % combine two files in contra/ipsi way: first should be LEFT HEMI, second should be RIGHT HEMI!!! BASTA!
        combine_contra_ipsi = 1;

        [FileVersion,NrOfCurves,StdDevErrs,NrOfCurveDataPoints,CurveName,TimeCourseThick,TimeCourseColorR,TimeCourseColorG,TimeCourseColorB,StdDevErrThick,StdDevErrColorR,StdDevErrColorG,StdDevErrColorB,NrOfSegIntervals,SegInt,data1l,data2l] = ne_read_era(fname{1});
        [FileVersion,NrOfCurves,StdDevErrs,NrOfCurveDataPoints,CurveName,TimeCourseThick,TimeCourseColorR,TimeCourseColorG,TimeCourseColorB,StdDevErrThick,StdDevErrColorR,StdDevErrColorG,StdDevErrColorB,NrOfSegIntervals,SegInt,data1r,data2r] = ne_read_era(fname{2});

        [pathstr,name1] = fileparts(fname{1});
        [pathstr,name2] = fileparts(fname{2});
        fname = [pathstr filesep name1 '_AND_' name2 '.dat'];

        % here should go sorting to left and right conditions

        idx_r = [1:2:NrOfCurves-1]; % odd
        idx_l = [2:2:NrOfCurves];   % even

        data1(:,idx_r) = (data1r(:,idx_l) + data1l(:,idx_r))/2; % contra
        data1(:,idx_l) = (data1r(:,idx_r) + data1l(:,idx_l))/2; % ipsi


        data2(:,idx_r) = (data2r(:,idx_l) + data2l(:,idx_r))/2; % contra
        data2(:,idx_l) = (data2r(:,idx_r) + data2l(:,idx_l))/2; % ipsi


        if settings.correct_se_4twice_trials; data2 = data2./sqrt(2); end; % "correct" for ipsi-contra doubling of trial numbers

else % ONE FILE

        [FileVersion,NrOfCurves,StdDevErrs,NrOfCurveDataPoints,~,TimeCourseThick,TimeCourseColorR,TimeCourseColorG,TimeCourseColorB,StdDevErrThick,StdDevErrColorR,StdDevErrColorG,StdDevErrColorB,NrOfSegIntervals,SegInt,data1,data2] = ne_read_era(fname,0,settings.select_curves);

        combine_contra_ipsi = 0;

end % of if iscell(fname)

CurveName = settings.CurveName;

if ~isempty(settings.select_curves), % select subset of curves
        data1 = data1(:,settings.select_curves);
        data2 = data2(:,settings.select_curves);
        CurveName = CurveName(settings.select_curves);
        NrOfCurves = length(settings.select_curves);
        TimeCourseColorR = TimeCourseColorR(settings.select_curves);
        TimeCourseColorG = TimeCourseColorG(settings.select_curves);
        TimeCourseColorB = TimeCourseColorB(settings.select_curves);
        StdDevErrColorR = StdDevErrColorR(settings.select_curves);
        StdDevErrColorG = StdDevErrColorG(settings.select_curves);
        StdDevErrColorB = StdDevErrColorB(settings.select_curves);
end


switch settings.ResolutionOfDataPoints
        case 'Seconds'
                time_resolution = 1;
        case 'Volumes'
                time_resolution = TR;
end

timeaxis = [0:settings.NrOfTimePoints-1]*time_resolution - settings.PreInterval;

if settings.arbitrary_shift ~= 0,
        data1 = data1 + settings.arbitrary_shift;
end

if ~isempty(settings.normalize_bins),
        max_change = max(max(data1(settings.normalize_bins,:))); % for normalization
else
        max_change = 1;
end

if ~isempty(settings.ra_bins_sec),
    settings.ra_bins = [find(timeaxis == settings.ra_bins_sec(1)):find(timeaxis == settings.ra_bins_sec(end))];
    data1_ra = mean(data1(settings.ra_bins,:),1);
    data2_ra = mean(data2(settings.ra_bins,:),1);
else
    data1_ra = [];
    data2_ra = [];
end





out.timeaxis    = timeaxis;
out.data1       = data1;
out.data2       = data2;
out.fname       = fname;
out.CurveName	= CurveName;
out.StdDevErrThick = StdDevErrThick;
out.TimeCourseColorR = TimeCourseColorR;
out.TimeCourseColorG = TimeCourseColorG;
out.TimeCourseColorB = TimeCourseColorB;
out.TimeCourseThick  = TimeCourseThick;
out.NrOfCurveDataPoints = settings.NrOfTimePoints;

out.StdDevErrColorR = StdDevErrColorR;
out.StdDevErrColorG = StdDevErrColorG;
out.StdDevErrColorB = StdDevErrColorB;
out.settings = settings;


% simple t tests: comparison of conditions as specified in settings.plot_diff
if ~isempty(settings.plot_diff)
    stat.n_trials = out.settings.NrOfConditionEvents;
    stat.timeaxis = timeaxis;
    stat.tst = 2; % unpaired t test using standard errors
    stat.ttest_h = zeros(length(timeaxis),settings.NrOfCurves);
    stat.ttest_p = zeros(length(timeaxis),settings.NrOfCurves);    
    for d=1:size(settings.plot_diff,1)
        for t = 1:size(data1,1)
            [h,p,tval] = testt_norawdata(data1(t,settings.plot_diff{d,1}),data1(t,settings.plot_diff{d,2}),...
                data2(t,settings.plot_diff{d,1}),data2(t,settings.plot_diff{d,2}),...
                stat.n_trials(settings.plot_diff{d,1}),stat.n_trials(settings.plot_diff{d,2}),...
                stat.tst);
            
            ttest_h(t,1) = h;
            ttest_p(t,1) = p;
            ttest_t(t,1) = tval;            
        end
        stat.ttest_h(:,settings.plot_diff{d,1}) = ttest_h;
        stat.ttest_p(:,settings.plot_diff{d,1}) = ttest_p;
        stat.ttest_t(:,settings.plot_diff{d,1}) = ttest_t;
    end
end

if isempty(params.plot_graphics), return; end

% plotting

if ~isempty(settings.plot_diff), % plot difference between (some) curves
        for d=1:size(settings.plot_diff,1)
                D(:,d) = data1(:,settings.plot_diff{d,1}) - data1(:,settings.plot_diff{d,2});
                c(1,d) = settings.plot_diff{d,1};
        end
        settings.errorbars_type = 0; % cannot plot error for difference
        data1(:,c(1,:)) = D;
        NrOfCurves = size(settings.plot_diff,1);

else
        c(1,:) = 1:NrOfCurves;
end


hf = [];

if (strcmp(params.plot_graphics,'tc') || strcmp(params.plot_graphics,'both')),

        if params.open_figure
                hf_tc = figure('Color','w','Name',fname);
                hf = [hf hf_tc];
        end

        settings.marked_intervals = [0 settings.MarkedIntervals];

        N_subplots_h = 1;
        N_subplots_v = 1;


        if isempty(settings.errorbar_rgb),
                for i = 1:NrOfCurves
                        settings.errorbar_rgb = [settings.errorbar_rgb; [TimeCourseColorR(c(1,i))/255 TimeCourseColorG(c(1,i))/255 TimeCourseColorB(c(1,i))/255]];
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
                                        patch([timeaxis fliplr(timeaxis)],[(data1(:,i)+data2(:,i))' fliplr((data1(:,i)-data2(:,i))')],-eps*ones(1,2*length(timeaxis)),'r','EdgeColor','none','FaceColor',settings.errorbar_rgb(i,:),'FaceAlpha',settings.error_patch_FaceAlpha); hold on;
                                elseif settings.errorbars_type == 2, % line
                                        line([timeaxis fliplr(timeaxis)],[(data1(:,i)+data2(:,i))' fliplr((data1(:,i)-data2(:,i))')],'Color',settings.errorbar_rgb(i,:),'LineWidth',StdDevErrThick(i)/2,'LineStyle','--'); hold on;
                                elseif settings.errorbars_type == 3, % errorbar
                                        he = errorbar(timeaxis,data1(:,i),data2(:,i)); hold on;
                                        set(he,'Color',settings.errorbar_rgb(i,:),'LineWidth',StdDevErrThick(i));
                                end
                        end

                end
                
                offset_star = 0;
                for i = c(k,:),                  
                    
                        plot(timeaxis,data1(:,i),'Color',[TimeCourseColorR(i) TimeCourseColorG(i) TimeCourseColorB(i)]/255,'LineWidth',TimeCourseThick(i)/1.5);

                        if settings.plot_symbols;
                                hold on; plot(timeaxis,data1(:,i),'o','MarkerSize',6,'MarkerFaceColor',[TimeCourseColorR(i) TimeCourseColorG(i) TimeCourseColorB(i)]/255,'MarkerEdgeColor',[TimeCourseColorR(i) TimeCourseColorG(i) TimeCourseColorB(i)]/255,'LineWidth',TimeCourseThick(i)/1.5);

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
                            t_x = timeaxis(stat.ttest_h(:,i) == 1);
                            t_x = t_x(t_x >= settings.plot_significance_period(1) & t_x <= settings.plot_significance_period(end));
                            t_y = ones(length(t_x),1)*(settings.Ylim(2)-0.2);                            
                            hold on;
                            text(t_x,t_y+offset_star,'*', 'Color', [TimeCourseColorR(i) TimeCourseColorG(i) TimeCourseColorB(i)]/255, 'FontSize', settings.font_size_text);
                        end                                  
                                                                      
                end

                if settings.do_stats % stat. analysis
                        do_tc_stats(out,name1);
                end

                % title(sprintf('%s',subtitle{k}),'Interpreter','none');

                set(gca,'Xlim',[min(timeaxis)-settings.offset_xaxis max(timeaxis)+settings.offset_xaxis],'YTick', settings.Ytick, 'box','off');
                % legend('Fix', 'Fix-Stim', 'SaccR', 'SaccR-Stim', 'MemL', 'MemL-Stim')
                % legend boxoff


                % end of plotting

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
                mlabel(settings.xlabel,settings.ylabel,fname,'Interpreter','none','HorizontalAlignment','left');
        else
                xlabel(settings.xlabel,'Interpreter','none','HorizontalAlignment','center');
                ylabel(settings.ylabel,'Interpreter','none','HorizontalAlignment','center');
                htitle = get(gca,'title');
                title({fname},'Interpreter','none','HorizontalAlignment','center');
                % title({fname sprintf('\t') get(htitle,'string')},'Interpreter','none','HorizontalAlignment','center');
        end




end

if strcmp(params.plot_graphics,'bars') || strcmp(params.plot_graphics,'both'),    
        if ~isempty(settings.xticklabel)
            xticklabel = settings.xticklabel;
        else xticklabel = CurveName;
        end
        
        if params.open_figure
                hf_bar = figure('Color','w','Name',[fname(1:end-4) '_bars' fname(end-3:end)],'PaperPositionMode','auto');
                hf = [hf hf_bar];
        end

        for i = 1:NrOfCurves
                color_map(i,:) =  [TimeCourseColorR(i) TimeCourseColorG(i) TimeCourseColorB(i)]/255;
                h = bar(i,data1_ra(i)); hold on;
                set(h,'Facecolor',color_map(i,:));
        end
        errorbar([1:NrOfCurves],data1_ra,data2_ra,'.','Marker','none','Color',[0 0 0]);
        set(gca,'Xlim',[0 NrOfCurves+1],'XTick',[1:NrOfCurves],'TickDir','out','XTickLabel',xticklabel,'box','off');
        title({fname},'Interpreter','none','HorizontalAlignment','center');
end

% save figure
if ~isempty(params.save_figure) && params.open_figure
        add_name = '';
        for f = 1:length(hf),
                if strfind(get(hf(f),'Name'),'bars'),
                        add_name = '_bars_earlymem';
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

                switch params.save_figure
                        case '.png'
                                print(hf(f),'-dpng','-r0',[fname add_name '.png']);
                        case '.pdf'
                                saveas(hf(f),[fname add_name '.pdf'],'pdf');
                        case '.ai'
                                set(hf(f),'Renderer','Painters');
                                print(hf(f),'-dill',[fname add_name '.ai']);
                        case '.eps'
                                set(hf(f),'Renderer','Painters');
                                print(hf(f),'-dpsc2',[fname add_name '.eps']);
                end

                disp(['Saved ' fname add_name params.save_figure]);

        end
end

cd(ini_dir);




