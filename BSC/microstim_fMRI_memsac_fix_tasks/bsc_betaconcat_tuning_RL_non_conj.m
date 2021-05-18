if isunix
    cd('/fileserver/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/MA/betaseries/Bacchus/LIPd_p_RL_contra(ig)')
elseif ispc
    cd('Y:\Personal\AlexandraWitt\MA\betaseries\Bacchus\LIPd_p_RL_contra(ig)')
end
files = dir('*.mat');
for i = 1:length(files)
    load(files(i).name)
end

if isunix
    cd('/fileserver/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/MA/betaseries/Bacchus/dPul_p_RL_contra(ig)')
elseif ispc
    cd('Y:\Personal\AlexandraWitt\MA\betaseries\Bacchus\dPul_p_RL_contra(ig)')    
end

files = dir('*.mat');
for i = 1:length(files)
    load(files(i).name)
end
% %check for outliers
bs0301 = (betaseries_20170301);%dPulp
bs0302 = (betaseries_20170302);
bs0303 = (betaseries_20170303);
bs0317 = (betaseries_20170317);
bs0324 = (betaseries_20170324);
bs0329 = (betaseries_20170329);
bs0405 = (betaseries_20170405);
bs0406 = (betaseries_20170406);
bs0407 = (betaseries_20170407);
bs0601 = (betaseries_20170601);%LIPdp
bs0602 = (betaseries_20170602);
bs0607 = (betaseries_20170607);
bs0608 = (betaseries_20170608);
bs0609 = (betaseries_20170609);
bs0614 = (betaseries_20170614);
bs0615 = (betaseries_20170615);
bs0616 = (betaseries_20170616);
bs0622 = (betaseries_20170622);
bs0623 = (betaseries_20170623);

llist = {bs0301,bs0302,bs0303,bs0317,bs0324,bs0329,bs0405,...
    bs0406,bs0407,bs0601,bs0602,...
    bs0607,bs0608,bs0609,bs0614,bs0615,bs0616,bs0622,bs0623};

for i = 1:length(llist)
    for j = 1:length(llist{i})
        rm = [];
        for k=1:size(llist{i}{j},1)
            if max(llist{i}{j}(k,:)) > 5 || min(llist{i}{j}(k,:))<-5
                rm = [rm, k];
            end
        end
        llist{i}{j}(rm,:) = [];
    end
end

bs0301 = bsc_z_score(betaseries_20170301);%dPulp
bs0302 = bsc_z_score(betaseries_20170302);
bs0303 = bsc_z_score(betaseries_20170303);
bs0317 = bsc_z_score(betaseries_20170317);
bs0324 = bsc_z_score(betaseries_20170324);
bs0329 = bsc_z_score(betaseries_20170329);
bs0405 = bsc_z_score(betaseries_20170405);
bs0406 = bsc_z_score(betaseries_20170406);
bs0407 = bsc_z_score(betaseries_20170407);
bs0601 = bsc_z_score(betaseries_20170601);%LIPdp
bs0602 = bsc_z_score(betaseries_20170602);
bs0607 = bsc_z_score(betaseries_20170607);
bs0608 = bsc_z_score(betaseries_20170608);
bs0609 = bsc_z_score(betaseries_20170609);
bs0614 = bsc_z_score(betaseries_20170614);
bs0615 = bsc_z_score(betaseries_20170615);
bs0616 = bsc_z_score(betaseries_20170616);
bs0622 = bsc_z_score(betaseries_20170622);
bs0623 = bsc_z_score(betaseries_20170623);

%lipdp for tuning

fixlip = vertcat(bs0601{1}, bs0602{1},bs0614{1}, bs0615{1}, bs0622{1},bs0607{1},bs0608{1},bs0609{1},bs0616{1},bs0623{1}); 
fixmslip = vertcat(bs0601{2}, bs0602{2},bs0614{2}, bs0615{2}, bs0622{2},bs0607{2},bs0608{2},bs0609{2},bs0616{2},bs0623{2});
memllip = vertcat(bs0601{3}, bs0602{3},bs0614{3}, bs0615{3}, bs0622{3},bs0607{3},bs0608{3},bs0609{3},bs0616{3},bs0623{3});
memrlip = vertcat(bs0601{4}, bs0602{4},bs0614{4}, bs0615{4}, bs0622{4},bs0607{4},bs0608{4},bs0609{4},bs0616{4},bs0623{4});
memlmslip = vertcat(bs0601{5}, bs0602{5},bs0614{5}, bs0615{5}, bs0622{5},bs0607{5},bs0608{5},bs0609{5},bs0616{5},bs0623{5});
memrmslip = vertcat(bs0601{6}, bs0602{6},bs0614{6}, bs0615{6}, bs0622{6},bs0607{6},bs0608{6},bs0609{6},bs0616{6},bs0623{6});


fixpul = vertcat(bs0302{1},bs0303{1},bs0317{1},bs0324{1},bs0329{1},bs0406{1},bs0407{1},bs0301{1},bs0405{1});%,
fixmspul = vertcat(bs0302{2},bs0303{2},bs0317{2},bs0324{2},bs0329{2},bs0406{2},bs0407{2},bs0301{2},bs0405{2});%,
memlpul = vertcat(bs0302{3},bs0303{3},bs0317{3},bs0324{3},bs0329{3},bs0406{3},bs0407{3},bs0301{3},bs0405{3});%,
memrpul = vertcat(bs0302{4},bs0303{4},bs0317{4},bs0324{4},bs0329{4},bs0406{4},bs0407{4},bs0301{4},bs0405{4});%,
memlmspul = vertcat(bs0302{5},bs0303{5},bs0317{5},bs0324{5},bs0329{5},bs0406{5},bs0407{5},bs0301{5},bs0405{5});%,
memrmspul = vertcat(bs0302{6},bs0303{6},bs0317{6},bs0324{6},bs0329{6},bs0406{6},bs0407{6},bs0301{6},bs0405{6});%,

pul = {fixpul, fixmspul, memlpul, memrpul, memlmspul, memrmspul};
lip = {fixlip, fixmslip, memllip, memrlip, memlmslip, memrmslip};

%BA LIPd_p
if isunix
    voi = xff('/fileserver/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/BA_LIPd_p_RL_ig_from_BA_CHARM_dilated_tal.voi');
elseif ispc
    voi = xff('Y:\Personal\AlexandraWitt\BA_LIPd_p_RL_ig_from_BA_CHARM_dilated_tal.voi');    
end
voinames = voi.VOI;
if isunix
    load('/fileserver/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/CHARM_SARM/CHARMSARMkeycombined.mat') %make path windowscompatible
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

conditions = {'BA LIP fixation LIPd_p ROIs RL' 'BA LIP fixation microstim LIPd_p ROIs RL' 'BA LIP memory left LIPd_p ROIs RL' 'BA LIP memory right LIPd_p ROIs RL' 'BA LIP memory left microstim LIPd_p ROIs RL' 'BA LIP memory right microstim LIPd_p ROIs RL'};
betaseries = lip;
for i = 1:length(conditions)
    [corr,P] = corrcoef(betaseries{i}, 'rows', 'pairwise');
    corr(~fdr_bh(P)) = 0; %removes non-significant correlations
    imagesc(corr)
    set(gca, 'XTick', 1:length(betaseries{i}));
    set(gca, 'YTick', 1:length(betaseries{i}));
    set(gca, 'TickLength',[0 0])
    set(gca, 'XTickLabel',strrep({voinames.Name}, '_', ' '), 'fontsize', 6);
    set(gca, 'YTickLabel',strrep({voinames.Name}, '_', ' '), 'fontsize', 6);
    ax = gca;
    for j = 1:length(ax.XTickLabel)
        if str2double(strtok(ax.XTickLabel{j},'-'))<90
            ax.XTickLabel{j} = ['\color{red}' ax.XTickLabel{j}];
            ax.YTickLabel{j} = ['\color{red}' ax.YTickLabel{j}];
        elseif str2double(strtok(ax.XTickLabel{j},'-'))<138
            ax.XTickLabel{j} = ['\color{orange}' ax.XTickLabel{j}];
            ax.YTickLabel{j} = ['\color{orange}' ax.YTickLabel{j}];
        elseif str2double(strtok(ax.XTickLabel{j},'-'))<231
            ax.XTickLabel{j} = ['\color{green}' ax.XTickLabel{j}];
            ax.YTickLabel{j} = ['\color{green}' ax.YTickLabel{j}];
        else
            ax.XTickLabel{j} = ['\color{blue}' ax.XTickLabel{j}];
            ax.YTickLabel{j} = ['\color{blue}' ax.YTickLabel{j}];
        end
    end
    set(gca, 'YDir', 'reverse');
    colormap(redblue) %uses https://de.mathworks.com/matlabcentral/fileexchange/25536-red-blue-colormap
    caxis([-1,1]);
    rotateXLabels(gca, 45);
    %title(conditions{i}, 'FontSize', 10);
    colorbar;
    axis square;
    if isunix
        saveas(gca, sprintf('/fileserver/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/Results/LIPd_p/RL/%s.png', conditions{i}))
    elseif ispc
        saveas(gca, sprintf('Y:\\Personal\\AlexandraWitt\\Results\\LIPd_p\\RL\\%s.png', conditions{i}))        
    end
end

corrfixlip = corrcoef(betaseries{1}, 'rows', 'pairwise');
corrfixmslip = corrcoef(betaseries{2}, 'rows', 'pairwise');
corrmemllip = corrcoef(betaseries{3}, 'rows', 'pairwise');
corrmemrlip = corrcoef(betaseries{4}, 'rows', 'pairwise');
corrmemlmslip = corrcoef(betaseries{5}, 'rows', 'pairwise');
corrmemrmslip = corrcoef(betaseries{6}, 'rows', 'pairwise');

%contrasts
corrs = {corrmemllip - corrfixlip,...
    corrmemrlip - corrfixlip, corrmemlmslip - corrfixmslip, corrmemrmslip - corrfixmslip,corrmemlmslip - corrmemllip,corrmemrmslip - corrmemrlip,...
    corrfixmslip - corrfixlip,corrmemllip-corrmemrlip,corrmemlmslip - corrmemrmslip};
names = {'BA LIP memory left - fix LIPd_p ROIs RL','BA LIP memory right - fix LIPd_p ROIs RL', 'BA LIP memory left microstim - fix microstim LIPd_p ROIs RL', 'BA LIP memory right microstim - fix microstim LIPd_p ROIs RL',...
    'BA LIP memory left microstim - no microstim LIPd_p ROIs RL', 'BA LIP memory right microstim - no microstim LIPd_p ROIs RL','BA LIP fixation microstim - no microstim LIPd_p ROIs RL', 'BA LIP Memory left - memory right LIPd_p ROIs RL', 'BA LIP Memory left microstim - memory right microstim LIPd_p ROIs RL'};

for i = 1:length(names)
    corr = corrs{i};
    name = names{i};
    imagesc(corr)
    set(gca, 'XTick', 1:length(voinames));
    set(gca, 'YTick', 1:length(voinames));
    set(gca, 'TickLength',[0 0])
    set(gca, 'XTickLabel',strrep({voinames.Name}, '_', ' '), 'fontsize', 6);
    set(gca, 'YTickLabel',strrep({voinames.Name}, '_', ' '), 'fontsize', 6);
    ax = gca;
    for j = 1:length(ax.XTickLabel)
        if str2double(strtok(ax.XTickLabel{j},'-'))<90
            ax.XTickLabel{j} = ['\color{red}' ax.XTickLabel{j}];
            ax.YTickLabel{j} = ['\color{red}' ax.YTickLabel{j}];
        elseif str2double(strtok(ax.XTickLabel{j},'-'))<138
            ax.XTickLabel{j} = ['\color{orange}' ax.XTickLabel{j}];
            ax.YTickLabel{j} = ['\color{orange}' ax.YTickLabel{j}];
        elseif str2double(strtok(ax.XTickLabel{j},'-'))<231
            ax.XTickLabel{j} = ['\color{green}' ax.XTickLabel{j}];
            ax.YTickLabel{j} = ['\color{green}' ax.YTickLabel{j}];
        else
            ax.XTickLabel{j} = ['\color{blue}' ax.XTickLabel{j}];
            ax.YTickLabel{j} = ['\color{blue}' ax.YTickLabel{j}];
        end
    end
    set(gca, 'YDir', 'reverse');
    colormap(redblue) %uses https://de.mathworks.com/matlabcentral/fileexchange/25536-red-blue-colormap
    hv = max(max(abs(corr)));
    caxis([-hv,hv]);
    rotateXLabels(gca, 45);
    %title(name, 'FontSize', 10);
    colorbar;
    axis square;
    if isunix
        saveas(gca, sprintf('/fileserver/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/Results/LIPd_p/RL/%s.png', name))
    elseif ispc
        saveas(gca, sprintf('Y:\\Personal\\AlexandraWitt\\Results\\LIPd_p\\RL\\%s.png', name))        
    end
end
names = {'BA LIP memory left - fix LIPd_p ROIs RL sig','BA LIP memory right - fix LIPd_p ROIs RL sig', 'BA LIP memory left microstim - fix microstim LIPd_p ROIs RL sig', 'BA LIP memory right microstim - fix microstim LIPd_p ROIs RL sig',...
    'BA LIP memory left microstim - no microstim LIPd_p ROIs RL sig', 'BA LIP memory right microstim - no microstim LIPd_p ROIs RL sig','BA LIP fixation microstim - no microstim LIPd_p ROIs RL sig', 'BA LIP Memory left - memory right LIPd_p ROIs RL sig', 'BA LIP Memory left microstim - memory right microstim LIPd_p ROIs RL sig'};
bootgroups = {{vertcat(memllip,fixlip),length(memllip)},...
    {vertcat(memrlip,fixlip),length(memrlip)}, {vertcat(memlmslip,fixmslip),length(memlmslip)},{vertcat(memrmslip,fixmslip),length(memrmslip)},{vertcat(memlmslip,memllip),length(memlmslip)},{vertcat(memrmslip,memrlip),length(memrmslip)},...
    {vertcat(fixlip,fixmslip),length(fixlip)}, {vertcat(memllip,memrlip),length(memllip)},{vertcat(memlmslip, memrmslip),length(memlmslip)}};

for i = 1:length(names)
    corr = corrs{i};
    name = names{i};
    [low,high] = bootcorrs(1000, bootgroups{i});
    corr(corr>low & corr<high) = 0;
    imagesc(corr)
    set(gca, 'XTick', 1:length(voinames));
    set(gca, 'YTick', 1:length(voinames));
    set(gca, 'TickLength',[0 0])
    set(gca, 'XTickLabel',strrep({voinames.Name}, '_', ' '), 'fontsize', 6);
    set(gca, 'YTickLabel',strrep({voinames.Name}, '_', ' '), 'fontsize', 6);
    ax = gca;
    for j = 1:length(ax.XTickLabel)
        if str2double(strtok(ax.XTickLabel{j},'-'))<90
            ax.XTickLabel{j} = ['\color{red}' ax.XTickLabel{j}];
            ax.YTickLabel{j} = ['\color{red}' ax.YTickLabel{j}];
        elseif str2double(strtok(ax.XTickLabel{j},'-'))<138
            ax.XTickLabel{j} = ['\color{orange}' ax.XTickLabel{j}];
            ax.YTickLabel{j} = ['\color{orange}' ax.YTickLabel{j}];
        elseif str2double(strtok(ax.XTickLabel{j},'-'))<231
            ax.XTickLabel{j} = ['\color{green}' ax.XTickLabel{j}];
            ax.YTickLabel{j} = ['\color{green}' ax.YTickLabel{j}];
        else
            ax.XTickLabel{j} = ['\color{blue}' ax.XTickLabel{j}];
            ax.YTickLabel{j} = ['\color{blue}' ax.YTickLabel{j}];
        end
    end
    set(gca, 'YDir', 'reverse');
    colormap(redblue) %uses https://de.mathworks.com/matlabcentral/fileexchange/25536-red-blue-colormap
    hv = max(max(abs(corr)));
    caxis([-hv,hv]);
    rotateXLabels(gca, 45);
    %title(name, 'FontSize', 10);
    colorbar;
    axis square;
    if isunix
        saveas(gca, sprintf('/fileserver/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/Results/LIPd_p/RL/%s.png', name))
    elseif ispc
        saveas(gca, sprintf('Y:\\Personal\\AlexandraWitt\\Results\\LIPd_p\\RL\\%s.png', name))        
    end
end

%BA dPul_p
if isunix
    voi = xff('/fileserver/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/BA_dPul_p_RL_ig_from_BA_CHARM_dilated_tal.voi');
elseif ispc
    voi = xff('Y:\Personal\AlexandraWitt\BA_dPul_p_RL_ig_from_BA_CHARM_dilated_tal.voi');    
end
    
voinames = voi.VOI;
if isunix
    load('/fileserver/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/CHARM_SARM/CHARMSARMkeycombined.mat') %make path windowscompatible
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

conditions = {'BA Pul fixation dPul_p ROIs RL' 'BA Pul fixation microstim dPul_p ROIs RL' 'BA Pul memory left dPul_p ROIs RL' 'BA Pul memory right dPul_p ROIs RL' 'BA Pul memory left microstim dPul_p ROIs RL' 'BA Pul memory right microstim dPul_p ROIs RL'};
betaseries = pul;
for i = 1:length(conditions)
    [corr,P] = corrcoef(betaseries{i}, 'rows', 'pairwise');
    corr(~fdr_bh(P)) = 0; %removes non-significant correlations
    imagesc(corr)
    set(gca, 'XTick', 1:length(betaseries{i}));
    set(gca, 'YTick', 1:length(betaseries{i}));
    set(gca, 'TickLength',[0 0])
    set(gca, 'XTickLabel',strrep({voinames.Name}, '_', '-'), 'fontsize', 6);
    set(gca, 'YTickLabel',strrep({voinames.Name}, '_', '-'), 'fontsize', 6);
    ax = gca;
    for j = 1:length(ax.XTickLabel)
        if str2double(strtok(ax.XTickLabel{j},'-'))<90
            ax.XTickLabel{j} = ['\color{red}' ax.XTickLabel{j}];
            ax.YTickLabel{j} = ['\color{red}' ax.YTickLabel{j}];
        elseif str2double(strtok(ax.XTickLabel{j},'-'))<138
            ax.XTickLabel{j} = ['\color{orange}' ax.XTickLabel{j}];
            ax.YTickLabel{j} = ['\color{orange}' ax.YTickLabel{j}];
        elseif str2double(strtok(ax.XTickLabel{j},'-'))<231
            ax.XTickLabel{j} = ['\color{green}' ax.XTickLabel{j}];
            ax.YTickLabel{j} = ['\color{green}' ax.YTickLabel{j}];
        else
            ax.XTickLabel{j} = ['\color{blue}' ax.XTickLabel{j}];
            ax.YTickLabel{j} = ['\color{blue}' ax.YTickLabel{j}];
        end
    end
    set(gca, 'YDir', 'reverse');
    colormap(redblue) %uses https://de.mathworks.com/matlabcentral/fileexchange/25536-red-blue-colormap
    caxis([-1,1]);
    rotateXLabels(gca, 45);
    %title(conditions{i}, 'FontSize', 10);
    colorbar;
    axis square;
    if isunix
        saveas(gca, sprintf('/fileserver/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/Results/dPul_p/RL/%s.png', conditions{i}))
    elseif ispc
        saveas(gca, sprintf('Y:\\Personal\\AlexandraWitt\\Results\\dPul_p\\RL\\%s.png', conditions{i}))        
    end
end

corrfixpul = corrcoef(betaseries{1}, 'rows', 'pairwise');
corrfixmspul = corrcoef(betaseries{2}, 'rows', 'pairwise');
corrmemlpul = corrcoef(betaseries{3}, 'rows', 'pairwise');
corrmemrpul = corrcoef(betaseries{4}, 'rows', 'pairwise');
corrmemlmspul = corrcoef(betaseries{5}, 'rows', 'pairwise');
corrmemrmspul = corrcoef(betaseries{6}, 'rows', 'pairwise');

%contrasts
corrs = {corrmemlpul - corrfixpul,...
    corrmemrpul - corrfixpul, corrmemlmspul - corrfixmspul, corrmemrmspul - corrfixmspul,corrmemlmspul - corrmemlpul,corrmemrmspul - corrmemrpul,...
    corrfixmspul - corrfixpul,corrmemlpul-corrmemrpul,corrmemlmspul - corrmemrmspul};
names = {'BA Pul memory left - fix dPul_p ROIs RL','BA Pul memory right - fix dPul_p ROIs RL', 'BA Pul memory left microstim - fix microstim dPul_p ROIs RL', 'BA Pul memory right microstim - fix microstim dPul_p ROIs RL',...
    'BA Pul memory left microstim - no microstim dPul_p ROIs RL', 'BA Pul memory right microstim - no microstim dPul_p ROIs RL','BA Pul fixation microstim - no microstim dPul_p ROIs RL', 'BA Pul Memory left - memory right dPul_p ROIs RL', 'BA Pul Memory left microstim - memory right microstim dPul_p ROIs RL'};

for i = 1:length(names)
    corr = corrs{i};
    name = names{i};
    imagesc(corr)
    set(gca, 'XTick', 1:length(voinames));
    set(gca, 'YTick', 1:length(voinames));
    set(gca, 'TickLength',[0 0])
    set(gca, 'XTickLabel',strrep({voinames.Name}, '_', '-'), 'fontsize', 6);
    set(gca, 'YTickLabel',strrep({voinames.Name}, '_', '-'), 'fontsize', 6);
    ax = gca;
    for j = 1:length(ax.XTickLabel)
        if str2double(strtok(ax.XTickLabel{j},'-'))<90
            ax.XTickLabel{j} = ['\color{red}' ax.XTickLabel{j}];
            ax.YTickLabel{j} = ['\color{red}' ax.YTickLabel{j}];
        elseif str2double(strtok(ax.XTickLabel{j},'-'))<138
            ax.XTickLabel{j} = ['\color{orange}' ax.XTickLabel{j}];
            ax.YTickLabel{j} = ['\color{orange}' ax.YTickLabel{j}];
        elseif str2double(strtok(ax.XTickLabel{j},'-'))<231
            ax.XTickLabel{j} = ['\color{green}' ax.XTickLabel{j}];
            ax.YTickLabel{j} = ['\color{green}' ax.YTickLabel{j}];
        else
            ax.XTickLabel{j} = ['\color{blue}' ax.XTickLabel{j}];
            ax.YTickLabel{j} = ['\color{blue}' ax.YTickLabel{j}];
        end
    end
    set(gca, 'YDir', 'reverse');
    colormap(redblue) %uses https://de.mathworks.com/matlabcentral/fileexchange/25536-red-blue-colormap
    hv = max(max(abs(corr)));
    caxis([-hv,hv]);
    rotateXLabels(gca, 45);
    %title(name, 'FontSize', 10);
    colorbar;
    axis square;
    if isunix
        saveas(gca, sprintf('/fileserver/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/Results/dPul_p/RL/%s.png', name))
    elseif ispc
        saveas(gca, sprintf('Y:\\Personal\\AlexandraWitt\\Results\\dPul_p\\RL\\%s.png', name))        
    end
end
names = {'BA Pul memory left - fix dPul_p ROIs RL sig','BA Pul memory right - fix dPul_p ROIs RL sig', 'BA Pul memory left microstim - fix microstim dPul_p ROIs RL sig', 'BA Pul memory right microstim - fix microstim dPul_p ROIs RL sig',...
    'BA Pul memory left microstim - no microstim dPul_p ROIs RL sig', 'BA Pul memory right microstim - no microstim dPul_p ROIs RL sig','BA Pul fixation microstim - no microstim dPul_p ROIs RL sig', 'BA Pul Memory left - memory right dPul_p ROIs RL sig', 'BA Pul Memory left microstim - memory right microstim dPul_p ROIs RL sig'};
bootgroups = {{vertcat(memlpul,fixpul),length(memlpul)},...
    {vertcat(memrpul,fixpul),length(memrpul)}, {vertcat(memlmspul,fixmspul),length(memlmspul)},{vertcat(memrmspul,fixmspul),length(memrmspul)},{vertcat(memlmspul,memlpul),length(memlmspul)},{vertcat(memrmspul,memrpul),length(memrmspul)},...
    {vertcat(fixpul,fixmspul),length(fixpul)}, {vertcat(memlpul,memrpul),length(memlpul)},{vertcat(memlmspul, memrmspul),length(memlmspul)}};

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
    ax = gca;
    for j = 1:length(ax.XTickLabel)
        if str2double(strtok(ax.XTickLabel{j},'-'))<90
            ax.XTickLabel{j} = ['\color{red}' ax.XTickLabel{j}];
            ax.YTickLabel{j} = ['\color{red}' ax.YTickLabel{j}];
        elseif str2double(strtok(ax.XTickLabel{j},'-'))<138
            ax.XTickLabel{j} = ['\color{orange}' ax.XTickLabel{j}];
            ax.YTickLabel{j} = ['\color{orange}' ax.YTickLabel{j}];
        elseif str2double(strtok(ax.XTickLabel{j},'-'))<231
            ax.XTickLabel{j} = ['\color{green}' ax.XTickLabel{j}];
            ax.YTickLabel{j} = ['\color{green}' ax.YTickLabel{j}];
        else
            ax.XTickLabel{j} = ['\color{blue}' ax.XTickLabel{j}];
            ax.YTickLabel{j} = ['\color{blue}' ax.YTickLabel{j}];
        end
    end
    set(gca, 'YDir', 'reverse');
    colormap(redblue) %uses https://de.mathworks.com/matlabcentral/fileexchange/25536-red-blue-colormap
    hv = max(max(abs(corr)));
    caxis([-hv,hv]);
    rotateXLabels(gca, 45);
    %title(name, 'FontSize', 10);
    colorbar;
    axis square;
    if isunix
        saveas(gca, sprintf('/fileserver/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/Results/dPul_p/RL/%s.png', name))
    elseif ispc
        saveas(gca, sprintf('Y:\\Personal\\AlexandraWitt\\Results\\dPul_p\\RL\\%s.png', name))        
    end
end

if isunix
    cd('/fileserver/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/MA/betaseries/Curius/LIPd_p_RL_contra(ig)')
elseif ispc
    cd('Y:\Personal\AlexandraWitt\MA\betaseries\Curius\LIPd_p_RL_contra(ig)')    
end
files = dir('*.mat');
for i = 1:length(files)
    load(files(i).name)
end

if isunix
    cd('/fileserver/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/MA/betaseries/Curius/dPul_p_RL_contra(ig)')
elseif ispc
    cd('Y:\Personal\AlexandraWitt\MA\betaseries\Curius\dPul_p_RL_contra(ig)')    
end
files = dir('*.mat');
for i = 1:length(files)
    load(files(i).name)
end

bs0122 = (betaseries_20140122);
bs0124 = (betaseries_20140124);
bs0129 = (betaseries_20140129);
bs0131 = (betaseries_20140131);
bs0204 = (betaseries_20140204);
bs0214 = (betaseries_20140214);
bs0226 = (betaseries_20140226);
bs0225 = (betaseries_20150225);%Lipd_p
bs150226 =(betaseries_20150226);
bs0303 = (betaseries_20150303);
bs0311 = (betaseries_20150311);
bs0507 = (betaseries_20150507);

llist = {bs0122,bs0124,bs0129,bs0131,bs0204,bs0214,bs0226,bs0225,bs150226,bs0303,bs0311,...
    bs0507};

for i = 1:length(llist)
    for j = 1:length(llist{i})
        rm = [];
        for k=1:size(llist{i}{j},1)
            if max(llist{i}{j}(k,:)) > 5 || min(llist{i}{j}(k,:))<-5
                rm = [rm, k];
            end
        end
        llist{i}{j}(rm,:) = [];
    end
end

%z-score

bs0122 = bsc_z_score(llist{1});
bs0124 = bsc_z_score(llist{2});
bs0129 = bsc_z_score(llist{3}); 
bs0131 = bsc_z_score(llist{4}); 
bs0204 = bsc_z_score(llist{5});
bs0214 = bsc_z_score(llist{6});
bs0226 = bsc_z_score(llist{7}); 
bs0225 = bsc_z_score(llist{8});
bs150226 = bsc_z_score(llist{9});
bs0303 = bsc_z_score(llist{10});
bs0311 = bsc_z_score(llist{11});
bs0507 = bsc_z_score(llist{12});

%sort conditions
fixlip = vertcat(bs0303{1},bs0311{1},bs0225{1},bs0507{1},bs150226{1}); 
fixmslip = vertcat(bs0303{2},bs0311{2},bs0225{2},bs0507{2},bs150226{2}); 
memllip = vertcat(bs0303{3},bs0311{3},bs0225{3},bs0507{3},bs150226{3}); 
memrlip = vertcat(bs0303{4},bs0311{4},bs0225{4},bs0507{4},bs150226{4}); 
memlmslip = vertcat(bs0303{5},bs0311{5},bs0225{5},bs0507{5},bs150226{5}); 
memrmslip = vertcat(bs0303{6},bs0311{6},bs0225{6},bs0507{6},bs150226{6}); 


fixpul = vertcat(bs0122{1}, bs0124{1},bs0129{1},bs0131{1},bs0204{1},bs0214{1},bs0226{1});%
fixmspul = vertcat(bs0122{2},bs0124{2},bs0129{2},bs0131{2},bs0204{2},bs0214{2},bs0226{2});
memlpul = vertcat(bs0122{1}, bs0124{3},bs0129{3},bs0131{3},bs0204{3},bs0214{3},bs0226{3});
memrpul = vertcat(bs0122{1}, bs0124{4},bs0129{4},bs0131{4},bs0204{4},bs0214{4},bs0226{4});
memlmspul = vertcat(bs0122{5}, bs0124{5},bs0129{5},bs0131{5},bs0204{5},bs0214{5},bs0226{5});
memrmspul = vertcat(bs0122{6}, bs0124{6},bs0129{6},bs0131{6},bs0204{6},bs0214{6},bs0226{6});

pul = {fixpul, fixmspul, memlpul, memrpul, memlmspul, memrmspul};
lip = {fixlip, fixmslip, memllip, memrlip, memlmslip, memrmslip};


%CU LIPd_p
if isunix
    voi = xff('/fileserver/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/CU_LIPd_p_RL_ig_from_CU_CHARM_dilated_tal.voi');
elseif ispc
    voi = xff('Y:\Personal\AlexandraWitt\CU_LIPd_p_RL_ig_from_CU_CHARM_dilated_tal.voi');    
end
voinames = voi.VOI;
if isunix
    load('/fileserver/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/CHARM_SARM/CHARMSARMkeycombined.mat') %make path windowscompatible
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

conditions = {'CU LIP fixation LIPd_p ROIs RL' 'CU LIP fixation microstim LIPd_p ROIs RL' 'CU LIP memory left LIPd_p ROIs RL' 'CU LIP memory right LIPd_p ROIs RL' 'CU LIP memory left microstim LIPd_p ROIs RL' 'CU LIP memory right microstim LIPd_p ROIs RL'};
betaseries = lip;
for i = 1:length(conditions)
    [corr,P] = corrcoef(betaseries{i}, 'rows', 'pairwise');
    corr(~fdr_bh(P)) = 0; %removes non-significant correlations
    imagesc(corr)
    set(gca, 'XTick', 1:length(betaseries{i}));
    set(gca, 'YTick', 1:length(betaseries{i}));
    set(gca, 'TickLength',[0 0])
    set(gca, 'XTickLabel',strrep({voinames.Name}, '_', ' '), 'fontsize', 6);
    set(gca, 'YTickLabel',strrep({voinames.Name}, '_', ' '), 'fontsize', 6);
    ax = gca;
    for j = 1:length(ax.XTickLabel)
        if str2double(strtok(ax.XTickLabel{j},'-'))<90
            ax.XTickLabel{j} = ['\color{red}' ax.XTickLabel{j}];
            ax.YTickLabel{j} = ['\color{red}' ax.YTickLabel{j}];
        elseif str2double(strtok(ax.XTickLabel{j},'-'))<138
            ax.XTickLabel{j} = ['\color{orange}' ax.XTickLabel{j}];
            ax.YTickLabel{j} = ['\color{orange}' ax.YTickLabel{j}];
        elseif str2double(strtok(ax.XTickLabel{j},'-'))<231
            ax.XTickLabel{j} = ['\color{green}' ax.XTickLabel{j}];
            ax.YTickLabel{j} = ['\color{green}' ax.YTickLabel{j}];
        else
            ax.XTickLabel{j} = ['\color{blue}' ax.XTickLabel{j}];
            ax.YTickLabel{j} = ['\color{blue}' ax.YTickLabel{j}];
        end
    end
    set(gca, 'YDir', 'reverse');
    colormap(redblue) %uses https://de.mathworks.com/matlabcentral/fileexchange/25536-red-blue-colormap
    caxis([-1,1]);
    rotateXLabels(gca, 45);
    %title(conditions{i}, 'FontSize', 10);
    colorbar;
    axis square;
    if isunix
        saveas(gca, sprintf('/fileserver/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/Results/LIPd_p/RL/%s.png', conditions{i}))
    elseif ispc
        saveas(gca, sprintf('Y:\\Personal\\AlexandraWitt\\Results\\LIPd_p\\RL\\%s.png', conditions{i}))        
    end
end

corrfixlip = corrcoef(betaseries{1}, 'rows', 'pairwise');
corrfixmslip = corrcoef(betaseries{2}, 'rows', 'pairwise');
corrmemllip = corrcoef(betaseries{3}, 'rows', 'pairwise');
corrmemrlip = corrcoef(betaseries{4}, 'rows', 'pairwise');
corrmemlmslip = corrcoef(betaseries{5}, 'rows', 'pairwise');
corrmemrmslip = corrcoef(betaseries{6}, 'rows', 'pairwise');

%contrasts
corrs = {corrmemllip - corrfixlip,...
    corrmemrlip - corrfixlip, corrmemlmslip - corrfixmslip, corrmemrmslip - corrfixmslip,corrmemlmslip - corrmemllip,corrmemrmslip - corrmemrlip,...
    corrfixmslip - corrfixlip,corrmemllip-corrmemrlip,corrmemlmslip - corrmemrmslip};
names = {'CU LIP memory left - fix LIPd_p ROIs RL','CU LIP memory right - fix LIPd_p ROIs RL', 'CU LIP memory left microstim - fix microstim LIPd_p ROIs RL', 'CU LIP memory right microstim - fix microstim LIPd_p ROIs RL',...
    'CU LIP memory left microstim - no microstim LIPd_p ROIs RL', 'CU LIP memory right microstim - no microstim LIPd_p ROIs RL','CU LIP fixation microstim - no microstim LIPd_p ROIs RL', 'CU LIP Memory left - memory right LIPd_p ROIs RL', 'CU LIP Memory left microstim - memory right microstim LIPd_p ROIs RL'};

for i = 1:length(names)
    corr = corrs{i};
    name = names{i};
    imagesc(corr)
    set(gca, 'XTick', 1:length(voinames));
    set(gca, 'YTick', 1:length(voinames));
    set(gca, 'TickLength',[0 0])
    set(gca, 'XTickLabel',strrep({voinames.Name}, '_', ' '), 'fontsize', 6);
    set(gca, 'YTickLabel',strrep({voinames.Name}, '_', ' '), 'fontsize', 6);
    ax = gca;
    for j = 1:length(ax.XTickLabel)
        if str2double(strtok(ax.XTickLabel{j},'-'))<90
            ax.XTickLabel{j} = ['\color{red}' ax.XTickLabel{j}];
            ax.YTickLabel{j} = ['\color{red}' ax.YTickLabel{j}];
        elseif str2double(strtok(ax.XTickLabel{j},'-'))<138
            ax.XTickLabel{j} = ['\color{orange}' ax.XTickLabel{j}];
            ax.YTickLabel{j} = ['\color{orange}' ax.YTickLabel{j}];
        elseif str2double(strtok(ax.XTickLabel{j},'-'))<231
            ax.XTickLabel{j} = ['\color{green}' ax.XTickLabel{j}];
            ax.YTickLabel{j} = ['\color{green}' ax.YTickLabel{j}];
        else
            ax.XTickLabel{j} = ['\color{blue}' ax.XTickLabel{j}];
            ax.YTickLabel{j} = ['\color{blue}' ax.YTickLabel{j}];
        end
    end
    set(gca, 'YDir', 'reverse');
    colormap(redblue) %uses https://de.mathworks.com/matlabcentral/fileexchange/25536-red-blue-colormap
    hv = max(max(abs(corr)));
    caxis([-hv,hv]);
    rotateXLabels(gca, 45);
    %title(name, 'FontSize', 10);
    colorbar;
    axis square;
    if isunix
        saveas(gca, sprintf('/fileserver/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/Results/LIPd_p/RL/%s.png', name))
    elseif ispc
        saveas(gca, sprintf('Y:\\Personal\\AlexandraWitt\\Results\\LIPd_p\\RL\\%s.png', name))        
    end
end
names = {'CU LIP memory left - fix LIPd_p ROIs RL sig','CU LIP memory right - fix LIPd_p ROIs RL sig', 'CU LIP memory left microstim - fix microstim LIPd_p ROIs RL sig', 'CU LIP memory right microstim - fix microstim LIPd_p ROIs RL sig',...
    'CU LIP memory left microstim - no microstim LIPd_p ROIs RL sig', 'CU LIP memory right microstim - no microstim LIPd_p ROIs RL sig','CU LIP fixation microstim - no microstim LIPd_p ROIs RL sig', 'CU LIP Memory left - memory right LIPd_p ROIs RL sig', 'CU LIP Memory left microstim - memory right microstim LIPd_p ROIs RL sig'};
bootgroups = {{vertcat(memllip,fixlip),length(memllip)},...
    {vertcat(memrlip,fixlip),length(memrlip)}, {vertcat(memlmslip,fixmslip),length(memlmslip)},{vertcat(memrmslip,fixmslip),length(memrmslip)},{vertcat(memlmslip,memllip),length(memlmslip)},{vertcat(memrmslip,memrlip),length(memrmslip)},...
    {vertcat(fixlip,fixmslip),length(fixlip)}, {vertcat(memllip,memrlip),length(memllip)},{vertcat(memlmslip, memrmslip),length(memlmslip)}};

for i = 1:length(names)
    corr = corrs{i};
    name = names{i};
    [low,high] = bootcorrs(1000, bootgroups{i});
    corr(corr>low & corr<high) = 0;
    imagesc(corr)
    set(gca, 'XTick', 1:length(voinames));
    set(gca, 'YTick', 1:length(voinames));
    set(gca, 'TickLength',[0 0])
    set(gca, 'XTickLabel',strrep({voinames.Name}, '_', ' '), 'fontsize', 6);
    set(gca, 'YTickLabel',strrep({voinames.Name}, '_', ' '), 'fontsize', 6);
    ax = gca;
    for j = 1:length(ax.XTickLabel)
        if str2double(strtok(ax.XTickLabel{j},'-'))<90
            ax.XTickLabel{j} = ['\color{red}' ax.XTickLabel{j}];
            ax.YTickLabel{j} = ['\color{red}' ax.YTickLabel{j}];
        elseif str2double(strtok(ax.XTickLabel{j},'-'))<138
            ax.XTickLabel{j} = ['\color{orange}' ax.XTickLabel{j}];
            ax.YTickLabel{j} = ['\color{orange}' ax.YTickLabel{j}];
        elseif str2double(strtok(ax.XTickLabel{j},'-'))<231
            ax.XTickLabel{j} = ['\color{green}' ax.XTickLabel{j}];
            ax.YTickLabel{j} = ['\color{green}' ax.YTickLabel{j}];
        else
            ax.XTickLabel{j} = ['\color{blue}' ax.XTickLabel{j}];
            ax.YTickLabel{j} = ['\color{blue}' ax.YTickLabel{j}];
        end
    end
    set(gca, 'YDir', 'reverse');
    colormap(redblue) %uses https://de.mathworks.com/matlabcentral/fileexchange/25536-red-blue-colormap
    hv = max(max(abs(corr)));
    caxis([-hv,hv]);
    rotateXLabels(gca, 45);
    %title(name, 'FontSize', 10);
    colorbar;
    axis square;
    if isunix
        saveas(gca, sprintf('/fileserver/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/Results/LIPd_p/RL/%s.png', name))
    elseif ispc
        saveas(gca, sprintf('Y:\\Personal\\AlexandraWitt\\Results\\LIPd_p\\RL\\%s.png', name))        
    end
end

%CU dPul_p
if isunix
    voi = xff('/fileserver/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/CU_dPul_p_RL_ig_from_CU_CHARM_dilated_tal.voi');
elseif ispc
    voi = xff('Y:\Personal\AlexandraWitt\CU_dPul_p_RL_ig_from_CU_CHARM_dilated_tal.voi');    
end
voinames = voi.VOI;
if isunix
    load('/fileserver/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/CHARM_SARM/CHARMSARMkeycombined.mat') %make path windowscompatible
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

conditions = {'CU Pul fixation dPul_p ROIs RL' 'CU Pul fixation microstim dPul_p ROIs RL' 'CU Pul memory left dPul_p ROIs RL' 'CU Pul memory right dPul_p ROIs RL' 'CU Pul memory left microstim dPul_p ROIs RL' 'CU Pul memory right microstim dPul_p ROIs RL'};
betaseries = pul;
for i = 1:length(conditions)
    [corr,P] = corrcoef(betaseries{i}, 'rows', 'pairwise');
    corr(~fdr_bh(P)) = 0; %removes non-significant correlations
    imagesc(corr)
    set(gca, 'XTick', 1:length(betaseries{i}));
    set(gca, 'YTick', 1:length(betaseries{i}));
    set(gca, 'TickLength',[0 0])
    set(gca, 'XTickLabel',strrep({voinames.Name}, '_', '-'), 'fontsize', 6);
    set(gca, 'YTickLabel',strrep({voinames.Name}, '_', '-'), 'fontsize', 6);
    ax = gca;
    for j = 1:length(ax.XTickLabel)
        if str2double(strtok(ax.XTickLabel{j},'-'))<90
            ax.XTickLabel{j} = ['\color{red}' ax.XTickLabel{j}];
            ax.YTickLabel{j} = ['\color{red}' ax.YTickLabel{j}];
        elseif str2double(strtok(ax.XTickLabel{j},'-'))<138
            ax.XTickLabel{j} = ['\color{orange}' ax.XTickLabel{j}];
            ax.YTickLabel{j} = ['\color{orange}' ax.YTickLabel{j}];
        elseif str2double(strtok(ax.XTickLabel{j},'-'))<231
            ax.XTickLabel{j} = ['\color{green}' ax.XTickLabel{j}];
            ax.YTickLabel{j} = ['\color{green}' ax.YTickLabel{j}];
        else
            ax.XTickLabel{j} = ['\color{blue}' ax.XTickLabel{j}];
            ax.YTickLabel{j} = ['\color{blue}' ax.YTickLabel{j}];
        end
    end
    set(gca, 'YDir', 'reverse');
    colormap(redblue) %uses https://de.mathworks.com/matlabcentral/fileexchange/25536-red-blue-colormap
    caxis([-1,1]);
    rotateXLabels(gca, 45);
    %title(conditions{i}, 'FontSize', 10);
    colorbar;
    axis square;
    if isunix
        saveas(gca, sprintf('/fileserver/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/Results/dPul_p/RL/%s.png', conditions{i}))
    elseif ispc
        saveas(gca, sprintf('Y:\\Personal\\AlexandraWitt\\Results\\dPul_p\\RL\\%s.png', conditions{i}))        
    end
end

corrfixpul = corrcoef(betaseries{1}, 'rows', 'pairwise');
corrfixmspul = corrcoef(betaseries{2}, 'rows', 'pairwise');
corrmemlpul = corrcoef(betaseries{3}, 'rows', 'pairwise');
corrmemrpul = corrcoef(betaseries{4}, 'rows', 'pairwise');
corrmemlmspul = corrcoef(betaseries{5}, 'rows', 'pairwise');
corrmemrmspul = corrcoef(betaseries{6}, 'rows', 'pairwise');

%contrasts
corrs = {corrmemlpul - corrfixpul,...
    corrmemrpul - corrfixpul, corrmemlmspul - corrfixmspul, corrmemrmspul - corrfixmspul,corrmemlmspul - corrmemlpul,corrmemrmspul - corrmemrpul,...
    corrfixmspul - corrfixpul,corrmemlpul-corrmemrpul,corrmemlmspul - corrmemrmspul};
names = {'CU Pul memory left - fix dPul_p ROIs RL','CU Pul memory right - fix dPul_p ROIs RL', 'CU Pul memory left microstim - fix microstim dPul_p ROIs RL', 'CU Pul memory right microstim - fix microstim dPul_p ROIs RL',...
    'CU Pul memory left microstim - no microstim dPul_p ROIs RL', 'CU Pul memory right microstim - no microstim dPul_p ROIs RL','CU Pul fixation microstim - no microstim dPul_p ROIs RL', 'CU Pul Memory left - memory right dPul_p ROIs RL', 'CU Pul Memory left microstim - memory right microstim dPul_p ROIs RL'};

for i = 1:length(names)
    corr = corrs{i};
    name = names{i};
    imagesc(corr)
    set(gca, 'XTick', 1:length(voinames));
    set(gca, 'YTick', 1:length(voinames));
    set(gca, 'TickLength',[0 0])
    set(gca, 'XTickLabel',strrep({voinames.Name}, '_', '-'), 'fontsize', 6);
    set(gca, 'YTickLabel',strrep({voinames.Name}, '_', '-'), 'fontsize', 6);
    ax = gca;
    for j = 1:length(ax.XTickLabel)
        if str2double(strtok(ax.XTickLabel{j},'-'))<90
            ax.XTickLabel{j} = ['\color{red}' ax.XTickLabel{j}];
            ax.YTickLabel{j} = ['\color{red}' ax.YTickLabel{j}];
        elseif str2double(strtok(ax.XTickLabel{j},'-'))<138
            ax.XTickLabel{j} = ['\color{orange}' ax.XTickLabel{j}];
            ax.YTickLabel{j} = ['\color{orange}' ax.YTickLabel{j}];
        elseif str2double(strtok(ax.XTickLabel{j},'-'))<231
            ax.XTickLabel{j} = ['\color{green}' ax.XTickLabel{j}];
            ax.YTickLabel{j} = ['\color{green}' ax.YTickLabel{j}];
        else
            ax.XTickLabel{j} = ['\color{blue}' ax.XTickLabel{j}];
            ax.YTickLabel{j} = ['\color{blue}' ax.YTickLabel{j}];
        end
    end
    set(gca, 'YDir', 'reverse');
    colormap(redblue) %uses https://de.mathworks.com/matlabcentral/fileexchange/25536-red-blue-colormap
    hv = max(max(abs(corr)));
    caxis([-hv,hv]);
    rotateXLabels(gca, 45);
    %title(name, 'FontSize', 10);
    colorbar;
    axis square;
    if isunix
        saveas(gca, sprintf('/fileserver/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/Results/dPul_p/RL/%s.png', name))
    elseif ispc
        saveas(gca, sprintf('Y:\\Personal\\AlexandraWitt\\Results\\dPul_p\\RL\\%s.png', name))        
    end
end
names = {'CU Pul memory left - fix dPul_p ROIs RL sig','CU Pul memory right - fix dPul_p ROIs RL sig', 'CU Pul memory left microstim - fix microstim dPul_p ROIs RL sig', 'CU Pul memory right microstim - fix microstim dPul_p ROIs RL sig',...
    'CU Pul memory left microstim - no microstim dPul_p ROIs RL sig', 'CU Pul memory right microstim - no microstim dPul_p ROIs RL sig','CU Pul fixation microstim - no microstim dPul_p ROIs RL sig', 'CU Pul Memory left - memory right dPul_p ROIs RL sig', 'CU Pul Memory left microstim - memory right microstim dPul_p ROIs RL sig'};
bootgroups = {{vertcat(memlpul,fixpul),length(memlpul)},...
    {vertcat(memrpul,fixpul),length(memrpul)}, {vertcat(memlmspul,fixmspul),length(memlmspul)},{vertcat(memrmspul,fixmspul),length(memrmspul)},{vertcat(memlmspul,memlpul),length(memlmspul)},{vertcat(memrmspul,memrpul),length(memrmspul)},...
    {vertcat(fixpul,fixmspul),length(fixpul)}, {vertcat(memlpul,memrpul),length(memlpul)},{vertcat(memlmspul, memrmspul),length(memlmspul)}};

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
    ax = gca;
    for j = 1:length(ax.XTickLabel)
        if str2double(strtok(ax.XTickLabel{j},'-'))<90
            ax.XTickLabel{j} = ['\color{red}' ax.XTickLabel{j}];
            ax.YTickLabel{j} = ['\color{red}' ax.YTickLabel{j}];
        elseif str2double(strtok(ax.XTickLabel{j},'-'))<138
            ax.XTickLabel{j} = ['\color{orange}' ax.XTickLabel{j}];
            ax.YTickLabel{j} = ['\color{orange}' ax.YTickLabel{j}];
        elseif str2double(strtok(ax.XTickLabel{j},'-'))<231
            ax.XTickLabel{j} = ['\color{green}' ax.XTickLabel{j}];
            ax.YTickLabel{j} = ['\color{green}' ax.YTickLabel{j}];
        else
            ax.XTickLabel{j} = ['\color{blue}' ax.XTickLabel{j}];
            ax.YTickLabel{j} = ['\color{blue}' ax.YTickLabel{j}];
        end
    end
    set(gca, 'YDir', 'reverse');
    colormap(redblue) %uses https://de.mathworks.com/matlabcentral/fileexchange/25536-red-blue-colormap
    hv = max(max(abs(corr)));
    caxis([-hv,hv]);
    rotateXLabels(gca, 45);
    %title(name, 'FontSize', 10);
    colorbar;
    axis square;
    if isunix
        saveas(gca, sprintf('/fileserver/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/Results/dPul_p/RL/%s.png', name))
    elseif ispc
        saveas(gca, sprintf('Y:\\Personal\\AlexandraWitt\\Results\\dPul_p\\RL\\%s.png', name))        
    end
end
