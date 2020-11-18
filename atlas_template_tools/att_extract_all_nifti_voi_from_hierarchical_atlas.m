function att_extract_all_nifti_voi_from_hierarchical_atlas(nii_path,label_value_name)
%ig_nifti_extract_all_nifti_vois_from_atlas  - extracts all vois
%
% USAGE:
% ig_nifti_extract_all_nifti_vois_from_atlas

% INPUTS:
%		nii_path		- atlas label nifti
%		label_value_name	- cell array with values (doubles, 1st column),
%		names (cells, 2nd column)and the level of the VOI (doubles, 3rd
%		column)
%		e.g. created as:
%		load('CHARMkeyds.mat')
%       load('SARMkeyds.mat')
%       
% OUTPUTS:
%		None
% REQUIRES:	NIfTI toolbox, ig_nifti_extract_all_nifti_vois_from_atlas
%
% See also IG_NIFTI_EXTRACT_NIFTI_VOI_FROM_ATLAS
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

for k = 1:length(label_value_name{1}),
	ig_nifti_extract_nifti_voi_from_hierarchical_atlas(nii_path,label_value_name{1}(k),label_value_name{2}{k},label_value_name{3}(k));
end
