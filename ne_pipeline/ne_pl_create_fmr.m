function fmr = ne_pl_create_fmr(dicom_path,fmr_fullpath,session_settings_id)

ori_dir = pwd;
cd(dicom_path);
d = dir([dicom_path filesep '*.dcm']);
imafiles = {d.name}';

run('ne_pl_session_settings');

% remove skipped volumes
imafiles = imafiles(settings.fmr_create.NrOfSkippedVolumes+1:end);
settings.fmr_create.NrOfSkippedVolumes = 0;

% flags
%          .fileorder slice-wise DCM file order, either 'tz' or {'zt'}
%          .flip      additionally flip data (e.g. 'xy')
%          .mosaic    flag to force mosaic processing
%          .mosdimord mosaic dimension order (default: [1, 2])
%          .nslices   number of slices for 1-slice DCM files
%          .xyres     functional x/y resolution (default [64, 64])

flags.xyres = [settings.fmr_create.ResolutionX,settings.fmr_create.ResolutionY];

switch settings.Species
    case 'human'
        % n = neuroelf; fmr = n.createfmr(imafiles, flags); % original NE - problems with positioning ("BV -> FMR properties -> POS Info)
        fmr = ne_createfmr(imafiles, flags, 'monkey'); % modified IK
    case 'monkey'
        fmr = ne_createfmr(imafiles, flags, settings.Species); % modified IK
end

settings2set = fieldnames(settings.fmr_create);
length_settings = length(settings2set);


for k=1:length_settings,
    fmr.(settings2set{k}) = settings.fmr_create.(settings2set{k});
end

fmr.SaveAs(fmr_fullpath);
disp([fmr_fullpath ' created']);
cd(ori_dir);
