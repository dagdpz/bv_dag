function [era,avg,voi,anova] = ne_era_anova(voipath,avgpath,mdmpath,era_settings_id,ra_bins, tc_interpolate, assignment, varnames, levnames)
% voi_def = 'D:\MRI\Curius\combined\microstim_20140122-20140226_5_3_250uA_nobaseline\11pred\microstim_20140122-20140226_5_3_250uA_nobaseline.voi';
% avgpath = 'D:\MRI\Curius\combined\microstim_20140122-20140226_5_3_250uA_nobaseline\11pred\combined_spkern_3-3-3_ne_prt2avg_fixation_memory_microstim.avg';
% era_settings_id = '';
% ra_bins = [7:10];
% tc_interpolate = 0;
% assignment = [1 1; 1 2; 2 1; 2 2; 3 1; 3 2];
% varnames = {'Task' 'Stimulation'};
% levnames = {{'Fix' 'MemR' 'MemL'} {'Nostim' 'Stim'}};


era = ne_era_new(voi_def, avgpath, era_settings_id, 'ra_bins',ra_bins, 'tc_interpolate',tc_interpolate);
avg = xff(avgpath);
voi = xff(voi_def);
voi = voi.VOI;

data = struct2cell(era.RA);
data = squeeze(data(1,:,:));

n_voi = size(era.RA,1);
for v = 1:n_voi
    anova(v) = nway_anova(data(v,:), assignment, varnames, levnames);
end