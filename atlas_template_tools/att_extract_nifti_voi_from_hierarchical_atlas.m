function nifti_voi_path = att_extract_nifti_voi_from_hierarchical_atlas(nii_path,label_value,abbr_name,level,atlas,subj)
%att_extract_nifti_voi_from_hierarchical_atlas  - extracts and saves one nifti volume corresponding to a value label in the atlas 
%
% USAGE:
% att_extract_nifti_voi_from_hierarchical_atlas('Y:\Atlases\macaque\CHARM\CHARM_in_curius_anat.nii.gz',202,'test', 6); 

%
% INPUTS:
%		nii_path	- atlas nifti
%		label_value	- intensity corresponding to a certain voi
%		abbr_name	- name for the roi
%       level       - level of the VOI
%       atlas       - Specify 'CHARM' or 'SARM'
% OUTPUTS:
%		None
% REQUIRES:	NIfTI toolbox
%
% See also NIFTI toolbox
%
%
% Author(s):	I.Kagan, DAG, DPZ; A.Witt, DAG, DPZ
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

if nargin < 6,
    subj = atlas;
end

[pathstr, name, ext] = fileparts(nii_path);

nii = load_untouch_nii(nii_path);

if isempty(find(nii.img==label_value)),
    disp(sprintf('label %d (%s) not found!',label_value,abbr_name));
    return;
end

idx = find(nii.img~=label_value);
nii.img(idx) = 0;

if strcmp(atlas,'CHARM');
    nii.img(:,:,:,:,1)=nii.img(:,:,:,:,level);
elseif strcmp(atlas, 'SARM');
    nii.img(:,:,:,1)=nii.img(:,:,:,level);
end

% make sure abbr_name does not contain slashes etc.
abbr_name=regexprep(abbr_name,'[\\|!?@#$&/]','-');

% remove '_'
abbr_name=regexprep(abbr_name,'_','-');

nifti_voi_path = [subj num2str(label_value) '-' abbr_name '.nii'];

if ~isempty(pathstr)
	nifti_voi_path = [pathstr filesep nifti_voi_path];
end

save_untouch_nii(nii,nifti_voi_path);
disp(['Saved ' nifti_voi_path]);
