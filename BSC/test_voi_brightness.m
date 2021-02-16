function test_voi_brightness(main_path,sessions,voipath,threshold)
cutoff = {};
[path,name] = fileparts(voipath);
voi = xff(voipath);
voinames = voi.VOI;
voinames = {voinames.Name};
for j = 30:39
    session_path = [main_path filesep sessions{j}]; 
    vtcs = findfiles(session_path, '*spkern_3-3-3.vtc');
    tcs = {};
    for i= 1:length(vtcs)
        vtc = vtcs{i};
        if ~isxff(vtc)
            vtc = xff(vtc);
        end
        tcs{i} = vtc.VOITimeCourseOrig(voi);
    end

    tcsm = {};
    subthresh = {};
    for i = 1:length(tcs)
        tcsm{i} = mean(tcs{i});
        subthresh{i} = tcsm{i}<threshold;
    end
    subthresh = logical(sum(vertcat(subthresh{:})));
    cutoff{j} = subthresh;
end
cutoff = logical(sum(vertcat(cutoff{:})));
sym = {};
j=1;
lowint = voi.VOI(cutoff); %additionally remove VOIs which are bad in the other hemisphere for symmetry
lowint = {lowint.Name};
for i = 1:length(lowint)
    mirrored = lowint{i};
    if mirrored(end) == 'l'
        mirrored(end) = 'r';
    elseif mirrored(end) == 'r'
        mirrored(end) = 'l';
    end
    if ~ismember(mirrored,lowint)
        sym{j} = strcmp(mirrored,voinames);
        j=j+1;
    end
end
if length(sym)>1
    sym = logical(sum(vertcat(sym{:})));
else
    sym = sym{1};
end
cutoff = or(cutoff,sym);
voi.VOI(cutoff) = [];
voi.NrOfVOIs = length(voi.VOI);
voi.SaveAs([path filesep name '_updated.voi'])
