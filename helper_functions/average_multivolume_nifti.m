function average_multivolume_nifti(fullpath)
%average_multivolume_nifti  - averages multiple volumes (of EPI) into mean volume
%
% USAGE:
% average_multivolume_nifti(fullpath_to_nifti);
%
% INPUTS:
%		fullpath	- ...
%
% OUTPUTS:
%		output1		- none
%
% REQUIRES:	nifti(_20140122)
%
% See also LOAD_NII, SAVE_NII
%
%
% Author(s):	I.Kagan, DAG, DPZ
% URL:		http://www.dpz.eu/dag
%
% Change log:
% 2014xxxx:	Created function (Igor Kagan)
% 20170519	Added header (IK)
% $Revision: 1.0 $  $Date: 2017-05-19 15:57:44 $

% ADDITIONAL INFO:
% ...
%%%%%%%%%%%%%%%%%%%%%%%%%[DAG mfile header version 1]%%%%%%%%%%%%%%%%%%%%%%%%% 


msg = sprintf('\n image read: %s',fullpath); disp(msg);    
nii = load_nii(fullpath);
F = nii.img;


AV=mean(F,4);


ResX=nii.hdr.dime.pixdim(2);
ResY=nii.hdr.dime.pixdim(3);
ResZ=nii.hdr.dime.pixdim(4);

voxel_size =[ ResX ResY ResZ ];
origin = [ 0 0 0 ];
datatype = 16;
nii_out = make_nii( AV , voxel_size , origin , datatype );

save_nii(nii_out,[fullpath(1:end-4) '_ave' '.nii']);
disp(sprintf('saved %s', [fullpath(1:end-4) '_ave' '.nii']));
