function ne_split_voi_LH_RH(voi_path)
% ne_split_voi_LH_RH - splits vois to left and right hemisphere vois

[path, name] = fileparts(voi_path);

lvoi=xff(voi_path);
rvoi=xff(voi_path);

delidxl=[];
delidxr=[];
for i = 1:length(lvoi.VOI)
    if strcmp(lvoi.VOI(i).Name(end-1:end), '_r')
        delidxl = [delidxl i];
    elseif ~strcmp(lvoi.VOI(i).Name(end-1:end), '_l')
        lvoi.VOI(i).Voxels(lvoi.VOI(i).Voxels(:,3)<lvoi.OriginalVMRFramingCubeDim/2,:)=[];
        lvoi.VOI(i).Name = [lvoi.VOI(i).Name '_l'];
    end
    
    if strcmp(rvoi.VOI(i).Name(end-1:end), '_l')
        delidxr = [delidxr i];
    elseif ~strcmp(rvoi.VOI(i).Name(end-1:end), '_r')
        rvoi.VOI(i).Voxels(rvoi.VOI(i).Voxels(:,3)>rvoi.OriginalVMRFramingCubeDim/2,:)=[];
        rvoi.VOI(i).Name = [rvoi.VOI(i).Name '_r'];
    end
end

lvoi.VOI(delidxl)=[];
empties = [];
for i = 1:length(lvoi.VOI)
    if lvoi.VOI(i).NrOfVoxels == 0
        empties = [empties i];
    end
end
lvoi.VOI(empties) = [];
lvoi.NrOfVOIs = length(lvoi.VOI);
if lvoi.NrOfVOIs ~=0
    lvoi.SaveAs([path filesep name '_l.voi']);
    disp(['Saved ' name '_l'])
else
    warning('left %s not saved; empty',voi_path) 
end

rvoi.VOI(delidxr)=[];
empties = [];
for i = 1:length(rvoi.VOI)
    if rvoi.VOI(i).NrOfVoxels == 0
        empties = [empties i];
    end
end
rvoi.VOI(empties) = [];
rvoi.NrOfVOIs = length(rvoi.VOI);
if rvoi.NrOfVOIs ~= 0
    rvoi.SaveAs([path filesep name '_r.voi']);
    disp(['Saved ' name '_r'])
else
    warning('right %s not saved; empty',voi_path) 
end
