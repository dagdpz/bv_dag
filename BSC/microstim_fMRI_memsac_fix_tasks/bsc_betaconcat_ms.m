%the pipeline to get correlation matrices for microstim-based VOIs (conj
%dPul_p, LIP_d_a)
%BA
%load betaseries
if isunix
    cd('/fileserver/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/MA/betaseries/Bacchus/dpulp_lipda_conj')
elseif ispc
    cd('Y:\Personal\AlexandraWitt\MA\betaseries\Bacchus/dpulp_lipda_conj')    
end
files = dir('*.mat');
for i = 1:length(files)
    load(files(i).name)
end

% %check for outlier betas
bs0301 =  (betaseries_20170301);
bs0302 =  (betaseries_20170302);
bs0303 =  (betaseries_20170303);
bs0317 =  (betaseries_20170317);
bs0324 =  (betaseries_20170324);
bs0329 =  (betaseries_20170329);
bs0405 =  (betaseries_20170405);
bs0406 =  (betaseries_20170406);
bs0407 =  (betaseries_20170407);
bs0412 =  (betaseries_20170412);
bs0413 =  (betaseries_20170413);
bs0426 =  (betaseries_20170426);
bs0427 =  (betaseries_20170427);
bs0428 =  (betaseries_20170428);
bs0503 =  (betaseries_20170503);
bs0504 =  (betaseries_20170504);
bs0505 =  (betaseries_20170505);
bs0511 =  (betaseries_20170511);
bs0517 =  (betaseries_20170517);
bs0518 =  (betaseries_20170518);

llist = {bs0301,bs0302,bs0303,bs0317,bs0324,bs0329,bs0405,...
    bs0406,bs0407,bs0412,bs0413,bs0426,bs0427,bs0428,bs0503,bs0504,bs0505,bs0511,bs0517,bs0518};

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

bs0301 = bsc_z_score(llist{1});%ol %dPulp
bs0302 = bsc_z_score(llist{2});
bs0303 = bsc_z_score(llist{3});
bs0317 = bsc_z_score(llist{4});
bs0324 = bsc_z_score(llist{5});
bs0329 = bsc_z_score(llist{6});
bs0405 = bsc_z_score(llist{7});%OL
bs0406 = bsc_z_score(llist{8});
bs0407 = bsc_z_score(llist{9});%
bs0412 = bsc_z_score(llist{10});%LIPd_a
bs0413 = bsc_z_score(llist{11});
bs0426 = bsc_z_score(llist{12});
bs0427 = bsc_z_score(llist{13});
bs0428 = bsc_z_score(llist{14});
bs0503 = bsc_z_score(llist{15});%OL
bs0504 = bsc_z_score(llist{16});
bs0505 = bsc_z_score(llist{17});
bs0511 = bsc_z_score(llist{18});
bs0517 = bsc_z_score(llist{19});
bs0518 = bsc_z_score(llist{20}); %OL

%  lipda for ms effect
fixlip = vertcat(bs0412{1},bs0413{1},bs0426{1},bs0427{1},bs0428{1},...
    bs0504{1},bs0505{1},bs0511{1},bs0517{1},bs0503{1},bs0518{1}); %

fixmslip = vertcat(bs0412{2},bs0413{2},bs0426{2},bs0427{2},bs0428{2},...
    bs0504{2},bs0505{2},bs0511{2},bs0517{2},bs0503{2},bs0518{2});%

memllip = vertcat(bs0412{3},bs0413{3},bs0426{3},bs0427{3},bs0428{3},...
    bs0504{3},bs0505{3},bs0511{3},bs0517{3},bs0503{3},bs0518{3});%

memrlip = vertcat(bs0412{4},bs0413{4},bs0426{4},bs0427{4},bs0428{4},...
    bs0504{4},bs0505{4},bs0511{4},bs0517{4},bs0503{4},bs0518{4});%

memlmslip = vertcat(bs0412{5},bs0413{5},bs0426{5},bs0427{5},bs0428{5},...
    bs0504{5},bs0505{5},bs0511{5},bs0517{5},bs0503{5},bs0518{5});%

memrmslip = vertcat(bs0412{6},bs0413{6},bs0426{6},bs0427{6},bs0428{6},...
    bs0504{6},bs0505{6},bs0511{6},bs0517{6},bs0503{6},bs0518{6});%

%dpulp
fixpul = vertcat(bs0302{1},bs0303{1},bs0317{1},bs0324{1},bs0329{1},bs0406{1},bs0407{1},bs0301{1},bs0405{1});%,

fixmspul = vertcat(bs0302{2},bs0303{2},bs0317{2},bs0324{2},bs0329{2},bs0406{2},bs0407{2},bs0301{2},bs0405{2});%,

memlpul = vertcat(bs0302{3},bs0303{3},bs0317{3},bs0324{3},bs0329{3},bs0406{3},bs0407{3},bs0301{3},bs0405{3});%,

memrpul = vertcat(bs0302{4},bs0303{4},bs0317{4},bs0324{4},bs0329{4},bs0406{4},bs0407{4},bs0301{4},bs0405{4});%,

memlmspul = vertcat(bs0302{5},bs0303{5},bs0317{5},bs0324{5},bs0329{5},bs0406{5},bs0407{5},bs0301{5},bs0405{5});%,

memrmspul = vertcat(bs0302{6},bs0303{6},bs0317{6},bs0324{6},bs0329{6},bs0406{6},bs0407{6},bs0301{6},bs0405{6});%,

pul = {fixpul, fixmspul, memlpul, memrpul, memlmspul, memrmspul};
lip = {fixlip, fixmslip, memllip, memrlip, memlmslip, memrmslip};


%BA ROIs 
%LIP
conditions = {'BA LIP fixation conj' 'BA LIP fixation microstim conj' 'BA LIP memory left conj' 'BA LIP memory right conj' 'BA LIP memory left microstim conj' 'BA LIP memory right microstim conj'};
if isunix
    voi = xff('/fileserver/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/BA_dpulp_lipda_conj_k10_FDR05_from_BA_CHARM_dilated_tal.voi');
elseif ispc
    voi = xff('Y:\Personal\AlexandraWitt\BA_dpulp_lipda_conj_k10_FDR05_from_BA_CHARM_dilated_tal.voi');
end
voinames = voi.VOI;
if isunix
    load('/fileserver/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/CHARM_SARM/CHARMSARMkeycombined.mat')
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
        saveas(gca, sprintf('/fileserver/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/Results/MS/%s.png', conditions{i}))
    elseif ispc
        saveas(gca, sprintf('Y:\\Personal\\AlexandraWitt\\Results\\MS\\%s.png', conditions{i}))
    end
end

corrfixlip = corrcoef(betaseries{1}, 'rows', 'pairwise');
corrfixmslip = corrcoef(betaseries{2}, 'rows', 'pairwise');
corrmemllip = corrcoef(betaseries{3}, 'rows', 'pairwise');
corrmemrlip = corrcoef(betaseries{4}, 'rows', 'pairwise');
corrmemlmslip = corrcoef(betaseries{5}, 'rows', 'pairwise');
corrmemrmslip = corrcoef(betaseries{6}, 'rows', 'pairwise');

conditions = {'BA Pul fixation conj' 'BA Pul fixation microstim conj' 'BA Pul memory left conj' 'BA Pul memory right conj' 'BA Pul memory left microstim conj' 'BA Pul memory right microstim conj'};

betaseries = pul;

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
        saveas(gca, sprintf('/fileserver/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/Results/MS/%s.png', conditions{i}))
    elseif ispc
        saveas(gca, sprintf('Y:\\Personal\\AlexandraWitt\\Results\\MS\\%s.png', conditions{i}))
    end
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
    corrmemlmslip - corrmemllip, corrmemrmslip - corrmemrlip,corrmemlmspul - corrmemlmslip, corrmemrmspul - corrmemrmslip,corrmemlpul-corrmemrpul,corrmemllip-corrmemrlip,corrmemlmspul-corrmemrmspul,corrmemlmslip-corrmemrmslip};
names = {'BA LIP memory left - fix conj', 'BA LIP memory right - fix conj', 'BA LIP memory left microstim - fix microstim conj','BA LIP memory right microstim - fix microstim conj', ...
    'BA Pul memory left - fix conj','BA Pul memory right - fix conj', 'BA Pul memory left microstim - fix microstim conj', 'BA Pul memory right microstim - fix microstim conj',...
    'BA Pul memory left microstim - no microstim conj', 'BA Pul memory right microstim - no microstim conj', 'BA LIP memory left microstim - no microstim conj', ...
    'BA LIP memory right microstim - no microstim conj', 'BA memory left microstim Pulvinar - LIP  conj', 'BA memory right microstim Pulvinar - LIP conj','BA Pul memory left - memory right conj','BA LIP memory left - memory right conj','BA Pul memory left microstim - memory right microstim conj','BA LIP memory left microstim - memory right microstim conj'};

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
        saveas(gca, sprintf('/fileserver/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/Results/MS/%s.png', name))
    elseif ispc
        saveas(gca, sprintf('Y:\\Personal\\AlexandraWitt\\Results\\MS\\%s.png', name))
    end
end

names = {'BA LIP memory left - fix conj sig', 'BA LIP memory right - fix conj sig', 'BA LIP memory left microstim - fix microstim conj sig','BA LIP memory right microstim - fix microstim conj sig', ...
    'BA Pul memory left - fix conj sig','BA Pul memory right - fix conj sig', 'BA Pul memory left microstim - fix microstim conj sig', 'BA Pul memory right microstim - fix microstim conj sig',...
    'BA Pul memory left microstim - no microstim conj sig', 'BA Pul memory right microstim - no microstim conj sig', 'BA LIP memory left microstim - no microstim conj sig', ...
    'BA LIP memory right microstim - no microstim conj sig', 'BA memory left microstim Pulvinar - LIP conj sig', 'BA memory right microstim Pulvinar - LIP conj sig','BA Pul memory left - memory right conj sig','BA LIP memory left - memory right conj sig','BA Pul memory left microstim - memory right microstim conj sig','BA LIP memory left microstim - memory right microstim conj sig'};
bootgroups = {{vertcat(memllip,fixlip),length(memllip)},{vertcat(memrlip,fixlip),length(memrlip)},{vertcat(memlmslip,fixmslip),length(memlmslip)},{vertcat(memrmslip,fixmslip),length(memrmslip)},{vertcat(memlpul,fixpul),length(memlpul)},...
    {vertcat(memrpul,fixpul),length(memrpul)}, {vertcat(memlmspul,fixmspul),length(memlmspul)},{vertcat(memrmspul,fixmspul),length(memrmspul)},{vertcat(memlmspul,memlpul),length(memlmspul)},{vertcat(memrmspul,memrpul),length(memrmspul)},...
    {vertcat(memlmslip, memllip),length(memlmslip)}, {vertcat(memrmslip,memrlip),length(memrmslip)},{vertcat(memlmspul,memlmslip),length(memlmspul)},{vertcat(memrmspul,memrmslip),length(memrmspul)},{vertcat(memlpul,memrpul),length(memlpul)},{vertcat(memllip,memrlip),length(memrlip)},{vertcat(memlmspul,memrmspul),length(memlmspul)},{vertcat(memlmslip,memrmslip),length(memrmslip)}};

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
        saveas(gca, sprintf('/fileserver/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/Results/MS/%s.png', name))
    elseif ispc
        saveas(gca, sprintf('Y:\\Personal\\AlexandraWitt\\Results\\MS\\%s.png', name))
    end
end

%CU
if isunix
    cd('/fileserver/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/MA/betaseries/Curius/dpulp_lipda_conj')
elseif ispc
    cd('Y:\Personal\AlexandraWitt\MA\betaseries\Curius\dpulp_lipda_conj')
end
files = dir('*.mat');
for i = 1:length(files)
    load(files(i).name)
end

% %find outlier betas
bs0122 = (betaseries_20140122);
bs0124 = (betaseries_20140124);
bs0129 = (betaseries_20140129);
bs0131 = (betaseries_20140131);
bs0204 = (betaseries_20140204);
bs0214 = (betaseries_20140214);
bs0226 = (betaseries_20140226);
bs0422 = (betaseries_20150422);
bs0423 = (betaseries_20150423);
bs0429 = (betaseries_20150429);
bs0430 = (betaseries_20150430);
bs0506 = (betaseries_20150506);

llist = {bs0122,bs0124,bs0129,bs0131,bs0204,bs0214,bs0226,bs0422,bs0423,bs0429,bs0430,bs0506};

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
bs0122 = bsc_z_score(llist{1}); %dPul_p
bs0124 = bsc_z_score(llist{2});
bs0129 = bsc_z_score(llist{3}); 
bs0131 = bsc_z_score(llist{4});
bs0204 = bsc_z_score(llist{5});
bs0214 = bsc_z_score(llist{6});
bs0226 = bsc_z_score(llist{7});
bs0422 = bsc_z_score(llist{8});%LIP_a
bs0423 = bsc_z_score(llist{9});%ol (20)
bs0429 = bsc_z_score(llist{10});
bs0430 = bsc_z_score(llist{11});
bs0506 = bsc_z_score(llist{12});

%sort by condition

fixpul = vertcat(bs0122{1}, bs0124{1},bs0129{1},bs0131{1},bs0204{1},bs0214{1},bs0226{1});
fixlip = vertcat(bs0422{1},bs0429{1},bs0430{1},bs0506{1},bs0423{1}); %

fixmspul = vertcat(bs0122{2}, bs0124{2},bs0129{2},bs0131{2},bs0204{2},bs0214{2},bs0226{2});
fixmslip = vertcat(bs0422{2},bs0429{2},bs0430{2},bs0506{2},bs0423{2}); %

memlpul = vertcat(bs0122{3}, bs0124{3},bs0129{3},bs0131{3},bs0204{3},bs0214{3},bs0226{3});
memllip = vertcat(bs0422{3},bs0429{3},bs0430{3},bs0506{3},bs0423{3}); %

memrpul = vertcat(bs0122{4}, bs0124{4},bs0129{4},bs0131{4},bs0204{4},bs0214{4},bs0226{4});
memrlip = vertcat(bs0422{4},bs0429{4},bs0430{4},bs0506{4},bs0423{4}); %

memlmspul = vertcat(bs0122{5}, bs0124{5},bs0129{5},bs0131{5},bs0204{5},bs0214{5},bs0226{5});
memlmslip = vertcat(bs0422{5},bs0429{5},bs0430{5},bs0506{5},bs0423{5}); %

memrmspul = vertcat(bs0122{6}, bs0124{6},bs0129{6},bs0131{6},bs0204{6},bs0214{6},bs0226{6});
memrmslip = vertcat(bs0422{6},bs0429{6},bs0430{6},bs0506{6},bs0423{6}); %

pul = {fixpul, fixmspul, memlpul, memrpul, memlmspul, memrmspul};
lip = {fixlip, fixmslip, memllip, memrlip, memlmslip, memrmslip};


%CU ROIs dPul_p, LIP_d_a
%LIP
conditions = {'CU LIP fixation conj' 'CU LIP fixation microstim conj' 'CU LIP memory left conj' 'CU LIP memory right conj' 'CU LIP memory left microstim conj' 'CU LIP memory right microstim conj'};
if isunix
    voi = xff('/fileserver/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/CU_dpulp_lipda_conj_k10_FDR05_from_CU_CHARM_dilated_tal.voi');
elseif ispc
    voi = xff('Y:\Personal\AlexandraWitt\CU_dpulp_lipda_conj_k10_FDR05_from_CU_CHARM_dilated_tal.voi');
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
        saveas(gca, sprintf('/fileserver/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/Results/MS/%s.png', conditions{i}))
    elseif ispc
        saveas(gca, sprintf('Y:\\Personal\\AlexandraWitt\\Results\\MS\\%s.png', conditions{i}))
    end
end

corrfixlip = corrcoef(betaseries{1}, 'rows', 'pairwise');
corrfixmslip = corrcoef(betaseries{2}, 'rows', 'pairwise');
corrmemllip = corrcoef(betaseries{3}, 'rows', 'pairwise');
corrmemrlip = corrcoef(betaseries{4}, 'rows', 'pairwise');
corrmemlmslip = corrcoef(betaseries{5}, 'rows', 'pairwise');
corrmemrmslip = corrcoef(betaseries{6}, 'rows', 'pairwise');

conditions = {'CU Pul fixation conj' 'CU Pul fixation microstim conj' 'CU Pul memory left conj' 'CU Pul memory right conj' 'CU Pul memory left microstim conj' 'CU Pul memory right microstim conj'};

betaseries = pul;

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
        saveas(gca, sprintf('/fileserver/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/Results/MS/%s.png', conditions{i}))
    elseif ispc
        saveas(gca, sprintf('Y:\\Personal\\AlexandraWitt\\Results\\MS\\%s.png', conditions{i}))
    end
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
    corrmemlmslip - corrmemllip, corrmemrmslip - corrmemrlip,corrmemlmspul - corrmemlmslip, corrmemrmspul - corrmemrmslip,corrmemlpul-corrmemrpul,corrmemllip-corrmemrlip,corrmemlmspul-corrmemrmspul,corrmemlmslip-corrmemrmslip};
names = {'CU LIP memory left - fix conj', 'CU LIP memory right - fix conj', 'CU LIP memory left microstim - fix microstim conj','CU LIP memory right microstim - fix microstim conj', ...
    'CU Pul memory left - fix conj','CU Pul memory right - fix conj', 'CU Pul memory left microstim - fix microstim conj', 'CU Pul memory right microstim - fix microstim conj',...
    'CU Pul memory left microstim - no microstim conj', 'CU Pul memory right microstim - no microstim conj', 'CU LIP memory left microstim - no microstim conj', ...
    'CU LIP memory right microstim - no microstim conj', 'CU memory left microstim Pulvinar - LIP conj', 'CU memory right microstim Pulvinar - LIP conj','CU Pul memory left - memory right conj','CU LIP memory left - memory right conj','CU Pul memory left microstim - memory right microstim conj','CU LIP memory left microstim - memory right microstim conj'};

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
        saveas(gca, sprintf('/fileserver/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/Results/MS/%s.png', name))
    elseif ispc
        saveas(gca, sprintf('Y:\\Personal\\AlexandraWitt\\Results\\MS\\%s.png', name))
    end
end

names = {'CU LIP memory left - fix conj sig', 'CU LIP memory right - fix conj sig', 'CU LIP memory left microstim - fix microstim conj sig','CU LIP memory right microstim - fix microstim conj sig', ...
    'CU Pul memory left - fix conj sig','CU Pul memory right - fix conj sig', 'CU Pul memory left microstim - fix microstim conj sig', 'CU Pul memory right microstim - fix microstim conj sig',...
    'CU Pul memory left microstim - no microstim conj sig', 'CU Pul memory right microstim - no microstim conj sig', 'CU LIP memory left microstim - no microstim conj sig', ...
    'CU LIP memory right microstim - no microstim conj sig', 'CU memory left microstim Pulvinar - LIP conj sig', 'CU memory right microstim Pulvinar - LIP conj sig','CU Pul memory left - memory right conj sig','CU LIP memory left - memory right conj sig','CU Pul memory left microstim - memory right microstim conj sig','CU LIP memory left microstim - memory right microstim conj sig'};
bootgroups = {{vertcat(memllip,fixlip),length(memllip)},{vertcat(memrlip,fixlip),length(memrlip)},{vertcat(memlmslip,fixmslip),length(memlmslip)},{vertcat(memrmslip,fixmslip),length(memrmslip)},{vertcat(memlpul,fixpul),length(memlpul)},...
    {vertcat(memrpul,fixpul),length(memrpul)}, {vertcat(memlmspul,fixmspul),length(memlmspul)},{vertcat(memrmspul,fixmspul),length(memrmspul)},{vertcat(memlmspul,memlpul),length(memlmspul)},{vertcat(memrmspul,memrpul),length(memrmspul)},...
    {vertcat(memlmslip, memllip),length(memlmslip)}, {vertcat(memrmslip,memrlip),length(memrmslip)},{vertcat(memlmspul,memlmslip),length(memlmspul)},{vertcat(memrmspul,memrmslip),length(memrmspul)},{vertcat(memlpul,memrpul),length(memlpul)}, ...
    {vertcat(memllip,memrlip),length(memrlip)},{vertcat(memlmspul,memrmspul),length(memlmspul)},{vertcat(memlmslip,memrmslip),length(memrmslip)}};

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
        saveas(gca, sprintf('/fileserver/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/Results/MS/%s.png', name))
    elseif ispc
        saveas(gca, sprintf('Y:\\Personal\\AlexandraWitt\\Results\\MS\\%s.png', name))
    end
end