function nifti_voi_path = att_extract_nifti_voi_from_atlas(nii_path,label_value,abbr_name,include_value_to_name)
%att_extract_nifti_voi_from_atlas  - extracts and saves one nifti volume corresponding to a value label in the atlas 
%
% USAGE:
% att_nifti_extract_nifti_voi_from_atlas('Z:\Atlases\macaque\Calabrese2015\test\civm_rhesus_v1_labels_downsample2.nii',202,'test');
%
% INPUTS:
%		nii_path	- atlas nifti
%		label_value	- intensity corresponding to a certain voi
%		abbr_name	- name for the roi
%       include_value_to_name - if true, add label_value to the nii name
% OUTPUTS:
%		None
% REQUIRES:	NIfTI toolbox
%
% See also NIFTI toolbox
%
%
% Author(s):	I.Kagan, DAG, DPZ
% URL:		http://www.dpz.eu/dag
%
% Change log:
% 20160225:	Created function (Igor Kagan)
% ...
% $Revision: 1.0 $  $Date: 2016-02-25 14:07:55 $

% ADDITIONAL INFO:
% uses NIFTI toolbox, NIfTI_20140122
% see http://de.mathworks.com/matlabcentral/fileexchange/8797-tools-for-nifti-and-analyze-image
%%%%%%%%%%%%%%%%%%%%%%%%%[DAG mfile header version 1]%%%%%%%%%%%%%%%%%%%%%%%%% 

if nargin < 3,
	abbr_name = '';
end

if nargin < 4,
	include_value_to_name = 1;
end

[pathstr, name, ext] = fileparts(nii_path);

nii = load_untouch_nii(nii_path);

idx = find(nii.img~=label_value);
nii.img(idx) = 0;

% make sure abbr_name does not contain slashes etc.
abbr_name=regexprep(abbr_name,'[\\|!?@#$&/]','_');

if include_value_to_name,
    nifti_voi_path = [num2str(label_value) '_' abbr_name '.nii'];
else
    nifti_voi_path = [abbr_name '.nii'];
end

if ~isempty(pathstr)
	nifti_voi_path = [pathstr filesep nifti_voi_path];
end

save_untouch_nii(nii,nifti_voi_path);
disp(['Saved ' nifti_voi_path]);
