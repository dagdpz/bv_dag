function [fq, fmridata] = ne_fmriquality(images, opts)
% modification of original fmriquality with options for outliers analysis IK 2014
% fmriquality  - get some quality assurance for fMRI data
%
% FORMAT:       [fq, fmridata = ] fmriquality(images [, opts])
%
% Input fields:
%
%       images      list of images (or fMRI datatype, like FMR/VTC)
%       opts        optional settings
%        .motcor    perform motion-correction (and re-do stats, def: false)
%        .nuisreg   nuisance regressors/confounds for temp. filtering
%        .pbar      1x1 xfigure::ProgressBar or xprogress object
%        .prange    progress bar range (default: [0 .. 1])
%        .qasheet   flag, display quality assessment sheet (default: false)
%        .res       resolution (for motion detection, default: from file)
%        .robfilt   flag, perform filtering robustly (default: false)
%        .robmotcor flag, do motion detection robustly (default: false)
%        .tempffrq  temp filter frequency cut-off (as TRs, default: 80)
%        .tempfset  temp filter set, either of 'DC', {'Fourrier'}
%	 *** Additional options IK 2014 
%	 .n_sd      number of SD for each criterion (default: [6 5 5 5 4])
% see http://neuroelf.net/wiki/doku.php?id=fmriquality
% Outlier detection
% The following criteria are being considered for the detection of outliers:
%     the estimated smoothness in a given volume is further away than 6 standard deviations from the mean
%     the global foreground time course is further away than 5 standard deviations from the mean
%     the absolute of the 1st order derivative of the global foreground time course is further away than 5 standard deviations from the mean (detecting stark signal level shifts)
%     the Mahalanobis Distance over the foreground slices' time courses is further away than 5 standard deviations from the mean (detecting patterns in time courses across slices, e.g. when partial-volume effects of motion make a volume an outlier, particularly in interleaved sequences!), this is also done with the absolute of the 1st order derivatives of the foreground slices' time courses
%     the temporally fitered versions of the global foreground timecourse as well as Mahalanobis Distance over the filtered foreground slices' time courses are further away than 4 standard deviations from their respective mean
% 
%
% Output fields:
%
%       fq          complex struct, containing masks, time courses, etc.
%       fmridata    4-D data slab (motion corrected, if selected)
%
% Note: the data of one run must at least fit into memory (in single
%       precision), plus some temporary arrays and, if motion correction
%       is selected, with further memory allocation required!

% Version:  v0.9c
% Build:    11042920
% Date:     Apr-29 2011, 8:11 PM EST
% Author:   Jochen Weber, SCAN Unit, Columbia University, NYC, NY, USA
% URL/Info: http://neuroelf.net/

% Copyright (c) 2010, 2011, Jochen Weber
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
%     * Redistributions of source code must retain the above copyright
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright
%       notice, this list of conditions and the following disclaimer in the
%       documentation and/or other materials provided with the distribution.
%     * Neither the name of Columbia University nor the
%       names of its contributors may be used to endorse or promote products
%       derived from this software without specific prior written permission.
% 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
% ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
% WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
% DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS BE LIABLE FOR ANY
% DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
% (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
% LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
% ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
% (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
% SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

% argument check
if nargin < 1 || ...
    isempty(images) || ...
   ((numel(images) ~= 1 || ...
    (~isxff(images, 'fmr') && ...
     ~isxff(images, 'vtc'))) && ...
    ~iscell(images) && ...
    (~isnumeric(images) || ...
     ndims(images) ~= 4) && ...
    (~ischar(images) || ...
     numel(images) ~= size(images, 2)))
    error( ...
        'neuroelf:BadArgument', ...
        'Bad or missing argument.' ...
    );
end
if ischar(images)
    images = {images};
end
if nargin < 2 || ...
   ~isstruct(opts) || ...
    numel(opts) ~= 1
    opts = struct;
end
if ~isfield(opts, 'motcor') || ...
   ~islogical(opts.motcor) || ...
    numel(opts.motcor) ~= 1
    opts.motcor = false;
end
if ~isfield(opts, 'nuisreg') || ...
   ~isa(opts.nuisreg, 'double') || ...
    ndims(opts.nuisreg) ~= 2 || ...
    any(isinf(opts.nuisreg(:)) | isnan(opts.nuisreg(:)))
    opts.nuisreg = [];
end
if ~isfield(opts, 'pbar') || ...
    numel(opts.pbar) ~= 1 || ...
   (~isa(opts.pbar, 'xfigure') && ...
    ~isa(opts.pbar, 'xprogress'))
    opts.pbar = [];
end
if ~isfield(opts, 'prange') || ...
   ~isa(opts.prange, 'double') || ...
    numel(opts.prange) ~= 2 || ...
    any(isinf(opts.prange) | isnan(opts.prange) | opts.prange < 0 | opts.prange > 1) || ...
    opts.prange(1) <= opts.prange(2)
    opts.prange = [0, 1];
end
if ~isfield(opts, 'qasheet') || ...
   ~islogical(opts.qasheet) || ...
    numel(opts.qasheet) ~= 1
    opts.qasheet = false;
end
if ~isfield(opts, 'res') || ...
   ~isa(opts.res, 'double') || ...
    numel(opts.res) ~= 3 || ...
    any(isinf(opts.res) | isnan(opts.res) | opts.res <= 0 | opts.res > 16)
    opts.res = [];
else
    opts.res = opts.res(:)';
end
if ~isfield(opts, 'robfilt') || ...
   ~islogical(opts.robfilt) || ...
    numel(opts.robfilt) ~= 1
    opts.robfilt = false;
end
if ~isfield(opts, 'robmotcor') || ...
   ~islogical(opts.robmotcor) || ...
    numel(opts.robmotcor) ~= 1
    opts.robmotcor = false;
end
if ~isfield(opts, 'tempffrq') || ...
   ~isa(opts.tempffrq, 'double') || ...
    numel(opts.tempffrq) ~= 1 || ...
    isnan(opts.tempffrq) || ...
    opts.tempffrq < 8
    opts.tempffrq = 80;
end
if ~isfield(opts, 'tempfset') || ...
   ~ischar(opts.tempfset) || ...
    isempty(opts.tempfset) || ...
   ~any(lower(opts.tempfset(1)) == 'df')
    opts.tempfset = true;
else
    opts.tempfset = (lower(opts.tempfset(1)) == 'd');
end
if ~isfield(opts, 'n_sd') || ...
   ~isa(opts.n_sd, 'double') || ...
    numel(opts.n_sd) ~= 5
    opts.n_sd = [6 5 5 5 4];
end

% prepare output
fq = struct( ...
    'Dims', [], ...
    'Filename', '4D data', ...
    'Masks', struct, ...
    'Raw', struct, ...
    'TempFiltered', struct, ...
    'Quality', struct, ...
    'TC', struct);

% progress
pbar = opts.pbar;
prmin = opts.prange(1);
prmax = opts.prange(2);
prdif = prmax - prmin;
if ~isempty(pbar)
    if isa(pbar, 'xprogress')
        xprogress(pbar, 'settitle', 'fmriquality - progress');
        pname = '';
    else
        pname = 'fmriquality - ';
    end
    pbar.Progress(prmin, [pname 'parsing images...']);
end

% if single cell with xff object, unpack
if numel(images) == 1 && ...
    iscell(images) && ...
    numel(images{1}) == 1 && ...
    isxff(images{1}, {'dmr', 'fmr', 'vtc', 'vdw'})
    images = images{1};
end

% read in data (depending on type)
filename = '';
if numel(images) == 1 && ...
    isxff(images, true)
    filename = images.FilenameOnDisk;
    if isxff(images, 'fmr')
        if images.FileVersion < 5 || ...
            images.DataStorageFormat < 2
            fmridata = images.Slice(1).STCData(:, :, :);
            fmridata(end, end, end, numel(images.Slice)) = 0;
            for sc = 2:size(fmridata, 4)
                fmridata(:, :, :, sc) = images.Slice(sc).STCData(:, :, :);
            end
            fmridata = single(permute(fmridata, [1, 2, 4, 3]));
        else
            fmridata = single(permute(images.Slice.STCData(:, :, :, :), [1, 2, 4, 3]));
        end
        if isempty(opts.res)
            opts.res = [ ...
                images.InplaneResolutionX, ...
                images.InplaneResolutionY, ...
                images.SliceThickness + images.GapThickness];
        end
    elseif isxff(images, 'vtc')
        fmridata = single(permute(images.VTCData(:, :, :, :), [4, 2, 3, 1]));
        if isempty(opts.res)
            opts.res = images.Resolution(1, [1, 1, 1]);
        end
    else
        % no other types yet
        error( ...
            'neuroelf:NotYetSupported', ...
            'Currently only FMR and VTC xff types supported.' ...
        );
    end
elseif iscell(images)
    fmridata = cell(size(images));
    for sc = numel(images):-1:1
        if ischar(images{sc})
            filename = images{sc}(:)';
            try
                if ~isempty(regexpi(filename, '\.(hdr|img|nii)'))
                    if ~isempty(regexpi(filename, '\.img(\,\d+)?\s*$'))
                        images{sc} = deblank(regexprep( ...
                            filename, '\.img', '.hdr', 'preservecase'));
                    end
                    images{sc} = xff(images{sc}(:)');
                    if ~isxff(images{sc}, 'hdr')
                        error('NO_HDR');
                    end
                    if ~isempty(pbar)
                        pbar.Progress(prmin);
                    end
                    ihdr = images{sc};
                    fmridata{sc} = ihdr.VoxelData(:, :, :, :);
                    if isempty(opts.res)
                        opts.res = ihdr.ImgDim.PixSpacing(2:4);
                    end
                    ihdr.ClearObject;
                elseif ~isempty(regexpi(filename, '\.(par|rec)$'))
                    if ~isempty(regexpi(filename, '\.rec$'))
                        images{sc} = ...
                            regexprep(filename, '\.rec', '.par', 'preservecase');
                    end
                    parfile = readpar(images{sc}(:)');
                    if ~strcmpi(parfile.RECDataType, 'dyn.slice')
                        error('WRONG_PAR_FORMAT');
                    end
                    if isempty(opts.res)
                        res1 = find(strcmp(parfile.MatrixHeaders, 'pixel_spacing_1'));
                        res2 = find(strcmp(parfile.MatrixHeaders, 'pixel_spacing_2'));
                        res3 = find(strcmp(parfile.MatrixHeaders, 'slice_thickness'));
                        res3g = find(strcmp(parfile.MatrixHeaders, 'slice_gap'));
                        opts.res = [parfile.MatrixValues(1, [res1, res2]), ...
                            sum(parfile.MatrixValues(1, [res3, res3g]))];
                    end
                    dyn = parfile.RECData.Dyn;
                    if numel(dyn) ~= parfile.Parameters.Max_number_of_dynamics
                        for slc = 1:numel(dyn(1).Slice)
                            if isempty(dyn(end).Slice(slc).IO)
                                dyn(end) = [];
                                break;
                            end
                        end
                    end
                    fmridata{sc} = dyn(1).Slice(1).IO(:, :);
                    fmridata{sc}(end, end, numel(dyn(1).Slice), numel(dyn)) = ...
                        fmridata{sc}(end, end);
                    for dync = 1:numel(dyn)
                        for slc = 1:numel(dyn(1).Slice)
                            fmridata{sc}(:, :, slc, dync) = ...
                                dyn(dync).Slice(slc).IO(:, :);
                        end
                    end
                elseif ~isempty(regexpi(filename, '\.(dmr|fmr|vtc|vdw)$'))
                    [fq, fmridata] = ne_fmriquality(xff(filename), opts);
                    return;
                else
                    error('BAD_FILETYPE');
                end
            catch ne_eo;
                neuroelf_lasterr(ne_eo);
                warning( ...
                    'neuroelf:FileNotReadable', ...
                    'Image file %s not readable. Skipped...', ...
                    filename ...
                );
                images(sc) = [];
            end
        elseif numel(images{sc}) == 1 && ...
            isxff(images{sc}, 'hdr')
            ihdr = images{sc};
            filename = ihdr.FilenameOnDisk;
            fmridata{sc} = ihdr.VoxelData(:, :, :, :);
            if isempty(opts.res)
                opts.res = ihdr.ImgDim.PixSpacing(2:4);
            end
        elseif ~isnumeric(images{sc}) || ...
            isempty(images{sc})
            images(sc) = [];
            fmridata(sc) = [];
        end
    end
    try
        fmridata = single(cat(4, fmridata{:}));
    catch ne_eo;
        error( ...
            'neuroelf:DimsMismatch', ...
            'Error concatenating images in 4th dimension: %s.', ...
            ne_eo.message ...
        );
    end
elseif isnumeric(images)
    if ~isa(images, 'single')
        fmridata = single(images);
    else
        fmridata = images;
    end
end

% get sizes
fmrisize = size(fmridata);
if numel(fmrisize) < 4
    error( ...
        'neuroelf:DataInputError', ...
        'Improper fMRI data supplied.' ...
    );
end
fmrisiz3 = fmrisize(1:3);
nslc = fmrisize(3);
nvol = fmrisize(4);
nvox = prod(fmrisiz3);
if nvol < 20
    error( ...
        'neuroelf:TooFewImages', ...
        'Too few volumes in time series.' ...
    );
end

% compute some things if progress is needed
if opts.robfilt
    pbflt = 2 * nvol;
else
    pbflt = 0.1 * nvol;
end
if ~isempty(pbar)
    if opts.motcor
        prdif = 0.45 * prdif;
        prmax = prmin + prdif;
        if opts.robmotcor
            pbmc = 6 * nvol;
        else
            pbmc = nvol;
        end
    else
        pbmc = 0;
    end
    pbst1 = 0.2 * nvol;
    pbstt = pbst1 + pbflt + pbmc;
    pbst1 = prdif * pbst1 / pbstt;
    pbflt = prdif * pbflt / pbstt;
    pbar.Progress(prmin, [pname 'initializing...']);
end

% re-set nuisreg
if size(opts.nuisreg, 1) ~= nvol
    opts.nuisreg = zeros(nvol, 0);
end

% preset output
fq.Dims = fmrisize;
if ~isempty(filename)
    fq.Filename = filename;
end
fq.Raw.MeanImage = zeros(fmrisiz3);
fq.Raw.StdevImage = zeros(fmrisiz3);
fq.Raw.NullVoxel = zeros(fmrisiz3);
fq.Quality.Outliers.VolumeRatio = 0;
fq.Quality.Outliers.Volumes = zeros(nvol, 1);
fq.TC.Global = zeros(nvol, 1);
fq.TC.Slices = zeros(nvol, nslc);

% compute some basic images
fq.Raw.MeanImage = (1 / nvol) .* sum(fmridata, 4);
fq.Raw.StdevImage = sqrt(varc(fmridata, 4, 1));

% get voxels that are likely to be background
if ~isempty(pbar)
    pbar.Progress(prmin + 0.1 * pbst1, [pname 'detecting foreground...']);
end
mfmrimean = mean(fq.Raw.MeanImage(:));
mdfmrimean = median(fq.Raw.MeanImage( ...
    fq.Raw.MeanImage < 0.9 * mfmrimean & fq.Raw.MeanImage > 0.1 * mfmrimean));
fmribg = (fq.Raw.MeanImage < mdfmrimean);
fmrifg = (fq.Raw.MeanImage > mfmrimean);
fmrifg = fmrifg & dilate3d(erode3d(fmrifg));

% and remove those with more than 5% zero values
fmribg(sum(fmridata == 0, 4) > (0.05 * nvol)) = false;

% find biggest chunk
[cs, fmribg] = clustercoordsc(fmribg);
fmribg = (fmribg == maxpos(cs));
[cs, fmrifg] = clustercoordsc(fmrifg);
fmrifg = (fmrifg == maxpos(cs));
fq.Masks.Background = fmribg;
fq.Masks.Foreground = fmrifg;
nforeg = sum(fmrifg(:));

% create temporary mask to estimate smoothness over time
fmrisest = median(fq.Raw.MeanImage(fmrifg));
fmrisesd = 0.5 * sqrt(varc(fq.Raw.MeanImage(fmrifg)));

% mask being within foreground where values between median +/- 0.5 * std
fmrisest = fmrifg & ...
    (fq.Raw.MeanImage > (fmrisest - fmrisesd)) & ...
    (fq.Raw.MeanImage < (fmrisest + fmrisesd));
fmrisest = (smoothdata3(double(fmrisest), [2, 2, 2]) > 0.75);
[cs, fmrisest] = clustercoordsc(fmrisest);
fmrisest = (fmrisest == maxpos(cs));

% get some time courses
if ~isempty(pbar)
    pbar.Progress(prmin + 0.25 * pbst1, [pname 'raw timecourses...']);
end
fq.TC.Global = lsqueeze(mean(mean(mean(fmridata))));
fq.TC.Slices = squeeze(mean(mean(fmridata)))';
fq.TC.Background = fq.TC.Global;
fq.TC.BackSlices = fq.TC.Slices;
fq.TC.Foreground = fq.TC.Global;
fq.TC.ForeSlices = fq.TC.Slices;
for vc = 1:nvol
    svol = fmridata(:, :, :, vc);
    fq.TC.Background(vc) = mean(svol(fmribg));
    fq.TC.Foreground(vc) = mean(svol(fmrifg));
    for sc = 1:nslc
        sslc = svol(:, :, sc);
        fq.TC.BackSlices(vc, sc) = mean(sslc(fmribg(:, :, sc)));
        fq.TC.ForeSlices(vc, sc) = mean(sslc(fmrifg(:, :, sc)));
    end
end
fq.TC.ForeSlices(isnan(fq.TC.ForeSlices)) = 0;

% estimate smoothness (over time), iterate over vols
if ~isempty(pbar)
    pbar.Progress(prmin + 0.35 * pbst1, [pname 'estimating smoothness...']);
end
fq.TC.SmoothEst = zeros(nvol, 1);
for vc = 1:nvol
    
    % get volume data
    svol = fmridata(:, :, :, vc);
    
    % compute standard deviation within temp mask
    fmrisesd = sqrt(varc(svol(fmrisest)));
    
    % actually smooth data
    svol = smoothdata3(svol, [2, 2, 2]);
    
    % and then recompute std and compare to unsmoothed value
    fq.TC.SmoothEst(vc) = sqrt(varc(svol(fmrisest))) ./ fmrisesd;
end
[trashvar, outlest] = winsorize(fq.TC.SmoothEst, opts.n_sd(1), 3); % IK crit 1
fq.Quality.Outliers.Volumes = fq.Quality.Outliers.Volumes + double(outlest(:));
fq.Quality.Outliers.VolumesSmoothEst = find(outlest);

% weigh slice timecourses by number of voxels
fq.TC.ForeSlicesWeighted = fq.TC.ForeSlices;
for sc = 1:nslc
    fq.TC.ForeSlicesWeighted(:, sc) = mean(fq.TC.ForeSlices(:, sc)) + ...
        min(1.5, nslc * sum(sum(fmrifg(:, :, sc))) / nforeg) .* ...
        (fq.TC.ForeSlices(:, sc) - mean(fq.TC.ForeSlices(:, sc)));
end
fq.TC.ForeSlicesWeighted(isnan(fq.TC.ForeSlicesWeighted)) = 0;

% estimate outliers of foreground (global)
if ~isempty(pbar)
    pbar.Progress(prmin + 0.65 * pbst1, [pname 'preliminary outliers...']);
end
[trashvar, outlest] = winsorize(fq.TC.Foreground, opts.n_sd(2), 5); %  IK crit 2
fq.Quality.Outliers.Volumes = fq.Quality.Outliers.Volumes + double(outlest(:));
fq.Quality.Outliers.VolumesForeTC = find(outlest);
dvarin = abs(diff(fq.TC.Foreground(:)));
dvarin = [dvarin; 0] + [0; dvarin];
[trashvar, outlest] = winsorize(dvarin, opts.n_sd(3), 5); %  IK crit 3
fq.Quality.Outliers.Volumes = fq.Quality.Outliers.Volumes + double(outlest(:));
fq.Quality.Outliers.VolumesForeTCDiff = find(outlest);

% estimate outliers of foreground (slices)
varest = varc(fq.TC.ForeSlicesWeighted, 1, true);
if nvol > (sum(varest > 0) + 3)
    mdistest = madistd(fq.TC.ForeSlicesWeighted(:, varest > 0));
else
    [varest, varesti] = sort(varest);
    mdistest = madistd(fq.TC.ForeSlicesWeighted(:, varesti(end-nvol+4:end)));
end
[trashvar, outlest] = winsorize(mdistest, opts.n_sd(4), 5); % IK crit 4
fq.Quality.Outliers.Volumes = fq.Quality.Outliers.Volumes + double(outlest(:));
fq.Quality.Outliers.VolumesForeSlicesTC = find(outlest);
dvarin = abs(diff(fq.TC.ForeSlicesWeighted));
dvarin = [dvarin; zeros(1, nslc)] + [zeros(1, nslc); dvarin];
varest = varc(dvarin, 1, true);
if nvol > (sum(varest > 0) + 3)
    mdistest = madistd(dvarin(:, varest > 0));
else
    [varest, varesti] = sort(varest);
    mdistest = madistd(dvarin(:, varesti(end-nvol+4:end)));
end
[trashvar, outlest] = winsorize(mdistest, opts.n_sd(4), 5); % IK crit 4
fq.Quality.Outliers.Volumes = fq.Quality.Outliers.Volumes + double(outlest(:));
fq.Quality.Outliers.VolumesForeSlicesWDiff = find(outlest);

% get background noise sample
if ~isempty(pbar)
    pbar.Progress(prmin + 0.9 * pbst1, [pname 'background noise...']);
    prmin = prmin + pbst1;
end
fmrins = sort(fq.Raw.StdevImage(fmribg));

% and compute mean over [0.25 ... 0.75] interval
fmrins = mean(fmrins(ceil(numel(fmrins) / 4):floor(3 * numel(fmrins) / 4)));

% compute signal to noise images
fq.Quality.GlobalSNRImage = (1 / fmrins) .* fq.Raw.MeanImage;
fq.Quality.LocalSNRImage = fq.Raw.MeanImage ./ fq.Raw.StdevImage;

% build temporal filtering argument
if opts.tempfset
    tfdct = opts.tempffrq;
    tfscf = 0;
else
    tfdct = Inf;
    tfscf = floor(nvol / opts.tempffrq);
end
tfstr = struct('nuisreg', opts.nuisreg, 'tdim', 4, 'tempdct', tfdct, ...
    'tempsc', tfscf, 'trobust', opts.robfilt);

% some fields need to be preset now
fgvox = 1 / sum(fmrifg(:));
fq.Quality.Outliers.WeightImage = zeros(fmrisiz3);
fq.Quality.TF_ContrastToNoise = zeros(fmrisiz3);
fq.Quality.TF_NoOutliers_StdevImage = zeros(fmrisiz3);
fq.Quality.TP_SumSquares = zeros(fmrisiz3);
fq.TC.TF_Global = zeros(nvol, 1);
fq.TC.TF_Slices = zeros(nvol, nslc);
fq.TC.TF_Foreground = zeros(nvol, nslc);
fq.TC.TF_ForeSlices = zeros(nvol, nslc);
fq.TC.TF_ForeSlicesWeighted = zeros(nvol, nslc);
fq.TC.TF_zScoreGlobal = zeros(nvol, nslc);
fq.TC.TF_zScoreSlices = zeros(nvol, nslc);
fq.TC.Outliers = zeros(nvol, nslc);
fq.TC.OutlierSlices = zeros(nvol, nslc);
fq.TempFiltered.StdevImage = zeros(fmrisiz3);

% from here on, it's slice-by-slice (too much memory usage otherwise!)
for sc = 1:nslc
    
    % progress
    if ~isempty(pbar)
        pbar.Progress(prmin + (sc - 1) * pbflt / nslc, ...
            sprintf('%sfiltering slice %d...', pname, sc));
    end
    
    % fill null-voxel
    fq.Raw.NullVoxel(:, :, sc) = sum(fmridata(:, :, sc, :) == 0, 4);

    % preliminary filter data
    [fmrifilt, fx, fmrioutl] = tempfilter(fmridata(:, :, sc, :), tfstr);
    fq.TempFiltered.StdevImage(:, :, sc) = sqrt(varc(fmrifilt, 4, 1));

    % get filtered time courses
    fq.TC.TF_Global(:, sc) = squeeze(sum(sum(fmrifilt)))';
    fq.TC.TF_Slices(:, sc) = squeeze(mean(mean(fmrifilt)))';
    slfmrifg = fmrifg(:, :, sc);
    sfmrifg = sum(slfmrifg(:));
    fgsvox = 1 / sfmrifg;
    for vc = 1:nvol
        svol = fmrifilt(:, :, :, vc);
        fq.TC.TF_Foreground(vc, sc) = sum(svol(slfmrifg));
    end
    fq.TC.TF_ForeSlices(:, sc) = fgsvox .* fq.TC.TF_Foreground(:, sc);

    % weigh slice timecourses by number of voxels
    fq.TC.TF_ForeSlicesWeighted(:, sc) = mean(fq.TC.TF_ForeSlices(:, sc)) + ...
        min(1, nslc * sfmrifg / nforeg) .* ...
        (fq.TC.TF_ForeSlices(:, sc) - mean(fq.TC.TF_ForeSlices(:, sc)));

    % get outlier time course
    for vc = 1:nvol
        svol = fmrioutl(:, :, :, vc);
        fq.TC.Outliers(vc, sc) = sum(svol(slfmrifg));
    end
    fq.TC.OutlierSlices(:, sc) = fgsvox .* fq.TC.Outliers(:, sc);

    % compute how much variance was explained by filtering
    [fmrifc, fmrifr] = cov_nd(fmridata(:, :, sc, :), fmrifilt);
    fmrifr(fmrifr < 0) = 0;
    fq.Quality.TF_SumSquares(:, :, sc) = 1 - sqrt(fmrifr);

    % create corrected time series (for further computation)
    fmrinflt = fmrifilt;

    % set values with robust weight < 0.75 to NaN
    fmrinflt(fmrioutl < 0.75) = NaN;

    % and compute mean without NaNs
    [fmrinflm, fmrinfge] = meannoinfnan(fmrinflt, 4);

    % as well as number of "OK" volumes
    fmrinfge = sum(fmrinfge, 4);

    % replace NaNs with mean (without NaNs)
    for vc = 1:nvol
        svol = fmrinflt(:, :, :, vc);
        svol(isnan(svol)) = fmrinflm(isnan(svol));
        fmrinflt(:, :, :, vc) = svol;
    end

    % now re-compute std, max and min of corrected time series
    fmrinfst = sqrt((nvol - 1) .* (varc(fmrinflt, 4, 1) ./ (fmrinfge - 1)));
    fq.Quality.TF_NoOutliers_StdevImage(:, :, sc) = fmrinfst;

    % temporal signal (maximal contrast)
    fmrinfmm = max(fmrinflt, [], 4) - min(fmrinflt, [], 4);

    % give quality measure in numbers of BG noise
    fq.Quality.TF_ContrastToNoise(:, :, sc) = ...
        (1 / fmrins) .* max(fmrinfmm - fmrinfst, 0);

    % compute z-transformed filtered data time courses
    fmrifilt = abs(ztrans(fmrifilt, 4));
    fmrifilt(isnan(fmrifilt)) = 0;
    fq.TC.TF_zScoreGlobal = fq.TC.Global;
    fq.TC.TF_zScoreSlices = fq.TC.Slices;
    for vc = 1:nvol
        svol = fmrifilt(:, :, :, vc);
        fq.TC.TF_zScoreGlobal(vc, sc) = sum(svol(slfmrifg));
    end
    fq.TC.TF_zScoreSlices(:, sc) = fgsvox .* fq.TC.TF_zScoreGlobal(:, sc);

    % compute outlier image
    fmrioutl = (1 / nvol) .* (nvol - sum(fmrioutl .* fmrioutl, 4));
    fq.Quality.Outliers.WeightImage(:, :, sc) = fmrioutl;
end

% replacing bad values
fq.TC.TF_ForeSlices(isnan(fq.TC.TF_ForeSlices)) = 0;
fq.TC.TF_ForeSlicesWeighted(isnan(fq.TC.TF_ForeSlicesWeighted)) = 0;

% and some computations
fq.TC.Outliers = fgvox .* sum(fq.TC.Outliers, 2);
fq.TC.TF_Global = (1 / nvox) .* sum(fq.TC.TF_Global, 2);
fq.TC.TF_Foreground = fgvox .* sum(fq.TC.TF_Foreground, 2);
fq.TC.TF_zScoreGlobal = fgvox .* sum(fq.TC.TF_zScoreGlobal, 2);

% now some more whole-volume computations
fmrifns = sort(fq.TempFiltered.StdevImage(fmribg));
fmrifns = mean(fmrifns(ceil(numel(fmrifns) / 4):floor(3 * numel(fmrifns) / 4)));

% compute filtered signal to noise images
fq.Quality.TF_GlobalSNRImage = (1 / fmrifns) .* fq.Raw.MeanImage;
fq.Quality.TF_LocalSNRImage = fq.Raw.MeanImage ./ fq.TempFiltered.StdevImage;

% estimate more outliers ...
[trashvar, outlest] = winsorize(fq.TC.TF_Foreground, opts.n_sd(5), 10); % IK crit 5
fq.Quality.Outliers.Volumes = fq.Quality.Outliers.Volumes + double(outlest(:));
fq.Quality.Outliers.VolumesTF_ForeTC = find(outlest);
varest = varc(fq.TC.TF_ForeSlicesWeighted, 1, true);
if nvol > (sum(varest > 0) + 3)
    mdistest = madistd(fq.TC.TF_ForeSlicesWeighted(:, varest > 0));
else
    [varest, varesti] = sort(varest);
    mdistest = madistd(fq.TC.TF_ForeSlicesWeighted(:, varesti(end-nvol+4:end)));
end
[trashvar, outlest] = winsorize(mdistest, opts.n_sd(5), 10); % IK crit 5
fq.Quality.Outliers.Volumes = fq.Quality.Outliers.Volumes + double(outlest(:));
fq.Quality.Outliers.VolumesTF_ForeSlicesTC = find(outlest);

% some global quality time courses
fq.TC.Quality = ztrans([ ...
    fq.TC.Global, fq.TC.Foreground, fq.TC.Outliers, fq.TC.TF_zScoreGlobal, ...
    fq.TC.SmoothEst]);

% do not perform extended (moco) analyses?
if ~opts.motcor
    if opts.qasheet
        fmriqasheet(fq);
    end
    return;
end

% perform motion correction
trf = eye(4);
trf([1, 6, 11]) = opts.res;
trf(13:15) = 0.5 * (- (opts.res .* (1 + fmrisize(1:3)))');
[tfm, trp, fmridata] = ...
    rbalign(fmridata(:, :, :, 1), fmridata, struct( ...
    'mask', dilate3d(fmrifg), 'robust', opts.robmotcor, ...
    'trfv1', trf, 'trfv2', trf, ...
    'pbar', pbar, 'prange', [prmin + pbflt, prmax]));

% recover motion parameters from TRFs
mparams = zeros(nvol, 6);
for vc = 1:nvol
 	trpc = spmitrf(trp(:, :, vc));
    mparams(vc, :) = [trpc{1}, (180 / pi) * trpc{2}];
end

% re-set some options
opts.motcor = false;
opts.nuisreg = [opts.nuisreg, ztrans(mparams), ztrans(mparams .* mparams)];
opts.prange(1) = prmax - eps;
opts.qasheet = false;

% re-compute for motion correction data
fq.MotCorr = ne_fmriquality(fmridata, opts);
fq.MotCorr.Params = mparams;

% output sheet ?
if opts.qasheet
    fmriqasheet(fq);
end
