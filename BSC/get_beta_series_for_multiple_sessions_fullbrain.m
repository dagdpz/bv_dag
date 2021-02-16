function betaseries=get_beta_series_for_multiple_sessions_fullbrain(session_path, model, allglm, voi, conditions)
%computes beta series per condition
%for now, expects rXX_condition/rXX_post_condition to find the indices
%properly
%example usage
% get_beta_series_for_multiple_sessions_fullbrain('/home/alex/MRI/Bacchus', 'BA_mat2prt_fixmemstim_BASCO', ... 
%     {'20170202', '20170203', '20170208', '20170209', '20170210','20170216', '20170222', '20170223', '20170224'},...
%     '/mnt/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/bacchus.warped/CHARM/level_5/BA_CHARM_l5_updated200.voi', ...
%     {'fixation' 'fixation microstim' 'memory left' 'memory right' 'memory left microstim' 'memory right microstim'});


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
        if regexp(voinames(j).Name, sprintf('%s_%s_%s', '\d*', chiffre.Abbreviation{i}, 'l'))
            voinames(j).Name = sprintf('%s-%s-%s', num2str(chiffre.Index(i)), chiffre.Full_Name{i},'left');
        elseif regexp(voinames(j).Name, sprintf('%s_%s_%s', '\d*', chiffre.Abbreviation{i}, 'r'))
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


for j = 1:length(allglm)
    glmdir =  dir([session_path filesep allglm{j} filesep model filesep '*.glm']);    
    glm = xff([session_path filesep allglm{j} filesep model filesep glmdir(1).name]);

    betas = squeeze(glm.VOIBetas(voi)); %outputs a PredsxVOI matrix
    x = glm.Predictor;
    names = {x.Name2};

    idx={};
    for i = 1:length(conditions)
        idx(i,:) = regexp(names, sprintf('%s-%s-%s', 'r\d*', conditions{i}, '\d*'));
    end
    idx(cellfun('isempty',idx))={0};
    idx=logical(cell2mat(idx));

    betaseries = {};
    for i = 1:length(conditions)
        betaseries{i} = betas(idx(i,:),:);
    end
    varname = sprintf('fullbrain_betaseries_%s',allglm{j});
    eval([varname '= betaseries']);
    save(sprintf('fullbrain_betaseries_%s.mat',allglm{j}), sprintf('%s',varname))
end

