function betaseries=bsc_get_beta_series_for_multiple_sessions(session_path, model, allglm, voi, conditions)
%computes beta series per condition and saves them by session name
%no plots
%expects predictor names in rXX_condition_XX format
%conditions = {'fixation' 'fixation microstim' 'memory left' 'memory right' 'memory left microstim' 'memory right microstim'};
%example usage
% get_beta_series_for_multiple_sessions('/home/alex/MRI/Curius', 'mat2prt_fixmemstim_BASCO', ... 
%     {'20131129', '20131204', '20131211', '20131213', '20131218','20140122', '20140124', '20140129', '20140131', '20140204', '20140214', '20140226', ...
%     '20150303', '20150311', '20150422', '20150423', '20150429', '20150430', '20150506', '20150507'},...
%     '/mnt/KognitiveNeurowissenschaften/DAG/Personal/AlexandraWitt/CU_bl_rl_k20_05FDR_positiveonly_from_CU_CHARM_tal.voi', {'fixation' 'fixation microstim' 'memory left' 'memory right' 'memory left microstim' 'memory right microstim'});


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
    varname = sprintf('betaseries_%s',allglm{j});
    eval([varname '= betaseries']);
    save(sprintf('betaseries_%s.mat',allglm{j}), sprintf('%s',varname))
end

