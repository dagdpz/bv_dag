function ne_manage_vois(voi_file,remove_clusters,voi_size_threshold,VOI_radius)

% Created by Caio Moreira 13.April.2016
% remove_clusters: 1=yes, 0=no (this option doesn't remove clusters which do not contain subclusters)
% voi_size_threshold: 0 = do not threshold the VOI size, >0 set the threshold as voi_size_threshold
% VOI_radius: number of voxels from the peak voxel which create a "sphere" of radius = VOI_radius

% e.g ne_manage_vois('D:\MRI\Human\PDW\Study\combined\mat2prt_hum_postwag_M2Squad_Wagbidirect_exponential\VOI\p0001_all.voi',1,21,2)

if nargin < 4
    VOI_radius = 0;
end

idx_folder = findstr(voi_file,'\');
disp(['Modifying ' voi_file(idx_folder(end)+1:end)]);

file = xff(voi_file);

idx_voi_to_remove = [];

for v = 1:(file.NrOfVOIs)
    
    if remove_clusters  && v ~= file.NrOfVOIs(end)      
        idx_cluster    = findstr(file.VOI(v).Name,'Cluster');
        idx_subcluster = findstr(file.VOI(v+1).Name,'SC');
        if idx_cluster & idx_subcluster,
            idx_voi_to_remove = [idx_voi_to_remove; v];
        end
    end
    
    if voi_size_threshold
        name_cluster_thr = ['_size_thr_' num2str(voi_size_threshold)];
        if file.VOI(v).NrOfVoxels < voi_size_threshold+1
            idx_voi_to_remove = [idx_voi_to_remove; v];
        end
    else
        name_cluster_thr = '';
    end
    
end

file.VOI(idx_voi_to_remove)   = [];
file.NrOfVOIs = file.NrOfVOIs-length(idx_voi_to_remove);

if VOI_radius    
    name_radius = ['_Radius_' num2str(VOI_radius)];    
    for v = 1:file.NrOfVOIs
        file.VOI(v).Voxels = file.VOI(v).Voxels(1,:);
        [xg] = addsphere(file.VOI(v).Voxels,VOI_radius);
        file.VOI(v).Voxels = xg;
    end    
else
    name_radius = '';
end

[pathstr,name,ext] = fileparts(voi_file);

if remove_clusters
    name_remove = '_rm_Clusters';
else
    name_remove = '';
end

new_file = [pathstr '\' name name_remove name_cluster_thr name_radius ext];

file.SaveAs(new_file);
disp(['created  ' new_file])

function [xg] = addsphere(c,r)

% part of the ne function voi_AddSphericalVOI

% for tal coordinates
bb = [-128, 128];

rc = round(c);
cr = ceil(r + 0.5);
[xg, yg, zg] = ndgrid( ...
    rc(1)-cr:rc(1)+cr, rc(2)-cr:rc(2)+cr, rc(3)-cr:rc(3)+cr);

% fill with grid
xg = [xg(:), yg(:), zg(:)];

% remove voxels beyond bounding box
xg(any(xg < bb(1), 2) | any(xg > bb(2), 2), :) = [];

% compute distance
yg = sqrt(sum((xg - c(ones(1, size(xg, 1)), :)) .^ 2, 2));

% sort by distance
[yg, ygi] = sort(yg);
xg = xg(ygi, :);

% remove further away stuff
xg(yg > r, :) = [];
