function betaseries=get_beta_series(glm, voi, conditions)
%computes beta series per condition
%for now, expects rXX_condition/rXX_post_condition to find the indices
%properly
%conditions = {'memory left' 'memory right' 'memory left microstim' 'memory right microstim'};

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
        if regexp(voinames(j).Name, sprintf('%s_%s_%s_%s', '\d*', chiffre.Abbreviation{i}, 'l','\w*'))
            voinames(j).Name = sprintf('%s-%s-%s', num2str(chiffre.Index(i)), chiffre.Full_Name{i},'left');
        elseif regexp(voinames(j).Name, sprintf('%s_%s_%s_%s', '\d*', chiffre.Abbreviation{i}, 'r','\w*'))
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

% idx={};
% for i = 1:length(conditions)
%     idx(i,:) = regexp(names, sprintf('%s-%s-%s', 'r\d*', conditions{i}, '\d*'));
% end
% idx(cellfun('isempty',idx))={0};
% idx=logical(cell2mat(idx));
% 
% betaseries = {};
% for i = 1:length(conditions)
%     betaseries{i} = betas(idx(i,:),:);
% end

idx={cell(1,glm.NrOfStudies),cell(1,glm.NrOfStudies),cell(1,glm.NrOfStudies),cell(1,glm.NrOfStudies)};
for i = 1:length(conditions)
    for j = 1:glm.NrOfStudies
        idx{i}{j} = regexp(names, sprintf('r0%d-%s-%s', j, conditions{i}, '\d*'));
    end
end
for i = 1:length(conditions)
    for j = 1:glm.NrOfStudies
        idx{i}{j}(cellfun('isempty',idx{i}{j}))={0};
        idx{i}{j}=logical(cell2mat(idx{i}{j}));
    end
end

betaseries = {};
for i = 1:length(conditions)
    for j = 1:glm.NrOfStudies
        betaseries{i}{j} = betas(idx{i}{j},:);
    end
end

for i = 1:length(conditions)
    rm = [];
    for j = 1:size(betaseries{i},2)
        if any(isnan(betaseries{i}(:,j)))
            rm = [rm j];
        end
    end
    betaseries{i}(:,rm) = []; 
     if rm ~= []
         warning(sprintf('Removed for NaN: %s \n', voinames(rm).Name))
     end
end
voinames(rm) = [];

for i = 1:length(betaseries)
    [corr,P] = corrcoef(betaseries{i});
    corr(P>0.05) = 0; %removes "non-significant" correlations
    imagesc(corr)
    set(gca, 'XTick', 1:length(voinames)); 
    set(gca, 'YTick', 1:length(voinames)); 
    set(gca, 'TickLength',[0 0])
    set(gca, 'XTickLabel',strrep({voinames.Name}, '_', '-'), 'fontsize', 8); 
    set(gca, 'YTickLabel',strrep({voinames.Name}, '_', '-'), 'fontsize', 8); 
    set(gca, 'YDir', 'reverse');
    colormap(redblue) %uses https://de.mathworks.com/matlabcentral/fileexchange/25536-red-blue-colormap
    caxis([-1,1]);
    rotateXLabels(gca, 45);
    title(conditions{i}, 'FontSize', 10); 
    colorbar;
    saveas(gca, sprintf('%s.png', conditions{i}))% 
end
end
