function sdm = ne_pl_create_sdm(prt_fullpath, session_settings_id,vtcs,k)

if nargin < 3
    vtcs = [];
    k = 0;
end

prt = xff(prt_fullpath);
run('ne_pl_session_settings');

% for PPI
if isfield(settings.sdm, 'ppicond') && ~isempty(settings.sdm.ppicond)
    voi = xff(settings.sdm.ppivoi);
    vtc = xff(vtcs{k});
    [voitc, voin] = vtc.VOITimeCourse(voi);
    settings.sdm.ppitc = ztrans(voitc(:,settings.sdm.ppivoiidx)); % z transform VOI time course before adding as a regressor
    sdm_add_name = ['_ppi' voin{settings.sdm.ppivoiidx}];
else sdm_add_name = '';
end

sdm = prt.BASCO(settings.sdm);
sdm.SaveAs([prt_fullpath(1:end-4),'_task' sdm_add_name '.sdm']);
disp(['created ' [prt_fullpath(1:end-4),'_task' sdm_add_name '.sdm']]);


