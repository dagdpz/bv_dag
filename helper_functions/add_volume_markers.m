function h = add_volume_markers(volume_markers,varargin)
%add_volume_markers  - add vertical volume markers to time-course
%
% USAGE:	add_volume_markers(outlier_volumes*settings.fmr_create.TR/1000,'Color',[0.9 0.7 0.7],'LineStyle','-');
% 
%		
% INPUTS:
%		volume_markers	- exlanation
%		varargin	- pair(s) of line properties
%
% OUTPUTS:
%		h		- handle to markers
%
% REQUIRES:	none
%
% See also NE_PL_EXCLUDE_OUTLIERS_AVG, NE_PL_FMRIQASHEET
%
%
% Author(s):	I.Kagan, DAG, DPZ
% URL:		http://www.dpz.eu/dag
%
% Change log:
% 2014xxxx:	Created function (Igor Kagan)
% 20170519	Added header (IK)
% $Revision: 1.0 $  $Date: 2017-05-19 15:38:03 $

% ADDITIONAL INFO:
% None
%%%%%%%%%%%%%%%%%%%%%%%%%[DAG mfile header version 1]%%%%%%%%%%%%%%%%%%%%%%%%% 

if length(unique(volume_markers))==2 && max(volume_markers) == 1 && min(volume_markers)==0 && length(volume_markers)>2,
	% probably logical 0s and 1s, convert to volume numbers
	volume_markers = find(volume_markers);
end

% make sure volume_markers is row vector
volume_markers = volume_markers(:)';

ylim = get(gca,'Ylim');


h = line(kron(volume_markers,[1 1 1]),repmat([ylim NaN],1,length(volume_markers)),'Color',[0 1 0],'LineStyle','--',varargin{:});
