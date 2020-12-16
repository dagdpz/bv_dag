function era = ne_era_frd_create_difference_timecourse(era_file,cond_diff)
% takes a single era file at a time
% make sure condition names are fitting:
% {'choi', 'instr'; 
%  'left', 'right';
%  'reach' 'sac'}
% left minus right cell, for each row
% cond_diff = {'choi', 'instr'; 'left', 'right';'reach' 'sac'};

%%
load(era_file);
% 'Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI\ANEL\mat2prt_reach_decision_vardelay_foravg\ANEL_era_cue_12_no_outliers.mat'
%%
cond_cell ={};
id = [];
for i = 1:size(era.avg.Curve,2)
    name = strsplit(era.avg.Curve(i).Name,'_'); 
    cond_cell(i,:) = name(1:3)'
    id = [id; i];
    
end

cond_cell(strcmp('l',cond_cell)) = {'left'};
cond_cell(strcmp('r',cond_cell)) = {'right'};


% 
cond_table = table();
cond_table = cell2table(cond_cell);
cond_table.id = id;

%%
for p = 1:size(cond_diff,1) 
    % which condition pair
    tb_diff = cond_diff(p,:);
    
    % get column of that pair
    [~,col_minu] = find(strcmp(tb_diff{1},cond_cell));
    [~,col_subtra] = find(strcmp(tb_diff{2},cond_cell));
    
    sel_col = unique([col_minu; col_subtra]);
    
    if length(sel_col)>1
        disp('There is more than one column with those variable names. Stopped here');
        break;
    end
    % find rows for minuend and subtrahend tables
    minu_table   = cond_table(strcmp(tb_diff{1},cond_table{:,sel_col}),:);
    subtra_table = cond_table(strcmp(tb_diff{2},cond_table{:,sel_col}),:);
    
    % find remaining condition colum names
    var_names = cond_table.Properties.VariableNames;
    var_names = var_names(1:end-1);
    ind_var_names = logical(ones(1,length(var_names)));
    ind_var_names(sel_col) = 0;
    var_names = var_names(ind_var_names);
    
    % create joined table
    diff_table = join(minu_table,subtra_table,'Keys',var_names);
    cond = {};
    for jc = 1:height(diff_table) % loop through joined table
        
        for v = 1:size(era.mean,1) % loop vois
            diff_mean(v,jc,:) = era.mean(v,diff_table.id_minu_table(jc),:) - era.mean(v,diff_table.id_subtra_table(jc),:);
            %diff_se(v,jc,:) = 
            

            
        end
        
        cond{jc} = [char(diff_table{1,strcmp(var_names{1},diff_table.Properties.VariableNames)}) '_'...
            char(diff_table{1,strcmp(var_names{2},diff_table.Properties.VariableNames)})];
        
    end
    
    diff_conds = [tb_diff{1} '_' tb_diff{2}];
    
    
    era.diff.(diff_conds).diff_mean = diff_mean;
    % era.diff.(diff_conds).diff_se = diff_se;
    era.diff.(diff_conds).cond = cond;
end




 
    

