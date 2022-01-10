function combined_filepath= ne_voi_combine_two_multivois(vois2combine,combined_filepath)

if nargin < 2,
	combined_filepath = [pwd filesep 'combined.voi'];
end

voi1 = xff(vois2combine{1});
voi2 = xff(vois2combine{2});

voi1.VOI(voi1.NrOfVOIs + 1:voi1.NrOfVOIs + voi2.NrOfVOIs) = voi2.VOI;
voi1.NrOfVOIs = voi1.NrOfVOIs + voi2.NrOfVOIs;

voi1.SaveAs(combined_filepath);
disp(['Saved ' combined_filepath]);
voi1.ClearObject;
voi2.ClearObject;