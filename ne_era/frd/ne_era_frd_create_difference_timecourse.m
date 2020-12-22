function era = ne_era_frd_create_difference_timecourse(era_file,cond_diff,incl_downsampled)
% takes a single era file at a time
% make sure condition names are fitting:
% left minus right cell, for each row
% cond_diff = {'choi', 'instr'; 'left', 'right';'reach' 'sac'};
% if one curve is empty, automatically creates NaNs for that curve

if nargin < 3
    incl_downsampled = 0;
end

% weighted sum of SE because potential test says both SEs are too
% different, see below
equal_variance = 1; % 0 


%%
% era_file = 'Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI\ANEL\mat2prt_reach_decision_vardelay_foravg\ANEL_era_cue_12_no_outliers.mat'
% era_file = 'Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI\CAST\mat2prt_reach_decision_vardelay_foravg\CAST_era_cue_3_no_outliers.mat'; one condition missing
load(era_file);

%%
cond_cell ={};
id = [];
for i = 1:size(era.avg.Curve,2)
    name = strsplit(era.avg.Curve(i).Name,'_'); 
    cond_cell(i,:) = name(1:3)';
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
    var_names = cond_table.Properties.VariableNames;    % all variable names
    var_names = var_names(1:end-1);                     % take away id
    ind_var_names = logical(ones(1,length(var_names))); %  create indx with same length
    ind_var_names(sel_col) = 0;                         % take out column with subtraction condition
    var_names = var_names(ind_var_names);               
    
    % create joined table
    diff_table = join(minu_table,subtra_table,'Keys',var_names);
    cond = {};
    for jc = 1:height(diff_table) % loop through joined table
        
        for v = 1:size(era.mean,1) % loop vois
             
            %% mean difference
            diff_mean(v,jc,:) = era.mean(v,diff_table.id_minu_table(jc),:) - era.mean(v,diff_table.id_subtra_table(jc),:);
            
            if incl_downsampled
                diff_mean_ds(v,jc,:) = era.mean_ds(v,diff_table.id_minu_table(jc),:) - era.mean_ds(v,diff_table.id_subtra_table(jc),:);
            end
            %% SE difference
            % before creating pooled variance, check if assumption of equal
            % variances
            if equal_variance == 1
                % see Fields, p. 374 -->  SE_diff = sqrt((SE_1)^2 + (SE_2)^2);
                diff_se(v,jc,:) = sqrt(era.se(v,diff_table.id_minu_table(jc),:).^2 + era.se(v,diff_table.id_subtra_table(jc),:).^2);
                
                if incl_downsampled
                    diff_se_ds(v,jc,:) = sqrt(era.se_ds(v,diff_table.id_minu_table(jc),:).^2 + era.se_ds(v,diff_table.id_subtra_table(jc),:).^2);
                end
                
                
            elseif equal_variance == 0
                % Levene Test (= BrownForsythe) for testing equal variance
                % for i = 1:length(era.mean(1,1,:)), 
                %       p(i) = vartestn([era.psc(1,2).perievents(i,:)',[era.psc(1,4).perievents(i,:)'; NaN(10,1)]],'TestType','BrownForsythe','Display','off');, 
                % end
                % see Fields, p. 374
                % sd_pooled = ((n_minu -1)*s_minu^2 + (n_subtra)*s_subtra^2) / (n_minu + n_subtra -2);
                
                for t = 1:size(era.mean,3)
                    
                    % check if one curve is empty to create a NaN
                    if isempty(era.psc(v,diff_table.id_minu_table(jc)).perievents) || isempty(era.psc(v,diff_table.id_subtra_table(jc)).perievents)
                        diff_se(v,jc,t) = NaN;
                    else
                        
                        n_minu = size(era.psc(v,diff_table.id_minu_table(jc)).perievents,2);
                        n_subtra = size(era.psc(v,diff_table.id_subtra_table(jc)).perievents,2);
                        
                        sd_pooled = ((n_minu  -1)*  std(era.psc(v,diff_table.id_minu_table(jc)).perievents(t,:)).^2 ...
                            + (n_subtra -1)*  std(era.psc(v,diff_table.id_subtra_table(jc)).perievents(t,:)).^2) / ...
                            (n_minu + n_subtra - 2);
                        
                        diff_se(v,jc,t) = sqrt(sd_pooled/n_minu + sd_pooled/n_subtra);
                    end
                    
                end
                
                if incl_downsampled
                    
                    for t = 1:size(era.mean_ds,3)
                        
                        % check if one curve is empty to create a NaN
                        if isempty(era.psc_ds(v,diff_table.id_minu_table(jc)).perievents) || isempty(era.psc_ds(v,diff_table.id_subtra_table(jc)).perievents)
                            diff_se_ds(v,jc,t) = NaN;
                        else
                            
                            n_minu = size(era.psc_ds(v,diff_table.id_minu_table(jc)).perievents,2);
                            n_subtra = size(era.psc_ds(v,diff_table.id_subtra_table(jc)).perievents,2);
                            
                            sd_pooled = ((n_minu  -1)*  std(era.psc_ds(v,diff_table.id_minu_table(jc)).perievents(t,:)).^2 ...
                                + (n_subtra -1)        *std(era.psc_ds(v,diff_table.id_subtra_table(jc)).perievents(t,:)).^2) / ...
                                (n_minu + n_subtra - 2);
                            
                            diff_se_ds(v,jc,t) = sqrt(sd_pooled/n_minu + sd_pooled/n_subtra);
                        end
                        
                    end
                end
            end
            
        end
        %% Condition name
        cond{jc} = [char(diff_table{jc,strcmp(var_names{1},diff_table.Properties.VariableNames)}) '_'...
            char(diff_table{jc,strcmp(var_names{2},diff_table.Properties.VariableNames)})];
        
    end
    
    %% putting it in file
    diff_conds = [tb_diff{1} '_' tb_diff{2}];
    
    
    era.diff.(diff_conds).diff_mean = diff_mean;
    era.diff.(diff_conds).diff_se = diff_se;
    era.diff.(diff_conds).cond = cond;
    
    if incl_downsampled
        era.diff.(diff_conds).diff_mean_ds = diff_mean_ds;
        era.diff.(diff_conds).diff_mean_ds = diff_se_ds;
    end
    
end




 
    

