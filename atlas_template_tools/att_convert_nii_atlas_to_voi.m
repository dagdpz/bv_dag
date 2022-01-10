function att_convert_nii_atlas_to_voi(nii_path,label_value_name,species,include_value_to_name)
%att_convert_nii_atlas_to_voi  - convert nii atlas to voi file
%
% USAGE:
% att_convert_nii_atlas_to_voi
%
% this function is a unified wrapper replacement for the initial "pipeline":
% att_extract_all_nifti_vois_from_atlas --> att_convert_nifti_atlas_vois_to_BV_vmr_voi --> ne_combine_multiple_vois(findfiles(pwd,'*.voi'),'atlas_combined.voi');
% currently works for non-hierarchical atlases
%
% INPUTS:
%		nii_path                - atlas label nifti
%		label_value_name        - cell array with values (doubles, 1st column) and names (cells, 2nd column): e.g. see
%                                 Y:\Atlases\human\MNI_Glasser_HCP_2019_v1.0\process_atlas
%       species                 - 'monkey' (macaque, that is) or 'human': important for resolution and bounding box
%       include_value_to_name   - if true, add label_value to the individual voi name
% OUTPUTS:
%		None
% REQUIRES:	NIfTI toolbox, NeuroElf
%
%
% Author(s):	I.Kagan, DAG, DPZ
% URL:		http://www.dpz.eu/dag
%
% Change log:
% 20201120:	Created function (Igor Kagan)
% ...
% $Revision: 1.0 $  $Date: 2020-11-20 14:23:34 $
%%%%%%%%%%%%%%%%%%%%%%%%%[DAG mfile header version 1]%%%%%%%%%%%%%%%%%%%%%%%%%
    
global n
n = neuroelf;

    
[pathstr, name, ext] = fileparts(nii_path);

if isempty(pathstr), % only nii name was provided, assuming we are in a target folder
    pathstr = pwd;
end

N = length(label_value_name{1});

% voi colormap, same for left and right vois, assuming that they come one after another
cmap = jet(ceil(N/2));
cmap = fix(255*reshape(repmat(cmap(:)',2,1),[],3));

for k = 1:N, 
    
    label_value = label_value_name{1}(k);
    label_name = label_value_name{2}{k};
    
    disp(sprintf('Processing voi %d out of %d: %s',k,N,label_name));
    
    nii = load_untouch_nii(nii_path);
    
    idx = find(nii.img~=label_value);
    nii.img(idx) = 0;
    
    % make sure abbr_name does not contain slashes etc.
    label_name=regexprep(label_name,'[\\|!?@#$&/]','_');

    
    if include_value_to_name,
        voi_name = [num2str(label_value) '_' label_name];
    else
        voi_name = [label_name];
    end
    
    nifti_voi_path = [pathstr filesep voi_name '.nii'];

    save_untouch_nii(nii,nifti_voi_path);
    
    vmr_path = ne_convert_MRIcron_nifti_voi_to_vmr(nifti_voi_path,'',species);
    ne_convert_vmr_to_voi(vmr_path,cmap(k,:),voi_name,'',species);
    
end

ne_combine_multiple_vois(findfiles(pathstr,'*.voi'),[name '.voi']);
