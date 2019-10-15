function [Slice1CenterX,Slice1CenterY,Slice1CenterZ,SliceNCenterX,SliceNCenterY,SliceNCenterZ] = get_sSliceArray_asSlice_sPosition(in1,setupIdent)
%get_sSliceArray_asSlice_sPosition  - this function reads Private_0029_1020 field (CSA Series Header) from
% DICOM file and returns slice positioning values (Pos Info in BV).
% This is important for monkey data for which standard header info is not working
%
% USAGE:
%  [Slice1CenterX,Slice1CenterY,Slice1CenterZ,SliceNCenterX,SliceNCenterY,SliceNCenterZ] = get_sSliceArray_asSlice_sPosition(in1);
%
% INPUTS:
%		in1		- path to dicom file or xff object
%
% OUTPUTS:
%		[Slice1CenterX,Slice1CenterY,Slice1CenterZ,SliceNCenterX,SliceNCenterY,SliceNCenterZ] - positioning info
% REQUIRES:	dicominfo
%
% See also DICOMINFO
%
%
% Author(s):	I.Kagan, DAG, DPZ
% URL:		http://www.dpz.eu/dag
%
% Change log:
% 2012xxxx:	Created function (Igor Kagan)
% 20160301:	Modified to work with DPZ Prisma DICOMs (Igor Kagan)
% $Revision: 1.0 $  $Date: 2016-03-01 18:23:16 $

% ADDITIONAL INFO:
% This function is part of ne_createfmr.m, which is part of DAG NeuroElf pipeline, residing in bv_dag
%%%%%%%%%%%%%%%%%%%%%%%%%[DAG mfile header version 1]%%%%%%%%%%%%%%%%%%%%%%%%% 

if nargin < 2,
	setupIdent = '';
end

if ischar(in1), % DICOM filepath
	
	d = dicominfo(in1);
	stream = char(d.Private_0029_1020)';
	% n_slices = length(d.Private_0019_1029); % This did not work with Caltech DICOM
	n_slices = length(strfind(stream,'sGroupArray.anMember['));
	slice_thickness = d.SliceThickness;
	
else % in1 comes from xff
	
	k_0019_1029 = find(strcmp(in1.DataKeys,'k_0019_1029'));
	k_0029_1020 = find(strcmp(in1.DataKeys,'k_0029_1020'));
	
	stream = char(in1.Data(k_0029_1020).Value);
	% n_slices = length(in1.Data(k_0019_1029).Value); % This did not work with Caltech DICOM
	n_slices = length(strfind(stream,'sGroupArray.anMember['));
	slice_thickness = in1.Value('SliceThickness');
end

% Z:\MRI\Human\Action Selection\Blocked\RIME\20140313\run01\10112-0006-0001.dcm
% sSliceArray.asSlice[0].sPosition.dSag    = -1.463844936
% sSliceArray.asSlice[0].sPosition.dCor    = -15.80432047
% sSliceArray.asSlice[0].sPosition.dTra    = -3.560982343
% sSliceArray.asSlice[0].sNormal.dSag      = -0.00588085788
% sSliceArray.asSlice[0].sNormal.dCor      = 0.08708496892
% sSliceArray.asSlice[0].sNormal.dTra      = 0.9961835291
% sSliceArray.asSlice[0].dThickness        = 3
% sSliceArray.asSlice[0].dPhaseFOV         = 192
% sSliceArray.asSlice[0].dReadoutFOV       = 192
% sSliceArray.asSlice[0].dInPlaneRot       = -0.01570796327

% D:\MRI\Human.Caltech\IK\20100409\run01\IK013 -0006-0001-00001.dcm  %%% no dSag!!!
% sSliceArray.asSlice[0].sPosition.dCor    = -24.62663281
% sSliceArray.asSlice[0].sPosition.dTra    = -6.469907846
% sSliceArray.asSlice[0].sNormal.dCor      = 0.2232501161
% sSliceArray.asSlice[0].sNormal.dTra      = 0.9747611942
% sSliceArray.asSlice[0].dThickness        = 3
% sSliceArray.asSlice[0].dPhaseFOV         = 192
% sSliceArray.asSlice[0].dReadoutFOV       = 192

% Z:\MRI\Curius\20140306\run01\0719-0011-0001.dcm  
% sSliceArray.asSlice[0].sPosition.dSag    = 4.196079907
% sSliceArray.asSlice[0].sPosition.dCor    = 5.502409636
% sSliceArray.asSlice[0].sPosition.dTra    = -0.5573563797
% sSliceArray.asSlice[0].sNormal.dCor      = 1
% sSliceArray.asSlice[0].dThickness        = 1.2
% sSliceArray.asSlice[0].dPhaseFOV         = 96
% sSliceArray.asSlice[0].dReadoutFOV       = 96
% sSliceArray.asSlice[0].dInPlaneRot       = -1.570796327




Slice1 = zeros(1,3);
SliceN = zeros(1,3);

stream(ismember(stream,char(9)))	= []; % remove tabs
stream(ismember(stream,' '))		= []; % remove spaces

% below is Lydia's code to deal with tabs and spaces, probably not needed
% switch setupIdent
%     case 'UMG'
% 
%         idx1 = findstr(stream','sSliceArray.asSlice[0].sPosition.dSag    = ');
%         idx2 = findstr(stream','sSliceArray.asSlice[0].sPosition.dCor    = ');
%         idx3 = findstr(stream','sSliceArray.asSlice[0].sPosition.dTra    = ');
%         len1 = length('sSliceArray.asSlice[0].sPosition.dSag    = ');
%         
%         idx4 = findstr(stream',['sSliceArray.asSlice[' num2str(n_slices-1) '].sPosition.dSag   = ']);
%         idx5 = findstr(stream',['sSliceArray.asSlice[' num2str(n_slices-1) '].sPosition.dCor   = ']);
%         idx6 = findstr(stream',['sSliceArray.asSlice[' num2str(n_slices-1) '].sPosition.dTra   = ']);
%         lenN = length(['sSliceArray.asSlice[' num2str(n_slices) '].sPosition.dTra    = ']);
%         
%     case 'DPZ'
%         
%         idx1 = findstr(stream',sprintf('sSliceArray.asSlice[%d].sPosition.dSag\t = \t', 0));
%         idx2 = findstr(stream',sprintf('sSliceArray.asSlice[%d].sPosition.dCor\t = \t', 0));
%         idx3 = findstr(stream',sprintf('sSliceArray.asSlice[%d].sPosition.dTra\t = \t', 0));
%         len1 = length(sprintf('sSliceArray.asSlice[%d].sPosition.dSag\t = \t', 0));
%         
%         idx4 = findstr(stream',sprintf('sSliceArray.asSlice[%d].sPosition.dSag\t = \t', n_slices-1));
%         
%         if numel(idx3) > 1
%             idx3 = idx3(end);
%         end
%         if numel(idx4) > 1
%             idx4 = idx4(end);
%         end
%         
%         idx5 = findstr(stream',sprintf('sSliceArray.asSlice[%d].sPosition.dCor\t = \t', n_slices-1));
%         idx6 = findstr(stream',sprintf('sSliceArray.asSlice[%d].sPosition.dTra\t = \t', n_slices-1));
%         lenN = length(sprintf('sSliceArray.asSlice[%d].sPosition.dTra\t = \t', n_slices));   
% end % end of Lydia's code to deal with tabs/spaces



idx1 = strfind(stream,'sSliceArray.asSlice[0].sPosition.dSag=');
idx2 = strfind(stream,'sSliceArray.asSlice[0].sPosition.dCor=');
idx3 = strfind(stream,'sSliceArray.asSlice[0].sPosition.dTra=');
len1 = length('sSliceArray.asSlice[0].sPosition.dSag=');


idx4 = strfind(stream,['sSliceArray.asSlice[' num2str(n_slices-1) '].sPosition.dSag=']);
idx5 = strfind(stream,['sSliceArray.asSlice[' num2str(n_slices-1) '].sPosition.dCor=']);
idx6 = strfind(stream,['sSliceArray.asSlice[' num2str(n_slices-1) '].sPosition.dTra=']);
lenN = length(['sSliceArray.asSlice[' num2str(n_slices-1) '].sPosition.dTra=']);


% The snippet below does not work with DPZ data because of tabs
% idx1 = findstr(stream,'sSliceArray.asSlice[0].sPosition.dSag    = ');
% idx2 = findstr(stream,'sSliceArray.asSlice[0].sPosition.dCor    = ');
% idx3 = findstr(stream,'sSliceArray.asSlice[0].sPosition.dTra    = ');
% len1 = length('sSliceArray.asSlice[0].sPosition.dSag    = ');
% 
% 
% idx4 = findstr(stream,['sSliceArray.asSlice[' num2str(n_slices-1) '].sPosition.dSag   = ']);
% idx5 = findstr(stream,['sSliceArray.asSlice[' num2str(n_slices-1) '].sPosition.dCor   = ']);
% idx6 = findstr(stream,['sSliceArray.asSlice[' num2str(n_slices-1) '].sPosition.dTra   = ']);
% lenN = length(['sSliceArray.asSlice[' num2str(n_slices) '].sPosition.dTra    = ']);

idx_eol = strfind(stream,sprintf('\n'));

idx_sorted1 = sort([idx_eol idx1 idx2 idx3]);
i_start = find(idx_sorted1 == min([idx1 idx2 idx3]));
i_end   = find(idx_sorted1 == max([idx1 idx2 idx3])) + 1;
idx_sorted1 = idx_sorted1(i_start:i_end+1);


idx_sorted2 = sort([idx_eol idx4 idx5 idx6]);
i_start = find(idx_sorted2 == min([idx4 idx5 idx6]));
i_end   = find(idx_sorted2 == max([idx4 idx5 idx6])) + 1;
idx_sorted2 = idx_sorted2(i_start:i_end+1);

% find non-empty fields (dSag / dCor / dTra)
idx_nonempty = find(~cellfun('isempty', {idx1 idx2 idx3}));


k = 1;
for n = idx_nonempty,
	Slice1(n) = str2num(stream(idx_sorted1(k) + len1 : idx_sorted1(k+1)));
	k = k + 2;
end
k = 1;
for n = idx_nonempty,
	SliceN(n) = str2num(stream(idx_sorted2(k) + lenN : idx_sorted2(k+1)));
	k = k + 2;
end

% for k = [1 3 5],
% 	Slice1(n) = str2num(stream(idx_sorted1(k) + len1 : idx_sorted1(k+1))');
% 	n = n + 1;
% end
% n = 1;
% for k = [1 3 5],
% 	SliceN(n) = str2num(stream(idx_sorted2(k) + len1 : idx_sorted2(k+1))');
% 	n = n + 1;
% end
Slice1CenterX = Slice1(1); % <- dSag
Slice1CenterY = Slice1(2); % <- dCor
Slice1CenterZ = Slice1(3); % <- dTra
SliceNCenterX = SliceN(1);
SliceNCenterY = SliceN(2);
SliceNCenterZ = SliceN(3);

% previous version (worked only with monkey data)
% idx1 = findstr(stream','sSliceArray.asSlice[0].sPosition.dSag    = ');
% len1 = length('sSliceArray.asSlice[0].sPosition.dSag    = ');
% 
% idx2 = findstr(stream','sSliceArray.asSlice[0].sPosition.dCor    = ');
% len2 = length('sSliceArray.asSlice[0].sPosition.dCor    = ');
% 
% idx3 = findstr(stream','sSliceArray.asSlice[0].sPosition.dTra    = ');
% len3 = length('sSliceArray.asSlice[0].sPosition.dTra    = ');
% 
% idx4 = findstr(stream','sSliceArray.asSlice[0].sNormal.dCor');
% 
% Slice1CenterX = str2num((stream(idx1+len1:idx2-1))');
% Slice1CenterY = str2num((stream(idx2+len2:idx3-1))');
% Slice1CenterZ = str2num((stream(idx3+len3:idx4-1))');
% 
% SliceNCenterX = Slice1CenterX;
% SliceNCenterY = Slice1CenterY + (n_slices-1)*slice_thickness;
% SliceNCenterZ = Slice1CenterZ;

