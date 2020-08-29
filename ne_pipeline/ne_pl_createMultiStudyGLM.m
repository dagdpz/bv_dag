function glm = ne_pl_createMultiStudyGLM(glm_path, glm_name, session_settings_id, mdm_file)

% glm_path = 'D:\MRI\Curius\20140528_test';
% glm_name = 'combined_spkern_3-3-3';
% session_settings_id = 'Curius_microstim_20131129-now';
% mdm_file = [glm_path filesep 'session_20140528_test.mdm'];

run('ne_pl_session_settings');

mdm = xff(mdm_file);

mdm.SeparatePredictors = settings.mdm.seppred; % separation of predictors

add_name = '';
% transformation applied to volume time courses
if settings.mdm.zTransformation
    mdm.zTransformation = 1;
    add_name = [add_name '_ZT'];
elseif settings.mdm.PSCTransformation
    mdm.PSCTransformation = 1;
    add_name = [add_name '_PSC'];
end

mdm.RFX_GLM = settings.mdm.RFX_GLM; % model: FFX or RFX
if settings.mdm.RFX_GLM
    add_name = [add_name '_RFX'];
else add_name = [add_name '_FFX'];
end

opts = struct();

if ~isempty(settings.mdm.mask)
    add_name = [add_name '_mask'];
    opts.mask = settings.mdm.mask;
end

% added IK 20190801
if isfield(settings.mdm,'robust'),
    if settings.mdm.robust
        add_name = [add_name '_robust'];
        opts.robust = true;
    end
end

if isfield(settings.sdm, 'ppicond') && ~isempty(settings.sdm.ppicond)
    voi = xff(settings.sdm.ppivoi);
    add_name = [add_name '_ppi' voi.VOI(settings.sdm.ppivoiidx).Name];
end

glm_filename = [glm_path filesep glm_name add_name '.glm'];

% see mdm_ComputeGLM.m for GLM computation, also see http://neuroelf.net/wiki/doku.php?id=mdm.computeglm (not up to date!) and http://neuroelf.net/wiki/doku.php?id=neuroelf_changelog
opts.outfile = glm_filename;

glm = mdm.ComputeGLM(opts);
disp([glm_filename ' created']);