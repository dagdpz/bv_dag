function plot_choice_effect
%% Plots choice effect stats
export = 0;
export_path = 'Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI\stats\plots choice effect';

%% load subject data 
load('Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI\stats\Exp_era_period_diff_choi_instr.mat');
%dd = tt_no_del;
tt.cond_delay = findgroups(tt.cond,tt.delay);

% vois = table(tt.voi_number,tt.location,tt.voi_short,tt.voi_short_hemi,tt.voi,tt.hemi);
% vois = unique(vois);
% vois.Properties.VariableNames = ({'voi_number','location','voi_short','voi_short_hemi','voi','hemi'});
% % save('Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI\voi_names.mat','vois');

load('Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI\voi_names.mat');
%% load categorical delay models
% cat_d = load('Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI\stats\CEfitted_catdelay.mat');
% 
% fit_cat = struct2table(cat_d.CEfitted);
% 
% fit_cat.effector = categorical(fit_cat.effector);
% fit_cat.period = categorical(fit_cat.period);
% fit_cat.delay = categorical(fit_cat.delay);
% 
% fit_cat = join(fit_cat,vois,'Keys','voi_number');

%% load numerical delay models

if ~exist('Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI\stats\CEfitted_table.mat')
    
    num_d = load('Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI\stats\CEfitted_numdelay.mat');
    
    fit_num = struct2table(num_d.CEfitted);
    
    fit_num.effector = categorical(fit_num.effector);
    fit_num.period = categorical(fit_num.period);
    fit_num.delay = categorical(fit_num.num_delay);
    
    fit_num = join(fit_num,vois,'Keys','voi_number');
    
    [fit_num.pvalue,fit_num.zscore,fit_num.SE] = pvalue_from_ci(fit_num.fitted,fit_num.lwr,fit_num.upr);
    
    save('Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI\stats\CEfitted_table.mat','fit_num')
    %writetable(fit_num,'Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI\stats\CEfitted_table.csv')    

else
    load('Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI\stats\CEfitted_table.mat');
end

%% ####################    FITTED VALUES     ###################

%% simple means

title = 'simple group means - left hemisphere';
figure ('Position', [100 100 1600 1000],'Name',title);
g = gramm('x',tt.period,'y',tt.diff,'color',tt.cond,'lightness',tt.delay,'subset',tt.hemi == 'lh');
g.facet_wrap(tt.voi,'ncols',4);
g.stat_summary('geom',{'bar','black_errorbar'},'setylim',true);
g.set_order_options('lightness',{'9','12','15'});
g.geom_hline('yintercept',0);
g.axe_property('YGrid',true);
g.set_title(title);
%g.set_color_options('map',[ 0.1020, 0.5882, 0.2549; 0.8431, 0.0980, 0.1098],'n_color',2,'n_lightness',1);
g.set_order_options('lightness',{'9','12','15'},'color',{'sac', 'reach'});
g.set_names('lightness','','color','','column','','y','diff % BOLD change');

g.draw;

if export
    g.export('file_name',title,...
        'export_path',export_path,...
        'file_type','pdf');
    
    close(title)
end

title = 'simple group means - right hemisphere';
figure ('Position', [100 100 1600 1000],'Name',title);
g = gramm('x',tt.period,'y',tt.diff,'color',tt.cond,'lightness',tt.delay,'subset',tt.hemi == 'rh');
g.facet_wrap(tt.voi,'ncols',4);
g.stat_summary('geom',{'bar','black_errorbar'},'setylim',true);
g.set_order_options('lightness',{'9','12','15'});
g.geom_hline('yintercept',0);
g.axe_property('YGrid',true);
g.set_title(title);
%g.set_color_options('map',[ 0.1020, 0.5882, 0.2549; 0.8431, 0.0980, 0.1098],'n_color',2,'n_lightness',1);
g.set_order_options('lightness',{'9','12','15'},'color',{'sac', 'reach'});
g.set_names('lightness','','color','','column','','y','diff % BOLD change');

g.draw;

if export
    g.export('file_name',title,...
        'export_path',export_path,...
        'file_type','pdf');
    
    close(title)
end

%% categorical delay
% title = 'fitted values, categorical delay - left hemisphere';
% figure ('Position', [100 100 1600 1000],'Name',title);
% g = gramm('x',fit_cat.period,'y',fit_cat.fitted,'ymin',fit_cat.lwr,'ymax',fit_cat.upr,'color',fit_cat.effector,'column',fit_cat.voi,'lightness',fit_cat.delay,'subset', fit_cat.hemi == 'lh');
% g.facet_wrap(fit_cat.voi,'ncols',4);
% g.geom_interval('geom',{'bar','black_errorbar'});
% g.set_order_options('lightness',{'9','12','15'});
% g.geom_hline('yintercept',0);
% g.axe_property('YGrid',true);
% g.set_title(title);
% %g.set_color_options('map',[ 0.1020, 0.5882, 0.2549; 0.8431, 0.0980, 0.1098],'n_color',2,'n_lightness',1);
% g.set_order_options('lightness',{'9','12','15'},'color',{'sac', 'reach'});
% g.set_names('lightness','','color','','column','','y','diff % BOLD change');
% 
% g.draw;
% 
% if export
%     g.export('file_name',title,...
%         'export_path',export_path,...
%         'file_type','pdf');
%     
%     close(title)
% end
% 
% title = 'fitted values, categorical delay - right hemisphere';
% figure ('Position', [100 100 1600 1000],'Name',title);
% g = gramm('x',fit_cat.period,'y',fit_cat.fitted,'ymin',fit_cat.lwr,'ymax',fit_cat.upr,'color',fit_cat.effector,'column',fit_cat.voi,'lightness',fit_cat.delay,'subset', fit_cat.hemi == 'rh');
% g.facet_wrap(fit_cat.voi,'ncols',4);
% g.geom_interval('geom',{'bar','black_errorbar'});
% g.set_order_options('lightness',{'9','12','15'});
% g.geom_hline('yintercept',0);
% g.axe_property('YGrid',true);
% g.set_title(title);
% %g.set_color_options('map',[ 0.1020, 0.5882, 0.2549; 0.8431, 0.0980, 0.1098],'n_color',2,'n_lightness',1);
% g.set_order_options('lightness',{'9','12','15'},'color',{'sac', 'reach'});
% g.set_names('lightness','','color','','column','','y','diff % BOLD change');
% 
% g.draw;
% 
% if export
%     g.export('file_name',title,...
%         'export_path',export_path,...
%         'file_type','pdf');
%     
%     close(title)
% end

%% numerical delay

title = 'fitted values, numerical delay - left hemisphere';
figure ('Position', [100 100 1600 1000],'Name',title);
g = gramm('x',fit_num.period,'y',fit_num.fitted,'ymin',fit_num.lwr,'ymax',fit_num.upr,'color',fit_num.effector,'column',fit_num.voi,'lightness',fit_num.delay,'subset', fit_num.hemi == 'lh');
g.facet_wrap(fit_num.voi,'ncols',4);
g.geom_interval('geom',{'bar','black_errorbar'});
g.set_order_options('lightness',{'9','12','15'});
g.geom_hline('yintercept',0);
g.axe_property('YGrid',true);
g.set_title(title);
%g.set_color_options('map',[ 0.1020, 0.5882, 0.2549; 0.8431, 0.0980, 0.1098],'n_color',2,'n_lightness',1);
g.set_order_options('lightness',{'9','12','15'},'color',{'sac', 'reach'});
g.set_names('lightness','','color','','column','','y','diff % BOLD change');

g.draw;

if export
    g.export('file_name',title,...
        'export_path',export_path,...
        'file_type','pdf');
    
    close(title)
end

title = 'fitted values, numerical delay - right hemisphere';
figure ('Position', [100 100 1600 1000],'Name',title);
g = gramm('x',fit_num.period,'y',fit_num.fitted,'ymin',fit_num.lwr,'ymax',fit_num.upr,'color',fit_num.effector,'column',fit_num.voi,'lightness',fit_num.delay,'subset', fit_num.hemi == 'rh');
g.facet_wrap(fit_num.voi,'ncols',4);
g.geom_interval('geom',{'bar','black_errorbar'});
g.set_order_options('lightness',{'9','12','15'});
g.geom_hline('yintercept',0);
g.axe_property('YGrid',true);
g.set_title(title);
%g.set_color_options('map',[ 0.1020, 0.5882, 0.2549; 0.8431, 0.0980, 0.1098],'n_color',2,'n_lightness',1);
g.set_order_options('lightness',{'9','12','15'},'color',{'sac', 'reach'});
g.set_names('lightness','','color','','column','','y','diff % BOLD change');

g.draw;

if export
    g.export('file_name',title,...
        'export_path',export_path,...
        'file_type','pdf');
    
    close(title)
end

%% ####################    DESCRIPTIVE PLOTS     ###################

%% PER DELAY
%% ++++++++++++++++ MEDIAL FRONTAL CORTEX +++++++++++++++++++++++
%% with fitted data plotted in front
% %% Bar plots EARLY and LATE
% title = 'choice effect, fitted values - medial frontal cortex, left hemisphere';
% % left hemisphere
% figure ('Position', [100 100 1600 1000],'Name',title);
% g = gramm('x',tt.period,'y',tt.diff,'color',tt.cond_delay,'subset',tt.voi_number< 20 & tt.hemi == 'lh')
% 
% g.facet_wrap(tt.voi,'ncols',3);
% g.geom_jitter('width',0.025,'dodge',0.6,'alpha',0.4);
% g.set_color_options('chroma',0);
% g.set_point_options('base_size',4);
% g.axe_property('YGrid','on');
% g.set_layout_options('legend',false);
% 
% g.set_order_options('lightness',{'9','12','15'},'color',{'sac', 'reach'});
% g.set_names('lightness','','color','','column','','y','diff % BOLD change');
% g.geom_hline('yintercept',0);
% g.set_title(title);
% 
% g.update('x',fit_cat.period,'y',fit_cat.fitted,'ymax',fit_cat.upr,'ymin',fit_cat.lwr,'color',fit_cat.effector,'lightness',fit_cat.delay,'subset',fit_cat.voi_number< 20 & fit_cat.hemi == 'lh')
% g.facet_wrap(fit_cat.voi,'ncols',3);
% g.geom_interval('geom',{'bar','black_errorbar'});
% g.set_color_options('legend','separate');
% 
% g.draw;
% 
% %%
% title = 'fitted values - medial frontal cortex, right hemisphere';
% % right hemisphere
% figure ('Position', [100 100 1600 1000],'Name',title);
% g = gramm('x',tt.period,'y',tt.diff,'color',tt.cond_delay,'subset',tt.voi_number< 120 & tt.hemi == 'rh')
% 
% g.facet_wrap(tt.voi,'ncols',3);
% g.geom_jitter('width',0.025,'dodge',0.6,'alpha',0.4);
% g.set_color_options('chroma',0);
% g.set_point_options('base_size',4);
% g.axe_property('YGrid','on');
% g.set_layout_options('legend',false);
% 
% g.set_order_options('lightness',{'9','12','15'},'color',{'sac', 'reach'});
% g.set_names('lightness','','color','','column','');
% g.geom_hline('yintercept',0);
% g.set_title(title);
% 
% g.update('x',fit_cat.period,'y',fit_cat.fitted,'ymax',fit_cat.upr,'ymin',fit_cat.lwr,'color',fit_cat.effector,'lightness',fit_cat.delay,'subset',fit_cat.voi_number< 120 & fit_cat.hemi == 'rh')
% g.facet_wrap(fit_cat.voi,'ncols',3);
% g.geom_interval('geom',{'bar','black_errorbar'});
% g.set_color_options('legend','separate');
% 
% g.draw;
%% with SIMPLE MEANS
%% Bar plots EARLY and LATE
title = 'simple group means - medial frontal cortex, left hemisphere';
% left hemisphere
figure ('Position', [100 100 1600 1000],'Name',title);
g = gramm('x',tt.period,'y',tt.diff,'color',tt.cond_delay,'subset',tt.voi_number< 20 & tt.hemi == 'lh')
g.facet_wrap(tt.voi,'ncols',3);
g.geom_jitter('width',0.025,'dodge',0.6,'alpha',0.4);
g.set_color_options('chroma',0);
g.set_point_options('base_size',4);
g.axe_property('YGrid','on');
g.set_layout_options('legend',false);

g.set_order_options('lightness',{'9','12','15'},'color',{'sac', 'reach'});
g.set_names('lightness','','color','','column','','y','diff % BOLD change');
g.geom_hline('yintercept',0);
g.set_title(title);

g.update('x',tt.period,'y',tt.diff,'color',tt.cond,'lightness',tt.delay,'subset',tt.voi_number< 120 & tt.hemi == 'lh')
g.stat_summary('geom',{'bar','black_errorbar'});
g.set_color_options('legend','separate');

g.draw;

if export
    g.export('file_name',title,...
        'export_path',export_path,...
        'file_type','pdf');
    
    close(title)
end
%% 
title = 'simple group means - medial frontal cortex, right hemisphere';
% right hemisphere
figure ('Position', [100 100 1600 1000],'Name',title);
g = gramm('x',tt.period,'y',tt.diff,'color',tt.cond_delay,'subset',tt.voi_number< 120 & tt.hemi == 'rh')

g.facet_wrap(tt.voi,'ncols',3);
g.geom_jitter('width',0.025,'dodge',0.6,'alpha',0.4);
g.set_color_options('chroma',0);
g.set_point_options('base_size',4);
g.axe_property('YGrid','on');
g.set_layout_options('legend',false);

g.set_order_options('lightness',{'9','12','15'},'color',{'sac', 'reach'});
g.set_names('lightness','','color','','column','');
g.geom_hline('yintercept',0);
g.set_title(title);

g.update('x',tt.period,'y',tt.diff,'color',tt.cond,'lightness',tt.delay,'subset',tt.voi_number< 120 & tt.hemi == 'rh')
g.stat_summary('geom',{'bar','black_errorbar'});
g.set_color_options('legend','separate');

g.draw;

if export
    g.export('file_name',title,...
        'export_path',export_path,...
        'file_type','pdf');
    
    close(title)
end

%% VIOLINE PLOT
% left hemisphere

title = 'distribution - left hemisphere';
figure ('Position', [100 100 1600 1000],'Name',title);
g = gramm('x',tt.period,'y',tt.diff,'color',tt.cond,'lightness',tt.delay,'subset',tt.hemi == 'lh')
g.facet_wrap(tt.voi,'ncols',4);
%g.stat_summary('geom',{'area', 'point'},'setylim',true);
%g.stat_summary('geom',{'line', 'point', 'errorbar'},'setylim',true,'dodge',0.2);
%g.stat_summary('geom',{'bar', 'black_errorbar'},'setylim',true,'dodge',0.7);
g.stat_violin('fill','edge','dodge',0.8);
g.stat_boxplot('width',0.2,'dodge',0.8);
%g.stat_glm('geom','area');
%g.axe_property('YLim',[0 0.25]);
g.axe_property('YGrid','on');
%g.set_color_options('map',[ 0.1020, 0.5882, 0.2549; 0.8431, 0.0980, 0.1098],'n_color',2,'n_lightness',1);

g.set_order_options('lightness',{'9','12','15'},'color',{'sac', 'reach'});
g.set_names('color','','column','');
g.geom_hline('yintercept',0);
g.set_title(title);
g.draw;

if export
    g.export('file_name',title,...
        'export_path',export_path,...
        'file_type','pdf');
    
    close(title)
end

    
%%
% right hemisphere
title = 'distribution - right hemisphere';
figure ('Position', [100 100 1600 1000],'Name',title);
g = gramm('x',tt.period,'y',tt.diff,'color',tt.cond,'lightness',tt.delay,'subset',tt.hemi == 'rh')
g.facet_wrap(tt.voi,'ncols',3);
%g.stat_summary('geom',{'area', 'point'},'setylim',true);
%g.stat_summary('geom',{'line', 'point', 'errorbar'},'setylim',true,'dodge',0.2);
%g.stat_summary('geom',{'bar', 'black_errorbar'},'setylim',true,'dodge',0.7);
g.stat_violin('fill','edge','dodge',0.8);
g.stat_boxplot('width',0.2,'dodge',0.8);
%g.stat_glm('geom','area');
%g.axe_property('YLim',[0 0.25]);
g.axe_property('YGrid','on');
%g.set_color_options('map',[ 0.1020, 0.5882, 0.2549; 0.8431, 0.0980, 0.1098],'n_color',2,'n_lightness',1);

g.set_order_options('lightness',{'9','12','15'},'color',{'sac', 'reach'});
g.set_names('color','','column','');
g.geom_hline('yintercept',0);
g.set_title(title);
g.draw;

if export
    g.export('file_name',title,...
        'export_path',export_path,...
        'file_type','pdf');
    
    close(title)
end

%% ONLY LATE
% %% Group Plots with fitted values
% % left hemisphere
% figure;
% g = gramm('x',tt.delay,'y',tt.diff,'group',tt.subj,'row',tt.cond,'column',tt.voi,'subset',tt.voi_number< 20 & tt.hemi == 'lh' & tt.period == 'late')
% %g.stat_summary('geom',{'area', 'point'},'setylim',true);
% g.stat_summary('geom',{'line'},'setylim',true,'dodge',0.2);
% %g.stat_summary('geom',{'bar', 'black_errorbar'},'setylim',true,'dodge',0.7);
% %g.stat_glm('geom','area');
% %g.axe_property('YLim',[0 0.25]);
% 
% g.axe_property('YGrid','on');
% g.set_color_options('chroma',0,'lightness',75);
% 
% g.set_order_options('x',{'9','12','15'});
% g.set_names('column','','row','','color','');
% g.geom_hline('yintercept',0);
% g.set_title('Areas of Medial Frontal Cortex');
% 
% g.update('x',fit_cat.delay,'y',fit_cat.fitted,'ymax',fit_cat.upr,'ymin',fit_cat.lwr,'color',fit_cat.effector,'group','','row',fit_cat.effector,'column',fit_cat.voi,'subset',fit_cat.voi_number< 20 & fit_cat.hemi == 'lh' & fit_cat.period == 'late')
% g.geom_interval('geom',{'area'},'dodge',0.2);
% g.set_color_options('map',[ 0.1020, 0.5882, 0.2549; 0.8431, 0.0980, 0.1098],'n_color',2,'n_lightness',1);
% g.set_order_options('x',{'9','12','15'});
% g.draw;


%% ONLY LATE
%% Group Plots
title = 'simple group means, late period - medial frontal cortex, left hemisphere';
% left hemisphere
figure ('Position', [100 100 1600 1000],'Name',title);
g = gramm('x',tt.delay,'y',tt.diff,'group',tt.subj,'row',tt.cond,'column',tt.voi,'subset',tt.voi_number< 20 & tt.hemi == 'lh' & tt.period == 'late');
%g.stat_summary('geom',{'area', 'point'},'setylim',true);
g.stat_summary('geom',{'line'},'setylim',true,'dodge',0.2);
%g.stat_summary('geom',{'bar', 'black_errorbar'},'setylim',true,'dodge',0.7);
%g.stat_glm('geom','area');
%g.axe_property('YLim',[0 0.25]);

g.axe_property('YGrid','on');
g.set_color_options('chroma',0,'lightness',75);

g.set_order_options('x',{'9','12','15'});
g.set_names('column','','row','','color','');
g.geom_hline('yintercept',0);
g.set_title(title);

g.update('x',tt.delay,'y',tt.diff,'color',tt.cond,'group','','row',tt.cond,'column',tt.voi,'subset',tt.voi_number< 20 & tt.hemi == 'lh' & tt.period == 'late')
g.stat_summary('geom',{'line', 'point','area'},'dodge',0.2);
g.set_color_options('map',[ 0.1020, 0.5882, 0.2549; 0.8431, 0.0980, 0.1098],'n_color',2,'n_lightness',1);
g.set_order_options('x',{'9','12','15'});
g.draw;

if export
    g.export('file_name',title,...
        'export_path',export_path,...
        'file_type','pdf');
    
    close(title)
end


%%
title = 'simple group means, late period - medial frontal cortex, right hemisphere';
% right hemisphere
figure ('Position', [100 100 1600 1000],'Name',title);
g = gramm('x',tt.delay,'y',tt.diff,'group',tt.subj,'row',tt.cond,'column',tt.voi,'subset',tt.voi_number< 120 & tt.hemi == 'rh' & tt.period == 'late')
%g.stat_summary('geom',{'area', 'point'},'setylim',true);
g.stat_summary('geom',{'line'},'setylim',true,'dodge',0.2);
%g.stat_summary('geom',{'bar', 'black_errorbar'},'setylim',true,'dodge',0.7);
%g.stat_glm('geom','area');
%g.axe_property('YLim',[0 0.25]);

g.axe_property('YGrid','on');
g.set_color_options('chroma',0,'lightness',75);

g.set_order_options('x',{'9','12','15'});
g.set_names('column','','row','','color','');
g.geom_hline('yintercept',0);
g.set_title(title);

g.update('x',tt.delay,'y',tt.diff,'color',tt.cond,'group','','row',tt.cond,'column',tt.voi,'subset',tt.voi_number< 120 & tt.hemi == 'rh' & tt.period == 'late')
g.stat_summary('geom',{'line', 'point','area'},'dodge',0.2);
g.set_color_options('map',[ 0.1020, 0.5882, 0.2549; 0.8431, 0.0980, 0.1098],'n_color',2,'n_lightness',1);
g.set_order_options('x',{'9','12','15'});
g.draw;

if export
    g.export('file_name',title,...
        'export_path',export_path,...
        'file_type','pdf');
    
    close(title)
end

%%  ++++++++++++++++++  OTHER AREAS +++++++++++++++++++++

%% ONLY LATE
%% Group Plots
% left hemisphere
title = 'simple group means, late period - other areas, left hemisphere';
figure ('Position', [100 100 1600 1000],'Name',title);
g = gramm('x',tt.delay,'y',tt.diff,'group',tt.subj,'row',tt.cond,'column',tt.voi,'subset',tt.voi_number>= 20 & tt.hemi == 'lh' & tt.period == 'late');
%g.stat_summary('geom',{'area', 'point'},'setylim',true);
g.stat_summary('geom',{'line'},'setylim',true,'dodge',0.2);
%g.stat_summary('geom',{'bar', 'black_errorbar'},'setylim',true,'dodge',0.7);
%g.stat_glm('geom','area');
%g.axe_property('YLim',[0 0.25]);

g.axe_property('YGrid','on');
g.set_color_options('chroma',0,'lightness',75);

g.set_order_options('x',{'9','12','15'});
g.set_names('column','','row','','color','');
g.geom_hline('yintercept',0);
g.set_title(title);

g.update('x',tt.delay,'y',tt.diff,'color',tt.cond,'group','','row',tt.cond,'column',tt.voi,'subset',tt.voi_number>= 20 & tt.hemi == 'lh' & tt.period == 'late')
g.stat_summary('geom',{'line', 'point','area'},'dodge',0.2);
g.set_color_options('map',[ 0.1020, 0.5882, 0.2549; 0.8431, 0.0980, 0.1098],'n_color',2,'n_lightness',1);
g.set_order_options('x',{'9','12','15'});
g.draw;

if export
    g.export('file_name',title,...
        'export_path',export_path,...
        'file_type','pdf');
    
    close(title)
end

%%
% right hemisphere
title = 'simple group means, late period - other areas, right hemisphere';
figure ('Position', [100 100 1600 1000],'Name',title);
g = gramm('x',tt.delay,'y',tt.diff,'group',tt.subj,'row',tt.cond,'column',tt.voi,'subset',tt.voi_number>= 120 & tt.hemi == 'rh' & tt.period == 'late')
%g.stat_summary('geom',{'area', 'point'},'setylim',true);
g.stat_summary('geom',{'line'},'setylim',true,'dodge',0.2);
%g.stat_summary('geom',{'bar', 'black_errorbar'},'setylim',true,'dodge',0.7);
%g.stat_glm('geom','area');
%g.axe_property('YLim',[0 0.25]);

g.axe_property('YGrid','on');
g.set_color_options('chroma',0,'lightness',75);

g.set_order_options('x',{'9','12','15'});
g.set_names('column','','row','','color','');
g.geom_hline('yintercept',0);
g.set_title(title);

g.update('x',tt.delay,'y',tt.diff,'color',tt.cond,'group','','row',tt.cond,'column',tt.voi,'subset',tt.voi_number>= 120 & tt.hemi == 'rh' & tt.period == 'late')
g.stat_summary('geom',{'line', 'point','area'},'dodge',0.2);
g.set_color_options('map',[ 0.1020, 0.5882, 0.2549; 0.8431, 0.0980, 0.1098],'n_color',2,'n_lightness',1);
g.set_order_options('x',{'9','12','15'});
g.draw;

if export
    g.export('file_name',title,...
        'export_path',export_path,...
        'file_type','pdf');
    
    close(title)
end


%%
if 0 
figure;
g = gramm('x',tt.delay,'y',tt.diff,'group',tt.subj,'row',tt.cond,'column',tt.voi,'subset',tt.voi_number< 20 & tt.hemi == 'lh' & tt.period == 'late')
%g.stat_summary('geom',{'area', 'point'},'setylim',true);
%g.stat_summary('geom',{'line'},'setylim',true,'dodge',0.2);
%g.stat_summary('geom',{'bar', 'black_errorbar'},'setylim',true,'dodge',0.7);
g.stat_glm('geom','line');
%g.axe_property('YLim',[0 0.25]);

g.axe_property('YGrid','on');
g.set_color_options('chroma',0,'lightness',75);

g.set_order_options('x',{'9','12','15'});
g.set_names('column','','row','','color','');
g.geom_hline('yintercept',0);
g.set_title('Late Period, Other Areas');

g.update('x',tt.delay,'y',tt.diff,'color',tt.cond,'group','','row',tt.cond,'column',tt.voi,'subset',tt.voi_number< 20 & tt.hemi == 'lh' & tt.period == 'late')
%g.stat_summary('geom',{'line', 'point','area'},'dodge',0.2);
g.stat_glm('geom','area');
g.set_color_options('map',[ 0.1020, 0.5882, 0.2549; 0.8431, 0.0980, 0.1098],'n_color',2,'n_lightness',1);
g.set_order_options('x',{'9','12','15'});
g.draw;

%% 
%% ONLY FITTED ALL AREAS
%% left hemisphere

figure ('Position', [100 100 1600 1000],'Name','fitted values - medial frontal cortex, left hemisphere');
g = gramm('x',fit_cat.period,'y',fit_cat.fitted,'ymin',fit_cat.lwr,'ymax',fit_cat.upr,'color',fit_cat.effector,'column',fit_cat.voi,'lightness',fit_cat.delay,'subset', fit_cat.hemi == 'lh')
g.facet_wrap(fit_cat.voi,'ncols',4);
g.geom_interval('geom',{'bar','black_errorbar'});
g.set_order_options('lightness',{'9','12','15'});
g.geom_hline('yintercept',0);
g.axe_property('YGrid',true);
g.set_title('fitted values - medial frontal cortex, left hemisphere');
%g.set_color_options('map',[ 0.1020, 0.5882, 0.2549; 0.8431, 0.0980, 0.1098],'n_color',2,'n_lightness',1);
g.draw;


figure ('Position', [100 100 1600 1000],'Name','fitted values - medial frontal cortex, right hemisphere');
g = gramm('x',fit_cat.period,'y',fit_cat.fitted,'ymin',fit_cat.lwr,'ymax',fit_cat.upr,'color',fit_cat.effector,'column',fit_cat.voi,'lightness',fit_cat.delay,'subset', fit_cat.hemi == 'rh')
g.facet_wrap(fit_cat.voi,'ncols',4);
g.geom_interval('geom',{'bar','black_errorbar'});
g.set_order_options('lightness',{'9','12','15'});
g.geom_hline('yintercept',0);
g.axe_property('YGrid',true);
g.set_title('fitted values - medial frontal cortex, right hemisphere');
%g.set_color_options('map',[ 0.1020, 0.5882, 0.2549; 0.8431, 0.0980, 0.1098],'n_color',2,'n_lightness',1);
g.draw;
end


%% %%%%%%%%%%% EXPORT FOR PAPER

%% numerical delay

fit_num.hemi_long = renamecats(fit_num.hemi,{'lh','rh'},{'left','right'});
fit_num.voi_fig = cell(length(fit_num.hemi),1);
for i = 1:length(fit_num.hemi)
    
   fit_num.voi_fig{i} = [char(fit_num.voi_short(i)),' ',char(fit_num.hemi_long(i))];
end

%% left
subset = fit_num.hemi == 'lh';
sor = sortrows(unique(table(fit_num.voi_fig(subset), fit_num.voi_number(subset))),2);

title = 'Model 2: Choice Effect over time - left hemisphere';
figure ('Position', [100 100 800 1000]);
g = gramm('x',fit_num.period,'y',fit_num.fitted,'ymin',fit_num.lwr,'ymax',fit_num.upr,'color',fit_num.effector,'column',fit_num.voi,'lightness',fit_num.delay,'subset',subset);
g.facet_wrap(fit_num.voi_fig,'ncols',3);
g.geom_interval('geom',{'bar','black_errorbar'},'width',0.6,'dodge',0.7);
g.set_order_options('lightness',{'9','12','15'});
%g.geom_hline('yintercept',0);
g.axe_property('YGrid',true,'YLim',[-0.1 0.3]);
g.set_title(title);
g.set_color_options('lightness_range',[40 80],'chroma_range',[80 40],'hue_range',[25 230]);
g.set_order_options('lightness',{'9','12','15'},'color',{'sac', 'reach'},'column',sor.Var1);
g.set_names('lightness','','color','','column','','y','diff % BOLD change','x','period');
g.set_text_options('base_size', 14,'facet_scaling',0.8,'title_scaling',1.1,'legend_scaling',0.75,'label_scaling',0.95);
g.set_line_options('base_size',1.2);
g.set_layout_options('legend_width',0.2,'legend_position',[0.86 0.07 0.2 0.17],'redraw',false,'margin_height',[0.1 0.15],'margin_width',[0.1 0.02],'gap',[0.03 0.06],'title_centering','plot');
%g.set_layout_options('legend',false,'title_centering','axes','redraw',false,'gap',[0.03, 0.03]);
%g.set_layout_options('legend',false,'title_centering','plot');
g.draw(false);


if 1
    g.export('file_name','model 2 left',...
        'export_path','Y:\Personal\Peter\writing up',...
        'file_type','jpg');
    
  
end


%% right

subset = fit_num.hemi == 'rh';
sor = sortrows(unique(table(fit_num.voi_fig(subset), fit_num.voi_number(subset))),2);

title = 'Model 2: Choice Effect over time - right hemisphere';
figure ('Position', [100 100 800 1000],'Name','Figure 1');
g = gramm('x',fit_num.period,'y',fit_num.fitted,'ymin',fit_num.lwr,'ymax',fit_num.upr,'color',fit_num.effector,'column',fit_num.voi,'lightness',fit_num.delay,'subset',subset);
g.facet_wrap(fit_num.voi_fig,'ncols',3);
g.geom_interval('geom',{'bar','black_errorbar'},'width',0.6,'dodge',0.7);
g.set_order_options('lightness',{'9','12','15'});
%g.geom_hline('yintercept',0);
g.axe_property('YGrid',true,'YLim',[-0.1 0.3]);
g.set_title(title);
g.set_color_options('lightness_range',[40 80],'chroma_range',[80 40],'hue_range',[25 230]);
g.set_order_options('lightness',{'9','12','15'},'color',{'sac', 'reach'},'column',sor.Var1);
g.set_names('lightness','','color','','column','','y','diff % BOLD change','x','period');
g.set_text_options('base_size', 14,'facet_scaling',0.8,'title_scaling',1.1,'legend_scaling',0.75,'label_scaling',0.95);
g.set_line_options('base_size',1.2);
g.set_layout_options('legend_width',0.2,'legend_position',[0.86 0.07 0.2 0.17],'redraw',false,'margin_height',[0.1 0.15],'margin_width',[0.1 0.02],'gap',[0.03 0.06],'title_centering','plot');
%g.set_layout_options('legend',false,'title_centering','axes','redraw',false,'gap',[0.03, 0.03]);
%g.set_layout_options('legend',false,'title_centering','plot');
g.draw(false);


if 1
    g.export('file_name','model 2 right',...
        'export_path','Y:\Personal\Peter\writing up',...
        'file_type','jpg');
    
    close('Figure 1')
end

%%
title = 'distribution - left hemisphere';
figure ('Position', [100 100 1600 1000],'Name',title);
g = gramm('x',tt.period,'y',tt.diff,'color',tt.cond,'lightness',tt.delay,'subset',tt.hemi == 'lh')
g.facet_wrap(tt.voi,'ncols',4);
%g.stat_summary('geom',{'area', 'point'},'setylim',true);
%g.stat_summary('geom',{'line', 'point', 'errorbar'},'setylim',true,'dodge',0.2);
%g.stat_summary('geom',{'bar', 'black_errorbar'},'setylim',true,'dodge',0.7);
g.stat_violin('fill','edge','dodge',0.8);
g.stat_boxplot('width',0.2,'dodge',0.8);
%g.stat_glm('geom','area');
%g.axe_property('YLim',[0 0.25]);
g.axe_property('YGrid','on');
%g.set_color_options('map',[ 0.1020, 0.5882, 0.2549; 0.8431, 0.0980, 0.1098],'n_color',2,'n_lightness',1);

g.set_order_options('lightness',{'9','12','15'},'color',{'sac', 'reach'});
g.set_names('color','','column','');
g.geom_hline('yintercept',0);
g.set_title(title);
g.draw;

if export
    g.export('file_name',title,...
        'export_path',export_path,...
        'file_type','pdf');
    
    close(title)
end


%% DIFFERENT SORTING of EXPORT PLOTS
% %% LEFT Medial Frontal Cortex
% subset = fit_num.location < 20 & fit_num.hemi == 'lh' ;
% sor = sortrows(unique(table(fit_num.voi_fig(subset), fit_num.voi_number(subset))),2);
% 
% title = 'CE_time_Medial Frontal Cortex - Left Hemisphere';
% figure ('Position', [100 100 800 500],'Name',title);
% g = gramm('x',fit_num.period,'y',fit_num.fitted,'ymin',fit_num.lwr,'ymax',fit_num.upr,'color',fit_num.effector,'column',fit_num.voi,'lightness',fit_num.delay,'subset',subset);
% g.facet_wrap(fit_num.voi_fig,'ncols',3);
% g.geom_interval('geom',{'bar','black_errorbar'},'width',0.6,'dodge',0.7);
% g.set_order_options('lightness',{'9','12','15'});
% %g.geom_hline('yintercept',0);
% g.axe_property('YGrid',true,'YLim',[-0.1 0.3]);
% %g.set_title(title);
% %g.set_color_options('map',[ 0.1020, 0.5882, 0.2549; 0.8431, 0.0980, 0.1098],'n_color',2,'n_lightness',1);
% g.set_color_options('lightness_range',[40 80],'chroma_range',[80 40],'hue_range',[25 230]);
% g.set_order_options('lightness',{'9','12','15'},'color',{'sac', 'reach'},'column',sor.Var1);
% g.set_names('lightness','','color','','column','','y','diff % BOLD change','x','period');
% g.set_text_options('base_size', 12,'facet_scaling',1,'title_scaling',1.1,'legend_scaling',0.9,'label_scaling',0.95);
% g.set_line_options('base_size',1.2);
% %g.set_layout_options('legend',false,'redraw',false,'margin_height',[0.02 0.05],'margin_width',[0.1 0.02]);
% %g.set_layout_options('legend',false,'title_centering','axes','redraw',false,'gap',[0.03, 0.03]);
% g.set_layout_options('legend_position',[0.8 0.08 0.2 0.4],'title_centering','plot','redraw_gap',0.02);
% g.draw;
% 
% if 1
%     g.export('file_name',title,...
%         'export_path','Y:\Personal\Peter\writing up',...
%         'file_type','jpg');
%     
%     close(title)
% end
% 
% %% RIGHT Medial Frontal Cortex
% subset = fit_num.location < 20 & fit_num.hemi == 'rh' ;
% sor = sortrows(unique(table(fit_num.voi_fig(subset), fit_num.voi_number(subset))),2);
% 
% title = 'CE_time_Medial Frontal Cortex - Right Hemisphere';
% figure ('Position', [100 100 800 500],'Name',title);
% g = gramm('x',fit_num.period,'y',fit_num.fitted,'ymin',fit_num.lwr,'ymax',fit_num.upr,'color',fit_num.effector,'column',fit_num.voi,'lightness',fit_num.delay,'subset',subset);
% g.facet_wrap(fit_num.voi_fig,'ncols',3);
% g.geom_interval('geom',{'bar','black_errorbar'},'width',0.6,'dodge',0.7);
% g.set_order_options('lightness',{'9','12','15'});
% %g.geom_hline('yintercept',0);
% g.axe_property('YGrid',true,'YLim',[-0.1 0.3]);
% %g.set_title(title);
% g.set_color_options('lightness_range',[40 80],'chroma_range',[80 40],'hue_range',[25 230]);
% g.set_order_options('lightness',{'9','12','15'},'color',{'sac', 'reach'},'column',sor.Var1);
% g.set_names('lightness','','color','','column','','y','diff % BOLD change','x','period');
% g.set_text_options('base_size', 12,'facet_scaling',1,'title_scaling',1.1,'legend_scaling',0.9,'label_scaling',0.95);
% g.set_line_options('base_size',1.2);
% %g.set_layout_options('legend',false,'redraw',false,'margin_height',[0.02 0.05],'margin_width',[0.1 0.02]);
% %g.set_layout_options('legend',false,'title_centering','axes','redraw',false,'gap',[0.03, 0.03]);
% g.set_layout_options('legend',false,'title_centering','plot','redraw_gap',0.02);
% %g.set_layout_options('legend',false,'redraw',false,'margin_height',[0.1 0.07],'margin_width',[0.1 0.02],'gap',[0.02 0.05]);
% 
% g.draw;
% 
% if 1
%     g.export('file_name',title,...
%         'export_path','Y:\Personal\Peter\writing up',...
%         'file_type','jpg');
%     
%     close(title)
% end
% 
% %% Other Areas
% subset = fit_num.location >= 20 ;
% sor = sortrows(unique(table(fit_num.voi_fig(subset), fit_num.voi_number(subset))),2);
% 
% title = 'CE_time_Other Areas';
% figure ('Position', [100 100 800 1000],'Name',title);
% g = gramm('x',fit_num.period,'y',fit_num.fitted,'ymin',fit_num.lwr,'ymax',fit_num.upr,'color',fit_num.effector,'column',fit_num.voi,'lightness',fit_num.delay,'subset',subset);
% g.facet_wrap(fit_num.voi_fig,'ncols',3);
% g.geom_interval('geom',{'bar','black_errorbar'},'width',0.6,'dodge',0.7);
% g.set_order_options('lightness',{'9','12','15'});
% %g.geom_hline('yintercept',0);
% g.axe_property('YGrid',true,'YLim',[-0.1 0.3]);
% %g.set_title(title);
% g.set_color_options('lightness_range',[40 80],'chroma_range',[80 40],'hue_range',[25 230]);
% g.set_order_options('lightness',{'9','12','15'},'color',{'sac', 'reach'},'column',sor.Var1);
% g.set_names('lightness','','color','','column','','y','diff % BOLD change','x','period');
% g.set_text_options('base_size', 14,'facet_scaling',0.8,'title_scaling',1.1,'legend_scaling',0.9,'label_scaling',0.95);
% g.set_line_options('base_size',1.2);
% g.set_layout_options('legend',false,'redraw',false,'margin_height',[0.1 0.07],'margin_width',[0.1 0.02],'gap',[0.02 0.05]);
% %g.set_layout_options('legend',false,'title_centering','axes','redraw',false,'gap',[0.03, 0.03]);
% %g.set_layout_options('legend',false,'title_centering','plot');
% g.draw(false);
% 
% 
% if 1
%     g.export('file_name',title,...
%         'export_path','Y:\Personal\Peter\writing up',...
%         'file_type','jpg');
%     
%     close(title)
% end
% 


%% 












