function att_extract_all_nifti_vois_from_atlas(nii_path,label_value_name,include_value_to_name)
%att_extract_all_nifti_vois_from_atlas  - extracts all vois
%
% USAGE:
% att_extract_all_nifti_vois_from_atlas

% INPUTS:
%		nii_path                - atlas label nifti
%		label_value_name        - cell array with values (doubles, 1st column) and names (cells, 2nd column)
%       include_value_to_name   - if true, add label_value to the nii name
%		e.g. created as:
%		load civm_rhesus_v1_ontology.mat
%		label_value_name = {ds.Value ds.Abbreviation};
%       or as:
%       Y:\Atlases\human\CerebrA\process_atlas.m
% OUTPUTS:
%		None
% REQUIRES:	NIfTI toolbox, att_extract_nifti_vois_from_atlas
%
% See also IG_EXTRACT_NIFTI_VOI_FROM_ATLAS
%
%
% Author(s):	I.Kagan, DAG, DPZ
% URL:		http://www.dpz.eu/dag
%
% Change log:
% 20160215:	Created function (Igor Kagan)
% ...
% $Revision: 1.0 $  $Date: 2016-02-25 14:23:34 $

% ADDITIONAL INFO:
% http://www.civm.duhs.duke.edu/rhesusatlas/
%%%%%%%%%%%%%%%%%%%%%%%%%[DAG mfile header version 1]%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin < 3,
    include_value_to_name = 1;
end

for k = 1:length(label_value_name{1}),
	att_extract_nifti_voi_from_atlas(nii_path,label_value_name{1}(k),label_value_name{2}{k},include_value_to_name);
end
