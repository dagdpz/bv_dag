function [voi,new_voi_path] = ne_voi_addvoxels(voi_input,shift_vois)
%ne_voi_addvoxels  - adds "missing" VMR voxels around NE ClusterTable exported VOI voxels
%
% USAGE:
% [voi,new_voi_path] = ne_voi_addvoxels(path_to_voi, [shift_vois]); % saves new voi to "path_to_voi"_voxadd.voi
% [voi] = ne_voi_addvoxels(voi_xff_object); % returns modified voi_xff_object
%
% INPUTS:
%		voi_input 1	- path to voi or voi xff object
%		shift_vois      - string to create VOIs that overlap with VMP in BV (default if not given as an input argument,'noshift'),
%				or VOIs that are shifted by +1 VTC subvoxel (VMR voxel) ('shift')
%
% OUTPUTS:
%		voi		- updated voi object
%		new_voi_path	- path to new (saved) voi
%
% REQUIRES:	NeuroElf
%
% See also TEST_VOI_VTC
%
%
% Author(s):	L. Gybson, I.Kagan, DAG, DPZ
% URL:		http://www.dpz.eu/dag
%
% Change log:
% 2015xxxx:	Created function (Lydia Gibson)
% 20160229:	Updated function to accept xff voi object, fixed looping through vois (Igor Kagan)
% 20160302:	Updated function to include shift_vois flag (Lydia Gibson)
% $Revision: 1.0 $  $Date: 2016-03-01 19:13:08 $

% ADDITIONAL INFO:
% https://docs.google.com/document/d/1ujUCpsIfLXNRvJb3aIbtsXtX0oMflYIGA5aQmC-Wopc/
%%%%%%%%%%%%%%%%%%%%%%%%%[DAG mfile header version 1]%%%%%%%%%%%%%%%%%%%%%%%%% 

if nargin < 2
    shift_vois = 'noshift'; % default: VOIs not shifted and thus overlapping with VMP
end

if  isxff(voi_input), % input is already xff voi object,
	voi = voi_input;
	new_voi_path = '';
else % voi_input is path to voi
	voi = xff(voi_input);
	new_voi_path = [voi_input(1:end-4) '_voxadd.voi'];
end
	
vois = voi.VOI;

for v = 1:voi.NrOfVOIs,
	vox_add = [];
    for vox = 1:length(vois(v).Voxels)
        
        switch shift_vois
            case 'noshift'
                vox_x = [vois(v).Voxels(vox,1) vois(v).Voxels(vox,1)-1];
                vox_y = [vois(v).Voxels(vox,2) vois(v).Voxels(vox,2)-1];
                vox_z = [vois(v).Voxels(vox,3) vois(v).Voxels(vox,3)-1];
                
            case 'shift'
                vox_x = [vois(v).Voxels(vox,1) vois(v).Voxels(vox,1)+1];
                vox_y = [vois(v).Voxels(vox,2) vois(v).Voxels(vox,2)+1];
                vox_z = [vois(v).Voxels(vox,3) vois(v).Voxels(vox,3)+1];
        end
        
        voxadd_x(1:4,1)		= vox_x(1); voxadd_x(5:8,1)		= vox_x(2);
        voxadd_y([1:2 5:6],1)	= vox_y(1); voxadd_y([3:4 7:8],1)	= vox_y(2);
        voxadd_z(1:2:8,1)	= vox_z(1); voxadd_z(2:2:8,1)		= vox_z(2);
        voxadd = [voxadd_x voxadd_y voxadd_z];
        vox_add = [vox_add; voxadd];
    end
    vox_add = unique(vox_add,'rows');
    vois(v).Voxels = vox_add;
    vois(v).NrOfVoxels = size(vois(v).Voxels,1);
end

voi.VOI = vois;

if ~isempty(new_voi_path),
	voi.SaveAs(new_voi_path);
	disp(['saved ' new_voi_path]);
end