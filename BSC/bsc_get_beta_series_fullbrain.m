function betaseries=bsc_get_beta_series_fullbrain(glm, voi, conditions)
%computes beta series per condition and saves condition plots
%expects predictor names in rXX_condition_XX format
%example usage 
if ~isxff(glm)
    glm = xff(glm);
end
if ~isxff(voi)
    voi = xff(voi);
end

%prettier labelling (removes number and combined/Clusterinfo, exchanges
%abbreviation for full name)
voinames = voi.VOI;
if isunix
    load('/mnt/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/CHARM_SARM/CHARMSARMkeycombined.mat') %make path windowscompatible
elseif ispc
    load('Y:\Personal\AlexandraWitt\CHARM_SARM\CHARMSARMkeycombined.mat')
end
for i = 1:height(chiffre)
    for j = 1:length({voinames.Name})
        if regexp(voinames(j).Name, sprintf('%s_%s_%s', '\d*', chiffre.Abbreviation{i}, 'l')) & strfind(voinames(j).Name, num2str(chiffre.Index(i)))
            voinames(j).Name = sprintf('%s-%s-%s', num2str(chiffre.Index(i)), chiffre.Full_Name{i},'left');
        elseif regexp(voinames(j).Name, sprintf('%s_%s_%s', '\d*', chiffre.Abbreviation{i}, 'r')) & strfind(voinames(j).Name, num2str(chiffre.Index(i)))
                        voinames(j).Name = sprintf('%s-%s-%s', num2str(chiffre.Index(i)),chiffre.Full_Name{i},'right');
        end
    end
end
left = strfind({voinames.Name}, 'left');
left(cellfun(@(x) isempty(x),left))={0};
left = cell2mat(left);
left = find(left);
right = setdiff(1:length(voinames),left);
neworder = [left, right];
voinames = voinames( :,neworder);
voi.VOI = voinames;



betas = squeeze(glm.VOIBetas(voi)); %outputs a PredsxVOI matrix
x = glm.Predictor;
names = {x.Name2};

%gets indices of the conditions
idx={};
for i = 1:length(conditions)
    idx(i,:) = regexp(names, sprintf('%s-%s-%s', 'r\d*', conditions{i}, '\d*'));
end
idx(cellfun('isempty',idx))={0};
idx=logical(cell2mat(idx));

%gets betaseries
betaseries = {};
for i = 1:length(conditions)
    betaseries{i} = betas(idx(i,:),:);
end

%old piece of code that checks for NaNs - should not do anything if VOIs
%are properly thresholded (test_voi_brightness)
for i = 1:length(conditions)
    rm = [];
    for j = 1:size(betaseries{i},2)
        if any(isnan(betaseries{i}(:,j)))
            rm = [rm j];
        end
    end
    betaseries{i}(:,rm) = []; 
     if ~isempty(rm)
         warning('Removed for NaN:\n %s \n', voinames(rm).Name)
     end     
end
voinames(rm) = [];

for i = 1:length(betaseries)
    [corr,P] = corrcoef(betaseries{i}, 'rows', 'pairwise');
    corr(P>0.05) = 0; %removes "non-significant" correlations
    imagesc(corr)
    line(length(left)+0.5+zeros(1,size(betaseries{i},2)+1),0:size(betaseries{i},2),'Color','black')
    line(0:size(betaseries{i},2),length(left)+0.5+zeros(1,size(betaseries{i},2)+1),'Color','black')
% set(gca, 'XTick', [0.5,28.5,49.5,75.5,82.5,112.5,133.5,158.5]);BA L5
% set(gca, 'YTick', [0.5,28.5,49.5,75.5,82.5,112.5,133.5,158.5]);BA L5
    set(gca, 'XTick', [0.5,28.5,49.5,71.5,78.5,107.5,128.5,148.5]);
    set(gca, 'YTick', [0.5,28.5,49.5,71.5,78.5,107.5,128.5,148.5]);
    set(gca, 'XTickLabel',{'Frontal left','Parietal left','Temporal left', 'Occipital left', 'Frontal right','Parietal right', 'Temporal right', 'Occipital right'})
    set(gca, 'YTickLabel',{'Frontal left','Parietal left','Temporal left', 'Occipital left', 'Frontal right','Parietal right', 'Temporal right', 'Occipital right'})
    set(gca, 'YDir', 'reverse');
    colormap(redblue) %uses https://de.mathworks.com/matlabcentral/fileexchange/25536-red-blue-colormap
    caxis([-1,1]);
    rotateXLabels(gca, 45);
    title(conditions{i}, 'FontSize', 10); 
    colorbar; % 
end
end




