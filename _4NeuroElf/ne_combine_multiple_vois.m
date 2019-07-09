function combined_filepath= ne_combine_multiple_vois(vois2combine,combined_filepath)
% vois2combine - list of individual voi files, e.g. from findfiles(pwd,'*.voi')
% combine multiple vois in one voi file

vois2combine = natsortfiles(vois2combine); % sort in natural order
if nargin < 2,
	combined_filepath = [pwd filesep 'combined.voi'];
end

cvoi = xff(vois2combine{1});
cvoi.NrOfVOIs = length(vois2combine);

for k = 2:cvoi.NrOfVOIs,
	voi = xff(vois2combine{k});
	cvoi.VOI(k) = voi.VOI;
end

cvoi.SaveAs(combined_filepath);
disp(['Saved ' combined_filepath]);