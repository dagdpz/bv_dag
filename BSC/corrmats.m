%all of my plots going off having lip and pul from the betaconcat

%CU
%LIP fullbrain
conditions = {'CU LIP fixation' 'CU LIP fixation microstim' 'CU LIP memory left' 'CU memory right LIP' 'CU memory left microstim LIP' 'CU memory right microstim LIP'};
voi = xff('/mnt/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/curius.warped/CHARM/level_5/CU_CHARM_l5_updated300.voi');
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


%run this to check for which stimsite has less NAs, they overlap but one
%generally will have more, but not in this case, wheee

betaseries = lip;
for i = 1:length(conditions)
    rm = [];
    for j = 1:size(betaseries{i},2)
        if any(isnan(betaseries{i}(:,j)))
            rm = [rm j];
        end
    end
    %betaseries{i}(:,rm) = []; 
     if ~isempty(rm)
         warning('Removed for NaN:\n %s \n', voinames(rm).Name)
     end     
end
voinames(rm) = [];
%% 
for i = 1:length(conditions)
    [corr,P] = corrcoef(betaseries{i}, 'rows', 'pairwise');
    corr(P>0.05) = 0; %removes non-significant correlations
    imagesc(corr)
    line(length(left)+0.5+zeros(1,size(betaseries{i},2)+1),0:size(betaseries{i},2),'Color','black')
    line(0:size(betaseries{i},2),length(left)+0.5+zeros(1,size(betaseries{i},2)+1),'Color','black')
    set(gca, 'XTick', [0.5,29.5,50.5,70.5,77.5,106.5,127.5,147.5]);
    set(gca, 'YTick', [0.5,29.5,50.5,70.5,77.5,106.5,127.5,147.5]);
    set(gca, 'XTickLabel',{'Frontal left','Parietal left','Temporal left', 'Occipital left', 'Frontal right','Parietal right', 'Temporal right', 'Occipital right'})
    set(gca, 'YTickLabel',{'Frontal left','Parietal left','Temporal left', 'Occipital left', 'Frontal right','Parietal right', 'Temporal right', 'Occipital right'})
    set(gca, 'YDir', 'reverse');
    colormap(redblue) %uses https://de.mathworks.com/matlabcentral/fileexchange/25536-red-blue-colormap
    caxis([-1,1]);
    rotateXLabels(gca, 45);
    title(conditions{i}, 'FontSize', 10);
    colorbar;
    axis square;
    saveas(gca, sprintf('/mnt/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/MA/Corrmats/%s.png', conditions{i}))
end

corrfixlip = corrcoef(betaseries{1}, 'rows', 'pairwise');
corrfixmslip = corrcoef(betaseries{2}, 'rows', 'pairwise');
corrmemllip = corrcoef(betaseries{3}, 'rows', 'pairwise');
corrmemrlip = corrcoef(betaseries{4}, 'rows', 'pairwise');
corrmemlmslip = corrcoef(betaseries{5}, 'rows', 'pairwise');
corrmemrmslip = corrcoef(betaseries{6}, 'rows', 'pairwise');

conditions = {'CU fixation Pul' 'CU fixation microstim Pul' 'CU memory left Pul' 'CU memory right Pul' 'CU memory left microstim Pul' 'CU memory right microstim Pul'};

betaseries = pul;
for i = 1:length(conditions)
    betaseries{i}(:,rm) = []; 
end

for i = 1:length(conditions)
    [corr,P] = corrcoef(betaseries{i}, 'rows', 'pairwise');
    corr(P>0.05) = 0; %removes non-significant correlations
    imagesc(corr)
    line(length(left)+zeros(1,size(betaseries{i},2)+1),0:size(betaseries{i},2),'Color','black')
    line(0:size(betaseries{i},2),length(left)+zeros(1,size(betaseries{i},2)+1),'Color','black')
    set(gca, 'XTick', [0.5,29.5,50.5,70.5,77.5,106.5,127.5,147.5]);
    set(gca, 'YTick', [0.5,29.5,50.5,70.5,77.5,106.5,127.5,147.5]);
    set(gca, 'XTickLabel',{'Frontal left','Parietal left','Temporal left', 'Occipital left', 'Frontal right','Parietal right', 'Temporal right', 'Occipital right'})
    set(gca, 'YTickLabel',{'Frontal left','Parietal left','Temporal left', 'Occipital left', 'Frontal right','Parietal right', 'Temporal right', 'Occipital right'})
    set(gca, 'YDir', 'reverse');
    colormap(redblue) %uses https://de.mathworks.com/matlabcentral/fileexchange/25536-red-blue-colormap
    caxis([-1,1]);
    rotateXLabels(gca, 45);
    title(conditions{i}, 'FontSize', 10);
    colorbar;
    axis square;
    saveas(gca, sprintf('/mnt/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/MA/Corrmats/%s.png', conditions{i}))
end

corrfixpul = corrcoef(betaseries{1}, 'rows', 'pairwise');
corrfixmspul = corrcoef(betaseries{2}, 'rows', 'pairwise');
corrmemlpul = corrcoef(betaseries{3}, 'rows', 'pairwise');
corrmemrpul = corrcoef(betaseries{4}, 'rows', 'pairwise');
corrmemlmspul = corrcoef(betaseries{5}, 'rows', 'pairwise');
corrmemrmspul = corrcoef(betaseries{6}, 'rows', 'pairwise');

%contrasts
corrs = {corrmemllip - corrfixlip, corrmemrlip - corrfixlip,corrmemlmslip - corrfixmslip, corrmemrmslip - corrfixmslip, corrmemlpul - corrfixpul, ...
    corrmemrpul - corrfixpul, corrmemlmspul - corrfixmspul,corrmemrmspul - corrfixmspul,corrmemlmspul - corrmemlpul, corrmemrmspul - corrmemrpul, ...
    corrmemlmslip - corrmemllip, corrmemrmslip - corrmemrlip, corrmemlmspul - corrmemlmslip, corrmemrmspul - corrmemrmslip};
names = {'CU LIP memory left - fix' 'CU LIP memory right - fix' 'CU LIP memory left microstim - fix microstim' 'CU LIP memory right microstim - fix microstim' ...
    'CU Pul memory left - fix' 'CU Pul memory right - fix' 'CU Pul memory left microstim - fix microstim' 'CU Pul memory right microstim - fix microstim' ...
    'CU Pul memory left microstim - no microstim' 'CU Pul memory right microstim - no microstim' ...
    'CU LIP memory left microstim - no microstim' 'CU LIP memory right microstim - no microstim' 'CU memory left microstim Pulvinar - LIP' 'CU memory right microstim Pulvinar - LIP'};

for i = 1:length(names)
    corr = corrs{i};
    name = names{i};
    imagesc(corr)
    line(length(left)+0.5+zeros(1,length(voinames)+1),0:length(voinames),'Color','black')
    line(0:length(voinames),length(left)+0.5+zeros(1,length(voinames)+1),'Color','black')
    set(gca, 'XTick', [0.5,29.5,50.5,70.5,77.5,106.5,127.5,147.5]);
    set(gca, 'YTick', [0.5,29.5,50.5,70.5,77.5,106.5,127.5,147.5]);
    set(gca, 'XTickLabel',{'Frontal left','Parietal left','Temporal left', 'Occipital left', 'Frontal right','Parietal right', 'Temporal right', 'Occipital right'})
    set(gca, 'YTickLabel',{'Frontal left','Parietal left','Temporal left', 'Occipital left', 'Frontal right','Parietal right', 'Temporal right', 'Occipital right'})
    set(gca, 'YDir', 'reverse');
    colormap(redblue) %uses https://de.mathworks.com/matlabcentral/fileexchange/25536-red-blue-colormap
    hv = max(max(abs(corr)));
    caxis([-hv,hv]);
    rotateXLabels(gca, 45);
    title(name, 'FontSize', 10);
    colorbar;
    axis square;
    saveas(gca, sprintf('/mnt/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/MA/Corrmats/%s.png', name))
end
names = {'CU LIP memory left - fix sig', 'CU LIP memory right - fix sig', 'CU LIP memory left microstim - fix microstim sig','CU LIP memory right microstim - fix microstim sig', ...
    'CU Pul memory left - fix sig','CU Pul memory right - fix sig', 'CU Pul memory left microstim - fix microstim sig', 'CU Pul memory right microstim - fix microstim sig',...
    'CU Pul memory left microstim - no microstim sig', 'CU Pul memory right microstim - no microstim sig', 'CU LIP memory left microstim - no microstim sig', ...
    'CU LIP memory right microstim - no microstim sig', 'CU memory left microstim Pulvinar - LIP  sig', 'CU memory right microstim Pulvinar - LIP sig'};
bootgroups = {{vertcat(memllip,fixlip),length(memllip)},{vertcat(memrlip,fixlip),length(memrlip)},{vertcat(memlmslip,fixmslip),length(memlmslip)},{vertcat(memrmslip,fixmslip),length(memrmslip)},{vertcat(memlpul,fixpul),length(memlpul)},...
    {vertcat(memrpul,fixpul),length(memrpul)}, {vertcat(memlmspul,fixmspul),length(memlmspul)},{vertcat(memrmspul,fixmspul),length(memrmspul)},{vertcat(memlmspul,memlpul),length(memlmspul)},{vertcat(memrmspul,memrpul),length(memrmspul)},...
    {vertcat(memlmslip, memllip),length(memlmslip)}, {vertcat(memrmslip,memrlip),length(memrmslip)},{vertcat(memlmspul,memlmslip),length(memlmspul)},{vertcat(memrmspul,memrmslip),length(memrmspul)}};

for i = 1:length(names)
    corr = corrs{i};
    name = names{i};
    [low,high] = bootcorrs(1000, bootgroups{i});
    corr(corr>low & corr<high) = 0;
    imagesc(corr)
    line(length(left)+0.5+zeros(1,length(voinames)+1),0:length(voinames),'Color','black')
    line(0:length(voinames),length(left)+0.5+zeros(1,length(voinames)+1),'Color','black')
    set(gca, 'XTick', [0.5,29.5,50.5,70.5,77.5,106.5,127.5,147.5]);
    set(gca, 'YTick', [0.5,29.5,50.5,70.5,77.5,106.5,127.5,147.5]);
    set(gca, 'XTickLabel',{'Frontal left','Parietal left','Temporal left', 'Occipital left', 'Frontal right','Parietal right', 'Temporal right', 'Occipital right'})
    set(gca, 'YTickLabel',{'Frontal left','Parietal left','Temporal left', 'Occipital left', 'Frontal right','Parietal right', 'Temporal right', 'Occipital right'})
    set(gca, 'YDir', 'reverse');
    colormap(redblue) %uses https://de.mathworks.com/matlabcentral/fileexchange/25536-red-blue-colormap
    hv = max(max(abs(corr)));
    caxis([-hv,hv]);
    rotateXLabels(gca, 45);
    title(name, 'FontSize', 10);
    colorbar;
    axis square;
    saveas(gca, sprintf('/mnt/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/MA/Corrmats/%s.png', name))
end
%% 
%CU ROIs LR
%LIP
conditions = {'CU ROIs LR LIP fixation' 'CU ROIs LR LIP fixation microstim' 'CU ROIs LR LIP memory left' 'CU ROIs LR LIP memory right' 'CU ROIs LR LIP memory left microstim' 'CU ROIs LR LIP memory right microstim'};
voi = xff('/mnt/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/CU_bl_lr_k20_05FDR_positiveonly_from_CU_CHARM_tal.voi');
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


%run this to check for which stimsite has less NAs, they overlap but one
%generally will have more, but not in this case, wheee

betaseries = lip;
for i = 1:length(conditions)
    rm = [];
    for j = 1:size(betaseries{i},2)
        if all(isnan(betaseries{i}(:,j)))
            rm = [rm j];
        end
    end
    betaseries{i}(:,rm) = []; 
     if ~isempty(rm)
         warning('Removed for NaN:\n %s \n', voinames(rm).Name)
     end     
end
voinames(rm) = [];

for i = 1:length(conditions)
    [corr,P] = corrcoef(betaseries{i}, 'rows', 'pairwise');
    corr(P>0.05) = 0; %removes non-significant correlations
    imagesc(corr)
    set(gca, 'XTick', 1:length(betaseries{i}));
    set(gca, 'YTick', 1:length(betaseries{i}));
    set(gca, 'TickLength',[0 0])
    set(gca, 'XTickLabel',strrep({voinames.Name}, '_', '-'), 'fontsize', 6);
    set(gca, 'YTickLabel',strrep({voinames.Name}, '_', '-'), 'fontsize', 6);
    set(gca, 'YDir', 'reverse');
    colormap(redblue) %uses https://de.mathworks.com/matlabcentral/fileexchange/25536-red-blue-colormap
    caxis([-1,1]);
    rotateXLabels(gca, 45);
    title(conditions{i}, 'FontSize', 10);
    colorbar;
    axis square;
    saveas(gca, sprintf('/mnt/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/MA/Corrmats/%s.png', conditions{i}))
end

corrfixlip = corrcoef(betaseries{1}, 'rows', 'pairwise');
corrfixmslip = corrcoef(betaseries{2}, 'rows', 'pairwise');
corrmemllip = corrcoef(betaseries{3}, 'rows', 'pairwise');
corrmemrlip = corrcoef(betaseries{4}, 'rows', 'pairwise');
corrmemlmslip = corrcoef(betaseries{5}, 'rows', 'pairwise');
corrmemrmslip = corrcoef(betaseries{6}, 'rows', 'pairwise');

conditions = {'CU fixation Pul ROIs LR' 'CU fixation microstim Pul ROIs LR' 'CU memory left Pul ROIs LR' 'CU memory right Pul ROIs LR' 'CU memory left microstim Pul ROIs LR' 'CU memory right microstim Pul ROIs LR'};

betaseries = pul;
for i = 1:length(conditions)
    betaseries{i}(:,rm) = []; 
end

for i = 1:length(conditions)
    [corr,P] = corrcoef(betaseries{i}, 'rows', 'pairwise');
    corr(P>0.05) = 0; %removes non-significant correlations
    imagesc(corr)
    set(gca, 'XTick', 1:length(betaseries{i}));
    set(gca, 'YTick', 1:length(betaseries{i}));
    set(gca, 'TickLength',[0 0])
    set(gca, 'XTickLabel',strrep({voinames.Name}, '_', '-'), 'fontsize', 6);
    set(gca, 'YTickLabel',strrep({voinames.Name}, '_', '-'), 'fontsize', 6);
    set(gca, 'YDir', 'reverse');
    colormap(redblue) %uses https://de.mathworks.com/matlabcentral/fileexchange/25536-red-blue-colormap
    caxis([-1,1]);
    rotateXLabels(gca, 45);
    title(conditions{i}, 'FontSize', 10);
    colorbar;
    axis square;
    saveas(gca, sprintf('/mnt/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/MA/Corrmats/%s.png', conditions{i}))
end

corrfixpul = corrcoef(betaseries{1}, 'rows', 'pairwise');
corrfixmspul = corrcoef(betaseries{2}, 'rows', 'pairwise');
corrmemlpul = corrcoef(betaseries{3}, 'rows', 'pairwise');
corrmemrpul = corrcoef(betaseries{4}, 'rows', 'pairwise');
corrmemlmspul = corrcoef(betaseries{5}, 'rows', 'pairwise');
corrmemrmspul = corrcoef(betaseries{6}, 'rows', 'pairwise');

%contrasts
corrs = {corrmemllip - corrfixlip,corrmemrlip - corrfixlip,corrmemlmslip - corrfixmslip, corrmemrmslip - corrfixmslip,corrmemlpul - corrfixpul,...
    corrmemrpul - corrfixpul, corrmemlmspul - corrfixmspul, corrmemrmspul - corrfixmspul,corrmemlmspul - corrmemlpul,corrmemrmspul - corrmemrpul,...
    corrmemlmslip - corrmemllip, corrmemrmslip - corrmemrlip,corrmemlmspul - corrmemlmslip, corrmemrmspul - corrmemrmslip};
names = {'CU LIP memory left - fix ROIs LR', 'CU LIP memory right - fix ROIs LR', 'CU LIP memory left microstim - fix microstim ROIs LR','CU LIP memory right microstim - fix microstim ROIs LR', ...
    'CU Pul memory left - fix ROIs LR','CU Pul memory right - fix ROIs LR', 'CU Pul memory left microstim - fix microstim ROIs LR', 'CU Pul memory right microstim - fix microstim ROIs LR',...
    'CU Pul memory left microstim - no microstim ROIs LR', 'CU Pul memory right microstim - no microstim ROIs LR', 'CU LIP memory left microstim - no microstim ROIs LR', ...
    'CU LIP memory right microstim - no microstim ROIs LR', 'CU memory left microstim Pulvinar - LIP  ROIs LR', 'CU memory right microstim Pulvinar - LIP ROIs LR'};

for i = 1:length(names)
    corr = corrs{i};
    name = names{i};
    imagesc(corr)
    set(gca, 'XTick', 1:length(voinames));
    set(gca, 'YTick', 1:length(voinames));
    set(gca, 'TickLength',[0 0])
    set(gca, 'XTickLabel',strrep({voinames.Name}, '_', '-'), 'fontsize', 6);
    set(gca, 'YTickLabel',strrep({voinames.Name}, '_', '-'), 'fontsize', 6);
    set(gca, 'YDir', 'reverse');
    colormap(redblue) %uses https://de.mathworks.com/matlabcentral/fileexchange/25536-red-blue-colormap
    hv = max(max(abs(corr)));
    caxis([-hv,hv]);
    rotateXLabels(gca, 45);
    title(name, 'FontSize', 10);
    colorbar;
    axis square;
    saveas(gca, sprintf('/mnt/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/MA/Corrmats/%s.png', name))
end
names = {'CU LIP memory left - fix ROIs LR sig', 'CU LIP memory right - fix ROIs LR sig', 'CU LIP memory left microstim - fix microstim ROIs LR sig','CU LIP memory right microstim - fix microstim ROIs LR sig', ...
    'CU Pul memory left - fix ROIs LR sig','CU Pul memory right - fix ROIs LR sig', 'CU Pul memory left microstim - fix microstim ROIs LR sig', 'CU Pul memory right microstim - fix microstim ROIs LR sig',...
    'CU Pul memory left microstim - no microstim ROIs LR sig', 'CU Pul memory right microstim - no microstim ROIs LR sig', 'CU LIP memory left microstim - no microstim ROIs LR sig', ...
    'CU LIP memory right microstim - no microstim ROIs LR sig', 'CU memory left microstim Pulvinar - LIP  ROIs LR sig', 'CU memory right microstim Pulvinar - LIP ROIs LR sig'};
bootgroups = {{vertcat(memllip,fixlip),length(memllip)},{vertcat(memrlip,fixlip),length(memrlip)},{vertcat(memlmslip,fixmslip),length(memlmslip)},{vertcat(memrmslip,fixmslip),length(memrmslip)},{vertcat(memlpul,fixpul),length(memlpul)},...
    {vertcat(memrpul,fixpul),length(memrpul)}, {vertcat(memlmspul,fixmspul),length(memlmspul)},{vertcat(memrmspul,fixmspul),length(memrmspul)},{vertcat(memlmspul,memlpul),length(memlmspul)},{vertcat(memrmspul,memrpul),length(memrmspul)},...
    {vertcat(memlmslip, memllip),length(memlmslip)}, {vertcat(memrmslip,memrlip),length(memrmslip)},{vertcat(memlmspul,memlmslip),length(memlmspul)},{vertcat(memrmspul,memrmslip),length(memrmspul)}};

for i = 1:length(names)
    corr = corrs{i};
    name = names{i};
    [low,high] = bootcorrs(1000, bootgroups{i});
    corr(corr>low & corr<high) = 0;
    imagesc(corr)
    set(gca, 'XTick', 1:length(voinames));
    set(gca, 'YTick', 1:length(voinames));
    set(gca, 'TickLength',[0 0])
    set(gca, 'XTickLabel',strrep({voinames.Name}, '_', '-'), 'fontsize', 6);
    set(gca, 'YTickLabel',strrep({voinames.Name}, '_', '-'), 'fontsize', 6);
    set(gca, 'YDir', 'reverse');
    colormap(redblue) %uses https://de.mathworks.com/matlabcentral/fileexchange/25536-red-blue-colormap
    hv = max(max(abs(corr)));
    caxis([-hv,hv]);
    rotateXLabels(gca, 45);
    title(name, 'FontSize', 10);
    colorbar;
    axis square;
    saveas(gca, sprintf('/mnt/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/MA/Corrmats/%s.png', name))
end
%% 
%CU ROIs RL
%LIP
conditions = {'CU ROIs RL LIP fixation' 'CU ROIs RL LIP fixation microstim' 'CU ROIs RL LIP memory left' 'CU ROIs RL LIP memory right' 'CU ROIs RL LIP memory left microstim' 'CU ROIs RL LIP memory right microstim'};
voi = xff('/mnt/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/CU_bl_lr_k20_05FDR_positiveonly_from_CU_CHARM_tal.voi');
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


%run this to check for which stimsite has less NAs, they overlap but one
%generally will have more, but not in this case, wheee

betaseries = lip;
for i = 1:length(conditions)
    rm = [];
    for j = 1:size(betaseries{i},2)
        if all(isnan(betaseries{i}(:,j)))
            rm = [rm j];
        end
    end
    betaseries{i}(:,rm) = []; 
     if ~isempty(rm)
         warning('Removed for NaN:\n %s \n', voinames(rm).Name)
     end     
end
voinames(rm) = [];

for i = 1:length(conditions)
    [corr,P] = corrcoef(betaseries{i}, 'rows', 'pairwise');
    corr(P>0.05) = 0; %removes non-significant correlations
    imagesc(corr)
    set(gca, 'XTick', 1:length(voinames));
    set(gca, 'YTick', 1:length(voinames));
    set(gca, 'TickLength',[0 0])
    set(gca, 'XTickLabel',strrep({voinames.Name}, '_', '-'), 'fontsize', 6);
    set(gca, 'YTickLabel',strrep({voinames.Name}, '_', '-'), 'fontsize', 6);
    set(gca, 'YDir', 'reverse');
    colormap(redblue) %uses https://de.mathworks.com/matlabcentral/fileexchange/25536-red-blue-colormap
    caxis([-1,1]);
    rotateXLabels(gca, 45);
    title(conditions{i}, 'FontSize', 10);
    colorbar;
    axis square;
    saveas(gca, sprintf('/mnt/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/MA/Corrmats/%s.png', conditions{i}))
end

corrfixlip = corrcoef(betaseries{1}, 'rows', 'pairwise');
corrfixmslip = corrcoef(betaseries{2}, 'rows', 'pairwise');
corrmemllip = corrcoef(betaseries{3}, 'rows', 'pairwise');
corrmemrlip = corrcoef(betaseries{4}, 'rows', 'pairwise');
corrmemlmslip = corrcoef(betaseries{5}, 'rows', 'pairwise');
corrmemrmslip = corrcoef(betaseries{6}, 'rows', 'pairwise');

conditions = {'CU fixation Pul ROIs RL' 'CU fixation microstim Pul ROIs RL' 'CU memory left Pul ROIs RL' 'CU memory right Pul ROIs RL' 'CU memory left microstim Pul ROIs RL' 'CU memory right microstim Pul ROIs RL'};

betaseries = pul;
for i = 1:length(conditions)
    betaseries{i}(:,rm) = []; 
end

for i = 1:length(conditions)
    [corr,P] = corrcoef(betaseries{i}, 'rows', 'pairwise');
    corr(P>0.05) = 0; %removes non-significant correlations
    imagesc(corr)
    set(gca, 'XTick', 1:length(betaseries{i}));
    set(gca, 'YTick', 1:length(betaseries{i}));
    set(gca, 'TickLength',[0 0])
    set(gca, 'XTickLabel',strrep({voinames.Name}, '_', '-'), 'fontsize', 6);
    set(gca, 'YTickLabel',strrep({voinames.Name}, '_', '-'), 'fontsize', 6);
    set(gca, 'YDir', 'reverse');
    colormap(redblue) %uses https://de.mathworks.com/matlabcentral/fileexchange/25536-red-blue-colormap
    caxis([-1,1]);
    rotateXLabels(gca, 45);
    title(conditions{i}, 'FontSize', 10);
    colorbar;
    axis square;
    saveas(gca, sprintf('/mnt/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/MA/Corrmats/%s.png', conditions{i}))
end

corrfixpul = corrcoef(betaseries{1}, 'rows', 'pairwise');
corrfixmspul = corrcoef(betaseries{2}, 'rows', 'pairwise');
corrmemlpul = corrcoef(betaseries{3}, 'rows', 'pairwise');
corrmemrpul = corrcoef(betaseries{4}, 'rows', 'pairwise');
corrmemlmspul = corrcoef(betaseries{5}, 'rows', 'pairwise');
corrmemrmspul = corrcoef(betaseries{6}, 'rows', 'pairwise');

%contrasts
corrs = {corrmemllip - corrfixlip,corrmemrlip - corrfixlip,corrmemlmslip - corrfixmslip, corrmemrmslip - corrfixmslip,corrmemlpul - corrfixpul,...
    corrmemrpul - corrfixpul, corrmemlmspul - corrfixmspul, corrmemrmspul - corrfixmspul,corrmemlmspul - corrmemlpul,corrmemrmspul - corrmemrpul,...
    corrmemlmslip - corrmemllip, corrmemrmslip - corrmemrlip,corrmemlmspul - corrmemlmslip, corrmemrmspul - corrmemrmslip};
names = {'CU LIP memory left - fix ROIs RL', 'CU LIP memory right - fix ROIs RL', 'CU LIP memory left microstim - fix microstim ROIs RL','CU LIP memory right microstim - fix microstim ROIs RL', ...
    'CU Pul memory left - fix ROIs RL','CU Pul memory right - fix ROIs RL', 'CU Pul memory left microstim - fix microstim ROIs RL', 'CU Pul memory right microstim - fix microstim ROIs RL',...
    'CU Pul memory left microstim - no microstim ROIs RL', 'CU Pul memory right microstim - no microstim ROIs RL', 'CU LIP memory left microstim - no microstim ROIs RL', ...
    'CU LIP memory right microstim - no microstim ROIs RL', 'CU memory left microstim Pulvinar - LIP  ROIs RL', 'CU memory right microstim Pulvinar - LIP ROIs RL'};

for i = 1:length(names)
    corr = corrs{i};
    name = names{i};
    imagesc(corr)
    set(gca, 'XTick', 1:length(voinames));
    set(gca, 'YTick', 1:length(voinames));
    set(gca, 'TickLength',[0 0])
    set(gca, 'XTickLabel',strrep({voinames.Name}, '_', '-'), 'fontsize', 6);
    set(gca, 'YTickLabel',strrep({voinames.Name}, '_', '-'), 'fontsize', 6);
    set(gca, 'YDir', 'reverse');
    colormap(redblue) %uses https://de.mathworks.com/matlabcentral/fileexchange/25536-red-blue-colormap
    hv = max(max(abs(corr)));
    caxis([-hv,hv]);
    rotateXLabels(gca, 45);
    title(name, 'FontSize', 10);
    colorbar;
    axis square;
    saveas(gca, sprintf('/mnt/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/MA/Corrmats/%s.png', name))
end

names = {'CU LIP memory left - fix ROIs RL sig', 'CU LIP memory right - fix ROIs RL sig', 'CU LIP memory left microstim - fix microstim ROIs RL sig','CU LIP memory right microstim - fix microstim ROIs RL sig', ...
    'CU Pul memory left - fix ROIs RL sig','CU Pul memory right - fix ROIs RL sig', 'CU Pul memory left microstim - fix microstim ROIs RL sig', 'CU Pul memory right microstim - fix microstim ROIs RL sig',...
    'CU Pul memory left microstim - no microstim ROIs RL sig', 'CU Pul memory right microstim - no microstim ROIs RL sig', 'CU LIP memory left microstim - no microstim ROIs RL sig', ...
    'CU LIP memory right microstim - no microstim ROIs RL sig', 'CU memory left microstim Pulvinar - LIP  ROIs RL sig', 'CU memory right microstim Pulvinar - LIP ROIs RL sig'};
bootgroups = {{vertcat(memllip,fixlip),length(memllip)},{vertcat(memrlip,fixlip),length(memrlip)},{vertcat(memlmslip,fixmslip),length(memlmslip)},{vertcat(memrmslip,fixmslip),length(memrmslip)},{vertcat(memlpul,fixpul),length(memlpul)},...
    {vertcat(memrpul,fixpul),length(memrpul)}, {vertcat(memlmspul,fixmspul),length(memlmspul)},{vertcat(memrmspul,fixmspul),length(memrmspul)},{vertcat(memlmspul,memlpul),length(memlmspul)},{vertcat(memrmspul,memrpul),length(memrmspul)},...
    {vertcat(memlmslip, memllip),length(memlmslip)}, {vertcat(memrmslip,memrlip),length(memrmslip)},{vertcat(memlmspul,memlmslip),length(memlmspul)},{vertcat(memrmspul,memrmslip),length(memrmspul)}};

for i = 1:length(names)
    corr = corrs{i};
    name = names{i};
    [low,high] = bootcorrs(100, bootgroups{i});
    corr(corr>low & corr<high) = 0;
    imagesc(corr)
    set(gca, 'XTick', 1:length(voinames));
    set(gca, 'YTick', 1:length(voinames));
    set(gca, 'TickLength',[0 0])
    set(gca, 'XTickLabel',strrep({voinames.Name}, '_', '-'), 'fontsize', 8);
    set(gca, 'YTickLabel',strrep({voinames.Name}, '_', '-'), 'fontsize', 8);
    set(gca, 'YDir', 'reverse');
    colormap(redblue) %uses https://de.mathworks.com/matlabcentral/fileexchange/25536-red-blue-colormap
    hv = max(max(abs(corr)));
    caxis([-hv,hv]);
    rotateXLabels(gca, 45);
    title(name, 'FontSize', 10);
    colorbar;
    axis square;
    saveas(gca, sprintf('/mnt/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/MA/Corrmats/%s.png', name))
end
%% 


%Bacchus

conditions = {'BA fixation LIP' 'BA fixation microstim LIP' 'BA memory left LIP' 'BA memory right LIP' 'BA memory left microstim LIP' 'BA memory right microstim LIP'};
voi = xff('/mnt/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/bacchus.warped/CHARM/level_5/BA_CHARM_l5_updated150.voi');
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

betaseries = lip;
for i = 1:length(conditions)
    rm = [];
    for j = 1:size(betaseries{i},2)
        if any(isnan(betaseries{i}(:,j)))
            rm = [rm j];
        end
    end
    %betaseries{i}(:,rm) = []; 
     if ~isempty(rm)
         warning('Removed for NaN:\n %s \n', voinames(rm).Name)
     end     
end
voinames(rm) = [];

for i = 1:length(conditions)
    [corr,P] = corrcoef(betaseries{i}, 'rows', 'pairwise');
    corr(P>0.05) = 0; %removes non-significant correlations
    imagesc(corr)
    line(length(left)+0.5+zeros(1,size(betaseries{i},2)+1),0:size(betaseries{i},2),'Color','black')
    line(0:size(betaseries{i},2),length(left)+0.5+zeros(1,size(betaseries{i},2)+1),'Color','black')
    set(gca, 'XTick', [0.5,29.5,50.5,70.5,77.5,106.5,127.5,147.5]);
    set(gca, 'YTick', [0.5,29.5,50.5,70.5,77.5,106.5,127.5,147.5]);
    set(gca, 'XTickLabel',{'Frontal left','Parietal left','Temporal left', 'Occipital left', 'Frontal right','Parietal right', 'Temporal right', 'Occipital right'})
    set(gca, 'YTickLabel',{'Frontal left','Parietal left','Temporal left', 'Occipital left', 'Frontal right','Parietal right', 'Temporal right', 'Occipital right'})
    set(gca, 'YDir', 'reverse');
    colormap(redblue) %uses https://de.mathworks.com/matlabcentral/fileexchange/25536-red-blue-colormap
    caxis([-1,1]);
    rotateXLabels(gca, 45);
    title(conditions{i}, 'FontSize', 10);
    colorbar;
    axis square;
    saveas(gca, sprintf('/mnt/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/MA/Corrmats/%s.png', conditions{i}))
end

corrfixlip = corrcoef(betaseries{1}, 'rows', 'pairwise');
corrfixmslip = corrcoef(betaseries{2}, 'rows', 'pairwise');
corrmemllip = corrcoef(betaseries{3}, 'rows', 'pairwise');
corrmemrlip = corrcoef(betaseries{4}, 'rows', 'pairwise');
corrmemlmslip = corrcoef(betaseries{5}, 'rows', 'pairwise');
corrmemrmslip = corrcoef(betaseries{6}, 'rows', 'pairwise');

conditions = {'BA fixation Pul' 'BA fixation microstim Pul' 'BA memory left Pul' 'BA memory right Pul' 'BA memory left microstim Pul' 'BA memory right microstim Pul'};

betaseries = pul;
for i = 1:length(conditions)
    betaseries{i}(:,rm) = []; 
end

for i = 1:length(conditions)
    [corr,P] = corrcoef(betaseries{i}, 'rows', 'pairwise');
    corr(P>0.05) = 0; %removes non-significant correlations
    imagesc(corr)
    line(length(left)+0.5+zeros(1,size(betaseries{i},2)+1),0:size(betaseries{i},2),'Color','black')
    line(0:size(betaseries{i},2),length(left)+0.5+zeros(1,size(betaseries{i},2)+1),'Color','black')
    set(gca, 'XTick', [0.5,29.5,50.5,70.5,77.5,106.5,127.5,147.5]);
    set(gca, 'YTick', [0.5,29.5,50.5,70.5,77.5,106.5,127.5,147.5]);
    set(gca, 'XTickLabel',{'Frontal left','Parietal left','Temporal left', 'Occipital left', 'Frontal right','Parietal right', 'Temporal right', 'Occipital right'})
    set(gca, 'YTickLabel',{'Frontal left','Parietal left','Temporal left', 'Occipital left', 'Frontal right','Parietal right', 'Temporal right', 'Occipital right'})
    set(gca, 'YDir', 'reverse');
    colormap(redblue) %uses https://de.mathworks.com/matlabcentral/fileexchange/25536-red-blue-colormap
    caxis([-1,1]);
    rotateXLabels(gca, 45);
    title(conditions{i}, 'FontSize', 10);
    colorbar;
    axis square;
    saveas(gca, sprintf('/mnt/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/MA/Corrmats/%s.png', conditions{i}))
end

corrfixpul = corrcoef(betaseries{1}, 'rows', 'pairwise');
corrfixmspul = corrcoef(betaseries{2}, 'rows', 'pairwise');
corrmemlpul = corrcoef(betaseries{3}, 'rows', 'pairwise');
corrmemrpul = corrcoef(betaseries{4}, 'rows', 'pairwise');
corrmemlmspul = corrcoef(betaseries{5}, 'rows', 'pairwise');
corrmemrmspul = corrcoef(betaseries{6}, 'rows', 'pairwise');

%contrasts

corrs = {corrmemllip - corrfixlip,corrmemrlip - corrfixlip,corrmemlmslip - corrfixmslip, corrmemrmslip - corrfixmslip,corrmemlpul - corrfixpul,...
    corrmemrpul - corrfixpul, corrmemlmspul - corrfixmspul, corrmemrmspul - corrfixmspul,corrmemlmspul - corrmemlpul,corrmemrmspul - corrmemrpul,...
    corrmemlmslip - corrmemllip, corrmemrmslip - corrmemrlip,corrmemlmspul - corrmemlmslip, corrmemrmspul - corrmemrmslip};
names = {'BA LIP memory left - fix', 'BA LIP memory right - fix', 'BA LIP memory left microstim - fix microstim','BA LIP memory right microstim - fix microstim', ...
    'BA Pul memory left - fix','BA Pul memory right - fix', 'BA Pul memory left microstim - fix microstim', 'BA Pul memory right microstim - fix microstim',...
    'BA Pul memory left microstim - no microstim', 'BA Pul memory right microstim - no microstim', 'BA LIP memory left microstim - no microstim', ...
    'BA LIP memory right microstim - no microstim', 'BA memory left microstim Pulvinar - LIP', 'BA memory right microstim Pulvinar - LIP'};
 
for i = 1:length(names)
    corr = corrs{i};
    name = names{i};
    imagesc(corr)
    line(length(left)+0.5+zeros(1,length(voinames)+1),0:length(voinames),'Color','black')
    line(0:length(voinames),length(left)+0.5+zeros(1,length(voinames)+1),'Color','black')
    set(gca, 'XTick', [0.5,29.5,50.5,70.5,77.5,106.5,127.5,147.5]);
    set(gca, 'YTick', [0.5,29.5,50.5,70.5,77.5,106.5,127.5,147.5]);
    set(gca, 'XTickLabel',{'Frontal left','Parietal left','Temporal left', 'Occipital left', 'Frontal right','Parietal right', 'Temporal right', 'Occipital right'})
    set(gca, 'YTickLabel',{'Frontal left','Parietal left','Temporal left', 'Occipital left', 'Frontal right','Parietal right', 'Temporal right', 'Occipital right'})
    set(gca, 'YDir', 'reverse');
    colormap(redblue) %uses https://de.mathworks.com/matlabcentral/fileexchange/25536-red-blue-colormap
    hv = max(max(abs(corr)));
    caxis([-hv,hv]);
    rotateXLabels(gca, 45);
    title(name, 'FontSize', 10);
    colorbar;
    axis square;
    saveas(gca, sprintf('/mnt/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/MA/Corrmats/%s.png', name))
end

names = {'BA LIP memory left - fix sig', 'BA LIP memory right - fix sig', 'BA LIP memory left microstim - fix microstim sig','BA LIP memory right microstim - fix microstim sig', ...
    'BA Pul memory left - fix sig','BA Pul memory right - fix sig', 'BA Pul memory left microstim - fix microstim sig', 'BA Pul memory right microstim - fix microstim sig',...
    'BA Pul memory left microstim - no microstim sig', 'BA Pul memory right microstim - no microstim sig', 'BA LIP memory left microstim - no microstim sig', ...
    'BA LIP memory right microstim - no microstim sig', 'BA memory left microstim Pulvinar - LIP  sig', 'BA memory right microstim Pulvinar - LIP sig'};
bootgroups = {{vertcat(memllip,fixlip),length(memllip)},{vertcat(memrlip,fixlip),length(memrlip)},{vertcat(memlmslip,fixmslip),length(memlmslip)},{vertcat(memrmslip,fixmslip),length(memrmslip)},{vertcat(memlpul,fixpul),length(memlpul)},...
    {vertcat(memrpul,fixpul),length(memrpul)}, {vertcat(memlmspul,fixmspul),length(memlmspul)},{vertcat(memrmspul,fixmspul),length(memrmspul)},{vertcat(memlmspul,memlpul),length(memlmspul)},{vertcat(memrmspul,memrpul),length(memrmspul)},...
    {vertcat(memlmslip, memllip),length(memlmslip)}, {vertcat(memrmslip,memrlip),length(memrmslip)},{vertcat(memlmspul,memlmslip),length(memlmspul)},{vertcat(memrmspul,memrmslip),length(memrmspul)}};

for i = 1:length(names)
    corr = corrs{i};
    name = names{i};
    [low,high] = bootcorrs(1000, bootgroups{i});
    corr(corr>low & corr<high) = 0;
    imagesc(corr)
    line(length(left)+0.5+zeros(1,length(voinames)+1),0:length(voinames),'Color','black')
    line(0:length(voinames),length(left)+0.5+zeros(1,length(voinames)+1),'Color','black')
    set(gca, 'XTick', [0.5,29.5,50.5,70.5,77.5,106.5,127.5,147.5]);
    set(gca, 'YTick', [0.5,29.5,50.5,70.5,77.5,106.5,127.5,147.5]);
    set(gca, 'XTickLabel',{'Frontal left','Parietal left','Temporal left', 'Occipital left', 'Frontal right','Parietal right', 'Temporal right', 'Occipital right'})
    set(gca, 'YTickLabel',{'Frontal left','Parietal left','Temporal left', 'Occipital left', 'Frontal right','Parietal right', 'Temporal right', 'Occipital right'})
    set(gca, 'YDir', 'reverse');
    colormap(redblue) %uses https://de.mathworks.com/matlabcentral/fileexchange/25536-red-blue-colormap
    hv = max(max(abs(corr)));
    caxis([-hv,hv]);
    rotateXLabels(gca, 45);
    title(name, 'FontSize', 10);
    colorbar;
    axis square;
    saveas(gca, sprintf('/mnt/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/MA/Corrmats/%s.png', name))
end
%% 
%BA ROIs LR
%LIP
conditions = {'BA ROIs LR LIP fixation' 'BA ROIs LR LIP fixation microstim' 'BA ROIs LR LIP memory left' 'BA ROIs LR LIP memory right' 'BA ROIs LR LIP memory left microstim' 'BA ROIs LR LIP memory right microstim'};
voi = xff('/mnt/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/BA_bl_lr_k20_05FDR_positiveonly_from_BA_CHARM_tal.voi');
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


%run this to check for which stimsite has less NAs, they overlap but one
%generally will have more, but not in this case, wheee

betaseries = lip;
for i = 1:length(conditions)
    rm = [];
    for j = 1:size(betaseries{i},2)
        if all(isnan(betaseries{i}(:,j)))
            rm = [rm j];
        end
    end
    betaseries{i}(:,rm) = []; 
     if ~isempty(rm)
         warning('Removed for NaN:\n %s \n', voinames(rm).Name)
     end     
end
voinames(rm) = [];

for i = 1:length(conditions)
    [corr,P] = corrcoef(betaseries{i}, 'rows', 'pairwise');
    corr(P>0.05) = 0; %removes non-significant correlations
    imagesc(corr)
    set(gca, 'XTick', 1:length(betaseries{i}));
    set(gca, 'YTick', 1:length(betaseries{i}));
    set(gca, 'TickLength',[0 0])
    set(gca, 'XTickLabel',strrep({voinames.Name}, '_', '-'), 'fontsize', 8);
    set(gca, 'YTickLabel',strrep({voinames.Name}, '_', '-'), 'fontsize', 8);
    set(gca, 'YDir', 'reverse');
    colormap(redblue) %uses https://de.mathworks.com/matlabcentral/fileexchange/25536-red-blue-colormap
    caxis([-1,1]);
    rotateXLabels(gca, 45);
    title(conditions{i}, 'FontSize', 10);
    colorbar;
    axis square;
    saveas(gca, sprintf('/mnt/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/MA/Corrmats/%s.png', conditions{i}))
end

corrfixlip = corrcoef(betaseries{1}, 'rows', 'pairwise');
corrfixmslip = corrcoef(betaseries{2}, 'rows', 'pairwise');
corrmemllip = corrcoef(betaseries{3}, 'rows', 'pairwise');
corrmemrlip = corrcoef(betaseries{4}, 'rows', 'pairwise');
corrmemlmslip = corrcoef(betaseries{5}, 'rows', 'pairwise');
corrmemrmslip = corrcoef(betaseries{6}, 'rows', 'pairwise');

conditions = {'BA fixation Pul ROIs LR' 'BA fixation microstim Pul ROIs LR' 'BA memory left Pul ROIs LR' 'BA memory right Pul ROIs LR' 'BA memory left microstim Pul ROIs LR' 'BA memory right microstim Pul ROIs LR'};

betaseries = pul;
for i = 1:length(conditions)
    betaseries{i}(:,rm) = []; 
end

for i = 1:length(conditions)
    [corr,P] = corrcoef(betaseries{i}, 'rows', 'pairwise');
    corr(P>0.05) = 0; %removes non-significant correlations
    imagesc(corr)
    set(gca, 'XTick', 1:length(betaseries{i}));
    set(gca, 'YTick', 1:length(betaseries{i}));
    set(gca, 'TickLength',[0 0])
    set(gca, 'XTickLabel',strrep({voinames.Name}, '_', '-'), 'fontsize', 8);
    set(gca, 'YTickLabel',strrep({voinames.Name}, '_', '-'), 'fontsize', 8);
    set(gca, 'YDir', 'reverse');
    colormap(redblue) %uses https://de.mathworks.com/matlabcentral/fileexchange/25536-red-blue-colormap
    caxis([-1,1]);
    rotateXLabels(gca, 45);
    title(conditions{i}, 'FontSize', 10);
    colorbar;
    axis square;
    saveas(gca, sprintf('/mnt/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/MA/Corrmats/%s.png', conditions{i}))
end

corrfixpul = corrcoef(betaseries{1}, 'rows', 'pairwise');
corrfixmspul = corrcoef(betaseries{2}, 'rows', 'pairwise');
corrmemlpul = corrcoef(betaseries{3}, 'rows', 'pairwise');
corrmemrpul = corrcoef(betaseries{4}, 'rows', 'pairwise');
corrmemlmspul = corrcoef(betaseries{5}, 'rows', 'pairwise');
corrmemrmspul = corrcoef(betaseries{6}, 'rows', 'pairwise');

%contrasts
corrs = {corrmemllip - corrfixlip,corrmemrlip - corrfixlip,corrmemlmslip - corrfixmslip, corrmemrmslip - corrfixmslip,corrmemlpul - corrfixpul,...
    corrmemrpul - corrfixpul, corrmemlmspul - corrfixmspul, corrmemrmspul - corrfixmspul,corrmemlmspul - corrmemlpul,corrmemrmspul - corrmemrpul,...
    corrmemlmslip - corrmemllip, corrmemrmslip - corrmemrlip,corrmemlmspul - corrmemlmslip, corrmemrmspul - corrmemrmslip};
names = {'BA LIP memory left - fix ROIs LR', 'BA LIP memory right - fix ROIs LR', 'BA LIP memory left microstim - fix microstim ROIs LR','BA LIP memory right microstim - fix microstim ROIs LR', ...
    'BA Pul memory left - fix ROIs LR','BA Pul memory right - fix ROIs LR', 'BA Pul memory left microstim - fix microstim ROIs LR', 'BA Pul memory right microstim - fix microstim ROIs LR',...
    'BA Pul memory left microstim - no microstim ROIs LR', 'BA Pul memory right microstim - no microstim ROIs LR', 'BA LIP memory left microstim - no microstim ROIs LR', ...
    'BA LIP memory right microstim - no microstim ROIs LR', 'BA memory left microstim Pulvinar - LIP  ROIs LR', 'BA memory right microstim Pulvinar - LIP ROIs LR'};
  
for i = 1:length(names)
    corr = corrs{i};
    name = names{i};
    imagesc(corr)
    set(gca, 'XTick', 1:length(voinames));
    set(gca, 'YTick', 1:length(voinames));
    set(gca, 'TickLength',[0 0])
    set(gca, 'XTickLabel',strrep({voinames.Name}, '_', '-'), 'fontsize', 8);
    set(gca, 'YTickLabel',strrep({voinames.Name}, '_', '-'), 'fontsize', 8);
    set(gca, 'YDir', 'reverse');
    colormap(redblue) %uses https://de.mathworks.com/matlabcentral/fileexchange/25536-red-blue-colormap
    hv = max(max(abs(corr)));
    caxis([-hv,hv]);
    rotateXLabels(gca, 45);
    title(name, 'FontSize', 10);
    colorbar;
    axis square;
    saveas(gca, sprintf('/mnt/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/MA/Corrmats/%s.png', name))
end
names = {'BA LIP memory left - fix ROIs LR sig', 'BA LIP memory right - fix ROIs LR sig', 'BA LIP memory left microstim - fix microstim ROIs LR sig','BA LIP memory right microstim - fix microstim ROIs LR sig', ...
    'BA Pul memory left - fix ROIs LR sig','BA Pul memory right - fix ROIs LR sig', 'BA Pul memory left microstim - fix microstim ROIs LR sig', 'BA Pul memory right microstim - fix microstim ROIs LR sig',...
    'BA Pul memory left microstim - no microstim ROIs LR sig', 'BA Pul memory right microstim - no microstim ROIs LR sig', 'BA LIP memory left microstim - no microstim ROIs LR sig', ...
    'BA LIP memory right microstim - no microstim ROIs LR sig', 'BA memory left microstim Pulvinar - LIP  ROIs LR sig', 'BA memory right microstim Pulvinar - LIP ROIs LR sig'};
bootgroups = {{vertcat(memllip,fixlip),length(memllip)},{vertcat(memrlip,fixlip),length(memrlip)},{vertcat(memlmslip,fixmslip),length(memlmslip)},{vertcat(memrmslip,fixmslip),length(memrmslip)},{vertcat(memlpul,fixpul),length(memlpul)},...
    {vertcat(memrpul,fixpul),length(memrpul)}, {vertcat(memlmspul,fixmspul),length(memlmspul)},{vertcat(memrmspul,fixmspul),length(memrmspul)},{vertcat(memlmspul,memlpul),length(memlmspul)},{vertcat(memrmspul,memrpul),length(memrmspul)},...
    {vertcat(memlmslip, memllip),length(memlmslip)}, {vertcat(memrmslip,memrlip),length(memrmslip)},{vertcat(memlmspul,memlmslip),length(memlmspul)},{vertcat(memrmspul,memrmslip),length(memrmspul)}};

for i = 1:length(names)
    corr = corrs{i};
    name = names{i};
    [low,high] = bootcorrs(1000, bootgroups{i});
    corr(corr>low & corr<high) = 0;
    imagesc(corr)
    set(gca, 'XTick', 1:length(voinames));
    set(gca, 'YTick', 1:length(voinames));
    set(gca, 'TickLength',[0 0])
    set(gca, 'XTickLabel',strrep({voinames.Name}, '_', '-'), 'fontsize', 8);
    set(gca, 'YTickLabel',strrep({voinames.Name}, '_', '-'), 'fontsize', 8);
    set(gca, 'YDir', 'reverse');
    colormap(redblue) %uses https://de.mathworks.com/matlabcentral/fileexchange/25536-red-blue-colormap
    hv = max(max(abs(corr)));
    caxis([-hv,hv]);
    rotateXLabels(gca, 45);
    title(name, 'FontSize', 10);
    colorbar;
    axis square;
    saveas(gca, sprintf('/mnt/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/MA/Corrmats/%s.png', name))
end

%% 
%BA ROIs RL
%LIP
conditions = {'BA ROIs RL LIP fixation' 'BA ROIs RL LIP fixation microstim' 'BA ROIs RL LIP memory left' 'BA ROIs RL LIP memory right' 'BA ROIs RL LIP memory left microstim' 'BA ROIs RL LIP memory right microstim'};
voi = xff('/mnt/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/BA_bl_lr_k20_05FDR_positiveonly_from_BA_CHARM_tal.voi');
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


%run this to check for which stimsite has less NAs, they overlap but one
%generally will have more, but not in this case, wheee

betaseries = lip;
for i = 1:length(conditions)
    rm = [];
    for j = 1:size(betaseries{i},2)
        if all(isnan(betaseries{i}(:,j)))
            rm = [rm j];
        end
    end
    betaseries{i}(:,rm) = []; 
     if ~isempty(rm)
         warning('Removed for NaN:\n %s \n', voinames(rm).Name)
     end     
end
voinames(rm) = [];

for i = 1:length(conditions)
    [corr,P] = corrcoef(betaseries{i}, 'rows', 'pairwise');
    corr(P>0.05) = 0; %removes non-significant correlations
    imagesc(corr)
    set(gca, 'XTick', 1:length(betaseries{i}));
    set(gca, 'YTick', 1:length(betaseries{i}));
    set(gca, 'TickLength',[0 0])
    set(gca, 'XTickLabel',strrep({voinames.Name}, '_', '-'), 'fontsize', 8);
    set(gca, 'YTickLabel',strrep({voinames.Name}, '_', '-'), 'fontsize', 8);
    set(gca, 'YDir', 'reverse');
    colormap(redblue) %uses https://de.mathworks.com/matlabcentral/fileexchange/25536-red-blue-colormap
    caxis([-1,1]);
    rotateXLabels(gca, 45);
    title(conditions{i}, 'FontSize', 10);
    colorbar;
    axis square;
    saveas(gca, sprintf('/mnt/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/MA/Corrmats/%s.png', conditions{i}))
end

corrfixlip = corrcoef(betaseries{1}, 'rows', 'pairwise');
corrfixmslip = corrcoef(betaseries{2}, 'rows', 'pairwise');
corrmemllip = corrcoef(betaseries{3}, 'rows', 'pairwise');
corrmemrlip = corrcoef(betaseries{4}, 'rows', 'pairwise');
corrmemlmslip = corrcoef(betaseries{5}, 'rows', 'pairwise');
corrmemrmslip = corrcoef(betaseries{6}, 'rows', 'pairwise');

conditions = {'BA fixation Pul ROIs RL' 'BA fixation microstim Pul ROIs RL' 'BA memory left Pul ROIs RL' 'BA memory right Pul ROIs RL' 'BA memory left microstim Pul ROIs RL' 'BA memory right microstim Pul ROIs RL'};

betaseries = pul;
for i = 1:length(conditions)
    betaseries{i}(:,rm) = []; 
end

for i = 1:length(conditions)
    [corr,P] = corrcoef(betaseries{i}, 'rows', 'pairwise');
    corr(P>0.05) = 0; %removes non-significant correlations
    imagesc(corr)
    set(gca, 'XTick', 1:length(betaseries{i}));
    set(gca, 'YTick', 1:length(betaseries{i}));
    set(gca, 'TickLength',[0 0])
    set(gca, 'XTickLabel',strrep({voinames.Name}, '_', '-'), 'fontsize', 8);
    set(gca, 'YTickLabel',strrep({voinames.Name}, '_', '-'), 'fontsize', 8);
    set(gca, 'YDir', 'reverse');
    colormap(redblue) %uses https://de.mathworks.com/matlabcentral/fileexchange/25536-red-blue-colormap
    caxis([-1,1]);
    rotateXLabels(gca, 45);
    title(conditions{i}, 'FontSize', 10);
    colorbar;
    axis square;
    saveas(gca, sprintf('/mnt/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/MA/Corrmats/%s.png', conditions{i}))
end

corrfixpul = corrcoef(betaseries{1}, 'rows', 'pairwise');
corrfixmspul = corrcoef(betaseries{2}, 'rows', 'pairwise');
corrmemlpul = corrcoef(betaseries{3}, 'rows', 'pairwise');
corrmemrpul = corrcoef(betaseries{4}, 'rows', 'pairwise');
corrmemlmspul = corrcoef(betaseries{5}, 'rows', 'pairwise');
corrmemrmspul = corrcoef(betaseries{6}, 'rows', 'pairwise');

%contrasts

corrs = {corrmemllip - corrfixlip,corrmemrlip - corrfixlip,corrmemlmslip - corrfixmslip, corrmemrmslip - corrfixmslip,corrmemlpul - corrfixpul,...
    corrmemrpul - corrfixpul, corrmemlmspul - corrfixmspul, corrmemrmspul - corrfixmspul,corrmemlmspul - corrmemlpul,corrmemrmspul - corrmemrpul,...
    corrmemlmslip - corrmemllip, corrmemrmslip - corrmemrlip,corrmemlmspul - corrmemlmslip, corrmemrmspul - corrmemrmslip};
names = {'BA LIP memory left - fix ROIs RL', 'BA LIP memory right - fix ROIs RL', 'BA LIP memory left microstim - fix microstim ROIs RL','BA LIP memory right microstim - fix microstim ROIs RL', ...
    'BA Pul memory left - fix ROIs RL','BA Pul memory right - fix ROIs RL', 'BA Pul memory left microstim - fix microstim ROIs RL', 'BA Pul memory right microstim - fix microstim ROIs RL',...
    'BA Pul memory left microstim - no microstim ROIs RL', 'BA Pul memory right microstim - no microstim ROIs RL', 'BA LIP memory left microstim - no microstim ROIs RL', ...
    'BA LIP memory right microstim - no microstim ROIs RL', 'BA memory left microstim Pulvinar - LIP  ROIs RL', 'BA memory right microstim Pulvinar - LIP ROIs RL'};

for i = 1:length(names)
    corr = corrs{i};
    name = names{i};
    imagesc(corr)
    set(gca, 'XTick', 1:length(voinames));
    set(gca, 'YTick', 1:length(voinames));
    set(gca, 'TickLength',[0 0])
    set(gca, 'XTickLabel',strrep({voinames.Name}, '_', '-'), 'fontsize', 8);
    set(gca, 'YTickLabel',strrep({voinames.Name}, '_', '-'), 'fontsize', 8);
    set(gca, 'YDir', 'reverse');
    colormap(redblue) %uses https://de.mathworks.com/matlabcentral/fileexchange/25536-red-blue-colormap
    hv = max(max(abs(corr)));
    caxis([-hv,hv]);
    rotateXLabels(gca, 45);
    title(name, 'FontSize', 10);
    colorbar;
    axis square;
    saveas(gca, sprintf('/mnt/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/MA/Corrmats/%s.png', name))
end

names = {'BA LIP memory left - fix ROIs RL sig', 'BA LIP memory right - fix ROIs RL sig', 'BA LIP memory left microstim - fix microstim ROIs RL sig','BA LIP memory right microstim - fix microstim ROIs RL sig', ...
    'BA Pul memory left - fix ROIs RL sig','BA Pul memory right - fix ROIs RL sig', 'BA Pul memory left microstim - fix microstim ROIs RL sig', 'BA Pul memory right microstim - fix microstim ROIs RL sig',...
    'BA Pul memory left microstim - no microstim ROIs RL sig', 'BA Pul memory right microstim - no microstim ROIs RL sig', 'BA LIP memory left microstim - no microstim ROIs RL sig', ...
    'BA LIP memory right microstim - no microstim ROIs RL sig', 'BA memory left microstim Pulvinar - LIP  ROIs RL sig', 'BA memory right microstim Pulvinar - LIP ROIs RL sig'};
bootgroups = {{vertcat(memllip,fixlip),length(memllip)},{vertcat(memrlip,fixlip),length(memrlip)},{vertcat(memlmslip,fixmslip),length(memlmslip)},{vertcat(memrmslip,fixmslip),length(memrmslip)},{vertcat(memlpul,fixpul),length(memlpul)},...
    {vertcat(memrpul,fixpul),length(memrpul)}, {vertcat(memlmspul,fixmspul),length(memlmspul)},{vertcat(memrmspul,fixmspul),length(memrmspul)},{vertcat(memlmspul,memlpul),length(memlmspul)},{vertcat(memrmspul,memrpul),length(memrmspul)},...
    {vertcat(memlmslip, memllip),length(memlmslip)}, {vertcat(memrmslip,memrlip),length(memrmslip)},{vertcat(memlmspul,memlmslip),length(memlmspul)},{vertcat(memrmspul,memrmslip),length(memrmspul)}};

for i = 1:length(names)
    corr = corrs{i};
    name = names{i};
    [low,high] = bootcorrs(1000, bootgroups{i});
    corr(corr>low & corr<high) = 0;
    imagesc(corr)
    set(gca, 'XTick', 1:length(voinames));
    set(gca, 'YTick', 1:length(voinames));
    set(gca, 'TickLength',[0 0])
    set(gca, 'XTickLabel',strrep({voinames.Name}, '_', '-'), 'fontsize', 8);
    set(gca, 'YTickLabel',strrep({voinames.Name}, '_', '-'), 'fontsize', 8);
    set(gca, 'YDir', 'reverse');
    colormap(redblue) %uses https://de.mathworks.com/matlabcentral/fileexchange/25536-red-blue-colormap
    hv = max(max(abs(corr)));
    caxis([-hv,hv]);
    rotateXLabels(gca, 45);
    title(name, 'FontSize', 10);
    colorbar;
    axis square;
    saveas(gca, sprintf('/mnt/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/MA/Corrmats/%s.png', name))
end
