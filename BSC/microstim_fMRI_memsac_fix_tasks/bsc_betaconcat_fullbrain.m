%the pipeline to get correlation matrices for whole brain VOIs
%BA
%load betaseries
if ispc
    cd('Y:\Personal\AlexandraWitt\MA\betaseries\Bacchus\l5brain')
else
    cd('/fileserver/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/MA/betaseries/Bacchus/l5brain')
end
files = dir('*.mat');
for i = 1:length(files)
    load(files(i).name)
end
% %check for outlier beta values
bs0202 =  (fullbrain_betaseries_20170202);
bs0203 =  (fullbrain_betaseries_20170203);
bs0208 =  (fullbrain_betaseries_20170208);
bs0209 =  (fullbrain_betaseries_20170209);
bs0210 =  (fullbrain_betaseries_20170210);
bs0216 =  (fullbrain_betaseries_20170216);
bs0222 =  (fullbrain_betaseries_20170222);
bs0223 =  (fullbrain_betaseries_20170223);
bs0224 =  (fullbrain_betaseries_20170224);
bs0301 =  (fullbrain_betaseries_20170301);
bs0302 =  (fullbrain_betaseries_20170302);
bs0303 =  (fullbrain_betaseries_20170303);
bs0317 =  (fullbrain_betaseries_20170317);
bs0324 =  (fullbrain_betaseries_20170324);
bs0329 =  (fullbrain_betaseries_20170329);
bs0405 =  (fullbrain_betaseries_20170405);
bs0406 =  (fullbrain_betaseries_20170406);
bs0407 =  (fullbrain_betaseries_20170407);
bs0412 =  (fullbrain_betaseries_20170412);
bs0413 =  (fullbrain_betaseries_20170413);
bs0426 =  (fullbrain_betaseries_20170426);
bs0427 =  (fullbrain_betaseries_20170427);
bs0428 =  (fullbrain_betaseries_20170428);
bs0503 =  (fullbrain_betaseries_20170503);
bs0504 =  (fullbrain_betaseries_20170504);
bs0505 =  (fullbrain_betaseries_20170505);
bs0511 =  (fullbrain_betaseries_20170511);
bs0517 =  (fullbrain_betaseries_20170517);
bs0518 =  (fullbrain_betaseries_20170518);
bs0601 =  (fullbrain_betaseries_20170601);
bs0602 =  (fullbrain_betaseries_20170602);
bs0607 =  (fullbrain_betaseries_20170607);
bs0608 =  (fullbrain_betaseries_20170608);
bs0609 =  (fullbrain_betaseries_20170609);
bs0614 =  (fullbrain_betaseries_20170614);
bs0615 =  (fullbrain_betaseries_20170615);
bs0616 =  (fullbrain_betaseries_20170616);
bs0622 =  (fullbrain_betaseries_20170622);
bs0623 =  (fullbrain_betaseries_20170623);

llist = {bs0202,bs0203,bs0208,bs0209,bs0210,bs0216,bs0222,bs0223,bs0224,bs0301,bs0302,bs0303,bs0317,bs0324,bs0329,bs0405,...
    bs0406,bs0407,bs0412,bs0413,bs0426,bs0427,bs0428,bs0503,bs0504,bs0505,bs0511,bs0517,bs0518,bs0601,bs0602,...
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

%z-score
bs0202 = bsc_z_score(llist{1});
bs0203 = bsc_z_score(llist{2});
bs0208 = bsc_z_score(llist{3});
bs0209 = bsc_z_score(llist{4});
bs0210 = bsc_z_score(llist{5});
bs0216 = bsc_z_score(llist{6});
bs0222 = bsc_z_score(llist{7}); %OL
bs0223 = bsc_z_score(llist{8});
bs0224 = bsc_z_score(llist{9});
bs0301 = bsc_z_score(llist{10}); %ol
bs0302 = bsc_z_score(llist{11});
bs0303 = bsc_z_score(llist{12});
bs0317 = bsc_z_score(llist{13});
bs0324 = bsc_z_score(llist{14});
bs0329 = bsc_z_score(llist{15});
bs0405 = bsc_z_score(llist{16}); %OL
bs0406 = bsc_z_score(llist{17});
bs0407 = bsc_z_score(llist{18});
bs0412 = bsc_z_score(llist{19});
bs0413 = bsc_z_score(llist{20});
bs0426 = bsc_z_score(llist{21});
bs0427 = bsc_z_score(llist{22});
bs0428 = bsc_z_score(llist{23});
bs0503 = bsc_z_score(llist{24}); %OL
bs0504 = bsc_z_score(llist{25});
bs0505 = bsc_z_score(llist{26});
bs0511 = bsc_z_score(llist{27});
bs0517 = bsc_z_score(llist{28});
bs0518 = bsc_z_score(llist{29}); %OL
bs0601 = bsc_z_score(llist{30});
bs0602 = bsc_z_score(llist{31});
bs0607 = bsc_z_score(llist{32}); %OL
bs0608 = bsc_z_score(llist{33}); %OL
bs0609 = bsc_z_score(llist{34}); %OL
bs0614 = bsc_z_score(llist{35});
bs0615 = bsc_z_score(llist{36});
bs0616 = bsc_z_score(llist{37}); %OL
bs0622 = bsc_z_score(llist{38});
bs0623 = bsc_z_score(llist{39}); %OL

%sort by condition
fixpul = vertcat(bs0202{1}, bs0203{1},bs0208{1},bs0209{1},bs0210{1},bs0216{1},bs0223{1},bs0224{1},...
    bs0302{1},bs0303{1},bs0317{1},bs0324{1},bs0329{1},bs0406{1},bs0407{1},bs0222{1},bs0301{1},bs0405{1});%,

fixlip = vertcat(bs0412{1},bs0413{1},bs0426{1},bs0427{1},bs0428{1},...
    bs0504{1},bs0505{1},bs0511{1},bs0517{1},bs0601{1},bs0602{1}, ...
    bs0614{1},bs0615{1},bs0622{1},bs0503{1},bs0518{1},bs0607{1},bs0608{1},bs0609{1},bs0616{1},bs0623{1}); %

fixmspul = vertcat(bs0202{2}, bs0203{2},bs0208{2},bs0209{2},bs0210{2},bs0216{2},bs0223{2},bs0224{2},...
    bs0302{2},bs0303{2},bs0317{2},bs0324{2},bs0329{2},bs0406{2},bs0407{2},bs0222{2},bs0301{2},bs0405{2});%,

fixmslip = vertcat(bs0412{2},bs0413{2},bs0426{2},bs0427{2},bs0428{2},...
    bs0504{2},bs0505{2},bs0511{2},bs0517{2},bs0601{2},bs0602{2}, ...
    bs0614{2},bs0615{2},bs0622{2},bs0503{2},bs0518{2},bs0607{2},bs0608{2},bs0609{2},bs0616{2},bs0623{2});%

memlpul = vertcat(bs0202{3}, bs0203{3},bs0208{3},bs0209{3},bs0210{3},bs0216{3},bs0223{3},bs0224{3},...
    bs0302{3},bs0303{3},bs0317{3},bs0324{3},bs0329{3},bs0406{3},bs0407{3},bs0222{3},bs0301{3},bs0405{3});%,

memllip = vertcat(bs0412{3},bs0413{3},bs0426{3},bs0427{3},bs0428{3},...
    bs0504{3},bs0505{3},bs0511{3},bs0517{3},bs0601{3},bs0602{3}, ...
    bs0614{3},bs0615{3},bs0622{3},bs0503{3},bs0518{3},bs0607{3},bs0608{3},bs0609{3},bs0616{3},bs0623{3});%

memrpul = vertcat(bs0202{4}, bs0203{4},bs0208{4},bs0209{4},bs0210{4},bs0216{4},bs0223{4},bs0224{4},...
    bs0302{4},bs0303{4},bs0317{4},bs0324{4},bs0329{4},bs0406{4},bs0407{4},bs0222{4},bs0301{4},bs0405{4});%,

memrlip = vertcat(bs0412{4},bs0413{4},bs0426{4},bs0427{4},bs0428{4},...
    bs0504{4},bs0505{4},bs0511{4},bs0517{4},bs0601{4},bs0602{4}, ...
    bs0614{4},bs0615{4},bs0622{4},bs0503{4},bs0518{4},bs0607{4},bs0608{4},bs0609{4},bs0616{4},bs0623{4});%

memlmspul = vertcat(bs0202{5}, bs0203{5},bs0208{5},bs0209{5},bs0210{5},bs0216{5},bs0223{5},bs0224{5},...
    bs0302{5},bs0303{5},bs0317{5},bs0324{5},bs0329{5},bs0406{5},bs0407{5},bs0222{5},bs0301{5},bs0405{5});%,

memlmslip = vertcat(bs0412{5},bs0413{5},bs0426{5},bs0427{5},bs0428{5},...
    bs0504{5},bs0505{5},bs0511{5},bs0517{5},bs0601{5},bs0602{5}, ...
    bs0614{5},bs0615{5},bs0622{5},bs0503{5},bs0518{5},bs0607{5},bs0608{5},bs0609{5},bs0616{5},bs0623{5});%

memrmspul = vertcat(bs0202{6}, bs0203{6},bs0208{6},bs0209{6},bs0210{6},bs0216{6},bs0223{6},bs0224{6},...
    bs0302{6},bs0303{6},bs0317{6},bs0324{6},bs0329{6},bs0406{6},bs0407{6},bs0222{6},bs0301{6},bs0405{6});%,

memrmslip = vertcat(bs0412{6},bs0413{6},bs0426{6},bs0427{6},bs0428{6},...
    bs0504{6},bs0505{6},bs0511{6},bs0517{6},bs0601{6},bs0602{6}, ...
    bs0614{6},bs0615{6},bs0622{6},bs0503{6},bs0518{6},bs0607{6},bs0608{6},bs0609{6},bs0616{6},bs0623{6});%

pul = {fixpul, fixmspul, memlpul, memrpul, memlmspul, memrmspul};
lip = {fixlip, fixmslip, memllip, memrlip, memlmslip, memrmslip};

conditions = {'BA LIP fixation' 'BA LIP fixation microstim' 'BA LIP memory left' 'BA LIP memory right' 'BA LIP memory left microstim' 'BA LIP memory right microstim'};
if isunix
    voi = xff('/fileserver/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/bacchus.warped/CHARM/level_5/BA_CHARM_l5_updated150.voi');
elseif ispc
    voi = xff('Y:\Personal\AlexandraWitt\bacchus.warped\CHARM\level_5\BA_CHARM_l5_updated150.voi');
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

%old check for NaN betas - should not be occurring with intensity
%thresholded VOIs

betaseries = lip;
% for i = 1:length(conditions)
%     rm = [];
%     for j = 1:size(betaseries{i},2)
%         if any(isnan(betaseries{i}(:,j)))
%             rm = [rm j];
%         end
%     end
%     %betaseries{i}(:,rm) = []; 
%      if ~isempty(rm)
%          warning('Removed for NaN:\n %s \n', voinames(rm).Name)
%      end     
% end
% voinames(rm) = [];

for i = 1:length(conditions)
    [corr,P] = corrcoef(betaseries{i}, 'rows', 'pairwise');
    corr(~fdr_bh(P)) = 0; %removes non-significant correlations
    imagesc(corr)
    line(length(left)+0.5+zeros(1,size(betaseries{i},2)+1),0:size(betaseries{i},2),'Color','black')
    line(0:size(betaseries{i},2),length(left)+0.5+zeros(1,size(betaseries{i},2)+1),'Color','black')
    set(gca, 'XTick', [0.5,29.5,50.5,75.5,82.5,111.5,132.5,157.5]);
    set(gca, 'YTick', [0.5,29.5,50.5,75.5,82.5,111.5,132.5,157.5]);
    set(gca, 'XTickLabel',{'Frontal left','Parietal left','Temporal left', 'Occipital left', 'Frontal right','Parietal right', 'Temporal right', 'Occipital right'})
    set(gca, 'YTickLabel',{'Frontal left','Parietal left','Temporal left', 'Occipital left', 'Frontal right','Parietal right', 'Temporal right', 'Occipital right'})
    set(gca, 'YDir', 'reverse');
    colormap(redblue) %uses https://de.mathworks.com/matlabcentral/fileexchange/25536-red-blue-colormap
    caxis([-1,1]);
    rotateXLabels(gca, 45);
    %title(conditions{i}, 'FontSize', 10);
    colorbar;
    axis square;
    if isunix
        saveas(gca, sprintf('/fileserver/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/Results/Fullbrain/fullbrain_%s.png', conditions{i}))
    elseif ispc
        saveas(gca, sprintf('Y:\\Personal\\AlexandraWitt\\Results\\Fullbrain\\fullbrain_%s.png', conditions{i}))        
    end
end

corrfixlip = corrcoef(betaseries{1}, 'rows', 'pairwise');
corrfixmslip = corrcoef(betaseries{2}, 'rows', 'pairwise');
corrmemllip = corrcoef(betaseries{3}, 'rows', 'pairwise');
corrmemrlip = corrcoef(betaseries{4}, 'rows', 'pairwise');
corrmemlmslip = corrcoef(betaseries{5}, 'rows', 'pairwise');
corrmemrmslip = corrcoef(betaseries{6}, 'rows', 'pairwise');

conditions = {'BA Pul fixation' 'BA Pul fixation microstim' 'BA Pul memory left' 'BA Pul memory right' 'BA Pul memory left microstim' 'BA Pul memory right microstim'};

betaseries = pul;
% for i = 1:length(conditions)
%     betaseries{i}(:,rm) = []; 
% end

for i = 1:length(conditions)
    [corr,P] = corrcoef(betaseries{i}, 'rows', 'pairwise');
    corr(~fdr_bh(P)) = 0; %removes non-significant correlations
    imagesc(corr)
    line(length(left)+0.5+zeros(1,size(betaseries{i},2)+1),0:size(betaseries{i},2),'Color','black')
    line(0:size(betaseries{i},2),length(left)+0.5+zeros(1,size(betaseries{i},2)+1),'Color','black')
    set(gca, 'XTick', [0.5,29.5,50.5,75.5,82.5,111.5,132.5,157.5]);
    set(gca, 'YTick', [0.5,29.5,50.5,75.5,82.5,111.5,132.5,157.5]);
    set(gca, 'XTickLabel',{'Frontal left','Parietal left','Temporal left', 'Occipital left', 'Frontal right','Parietal right', 'Temporal right', 'Occipital right'})
    set(gca, 'YTickLabel',{'Frontal left','Parietal left','Temporal left', 'Occipital left', 'Frontal right','Parietal right', 'Temporal right', 'Occipital right'})
    set(gca, 'YDir', 'reverse');
    colormap(redblue) %uses https://de.mathworks.com/matlabcentral/fileexchange/25536-red-blue-colormap
    caxis([-1,1]);
    rotateXLabels(gca, 45);
    %title(conditions{i}, 'FontSize', 10);
    colorbar;
    axis square;
    if isunix
        saveas(gca, sprintf('/fileserver/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/Results/Fullbrain/fullbrain_%s.png', conditions{i}))
    elseif ispc
        saveas(gca, sprintf('Y:\\Personal\\AlexandraWitt\\Results\\Fullbrain\\fullbrain_%s.png', conditions{i}))        
    end
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
    corrmemlmslip - corrmemllip, corrmemrmslip - corrmemrlip, corrmemlmspul - corrmemlmslip, corrmemrmspul - corrmemrmslip, corrmemlmspul - corrmemrmspul, corrmemlmslip - corrmemrmslip};
names = {'BA LIP memory left - fix' 'BA LIP memory right - fix' 'BA LIP memory left microstim - fix microstim' 'BA LIP memory right microstim - fix microstim' ...
    'BA Pul memory left - fix' 'BA Pul memory right - fix' 'BA Pul memory left microstim - fix microstim' 'BA Pul memory right microstim - fix microstim' ...
    'BA Pul memory left microstim - no microstim' 'BA Pul memory right microstim - no microstim' ...
    'BA LIP memory left microstim - no microstim' 'BA LIP memory right microstim - no microstim' 'BA memory left microstim Pulvinar - LIP' 'BA memory right microstim Pulvinar - LIP','BA Pul memory left microstim - memory right microstim','BA LIP memory left microstim - memory right microstim'};
 
for i = 1:length(names)
    corr = corrs{i};
    name = names{i};
    imagesc(corr)
    line(length(left)+0.5+zeros(1,length(voinames)+1),0:length(voinames),'Color','black')
    line(0:length(voinames),length(left)+0.5+zeros(1,length(voinames)+1),'Color','black')
    set(gca, 'XTick', [0.5,29.5,50.5,75.5,82.5,111.5,132.5,157.5]);
    set(gca, 'YTick', [0.5,29.5,50.5,75.5,82.5,111.5,132.5,157.5]);
    set(gca, 'XTickLabel',{'Frontal left','Parietal left','Temporal left', 'Occipital left', 'Frontal right','Parietal right', 'Temporal right', 'Occipital right'})
    set(gca, 'YTickLabel',{'Frontal left','Parietal left','Temporal left', 'Occipital left', 'Frontal right','Parietal right', 'Temporal right', 'Occipital right'})
    set(gca, 'YDir', 'reverse');
    colormap(redblue) %uses https://de.mathworks.com/matlabcentral/fileexchange/25536-red-blue-colormap
    hv = max(max(abs(corr)));
    caxis([-hv,hv]);
    rotateXLabels(gca, 45);
    %title(name, 'FontSize', 10);
    colorbar;
    axis square;
    if isunix
        saveas(gca, sprintf('/fileserver/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/Results/Fullbrain/fullbrain_%s.png', names{i}))
    elseif ispc
        saveas(gca, sprintf('Y:\\Personal\\AlexandraWitt\\Results\\Fullbrain\\fullbrain_%s.png', names{i}))        
    end
end

names = {'BA LIP memory left - fix sig', 'BA LIP memory right - fix sig', 'BA LIP memory left microstim - fix microstim sig','BA LIP memory right microstim - fix microstim sig', ...
    'BA Pul memory left - fix sig','BA Pul memory right - fix sig', 'BA Pul memory left microstim - fix microstim sig', 'BA Pul memory right microstim - fix microstim sig',...
    'BA Pul memory left microstim - no microstim sig', 'BA Pul memory right microstim - no microstim sig', 'BA LIP memory left microstim - no microstim sig', ...
    'BA LIP memory right microstim - no microstim sig', 'BA memory left microstim Pulvinar - LIP sig', 'BA memory right microstim Pulvinar - LIP sig','BA Pul memory left microstim - memory right microstim sig','BA LIP memory left microstim - memory right microstim sig'};
bootgroups = {{vertcat(memllip,fixlip),length(memllip)},{vertcat(memrlip,fixlip),length(memrlip)},{vertcat(memlmslip,fixmslip),length(memlmslip)},{vertcat(memrmslip,fixmslip),length(memrmslip)},{vertcat(memlpul,fixpul),length(memlpul)},...
    {vertcat(memrpul,fixpul),length(memrpul)}, {vertcat(memlmspul,fixmspul),length(memlmspul)},{vertcat(memrmspul,fixmspul),length(memrmspul)},{vertcat(memlmspul,memlpul),length(memlmspul)},{vertcat(memrmspul,memrpul),length(memrmspul)},...
    {vertcat(memlmslip, memllip),length(memlmslip)}, {vertcat(memrmslip,memrlip),length(memrmslip)},{vertcat(memlmspul,memlmslip),length(memlmspul)},{vertcat(memrmspul,memrmslip),length(memrmspul)},{vertcat(memrmspul,memlmspul),length(memrmspul)},{vertcat(memrmslip,memlmslip),length(memrmslip)}};

for i = 1:length(names)
    corr = corrs{i};
    name = names{i};
    [low,high] = bootcorrs(1000, bootgroups{i});
    corr(corr>low & corr<high) = 0;
    imagesc(corr)
    line(length(left)+0.5+zeros(1,length(voinames)+1),0:length(voinames),'Color','black')
    line(0:length(voinames),length(left)+0.5+zeros(1,length(voinames)+1),'Color','black')
    set(gca, 'XTick', [0.5,29.5,50.5,75.5,82.5,111.5,132.5,157.5]);
    set(gca, 'YTick', [0.5,29.5,50.5,75.5,82.5,111.5,132.5,157.5]);
    set(gca, 'XTickLabel',{'Frontal left','Parietal left','Temporal left', 'Occipital left', 'Frontal right','Parietal right', 'Temporal right', 'Occipital right'})
    set(gca, 'YTickLabel',{'Frontal left','Parietal left','Temporal left', 'Occipital left', 'Frontal right','Parietal right', 'Temporal right', 'Occipital right'})
    set(gca, 'YDir', 'reverse');
    colormap(redblue) %uses https://de.mathworks.com/matlabcentral/fileexchange/25536-red-blue-colormap
    hv = max(max(abs(corr)));
    caxis([-hv,hv]);
    rotateXLabels(gca, 45);
    %title(name, 'FontSize', 10);
    colorbar;
    axis square;
    if isunix
        saveas(gca, sprintf('/fileserver/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/Results/Fullbrain/fullbrain_%s.png', names{i}))
    elseif ispc
        saveas(gca, sprintf('Y:\\Personal\\AlexandraWitt\\Results\\Fullbrain\\fullbrain_%s.png', names{i}))        
    end
end

% % %CU
if ispc
    cd('Y:\Personal\AlexandraWitt\MA\betaseries\Curius\l5brain')
else
    cd('/fileserver/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/MA/betaseries/Curius/l5brain')
end
files = dir('*.mat');
for i = 1:length(files)
    load(files(i).name)
end

% %check for outlier betas
bs1129 = (fullbrain_betaseries_20131129);
bs1204 = (fullbrain_betaseries_20131204);
bs1211 = (fullbrain_betaseries_20131211);
bs1213 = (fullbrain_betaseries_20131213);
bs1218 = ( fullbrain_betaseries_20131218);
bs0122 = ( fullbrain_betaseries_20140122);
bs0124 = ( fullbrain_betaseries_20140124);
bs0129 = ( fullbrain_betaseries_20140129);
bs0131 = ( fullbrain_betaseries_20140131);
bs0204 = ( fullbrain_betaseries_20140204);
bs0214 = ( fullbrain_betaseries_20140214);
bs0226 = ( fullbrain_betaseries_20140226);
bs0225 = (fullbrain_betaseries_20150225);%Lipd_p
bs150226 =(fullbrain_betaseries_20150226);
bs0303 = ( fullbrain_betaseries_20150303);
bs0311 = ( fullbrain_betaseries_20150311);
bs0422 = ( fullbrain_betaseries_20150422);
bs0423 = ( fullbrain_betaseries_20150423);
bs0429 = ( fullbrain_betaseries_20150429);
bs0430 = ( fullbrain_betaseries_20150430);
bs0506 = ( fullbrain_betaseries_20150506);
bs0507 = ( fullbrain_betaseries_20150507);
% 
llist = {bs1129,bs1204,bs1211,bs1213,bs1218,bs0122,bs0124,bs0129,bs0131,bs0204,bs0214,bs0226,bs0225,bs150226,bs0303,bs0311,...
    bs0422,bs0423,bs0429,bs0430,bs0506,bs0507};

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
bs1129 = bsc_z_score(llist{1});
bs1204 = bsc_z_score(llist{2});
bs1211 = bsc_z_score(llist{3}); %OL
bs1213 = bsc_z_score(llist{4});
bs1218 = bsc_z_score(llist{5});
bs0122 = bsc_z_score(llist{6});
bs0124 = bsc_z_score(llist{7});
bs0129 = bsc_z_score(llist{8}); %OL
bs0131 = bsc_z_score(llist{9}); %ol (20)
bs0204 = bsc_z_score(llist{10});
bs0214 = bsc_z_score(llist{11});
bs0226 = bsc_z_score(llist{12}); %ol (20)
bs0225 = bsc_z_score(llist{13});
bs150226 = bsc_z_score(llist{14});
bs0303 = bsc_z_score(llist{15});
bs0311 = bsc_z_score(llist{16});
bs0422 = bsc_z_score(llist{17});
bs0423 = bsc_z_score(llist{18});%ol (20)
bs0429 = bsc_z_score(llist{19});
bs0430 = bsc_z_score(llist{20});
bs0506 = bsc_z_score(llist{21});
bs0507 = bsc_z_score(llist{22});

%sort by condition
fixpul = vertcat(bs1129{1}, bs1204{1}, bs1213{1}, bs0124{1},...
       bs1218{1}, bs0122{1},bs0204{1},bs0214{1}, bs1211{1}, bs0129{1},bs0131{1},bs0226{1});%
fixlip = vertcat(bs0225{1},bs150226{1},bs0303{1},bs0311{1}, bs0422{1}, bs0429{1}, bs0430{1}, bs0506{1}, bs0507{1},bs0423{1});%

fixmspul = vertcat(bs1129{2}, bs1204{2}, bs1213{2}, bs0124{2},...
       bs1218{2}, bs0122{2},bs0204{2},bs0214{2}, bs1211{2}, bs0129{2},bs0131{2},bs0226{2});%
fixmslip = vertcat(bs0225{2},bs150226{2},bs0303{2},bs0311{2}, bs0422{2}, bs0429{2}, bs0430{2}, bs0506{2}, bs0507{2}, bs0423{2});%

memlpul = vertcat(bs1129{3}, bs1204{3}, bs1213{3}, bs0124{3},...
       bs1218{3}, bs0122{3},bs0204{3},bs0214{3},bs1211{3}, bs0129{3},bs0131{3},bs0226{3});%
memllip = vertcat(bs0225{3},bs150226{3},bs0303{3},bs0311{3}, bs0422{3}, bs0429{3}, bs0430{3}, bs0506{3}, bs0507{3},bs0423{3});%

memrpul = vertcat(bs1129{4}, bs1204{4}, bs1213{4}, bs0124{4},...
       bs1218{4}, bs0122{4},bs0204{4},bs0214{4},bs1211{4}, bs0129{4},bs0131{4},bs0226{4});%
memrlip = vertcat(bs0225{4},bs150226{4},bs0303{4},bs0311{4}, bs0422{4}, bs0429{4}, bs0430{4}, bs0506{4}, bs0507{4},bs0423{4});%

memlmspul = vertcat(bs1129{5}, bs1204{5}, bs1213{5}, bs0124{5},...
       bs1218{5}, bs0122{5},bs0204{5},bs0214{5},bs1211{5}, bs0129{5},bs0131{5},bs0226{5});%
memlmslip = vertcat(bs0225{5},bs150226{5},bs0303{5},bs0311{5}, bs0422{5}, bs0429{5}, bs0430{5}, bs0506{5}, bs0507{5},bs0423{5});%

memrmspul = vertcat(bs1129{6}, bs1204{6}, bs1213{6}, bs0124{6},...
       bs1218{6}, bs0122{6},bs0204{6},bs0214{6},bs1211{6}, bs0129{6},bs0131{6},bs0226{6});%
memrmslip = vertcat(bs0225{6},bs150226{6},bs0303{6},bs0311{6}, bs0422{6}, bs0429{6}, bs0430{6}, bs0506{6}, bs0507{6},bs0423{6});%

pul = {fixpul, fixmspul, memlpul, memrpul, memlmspul, memrmspul};
lip = {fixlip, fixmslip, memllip, memrlip, memlmslip, memrmslip};

%LIP 
conditions = {'CU LIP fixation' 'CU LIP fixation microstim' 'CU LIP memory left' 'CU LIP memory right' 'CU LIP memory left microstim' 'CU LIP memory right microstim'};
if isunix
    voi = xff('/fileserver/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/curius.warped/CHARM/level_5/CU_CHARM_l5_updated300.voi');
elseif ispc
    voi = xff('Y:\\Personal\\AlexandraWitt\\curius.warped\\CHARM\\level_5\\CU_CHARM_l5_updated300.voi');
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


%old check for NaN betas - should not be occurring with intensity
%thresholded VOIs

betaseries = lip;
% for i = 1:length(conditions)
%     rm = [];
%     for j = 1:size(betaseries{i},2)
%         if any(isnan(betaseries{i}(:,j)))
%             rm = [rm j];
%         end
%     end
%     %betaseries{i}(:,rm) = []; 
%      if ~isempty(rm)
%          warning('Removed for NaN:\n %s \n', voinames(rm).Name)
%      end     
% end
% voinames(rm) = [];

for i = 1:length(conditions)
    [corr,P] = corrcoef(betaseries{i}, 'rows', 'pairwise');
    corr(~fdr_bh(P)) = 0; %removes non-significant correlations
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
    %title(conditions{i}, 'FontSize', 10);
    colorbar;
    axis square;
    if isunix
        saveas(gca, sprintf('/fileserver/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/Results/Fullbrain/fullbrain_%s.png', conditions{i}))
    elseif ispc
        saveas(gca, sprintf('Y:\\Personal\\AlexandraWitt\\Results\\Fullbrain\\fullbrain_%s.png', conditions{i}))        
    end
end

corrfixlip = corrcoef(betaseries{1}, 'rows', 'pairwise');
corrfixmslip = corrcoef(betaseries{2}, 'rows', 'pairwise');
corrmemllip = corrcoef(betaseries{3}, 'rows', 'pairwise');
corrmemrlip = corrcoef(betaseries{4}, 'rows', 'pairwise');
corrmemlmslip = corrcoef(betaseries{5}, 'rows', 'pairwise');
corrmemrmslip = corrcoef(betaseries{6}, 'rows', 'pairwise');

conditions = {'CU Pul fixation' 'CU Pul fixation microstim' 'CU Pul memory left' 'CU Pul memory right' 'CU Pul memory left microstim' 'CU Pul memory right microstim'};

betaseries = pul;
% for i = 1:length(conditions)
%     betaseries{i}(:,rm) = []; 
% end

for i = 1:length(conditions)
    [corr,P] = corrcoef(betaseries{i}, 'rows', 'pairwise');
    corr(~fdr_bh(P)) = 0; %removes non-significant correlations
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
    %title(conditions{i}, 'FontSize', 10);
    colorbar;
    axis square;
    if isunix
        saveas(gca, sprintf('/fileserver/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/Results/Fullbrain/fullbrain_%s.png', conditions{i}))
    elseif ispc
        saveas(gca, sprintf('Y:\\Personal\\AlexandraWitt\\Results\\Fullbrain\\fullbrain_%s.png', conditions{i}))        
    end
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
    corrmemlmslip - corrmemllip, corrmemrmslip - corrmemrlip, corrmemlmspul - corrmemlmslip, corrmemrmspul - corrmemrmslip, corrmemlmspul - corrmemrmspul, corrmemlmslip - corrmemrmslip};
names = {'CU LIP memory left - fix' 'CU LIP memory right - fix' 'CU LIP memory left microstim - fix microstim' 'CU LIP memory right microstim - fix microstim' ...
    'CU Pul memory left - fix' 'CU Pul memory right - fix' 'CU Pul memory left microstim - fix microstim' 'CU Pul memory right microstim - fix microstim' ...
    'CU Pul memory left microstim - no microstim' 'CU Pul memory right microstim - no microstim' ...
    'CU LIP memory left microstim - no microstim' 'CU LIP memory right microstim - no microstim' 'CU memory left microstim Pulvinar - LIP' 'CU memory right microstim Pulvinar - LIP','CU Pul memory left microstim - memory right microstim','CU LIP memory left microstim - memory right microstim'};

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
    %title(name, 'FontSize', 10);
    colorbar;
    axis square;
    if isunix
        saveas(gca, sprintf('/fileserver/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/Results/Fullbrain/fullbrain_%s.png', names{i}))
    elseif ispc
        saveas(gca, sprintf('Y:\\Personal\\AlexandraWitt\\Results\\Fullbrain\\fullbrain_%s.png', names{i}))        
    end
end
names = {'CU LIP memory left - fix sig', 'CU LIP memory right - fix sig', 'CU LIP memory left microstim - fix microstim sig','CU LIP memory right microstim - fix microstim sig', ...
    'CU Pul memory left - fix sig','CU Pul memory right - fix sig', 'CU Pul memory left microstim - fix microstim sig', 'CU Pul memory right microstim - fix microstim sig',...
    'CU Pul memory left microstim - no microstim sig', 'CU Pul memory right microstim - no microstim sig', 'CU LIP memory left microstim - no microstim sig', ...
    'CU LIP memory right microstim - no microstim sig', 'CU memory left microstim Pulvinar - LIP sig', 'CU memory right microstim Pulvinar - LIP sig','CU Pul memory left microstim - memory right microstim sig','CU LIP memory left microstim - memory right microstim sig'};
bootgroups = {{vertcat(memllip,fixlip),length(memllip)},{vertcat(memrlip,fixlip),length(memrlip)},{vertcat(memlmslip,fixmslip),length(memlmslip)},{vertcat(memrmslip,fixmslip),length(memrmslip)},{vertcat(memlpul,fixpul),length(memlpul)},...
    {vertcat(memrpul,fixpul),length(memrpul)}, {vertcat(memlmspul,fixmspul),length(memlmspul)},{vertcat(memrmspul,fixmspul),length(memrmspul)},{vertcat(memlmspul,memlpul),length(memlmspul)},{vertcat(memrmspul,memrpul),length(memrmspul)},...
    {vertcat(memlmslip, memllip),length(memlmslip)}, {vertcat(memrmslip,memrlip),length(memrmslip)},{vertcat(memlmspul,memlmslip),length(memlmspul)},{vertcat(memrmspul,memrmslip),length(memrmspul)},{vertcat(memrmspul,memlmspul),length(memrmspul)},{vertcat(memrmslip,memlmslip),length(memrmslip)}};

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
    %title(name, 'FontSize', 10);
    colorbar;
    axis square;
    if isunix
        saveas(gca, sprintf('/fileserver/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/Results/Fullbrain/fullbrain_%s.png', names{i}))
    elseif ispc
        saveas(gca, sprintf('Y:\\Personal\\AlexandraWitt\\Results\\Fullbrain\\fullbrain_%s.png', names{i}))        
    end
end



