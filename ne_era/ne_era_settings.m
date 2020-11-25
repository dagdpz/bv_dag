% ne era settings

% general default settings, unlikely to change
% overwrite in era_settings_id case if needed
settings.correct_se_4twice_trials = 1;
settings.arbitrary_shift = 0;
settings.normalize_bins = [];
settings.ra_bins_sec = [];
settings.do_stats = 0;
settings.select_curves = [];	% if empty, take all curves from file
settings.plot_diff = [];	% define pairs for subtraction (1st - 2nd)


% graphics
settings.xlabel = 'Time from stimulation onset (s)';
settings.ylabel = '% BOLD change';
settings.errorbar_rgb = []; % use colors from file
settings.plot_symbols = 1; % plot markers in addition to line
settings.shade_color = [0.9   0.9   0.9];
settings.error_patch_FaceAlpha = 0.5;
settings.offset_xaxis = 0.5;

switch era_settings_id
	case '' % default
	
	case 'Curius_microstim_20130814-20131009'
		
		
    case 'Curius_microstim_20131129-now'
        
        % those settings could come from avg file - in this case they will be overwritten by avg
        settings.ResolutionOfDataPoints	= 'Seconds';
        settings.PreInterval		= 5; % s
        settings.PostInterval		= 15; % s
        settings.NrOfConditionEvents	= [];
        settings.BaselineMode		= 3;
        settings.AverageBaselineFrom	= -3; % s
        settings.AverageBaselineTo	= 0; % s
        
        % those settings need to be set even if avg is specified
        settings.TR 			= 2;
        settings.MarkedIntervals	= [10]; % relative to onset
        settings.errorbars_type = 1; % 0 - none, 1 - patch, 2 - line, 3 - errorbar
        settings.do_stats = 0;
        
        % statistics
        settings.assignment = [1 1; 1 2; 2 1; 2 2; 3 1; 3 2]; % vector that assigns conditions to factor levels. If left emtpy [], ANOVA will be skipped
        settings.varnames = {'Task' 'Stimulation'}; % factor names for ANOVA
        settings.levnames = {{'Fix' 'MemR' 'MemL'} {'Nostim' 'Stim'}}; % factor level names for ANOVA
        settings.conditions2take = [1:6];
        settings.condition_numbers = [1 3 5 2 4 6]; % numbering of conditions in barplot coming from AVG file is different from numbering coming from post-hoc comparisons (multcompare function),
        % you have to figure out the numbering for your dataset.
        % settings.condition_numbers contains the barplot numbering corresponding to [1 2 3 4 5 6] numbering in comparisons,
        % e.g. condition #3 in barplot corresponds to condition #2 in multcompare output, condition #5 in barplot corresponds to condition #3 in multcompare output
        settings.ra_bins_sec = [2:9]; % data points (in seconds) across which response amplitudes will be averaged for barplots
        settings.alpha_post_hoc_t = 0.05; % significance level for ANOVA post-hoc comparisons, comparisons are made without corrections for multiple comparisons
        
        % plotting settings
        settings.select_curves = [];
        settings.plot_ra_bins		= 0; % plot a line for the specified period
        settings.plot_baseline		= 1; % plot a line for baseline
        settings.xticklabel = {'Fix' 'Fix-Stim' 'SaccR' 'SaccR-Stim' 'MemL' 'MemL-Stim'}; %{'Fix' 'Fix-Stim' 'SaccR' 'SaccR-Stim' 'MemL' 'MemL-Stim'}; %XTickLabels for barplots, if empty ([]), CurveNames from dat file will be used
        settings.Ylim = [-0.5 1];
        settings.Ytick = -0.5:0.5:1;
        
        %         settings.plot_diff = { ...  % leave empty ([]) to skip plotting differences;
        %             { {2} {1} } ; ...       % define pairs for subtraction of the following way: settings.plot_diff_fun(1st cell) - settings.plot_diff_fun(2nd cell)
        %             { {4} {3} }; ...
        %             { {6} {5} } ...
        %             };
        settings.plot_diff = [];
        % settings.plot_diff_color = [0 0 0; 0 0 1; 1 0 0];
        settings.plot_diff_fun = @(x,y) mean(x,y); % function that will be applied to data before calculating the difference according to settings.plot_diff, check line 195 in ne_plot_era_fmri_microstim for correct input!
        
        settings.plot_significance = 1; % plot asterisk if
        % for difference time courses: difference between two conditions at a given time point is statistically significant (uncorrected), see settings.plot_diff
        % for bar plots: difference between two conditions/bars is significant (level of significance specified as settings.alpha_post_hoc_t)
        % set to 0 to not plot asterisks
        settings.plot_significance_period = [0 10]; % time period in which significance should be plotted in units of timeaxis (sec) in difference time courses
        settings.plot_significance_multcomp = [1 2 3 6 8 12]; % relevant post-hoc comparisons, i.e. relevant rows of output of multcompare function; leave empty ([]) to plot all significant comparisons
        settings.font_size_text = 14; % size of the significance asterisks
        settings.font_size_axes = 14; % font size of xlabel, ylabel, and title
        settings.offset_xaxis = 0;
        
        settings.name_appendix = '_memory_2_9'; % appendix of barplot's filename
        % settings.name_appendix = '_latememory_6_9';
        % settings.name_appendix = '_earlymemory_2_5';
        
    case 'Curius_fixmemory_baseline_20131129-now'
        
        % those settings could come from avg file - in this case they will be overwritten by avg
        settings.ResolutionOfDataPoints	= 'Seconds';
        settings.PreInterval		= 5; % s
        settings.PostInterval		= 15; % s
        settings.NrOfConditionEvents	= [];
        settings.BaselineMode		= 3;
        settings.AverageBaselineFrom	= -3; % s
        settings.AverageBaselineTo	= 0; % s
        
        % those settings need to be set even if avg is specified
        settings.TR 			= 2;
        settings.MarkedIntervals	= [10]; % relative to onset
        settings.errorbars_type = 1; % 0 - none, 1 - patch, 2 - line, 3 - errorbar
        settings.do_stats = 0;
        
        % statistics
        settings.assignment = [1; 2; 3]; % vector that assigns conditions to factor levels. If left emtpy [], ANOVA will be skipped
        settings.varnames = {'Task'}; % factor names for ANOVA
        settings.levnames = {{'Fix' 'MemR' 'MemL'}}; % factor level names for ANOVA
        settings.conditions2take = [1:3];
        settings.condition_numbers = [1 2 3]; % see previous case for explanation
        settings.ra_bins_sec = [2:9]; % data points (in seconds) across which response amplitudes will be averaged for barplots
        settings.alpha_post_hoc_t = 0.05; % significance level for ANOVA post-hoc comparisons, comparisons are made without corrections for multiple comparisons
        
        % plotting settings
        settings.select_curves = [];
        settings.plot_ra_bins		= 0; % plot a line for the specified period
        settings.plot_baseline		= 1; % plot a line for baseline
        settings.xticklabel = {'Fix' 'SaccR' 'MemL'}; %{'Fix' 'Fix-Stim' 'SaccR' 'SaccR-Stim' 'MemL' 'MemL-Stim'}; %XTickLabels for barplots, if empty ([]), CurveNames from dat file will be used
        settings.Ylim = [-0.5 1];
        settings.Ytick = -0.5:0.5:1;
        
        %         settings.plot_diff = { ...  % leave empty ([]) to skip plotting differences;
        %             { {2} {1} } ; ...       % define pairs for subtraction of the following way: settings.plot_diff_fun(1st cell) - settings.plot_diff_fun(2nd cell)
        %             { {4} {3} }; ...
        %             { {6} {5} } ...
        %             };
        settings.plot_diff = [];
        % settings.plot_diff_color = [0 0 0; 0 0 1; 1 0 0];
        settings.plot_diff_fun = @(x,y) mean(x,y); % function that will be applied to data before calculating the difference according to settings.plot_diff, check line 195 in ne_plot_era_fmri_microstim for correct input!
        
        settings.plot_significance = 1; % plot asterisk if
        % for difference time courses: difference between two conditions at a given time point is statistically significant (uncorrected), see settings.plot_diff
        % for bar plots: difference between two conditions/bars is significant (level of significance specified as settings.alpha_post_hoc_t)
        % set to 0 to not plot asterisks
        settings.plot_significance_period = [0 10]; % time period in which significance should be plotted in units of timeaxis (sec) in difference time courses
        settings.plot_significance_multcomp = [1 2 3]; % relevant post-hoc comparisons, i.e. relevant rows of output of multcompare function; leave empty ([]) to plot all significant comparisons
        settings.font_size_text = 14; % size of the significance asterisks
        settings.font_size_axes = 14; % font size of xlabel, ylabel, and title
        settings.offset_xaxis = 0;
        
        settings.name_appendix = '_memory_2_9'; % appendix of barplot's filename
        
    case 'Bacchus_microstim_20170201-now'
        
        % those settings could come from avg file - in this case they will be overwritten by avg
        settings.ResolutionOfDataPoints	= 'Seconds';
        settings.PreInterval		= 5; % s
        settings.PostInterval		= 15; % s
        settings.NrOfConditionEvents	= [];
        settings.BaselineMode		= 3;
        settings.AverageBaselineFrom	= -3; % s
        settings.AverageBaselineTo	= 0; % s
        
        % those settings need to be set even if avg is specified
        settings.TR 			= 2;
        settings.MarkedIntervals	= [10]; % relative to onset
        settings.errorbars_type = 1; % 0 - none, 1 - patch, 2 - line, 3 - errorbar
        settings.do_stats = 0;
        
        % statistics
        settings.assignment = [1 1; 1 2; 2 1; 2 2; 3 1; 3 2]; % vector that assigns conditions to factor levels. If left emtpy [], ANOVA will be skipped
        settings.varnames = {'Task' 'Stimulation'}; % factor names for ANOVA
        settings.levnames = {{'Fix' 'MemR' 'MemL'} {'Nostim' 'Stim'}}; % factor level names for ANOVA
        settings.conditions2take = [1:6];
        settings.condition_numbers = [1 3 5 2 4 6]; % numbering of conditions in barplot coming from AVG file is different from numbering coming from post-hoc comparisons (multcompare function),
        % you have to figure out the numbering for your dataset.
        % settings.condition_numbers contains the barplot numbering corresponding to [1 2 3 4 5 6] numbering in comparisons,
        % e.g. condition #3 in barplot corresponds to condition #2 in multcompare output, condition #5 in barplot corresponds to condition #3 in multcompare output
        settings.ra_bins_sec = [2:9]; % data points (in seconds) across which response amplitudes will be averaged for barplots
        settings.alpha_post_hoc_t = 0.05; % significance level for ANOVA post-hoc comparisons, comparisons are made without corrections for multiple comparisons
        
        % plotting settings
        settings.select_curves = [];
        settings.plot_ra_bins		= 0; % plot a line for the specified period
        settings.plot_baseline		= 1; % plot a line for baseline
        settings.xticklabel = {'Fix' 'Fix-Stim' 'SaccR' 'SaccR-Stim' 'MemL' 'MemL-Stim'}; %{'Fix' 'Fix-Stim' 'SaccR' 'SaccR-Stim' 'MemL' 'MemL-Stim'}; %XTickLabels for barplots, if empty ([]), CurveNames from dat file will be used
        settings.Ylim = [-0.5 1];
        settings.Ytick = -0.5:0.5:1;
        
        %         settings.plot_diff = { ...  % leave empty ([]) to skip plotting differences;
        %             { {2} {1} } ; ...       % define pairs for subtraction of the following way: settings.plot_diff_fun(1st cell) - settings.plot_diff_fun(2nd cell)
        %             { {4} {3} }; ...
        %             { {6} {5} } ...
        %             };
        settings.plot_diff = [];
        % settings.plot_diff_color = [0 0 0; 0 0 1; 1 0 0];
        settings.plot_diff_fun = @(x,y) mean(x,y); % function that will be applied to data before calculating the difference according to settings.plot_diff, check line 195 in ne_plot_era_fmri_microstim for correct input!
        
        settings.plot_significance = 1; % plot asterisk if
        % for difference time courses: difference between two conditions at a given time point is statistically significant (uncorrected), see settings.plot_diff
        % for bar plots: difference between two conditions/bars is significant (level of significance specified as settings.alpha_post_hoc_t)
        % set to 0 to not plot asterisks
        settings.plot_significance_period = [0 10]; % time period in which significance should be plotted in units of timeaxis (sec) in difference time courses
        settings.plot_significance_multcomp = [1 2 3 6 8 12]; % relevant post-hoc comparisons, i.e. relevant rows of output of multcompare function; leave empty ([]) to plot all significant comparisons
        settings.font_size_text = 14; % size of the significance asterisks
        settings.font_size_axes = 14; % font size of xlabel, ylabel, and title
        settings.offset_xaxis = 0;
        
        settings.name_appendix = '_memory_2_9'; % appendix of barplot's filename
        % settings.name_appendix = '_latememory_6_9';
        % settings.name_appendix = '_earlymemory_2_5';
        
end