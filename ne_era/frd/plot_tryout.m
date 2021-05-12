function plot_tryout

%% IMPORT Glassertable sheet 2 via gui
% vois = Glasser2016TableeditedS4;
% vois.Properties.VariableNames = {'number', 'location','occurence','voi_short','voi_detailed'};
% save('Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI\_combined_atlas\Glasser2016TableeditedS4.mat','vois')

load('Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI\_combined_atlas\Glasser2016TableeditedS4.mat');

%%
%load('Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI\stats\Exp_era_period_diff_choi_instr.mat');
load('Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI\stats\Exp_era_period_average.mat');

%tt = tt_ges;
%load('Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI\stats\Exp_era_period_diff_63-8BM_l_Cluster0001_-9_21_48_.mat');
%%
% tt.voi = cellstr(tt.voi);
% n_v = {};
% n_v_h = {};
% for i = 1:height(tt)
% 
%    name_parts = strsplit(tt.voi{i},'_');
%    
%    voi_name = strsplit(name_parts{1},'-');
%   
%    if length(voi_name) == 2
%        n_v(i) = {voi_name{2}};     
%    else
%        n_v(i) =  {[voi_name{2} '-' voi_name{3}]};       
%    end
%    
%    n_v_h(i) = {[n_v{i} '_' name_parts{2}]};
%    
% end
% 
% tt.voi_short = categorical(n_v');
% tt.voi = categorical(tt.voi);
% tt.voi_hemi = categorical(n_v_h');


%%

%%

tt.num_delay = str2num(char(cellstr(tt.delay)));
%%
subs = tt.location == 'Anterior_Cingulate_and_Medial_Prefrontal' | tt.location == 'Paracentral_Lobular_and_Mid_Cingulate';
subs2 =  tt.location == 'Anterior_Cingulate_and_Medial_Prefrontal' | tt.location == 'Paracentral_Lobular_and_Mid_Cingulate' | tt.location == 'Dorsolateral_Prefrontal';
%%
figure;
g = gramm('x',tt.period,'y',tt.diff,'color',tt.cond,'linestyle',tt.delay,'subset',tt.location == 'Paracentral_Lobular_and_Mid_Cingulate','column',tt.voi_hemi,'row',tt.delay);
%g.facet_wrap(tt.voi_hemi,'ncols',5);
g.stat_summary('geom',{'line', 'point', 'errorbar'},'setylim',true,'dodge',0.2);
%g.stat_summary('geom',{'line', 'point', 'errorbar'},'setylim',true);
%g.stat_summary('geom',{'bar', 'black_errorbar'},'setylim',true);
%g.stat_violin();
%g.stat_glm('geom','area');
%g.axe_property('YLim',[0 0.25]);
g.axe_property('YGrid','on');
g.set_color_options('map',[ 0.1020, 0.5882, 0.2549; 0.8431, 0.0980, 0.1098],'n_color',2,'n_lightness',1);

g.set_order_options('row',{'9','12','15'});
g.geom_hline('yintercept',0);
g.draw;
%%

figure;
g = gramm('x',tt.period,'y',tt.diff,'color',tt.delay,'linestyle',tt.delay,'subset',tt.location == 'Paracentral_Lobular_and_Mid_Cingulate','column',tt.voi_hemi,'row',tt.cond)
%g.facet_wrap(tt.voi_hemi,'ncols',5);
g.stat_summary('geom',{'line', 'point', 'errorbar'},'setylim',true,'dodge',0.2);
%g.stat_summary('geom',{'line', 'point', 'errorbar'},'setylim',true);
%g.stat_summary('geom',{'bar', 'black_errorbar'},'setylim',true);
%g.stat_violin();
%g.stat_glm('geom','area');
%g.axe_property('YLim',[0 0.25]);
g.axe_property('YGrid','on');
%g.set_color_options('map',[ 0.1020, 0.5882, 0.2549; 0.8431, 0.0980, 0.1098],'n_color',2,'n_lightness',1);

g.set_order_options('color',{'9','12','15'});
g.geom_hline('yintercept',0);
g.draw;








%%
tt2 = rowfun(@mean,tt,'InputVariables',{'diff'},'GroupingVariable', {'cond','period','subj','voi_hemi'},'OutputVariableNames','diff');

figure;
g = gramm('x',tt.period,'y',tt.diff,'subset',tt.location == 'Paracentral_Lobular_and_Mid_Cingulate','color',tt.cond)
g.facet_wrap(tt.voi_hemi,'ncols',5);
g.stat_summary('geom',{'line', 'point', 'errorbar'},'setylim',true,'dodge',0.2);
%g.stat_summary('geom',{'line', 'point', 'errorbar'},'setylim',true);
%g.stat_summary('geom',{'bar', 'black_errorbar'},'setylim',true);
%g.stat_violin();
%g.stat_glm('geom','area');
%g.axe_property('YLim',[0 0.25]);
g.axe_property('YGrid','on');
g.set_color_options('map',[ 0.1020, 0.5882, 0.2549; 0.8431, 0.0980, 0.1098],'n_color',2,'n_lightness',1);

%g.set_order_options('color',{'9','12','15'});
g.geom_hline('yintercept',0);
g.draw;


%%
%%
%%
%%

tt.voi_number = double(tt.voi_number);

figure;
g = gramm('x',tt.period,'y',tt.diff,'color',tt.cond,'linestyle',tt.delay,'column',tt.voi,'row',tt.delay,'subset',tt.voi_number< 20 & tt.hemi == 'rh')
%g.facet_wrap(tt.voi_hemi,'ncols',5);
%g.stat_summary('geom',{'line', 'point', 'errorbar'},'setylim',true,'dodge',0.2);
g.stat_summary('geom',{'line', 'point', 'errorbar'},'setylim',true);
%g.stat_summary('geom',{'bar', 'black_errorbar'},'setylim',true);
%g.stat_violin();
%g.stat_glm('geom','area');
%g.axe_property('YLim',[0 0.25]);
g.axe_property('YGrid','on');
g.set_color_options('map',[ 0.1020, 0.5882, 0.2549; 0.8431, 0.0980, 0.1098],'n_color',2,'n_lightness',1);

g.set_order_options('row',{'9','12','15'},'linestyle',{'9','12','15'});
g.geom_hline('yintercept',0);
g.draw;

%%
tt2 = rowfun(@mean,tt,'InputVariables',{'diff'},'GroupingVariable', {'cond','period','subj','voi'},'OutputVariableNames','diff');

figure;
g = gramm('x',tt2.period,'y',tt2.diff,'color',tt2.cond,'column',tt2.voi)
%g.facet_wrap(tt2.voi_hemi,'ncols',5);
g.stat_summary('geom',{'line', 'point', 'errorbar'},'setylim',true,'dodge',0.2);
%g.stat_summary('geom',{'line', 'point', 'errorbar'},'setylim',true);
%g.stat_summary('geom',{'bar', 'black_errorbar'},'setylim',true);
%g.stat_violin();
%g.stat_glm('geom','area');
%g.axe_property('YLim',[0 0.25]);
g.axe_property('YGrid','on');
g.set_color_options('map',[ 0.1020, 0.5882, 0.2549; 0.8431, 0.0980, 0.1098],'n_color',2,'n_lightness',1);

%g.set_order_options('color',{'9','12','15'});
g.geom_hline('yintercept',0);
g.draw;


%% THIS IS NOW FOR AVERAGE; BUT NOT DIFF
%%%%%%%%%
figure;
g = gramm('x',tt.eff,'y',tt.mean,'color',tt.choi,'lightness',tt.side,'subset',tt.location< 20 & tt.hemi == 'lh')
g.facet_wrap(tt.voi);
g.stat_summary('geom',{'bar','black_errorbar'},'setylim',true);
g.draw;


