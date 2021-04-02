function ne_modify_voi_name(voi_path,oldsubstr,newsubstr)
% replace oldsubstr->newsubstr in voi name(s)
% or append a string to the beginning or the end of the name
% ne_modify_voi_name('2021.voi','ENDING_hemi');

if nargin < 3,
    newsubstr = '';
end

voi = xff(voi_path);


for k = 1:voi.NrOfVOIs,
    
    if strcmp(oldsubstr,'BEGINNING'),
        voi.VOI(k).Name = [newsubstr voi.VOI(k).Name];
    elseif strcmp(oldsubstr,'ENDING')
        voi.VOI(k).Name = [voi.VOI(k).Name newsubstr];
    elseif strcmp(oldsubstr,'ENDING_hemi'), % quick and dirty, re-code?
        cluster_name = voi.VOI(k).Name;
        if strcmp(cluster_name(13),'-'),
            cluster_name = [cluster_name 'l'];
        else
            cluster_name = [cluster_name 'r'];
        end
        voi.VOI(k).Name = cluster_name;
    else % replace
        voi.VOI(k).Name = strrep(voi.VOI(k).Name,oldsubstr,newsubstr);
    end
end

voi.SaveAs(voi_path);
disp(['Saved ' voi_path]);