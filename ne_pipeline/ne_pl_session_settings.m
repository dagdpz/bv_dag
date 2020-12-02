% session settings

%% general settings (for all possible datasets)

%% settings for slice timing correction (fmr_SliceTiming.m)
%       opts        optional settings
%        .interp    interpolation method, one of {'cubic'}, 'lanczos3'
%        .order     slice order, either 1xS spatial scanning order or one
%                   of {'asc', 'aint1', 'aint2', 'des', 'dint1', 'dint2'}
%                   *** IK: Determine this setting from BV or DICOM, use '' for no correction ***
%        .refslice  reference slice, default: 1
%        .tshift    if given, either a 1x1 or 1xS double in ms


%% settings for motion correction (fmr_Realign.m)
%       opts        optional settings
%        .interpe   estim interpolation, {'linear'}, 'cubic', 'lanczos3'
%        .interpr   reslice interpolation, 'linear', 'cubic', {'lanczos3'}
%        .mask      1x1 double [0...2], relative masking threshold (0.5)
%        .robust    use robust regression to detect motion (default: false)
%        .rtplot    real-time plot of params (default: true)
%        .savemean  boolean flag, save mean as one-vol FMR (def: false)
%        .savepar   boolean flag, save parameters (default: true)
%        .smooth    smoothing kernel in mm (default: twice the voxelsize)
%        .smpl      sampling width in mm (either 1x1 or 1x3)
%        .tomean    two-pass realignment (if value > 2 perform N passes)
%        .totarget  if given, must be either a volume of data (double) or a
%                   1x2 cell with FMR object (filename) and volume number

%% settings for spatial and temporal filtering (fmr_Filter.m)
%       opts        mandatory struct but with optional fields
%        .spat      enable spatial filtering (default: false)
%        .spkern    smoothing kernel in mm (default: [6, 6, 6])
%        .temp      enable temporal filtering (default: false)
%        .tempdct   DCT-based filtering (min. wavelength, default: Inf)
%        .tempdt    detrend (default: true, is overriden by dct/sc)
%        .templp    temporal lowpass (smoothing) kernel in secs (def: 0)
%        .tempsc    sin/cos set of frequencies (number of pairs, def: 0)

%% settings for converting prt to sdm (prt_CreateSDM.m)
%        params      1x1 struct with optional fields
%         .erlen     duration of event-related (0-length) stimuli (100ms)
%         .hshape    HRF shape to use ({'twogamma'}, 'boynton')
%         .hpttp     HRF time to peak for positive response (5)
%         .hnttp     HRF time to peak for negative response (15)
%         .hpnr      HRF positive/negative ratio (6)
%         .hons      HRF onset (0)
%         .hpdsp     HRF positive response dispersion (1)
%         .hndsp     HRF negative response dispersion (1)
%         .ndcreg    deconvolution number of lags (regressors, 8)
%         .nderiv    add derivatives to HRF (1xN double, [])
%         .nvol      number of volumes (data points, 200)
%         .ortho     if given and true, orthogonalize derivatives
%         .params    1xN struct for parametrical designs (empty)
%           .cond    condition name or number
%           .name    parameter name
%           .opts    optional settings for parameter
%             .comp  compress parameter, 'log', 'sqrt'
%             .norm  z-normalization of parameter (otherwise mean removed)
%             .ortho normalize convolved regressor against design
%           .pval    parameter values (must match number of onsets)
%         .pnorm     normalize parameters from Cond(x).Weights (true)
%         .portho    orthogonalize params from Cond(x).Weights (false)
%         .ppicond   list of condition(s) to interact ppitc with
%         .ppitc     time-course from VOI/phys data (in TR resolution)
%         .ppitf     1x2 cell array with temporal filtering for .ppitc
%         .prtr      TR (in ms, 2000)
%         .rcond     Conditions to remove (rest, 1)
%         .regi      VxR regressors of interest or SDM (not orthogonalized)
%         .regni     VxR regressors of no interest or SDM (orthogonalized)
%         .rnorm     Normalization (default: normalize HRF plateau to 1)
%         .sbins     number of slices (default: 30, only if srbin > 1)
%         .sbinta    acquisition time for all slices (default: prtr)
%         .sbinte    time of echo (duration to acquire one slice, prtr/sbins)
%         .srbin     reference bin (ref slice in slice-time correction: 1)
%         .tshift    Temporally shift convoluted regressor (in ms, 0)
%         .type      HRF or FIR model ({'hrf'}, 'fir')
%
%  Output fields:
%
%        sdm         SDM object (design matrix)
%
%  Note: parametrical weights in Cond(c).Weights will be *ADDED* to the
%        parameters after the evaluation of .param!


%% settings for preprocess fmr (all steps together) !!! NOT IMPLEMENTED YET? !!!
% (see D:\Sources\NeuroElf_v09c\@xff\private\frm_Preprocess.m)

%       opts        optional settings
%        .steps     1xS cell array with letters/words
%                   'i'/'intensity' for global/slicewise intensity
%                   'st'/'slicetiming' for slice-timing correction
%                   'm'/'motion' for motion detection / correction
%                   's'/'smooth' for smoothing
%                   't'/'tempfilter' for temporal filtering
%                   if not given, use default: {'st', 'm'}
%        .icorrect  correct fluctuations, either of {'no'}, 'add', 'mult'
%        .islice    perform intensity fluctuations per slice (def: false)
%        .mdetect   boolean flag, only detect motion (parameters in par)
%        .msavemean boolean flag, save mean as one-vol FMR (def: false)
%        .msavepar  boolean flag, save parameters (default: true)
%        .msmooth   smoothing kernel in mm (default: twice the voxelsize)
%        .msmpl     sampling width in mm (either 1x1 or 1x3)
%        .mtomean   two-pass realignment (if value > 2 perform N passes)
%        .mtotarget target specification, see FMR::Realign method
%        .ssmooth   smoothing kernel in mm (default: [0, 0, 0])
%        .storder   slice order, default: from FMR
%        .tempdct   DCT-based filtering (min. wavelength, default: Inf)
%        .tempdt    detrend (default: true, is overriden by dct/sc)
%        .templp    temporal lowpass (smoothing) kernel in secs (def: 0)
%        .tempsc    sin/cos set of frequencies (number of pairs, def: 0)

%% settings for multi-study GLM computation (mdm_ComputeGLM.m)
%       options     optional 1x1 struct with fields
%        .bbox      bounding box for GLM (default: full MNI)
%        .bcomp     HRF-boost computation type (default: 'none')
%        .bftype    HRF-boost basis-function type, either {'bfs'} or 'sdm'
%        .bwtype    HRF-boost weighting type (default: 'varfract')
%        .discard   Sx1 cell array with volumes to discard (in addition)
%        .globsigd  also add diff of global signals as nuisance regressors
%        .globsigs  add global signals as confound, one of
%                   0 - none
%                   1 - entire dataset (above threshold/within mask)
%                   2 - two (one per hemisphere, split at BV Z=128)
%                   3 or more, perform PCA of time courses and first N
%                   xff object(s), extract average time course from masks
%        .imeth     interpolation method (where necessary, default: cubic)
%        .ithresh   intensity threshold, default: 100
%        .loadglm   boolean flag, load GLM file named in .outfile
%        .mask      optional masking, default: no mask (for now only VTC)
%        .maxiter   maximum number of robust iterations (default: 30)
%        .motpars   motion parameters (Sx1 cell array with sdm/txt files)
%        .motparsd  also add diff of motion parameters (default: false)
%        .motparsq  also add squared motion parameters (default: false)
%        .ndcreg    if set > 0, perform deconvolution (only with PRTs!)
%        .orthconf  orthogonalize confounds (and motion parameters, true)
%        .outfile   output filename of GLM file, default: no saving
%        .ppicond   list of regressors (or differences) to interact
%        .ppirob    perform robust regression on VOI timecourse and remove
%                   outliers from timecourse/model (threshold, default: 0)
%        .ppitfilt  temporally filter PPI VOI timecourse (default: true)
%        .ppivoi    VOI object used to extract time-course from
%        .ppivoiidx intra-VOI-object index (default: 1)
%        .progress  either {false} or a 1x1 xfigure::progress or xprogress
%        .prtpnorm  normalize parameters of PRT.Conds (true)
%        .redo      selected subjects will be overwritten (default: false)
%        .regdiff   flag, regress first discreet derivatives (diff) instead
%        .res       resolution for GLM (default: 3)
%        .restcond  remove rest condition (rest cond. name, default: '')
%        .robust    perform robust instead of OLS regression
%        .savesdms  token, if not empty, save on-the-fly SDMs (e.g. '.sdm')
%        .showsdms  token, passed to SDM::ShowDesign (if valid)
%        .shuflab   PRT labels (conditions names) to shuffle
%        .shuflabm  minimum number of onsets per label (1x1 or 1xL)
%        .sngtpool  pool all but single trial to one (lower model DF, false)
%        .sngtrial  single-trial GLM (only with PRTs, default: false)
%        .sngtskip  condition list to skip during single-trial conversion
%        .subsel    cell array with subject IDs to work on
%        .tfilter   add filter regressors to SDMs (cut-off in secs)
%        .tfilttype temporal filter type (one of {'dct'}, 'fourier', 'poly')
%        .tmaps     store t-maps rather than betas (e.g. for RSA, false)
%        .transio   boolean flag, if true, save GLM and use transio
%        .vweight   combine runs/studies variance-weighted (default: true)
%        .wdvarsfd  weigh volumes by DVARS and FD (if available, false)
%        .writeres  write residual VTCs, default: '' (off, e.g. '%_res.vtc')
%        .xconfound just as motpars, but without restriction on number

switch session_settings_id
    
	case 'Human_reach_decision'
		
		settings.Species = 'human';
		
		% settings for create fmr
		settings.fmr_create.NrOfSkippedVolumes = 0;
		settings.fmr_create.TR			= 900;
		settings.fmr_create.InterSliceTime 	= 20; % TR/n_slices, here 45 slices
		settings.fmr_create.ResolutionX	= 70; % series info Mosaic rows
		settings.fmr_create.ResolutionY	= 70;
		settings.fmr_create.InplaneResolutionX	= 3; % voxel size
		settings.fmr_create.InplaneResolutionY	= 3;
		settings.fmr_create.SliceThickness	= 3;
		settings.fmr_create.SliceGap		= 0.3; % is this a yes (1) or no (0) information?????
		settings.fmr_create.VoxelResolutionVerified = 1;
		settings.fmr_create.GapThickness	= 0.3; % Slicespacing - SliceThickness
		settings.fmr_create.TimeResolutionVerified = 1;
		settings.fmr_create.SliceAcquisitionOrder = 1; % 1 = asc, 5 - aint2 (xff function)
		settings.fmr_create.SliceAcquisitionOrderVerified = 1;
		
		% settings for slice-timing correction of fmr
		settings.fmr_slicetiming.order = 'asc';
		
		% settings for motion correction of fmr
		settings.fmr_realign.totarget = 1; % use the volume number 1 as a reference volume for the alignment
		settings.fmr_realign.rtplot = 1; % plot real time motion correction
		
		% settings for spatial and temporal filtering of fmr
		settings.fmr_filter.spat = false;
		settings.fmr_filter.temp = true;
		settings.fmr_filter.tempsc = 3; % sin/cos motion correction (very low frequencies: lower than 0.005 Hz)
		
		% settings for converting behavioral files to BV *.prt
		settings.prt.beh2prt_function_handle = '';
		settings.model = ''; % 'only_cor_trials_cue_mem_mov';
		
		% settings for converting prt to sdm
		settings.sdm.nvol = 800; % total number of volumes - skiped volumes
		settings.sdm.prtr = settings.fmr_create.TR;
		settings.sdm.hpttp = 5; %default for human
		settings.sdm.hnttp = 15; %default for human
		settings.sdm.rcond = []; % exclude "rest"/"baseline" condition (i.e. initial fixation)
        
        
        % settings for QA
		settings.fmr_quality.outlier_detection_method = 'ne_DVARS';
		% NeuroElf 'ne_fmriquality_method' | 'ne_fmriquality_TC_Quality2_method' | 'ne_framewise_disp' | 'ne_DVARS' | 'ne_fmriquality_TC_custom_method' 
        
		
		% specific settings for 'ne_fmriquality_method'
		settings.fmr_quality.outlier_detection_threshold = 1; % outlier detection threshold (nr of criteria, default: 3)
		settings.fmr_quality.n_sd = [6 5 5 5 4]; % number of SD for each criterion (default: [6 5 5 5 4]), see ne_fmriquality and http://neuroelf.net/wiki/doku.php?id=fmriquality
		
		% specific settings for 'ne_fmriquality_TC_Quality2_method'
		settings.fmr_quality.ne_fmriquality_TC_Quality2_threshold = 1.5;
		settings.fmr_quality.ne_fmriquality_TC_Quality2_n_smooth = 11; % n volumes fr smoothing quality timecourse
		
		% specific settings for 'ne_framewise_disp'
		settings.fmr_quality.fd_cutoff = 0.5;
		settings.fmr_quality.fd_radius = 50; % mm, 50 human, 5 monkeys
		
		% specific settings for 'ne_framewise_disp'
		settings.fmr_quality.fd_cutoff = 0.5;
		settings.fmr_quality.fd_radius = 50; % mm, 50 human, 5 monkeys
        
        % specific settings for 'ne_DVARS'
        settings.fmr_quality.DVARS_psig = 20; % 
		
		% general settings for all methods
		settings.fmr_quality.reject_volumes_before_after_outlier	= [1	1];	% volumes to exclude before and after outlier volumes (for .sdm)
		settings.fmr_quality.avg_exclude_before_after_outlier		= [500 500];	% ms, time to exclude from avg before / after outlier
        settings.fmr_quality.plot_events = 'reach.+mov'; % if '', no events would be plotted, or 'reward', or regular expression such as 'reach.+mov'
        
        
		% settings for creating vtc
		settings.vtc_create.res		= 3;		% resolution 1 / 2 / 3
		settings.vtc_create.meth	= 'linear';	% interpolation: 'cubic', 'lanczos3', {'linear'}, 'nearest'
		settings.vtc_create.space	= 'tal';	% 'native' (monkeys) | 'acpc' | 'tal'
		settings.vtc_create.bbox	= [];		% [xstart ystart zstart; xend yend zend]; % 2x3 bounding box (optional, default: small TAL box)
		settings.vtc_create.dt		= 2;		% datatype override (default: uint16, FV 2)
		
		settings.vtc_filter.spkern	= [6 6 6];	% spatial smoothing kernel in mm
		
		% settings for multi-study GLM computation
		settings.mdm.seppred =2; % predictors of equal name are (0) concatenated across all runs, (1) fully separated across runs and subjects, or (2) concatenated only across runs of the same subject, but separate across subjects
		settings.mdm.zTransformation = 0; % apply z-transformation to volume time courses
		settings.mdm.PSCTransformation = 1; % apply percent-signal-change transformation to volume time courses, NOTE: you can only choose ONE type of transformation (z or PSC)!
		settings.mdm.RFX_GLM = 0; % 0 = fixed-effects model (FFX), 1 = random-effects model (RFX)
		settings.mdm.mask = 'Y:\MRI\Human\mni_icbm152_t1_tal_nlin_sym_09a_mask.msk'; %Y:\Sources\NeuroElf_v11_7521\_files\masks\colin_brain_ICBMnorm_brain3mm.msk'; %'Y:\MRI\Human\colin_brain_ICBMnorm_TAL.msk'; 
		settings.mdm.robust = false; % don't run robust with FFX	
	
	case 'Human_reach_decision_pilot'
		
		settings.Species = 'human';
        settings.model = '';
		
		% settings for create fmr
		settings.fmr_create.NrOfSkippedVolumes = 0;
		settings.fmr_create.TR			= 900;
		settings.fmr_create.InterSliceTime 	= 20; % TR/n_slices, here 45 slices
		settings.fmr_create.ResolutionX	= 70; % series info Mosaic rows
		settings.fmr_create.ResolutionY	= 70;
		settings.fmr_create.InplaneResolutionX	= 3; % voxel size
		settings.fmr_create.InplaneResolutionY	= 3;
		settings.fmr_create.SliceThickness	= 3;
		settings.fmr_create.SliceGap		= 0.3; % is this a yes (1) or no (0) information?????
		settings.fmr_create.VoxelResolutionVerified = 1;
		settings.fmr_create.GapThickness	= 0.3; % Slicespacing - SliceThickness
		settings.fmr_create.TimeResolutionVerified = 1;
		settings.fmr_create.SliceAcquisitionOrder = 1; % 1 = asc, 5 - aint2 (xff function)
		settings.fmr_create.SliceAcquisitionOrderVerified = 1;
		
		% settings for slice-timing correction of fmr
		settings.fmr_slicetiming.order = 'asc';
		
		% settings for motion correction of fmr
		settings.fmr_realign.totarget = 1; % use the volume number 1 as a reference volume for the alignment
		settings.fmr_realign.rtplot = 1; % plot real time motion correction
		
		% settings for spatial and temporal filtering of fmr
		settings.fmr_filter.spat = false;
		settings.fmr_filter.temp = true;
		settings.fmr_filter.tempsc = 3; % sin/cos motion correction (very low frequencies: lower than 0.005 Hz)
		
		% settings for converting behavioral files to BV *.prt
		settings.prt.beh2prt_function_handle = @mat2prt_reach_decision_pilot_v2;
		settings.model = ''; % 'only_cor_trials_cue_mem_mov';
		
		% settings for converting prt to sdm
		settings.sdm.nvol = 800; % total number of volumes - skiped volumes
		settings.sdm.prtr = settings.fmr_create.TR;
		settings.sdm.hpttp = 5; %default for human
		settings.sdm.hnttp = 15; %default for human
		settings.sdm.rcond = []; % exclude "rest"/"baseline" condition (i.e. initial fixation)
        
        
        % settings for QA
		settings.fmr_quality.outlier_detection_method = 'ne_framewise_disp';
		% NeuroElf 'ne_fmriquality_method' | 'ne_fmriquality_TC_Quality2_method' | 'ne_framewise_disp' | 'ne_fmriquality_TC_custom_method'
		
		% specific settings for 'ne_fmriquality_method'
		settings.fmr_quality.outlier_detection_threshold = 1; % outlier detection threshold (nr of criteria, default: 3)
		settings.fmr_quality.n_sd = [6 5 5 5 4]; % number of SD for each criterion (default: [6 5 5 5 4]), see ne_fmriquality and http://neuroelf.net/wiki/doku.php?id=fmriquality
		
		% specific settings for 'ne_fmriquality_TC_Quality2_method'
		settings.fmr_quality.ne_fmriquality_TC_Quality2_threshold = 1.5;
		settings.fmr_quality.ne_fmriquality_TC_Quality2_n_smooth = 11; % n volumes fr smoothing quality timecourse
		
		% specific settings for 'ne_framewise_disp'
		settings.fmr_quality.fd_cutoff = 0.5;
		settings.fmr_quality.fd_radius = 50; % mm, 50 human, 5 monkeys
		
		% general settings for all methods
		settings.fmr_quality.reject_volumes_before_after_outlier	= [1	1];	% volumes to exclude before and after outlier volumes (for .sdm)
		settings.fmr_quality.avg_exclude_before_after_outlier		= [500 500];	% ms, time to exclude from avg before / after outlier
        settings.fmr_quality.plot_events = 'reach.+mov'; % if '', no events would be plotted, or 'reward', or regular expression such as 'reach.+mov'
        
        
		% settings for creating vtc
		settings.vtc_create.res		= 3;		% resolution 1 / 2 / 3
		settings.vtc_create.meth	= 'linear';	% interpolation: 'cubic', 'lanczos3', {'linear'}, 'nearest'
		settings.vtc_create.space	= 'tal';	% 'native' (monkeys) | 'acpc' | 'tal'
		settings.vtc_create.bbox	= [];		% [xstart ystart zstart; xend yend zend]; % 2x3 bounding box (optional, default: small TAL box)
		settings.vtc_create.dt		= 2;		% datatype override (default: uint16, FV 2)
		
		settings.vtc_filter.spkern	= [6 6 6];	% spatial smoothing kernel in mm
		
		% settings for multi-study GLM computation
		settings.mdm.seppred =2; % predictors of equal name are (0) concatenated across all runs, (1) fully separated across runs and subjects, or (2) concatenated only across runs of the same subject, but separate across subjects
		settings.mdm.zTransformation = 0; % apply z-transformation to volume time courses
		settings.mdm.PSCTransformation = 1; % apply percent-signal-change transformation to volume time courses, NOTE: you can only choose ONE type of transformation (z or PSC)!
		settings.mdm.RFX_GLM = 0; % 0 = fixed-effects model (FFX), 1 = random-effects model (RFX)
		settings.mdm.mask = 'Y:\MRI\Human\colin_brain_ICBMnorm_TAL.msk'; 
		settings.mdm.robust = false; % don't run robust with FFX
		
		
	case 'Curius_microstim_20130814-20131009'
		
		settings.Species = 'monkey'; % either 'human' or 'monkey'
		
		% settings for create fmr
		settings.fmr_create.NrOfSkippedVolumes = 4;
		settings.fmr_create.TR			= 2000;
		settings.fmr_create.InterSliceTime 	= 62; % TR/n_slices, here 32 slices
		settings.fmr_create.ResolutionX	= 80;
		settings.fmr_create.ResolutionY	= 80;
		settings.fmr_create.InplaneResolutionX	= 1.2;
		settings.fmr_create.InplaneResolutionY	= 1.2;
		settings.fmr_create.SliceThickness	= 1.2;
		settings.fmr_create.SliceGap		= 0;
		settings.fmr_create.VoxelResolutionVerified = 1;
		settings.fmr_create.GapThickness	= 0;
		settings.fmr_create.TimeResolutionVerified = 1;
		settings.fmr_create.SliceAcquisitionOrder = 5;
		settings.fmr_create.SliceAcquisitionOrderVerified = 1;
		
		% settings for slice-timing correction of fmr
		settings.fmr_slicetiming.order = 'aint2';
		
		% settings for motion correction of fmr
		settings.fmr_realign.totarget = 1;
		settings.fmr_realign.rtplot = 1;
		
		% settings for spatial and temporal filtering of fmr
		settings.fmr_filter.spat = false;
		settings.fmr_filter.temp = true;
		settings.fmr_filter.tempsc = 3;
		
		% settings for converting behavioral files to BV *.prt
		% settings.prt.beh2prt_function_handle = ;
		
		% settings for converting prt to sdm
		settings.sdm.nvol = 300;
		settings.sdm.prtr = settings.fmr_create.TR;
		settings.sdm.hpttp = 3;
		settings.sdm.hnttp = 10;
		settings.sdm.rcond = []; % exclude "rest"/"baseline" condition (i.e. initial fixation)
		
		% settings for multi-study GLM computation
		settings.mdm.seppred = 0; % predictors of equal name are (0) concatenated across all runs, (1) fully separated across runs and subjects, or (2) concatenated only across runs of the same subject, but separate across subjects
		settings.mdm.zTransformation = 1; % apply z-transformation to volume time courses
		settings.mdm.PSCTransformation = 0; % apply percent-signal-change transformation to volume time courses, NOTE: you can only choose ONE type of transformation (z or PSC)!
		settings.mdm.RFX_GLM = 0; % 0 = fixed-effects model (FFX), 1 = random-effects model (RFX)
		settings.mdm.mask = 'D:\MRI\Curius\mask.msk';
		
	case 'Curius_microstim_20131129-now'
		
		settings.Species = 'monkey'; % either 'human' or 'monkey'
		
		% settings for create fmr
		settings.fmr_create.NrOfSkippedVolumes = 4;
		settings.fmr_create.TR			= 2000;
		settings.fmr_create.InterSliceTime 	= 66.7; % TR/n_slices, here 30 slices
		settings.fmr_create.ResolutionX	= 80;  % series info Mosaic rows
		settings.fmr_create.ResolutionY	= 80;
		settings.fmr_create.InplaneResolutionX	= 1.2;
		settings.fmr_create.InplaneResolutionY	= 1.2;
		settings.fmr_create.SliceThickness	= 1.2;
		settings.fmr_create.SliceGap		= 0;
		settings.fmr_create.VoxelResolutionVerified = 1;
		settings.fmr_create.GapThickness	= 0;
		settings.fmr_create.TimeResolutionVerified = 1;
		settings.fmr_create.SliceAcquisitionOrder = 5;
		settings.fmr_create.SliceAcquisitionOrderVerified = 1;
		
		% settings for slice-timing correction of fmr
		settings.fmr_slicetiming.order = 'aint2';
		
		% settings for motion correction of fmr
		settings.fmr_realign.totarget = 1;
		settings.fmr_realign.rtplot = 1;
		
		% settings for spatial and temporal filtering of fmr
		settings.fmr_filter.spat = false;
		settings.fmr_filter.temp = true;
		settings.fmr_filter.tempsc = 3;
		
		% settings for QA
		settings.fmr_quality.outlier_detection_method = 'ne_fmriquality_TC_Quality2_method'; % NeuroElf 'ne_fmriquality_method' | 'ne_fmriquality_TC_Quality2_method' | 'ne_framewise_disp' | 'ne_fmriquality_TC_custom_method'
		% settings for method 'ne_fmriquality_TC_Quality2_method'
		settings.fmr_quality.ne_fmriquality_TC_Quality2_threshold = []; % absolute outlier detection threshold for ne_fmriquality_TC_Quality2_method
		settings.fmr_quality.ne_fmriquality_TC_Quality2_threshold_nsd = []; % number of standard deviations of target signal as outlier detection threshold for ne_fmriquality_TC_Quality2_method
		settings.fmr_quality.ne_fmriquality_TC_Quality2_threshold_nMAD = [];%2.5; % number of median absolute deviations of target signal as outlier detection threshold for ne_fmriquality_TC_Quality2_method
		% see Leys et al. (2013). Detecting outliers: Do not use standard deviation around the mean, use absolute deviation around the median. Journal of Experimental Social Psychology, 49(4), 764�766.
		settings.fmr_quality.ne_fmriquality_TC_Quality2_threshold_prct = 1.5; % number of interquartile ranges added/subtracted to/from 75%/25% percentile of target signal to define upper and lower threshold
		% see http://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FSLMotionOutliers
		settings.fmr_quality.ne_fmriquality_TC_Quality2_n_smooth = 5; % n volumes for smoothing quality timecourse
		settings.fmr_quality.reject_volumes_before_after_outlier = [0 0]; % volumes to exclude before and after outlier volumes
		% settings for NeuroElf method 'ne_fmriquality_method'
		%settings.fmr_quality.outlier_detection_threshold = 1; % outlier detection threshold for ne_method (nr of criteria, default: 3)
		%settings.fmr_quality.n_sd = [6 5 5 5 4]; % number of SD for each criterion (default: [6 5 5 5 4]), see ne_fmriquality and http://neuroelf.net/wiki/doku.php?id=fmriquality
		% settings for method 'ne_framewise_disp'
		%settings.fmr_quality.reject_volumes_before_after_outlier = [1 1];
		%settings.fmr_quality.fd_cutoff;
		%settings.fmr_quality.fd_radius;
		% settings for custom QA method
		%settings.fmr_quality.ne_fmriquality_TC_custom_method_function_handle = @lll;
		settings.fmr_quality.avg_exclude_before_after_outlier = [100 100]; % ms, time to exclude from avg before / after outlier
		
		% settings for converting behavioral files to BV *.prt
		settings.prt.beh2prt_function_handle = @mat2prt_fixmemstim;%@mat2prt_fixmemstim; %mat2prt_ind; % @mat2prt_es_analysis
		settings.model = ''; % name of the model; if left empty (''), name of settings.prt.beh2prt_function_handle will be used
		
		% settings for converting prt to sdm
		settings.sdm.nvol = 450;
		settings.sdm.prtr = settings.fmr_create.TR;
		settings.sdm.hpttp = 3;
		settings.sdm.hnttp = 10;
		settings.sdm.rcond = []; % exclude "rest"/"baseline" condition (i.e. initial fixation)
		
		% PPI settings
		%         settings.sdm.ppicond = [];
		%         % settings.sdm.ppicond = {'fixation','fixation microstim', 'memory right','memory right microstim', 'memory left', 'memory left microstim'};
		%         settings.sdm.ppivoi = 'D:\MRI\Curius\combined\microstim_20140409-20140528_5_3_100uA\microstim_20140122-20140226_5_3_250uA_nobaseline_TAL_SfN2014.voi';
		%         settings.sdm.ppivoiidx = 1;
		
		% VTC settings, VTC creation does not work for monkey data
		% settings.vtc_create.res		= 2;		% resolution 1 / 2 / 3
		% settings.vtc_create.meth	= 'linear';	% interpolation: 'cubic', 'lanczos3', {'linear'}, 'nearest'
		% settings.vtc_create.space	= 'acpc';	% 'native' (monkeys) | 'acpc' | 'tal'
		% settings.vtc_create.bbox	= [70 55 70; 190 225 166];		% [xstart ystart zstart; xend yend zend]; % 2x3 bounding box (optional, default: small TAL box)
		% settings.vtc_create.dt		= 2;		% datatype override (default: uint16, FV 2)
		settings.vtc_filter.spkern	= [3 3 3];
		
		% settings for multi-study GLM computation
		settings.mdm.seppred = 0; % predictors of equal name are (0) concatenated across all runs, (1) fully separated across runs and subjects, or (2) concatenated only across runs of the same subject, but separate across subjects
		settings.mdm.zTransformation = 0; % apply z-transformation to volume time courses
		settings.mdm.PSCTransformation = 1; % apply percent-signal-change transformation to volume time courses, NOTE: you can only choose ONE type of transformation (z or PSC)!
		settings.mdm.RFX_GLM = 0; % 0 = fixed-effects model (FFX), 1 = random-effects model (RFX)
		settings.mdm.mask = 'D:\MRI\Curius\mask.msk';
		
	case 'Curius_microstim_restingstate_20140304-now'
		
		settings.Species = 'monkey'; % either 'human' or 'monkey'
		
		% settings for create fmr
		settings.fmr_create.NrOfSkippedVolumes = 4;
		settings.fmr_create.TR			= 2000;
		settings.fmr_create.InterSliceTime 	= 66.7; % TR/n_slices, here 30 slices
		settings.fmr_create.ResolutionX	= 80;  % series info Mosaic rows
		settings.fmr_create.ResolutionY	= 80;
		settings.fmr_create.InplaneResolutionX	= 1.2;
		settings.fmr_create.InplaneResolutionY	= 1.2;
		settings.fmr_create.SliceThickness	= 1.2;
		settings.fmr_create.SliceGap		= 0;
		settings.fmr_create.VoxelResolutionVerified = 1;
		settings.fmr_create.GapThickness	= 0;
		settings.fmr_create.TimeResolutionVerified = 1;
		settings.fmr_create.SliceAcquisitionOrder = 5;
		settings.fmr_create.SliceAcquisitionOrderVerified = 1;
		
		% settings for slice-timing correction of fmr
		settings.fmr_slicetiming.order = 'aint2';
		
		% settings for motion correction of fmr
		settings.fmr_realign.totarget = 1;
		settings.fmr_realign.rtplot = 1;
		
		% settings for spatial and temporal filtering of fmr
		settings.fmr_filter.spat = false;
		settings.fmr_filter.temp = true;
		settings.fmr_filter.tempsc = 3;
		
		% settings for converting behavioral files to BV *.prt
		settings.prt.beh2prt_function_handle = @mat2prt_fixstim_rest; %@mat2prt_fixstim_rest; %@mat2prt_fixstim_noabort_rest; % old_prt: @mat2prt_fix_stim;
		settings.model = '';
		
		% settings for converting prt to sdm
		settings.sdm.nvol = 450;
		settings.sdm.prtr = settings.fmr_create.TR;
		settings.sdm.hpttp = 3;
		settings.sdm.hnttp = 10;
		settings.sdm.rcond = []; % exclude "rest"/"baseline" condition (i.e. initial fixation)
		
		% VTC settings, VTC creation does not work for monkey data
		settings.vtc_filter.spkern	= [3 3 3];
		
		% settings for multi-study GLM computation
		settings.mdm.seppred = 0; % predictors of equal name are (0) concatenated across all runs, (1) fully separated across runs and subjects, or (2) concatenated only across runs of the same subject, but separate across subjects
		settings.mdm.zTransformation = 1; % apply z-transformation to volume time courses
		settings.mdm.PSCTransformation = 0; % apply percent-signal-change transformation to volume time courses, NOTE: you can only choose ONE type of transformation (z or PSC)!
		settings.mdm.RFX_GLM = 0; % 0 = fixed-effects model (FFX), 1 = random-effects model (RFX)
		settings.mdm.mask = 'D:\MRI\Curius\mask.msk';
		
	case 'Curius_fixmemory_baseline_20131129-now'
		
		settings.Species = 'monkey'; % either 'human' or 'monkey'
		
		% settings for create fmr
		settings.fmr_create.NrOfSkippedVolumes = 4;
		settings.fmr_create.TR			= 2000;
		settings.fmr_create.InterSliceTime 	= 66.7; % TR/n_slices, here 30 slices
		settings.fmr_create.ResolutionX	= 80;  % series info Mosaic rows
		settings.fmr_create.ResolutionY	= 80;
		settings.fmr_create.InplaneResolutionX	= 1.2;
		settings.fmr_create.InplaneResolutionY	= 1.2;
		settings.fmr_create.SliceThickness	= 1.2;
		settings.fmr_create.SliceGap		= 0;
		settings.fmr_create.VoxelResolutionVerified = 1;
		settings.fmr_create.GapThickness	= 0;
		settings.fmr_create.TimeResolutionVerified = 1;
		settings.fmr_create.SliceAcquisitionOrder = 5;
		settings.fmr_create.SliceAcquisitionOrderVerified = 1;
		
		% settings for slice-timing correction of fmr
		settings.fmr_slicetiming.order = 'aint2';
		
		% settings for motion correction of fmr
		settings.fmr_realign.totarget = 1;
		settings.fmr_realign.rtplot = 1;
		
		% settings for spatial and temporal filtering of fmr
		settings.fmr_filter.spat = false;
		settings.fmr_filter.temp = true;
		settings.fmr_filter.tempsc = 3; % cycles; "a cycle means that one sine wave (from 0 to 360 degrees or 0 to 2PI) is spread across the number of time points of the fMRI data,
		% a cycle of 2 means that two sine waves fall within the extent of the data" (http://www.brainvoyager.com/bvqx/doc/UsersGuide/Preprocessing/TemporalHighPassFiltering.html)
		
		% settings for converting behavioral files to BV *.prt
		settings.prt.beh2prt_function_handle = @mat2prt_fixmem;
		
		% settings for converting prt to sdm
		settings.sdm.nvol = 450;
		settings.sdm.prtr = settings.fmr_create.TR;
		settings.sdm.hpttp = 3;
		settings.sdm.hnttp = 10;
		settings.sdm.rcond = []; % exclude "rest"/"baseline" condition (i.e. initial fixation)
		
		% settings for multi-study GLM computation
		settings.mdm.seppred = 0; % predictors of equal name are (0) concatenated across all runs, (1) fully separated across runs and subjects, or (2) concatenated only across runs of the same subject, but separate across subjects
		settings.mdm.zTransformation = 1; % apply z-transformation to volume time courses
		settings.mdm.PSCTransformation = 0; % apply percent-signal-change transformation to volume time courses, NOTE: you can only choose ONE type of transformation (z or PSC)!
		settings.mdm.RFX_GLM = 0; % 0 = fixed-effects model (FFX), 1 = random-effects model (RFX)
		settings.mdm.mask = 'D:\MRI\Curius\mask.msk';
		
		%% Bacchus
	case 'Bacchus_fixmemory_baseline_20161111-now'
		
		settings.Species = 'monkey'; % either 'human' or 'monkey'
		
		% settings for create fmr
		settings.fmr_create.NrOfSkippedVolumes = 4;
		settings.fmr_create.TR			= 2000;
		settings.fmr_create.InterSliceTime 	= 61.8; % TR/n_slices, here 32 slices, here taken from SeriesInfo Slice duration
		settings.fmr_create.ResolutionX	= 80;  % series info Mosaic rows
		settings.fmr_create.ResolutionY	= 80;
		settings.fmr_create.InplaneResolutionX	= 1.2;
		settings.fmr_create.InplaneResolutionY	= 1.2;
		settings.fmr_create.SliceThickness	= 1.2;
		settings.fmr_create.SliceGap		= 0;
		settings.fmr_create.VoxelResolutionVerified = 1;
		settings.fmr_create.GapThickness	= 0;
		settings.fmr_create.TimeResolutionVerified = 1;
		settings.fmr_create.SliceAcquisitionOrder = 5;
		settings.fmr_create.SliceAcquisitionOrderVerified = 1;
		
		% settings for slice-timing correction of fmr
		settings.fmr_slicetiming.order = 'aint2';
		
		% settings for motion correction of fmr
		settings.fmr_realign.totarget = 1;
		settings.fmr_realign.rtplot = 1;
		
		% settings for spatial and temporal filtering of fmr
		settings.fmr_filter.spat = false;
		settings.fmr_filter.temp = true;
		settings.fmr_filter.tempsc = 3; % cycles; "a cycle means that one sine wave (from 0 to 360 degrees or 0 to 2PI) is spread across the number of time points of the fMRI data,
		% a cycle of 2 means that two sine waves fall within the extent of the data" (http://www.brainvoyager.com/bvqx/doc/UsersGuide/Preprocessing/TemporalHighPassFiltering.html)
        
        % settings for QA
 		settings.fmr_quality.outlier_detection_method = 'ne_framewise_disp'; % NeuroElf 'ne_fmriquality_method' | 'ne_fmriquality_TC_Quality2_method' | 'ne_framewise_disp' | 'ne_fmriquality_TC_custom_method'

 		% specific settings for method 'ne_framewise_disp'
		settings.fmr_quality.fd_cutoff = 1;
		settings.fmr_quality.fd_radius = 5;

        % general settings for all methods
		settings.fmr_quality.reject_volumes_before_after_outlier	= [1	1];	% volumes to exclude before and after outlier volumes (for .sdm)
		settings.fmr_quality.avg_exclude_before_after_outlier		= [100 100];	% ms, time to exclude from avg before / after outlier
        settings.fmr_quality.plot_events = 'reward'; % if '', no events would be plotted, or 'reward', or regular expression such as 'reach.+mov'
        
		
		% settings for converting behavioral files to BV *.prt
		settings.prt.beh2prt_function_handle = @BA_mat2prt_fixmem;
		settings.model = '';
		
		% settings for converting prt to sdm
		settings.sdm.nvol = 450;
		settings.sdm.prtr = settings.fmr_create.TR;
		settings.sdm.hpttp = 3;
		settings.sdm.hnttp = 10;
		settings.sdm.rcond = []; % exclude "rest"/"baseline" condition (i.e. initial fixation)
		
		% VTC settings, VTC creation does not work for monkey data
		settings.vtc_filter.spkern	= [3 3 3];
		
		% settings for multi-study GLM computation
		settings.mdm.seppred = 0; % predictors of equal name are (0) concatenated across all runs, (1) fully separated across runs and subjects, or (2) concatenated only across runs of the same subject, but separate across subjects
		settings.mdm.zTransformation = 1; % apply z-transformation to volume time courses
		settings.mdm.PSCTransformation = 0; % apply percent-signal-change transformation to volume time courses, NOTE: you can only choose ONE type of transformation (z or PSC)!
		settings.mdm.RFX_GLM = 0; % 0 = fixed-effects model (FFX), 1 = random-effects model (RFX)
        if isunix
            settings.mdm.mask = '/mnt/KognitiveNeurowissenschaften/DAG/MRI/Bacchus/BA_20140711_ACPC_BRAIN_BrainMask.msk';
        elseif ispc
            settings.mdm.mask = 'D:\MRI\Bacchus\BA_20140711_ACPC_BRAIN_BrainMask.msk'; %'D:\MRI\Bacchus\BA_brain_mask.msk'; % D:\MRI\Bacchus\BA_20140711_ACPC_BRAIN_BrainMask.msk';	
        end		
        
    case 'Bacchus_fixmemory_baseline_BASCO_20161111-now'
		
		settings.Species = 'monkey'; % either 'human' or 'monkey'
		
		% settings for create fmr
		settings.fmr_create.NrOfSkippedVolumes = 4;
		settings.fmr_create.TR			= 2000;
		settings.fmr_create.InterSliceTime 	= 61.8; % TR/n_slices, here 32 slices, here taken from SeriesInfo Slice duration
		settings.fmr_create.ResolutionX	= 80;  % series info Mosaic rows
		settings.fmr_create.ResolutionY	= 80;
		settings.fmr_create.InplaneResolutionX	= 1.2;
		settings.fmr_create.InplaneResolutionY	= 1.2;
		settings.fmr_create.SliceThickness	= 1.2;
		settings.fmr_create.SliceGap		= 0;
		settings.fmr_create.VoxelResolutionVerified = 1;
		settings.fmr_create.GapThickness	= 0;
		settings.fmr_create.TimeResolutionVerified = 1;
		settings.fmr_create.SliceAcquisitionOrder = 5;
		settings.fmr_create.SliceAcquisitionOrderVerified = 1;
		
		% settings for slice-timing correction of fmr
		settings.fmr_slicetiming.order = 'aint2';
		
		% settings for motion correction of fmr
		settings.fmr_realign.totarget = 1;
		settings.fmr_realign.rtplot = 1;
		
		% settings for spatial and temporal filtering of fmr
		settings.fmr_filter.spat = false;
		settings.fmr_filter.temp = true;
		settings.fmr_filter.tempsc = 3; % cycles; "a cycle means that one sine wave (from 0 to 360 degrees or 0 to 2PI) is spread across the number of time points of the fMRI data,
		% a cycle of 2 means that two sine waves fall within the extent of the data" (http://www.brainvoyager.com/bvqx/doc/UsersGuide/Preprocessing/TemporalHighPassFiltering.html)
        
        % settings for QA
 		settings.fmr_quality.outlier_detection_method = 'ne_framewise_disp'; % NeuroElf 'ne_fmriquality_method' | 'ne_fmriquality_TC_Quality2_method' | 'ne_framewise_disp' | 'ne_fmriquality_TC_custom_method'

 		% specific settings for method 'ne_framewise_disp'
		settings.fmr_quality.fd_cutoff = 1;
		settings.fmr_quality.fd_radius = 5;

        % general settings for all methods
		settings.fmr_quality.reject_volumes_before_after_outlier	= [1	1];	% volumes to exclude before and after outlier volumes (for .sdm)
		settings.fmr_quality.avg_exclude_before_after_outlier		= [100 100];	% ms, time to exclude from avg before / after outlier
        settings.fmr_quality.plot_events = 'reward'; % if '', no events would be plotted, or 'reward', or regular expression such as 'reach.+mov'
        
		
		% settings for converting behavioral files to BV *.prt
		settings.prt.beh2prt_function_handle = @BA_mat2prt_fixmem_BASCO;
		settings.model = '';
		
		% settings for converting prt to sdm
		settings.sdm.nvol = 450;
		settings.sdm.prtr = settings.fmr_create.TR;
		settings.sdm.hpttp = 3;
		settings.sdm.hnttp = 10;
		settings.sdm.rcond = []; % exclude "rest"/"baseline" condition (i.e. initial fixation)
		
		% VTC settings, VTC creation does not work for monkey data
		settings.vtc_filter.spkern	= [3 3 3];
		
		% settings for multi-study GLM computation
		settings.mdm.seppred = 0; % predictors of equal name are (0) concatenated across all runs, (1) fully separated across runs and subjects, or (2) concatenated only across runs of the same subject, but separate across subjects
		settings.mdm.zTransformation = 1; % apply z-transformation to volume time courses
		settings.mdm.PSCTransformation = 0; % apply percent-signal-change transformation to volume time courses, NOTE: you can only choose ONE type of transformation (z or PSC)!
		settings.mdm.RFX_GLM = 0; % 0 = fixed-effects model (FFX), 1 = random-effects model (RFX)
		if isunix
            settings.mdm.mask = '/mnt/KognitiveNeurowissenschaften/DAG/MRI/Bacchus/BA_20140711_ACPC_BRAIN_BrainMask.msk';
        elseif ispc
            settings.mdm.mask = 'D:\MRI\Bacchus\BA_20140711_ACPC_BRAIN_BrainMask.msk'; %'D:\MRI\Bacchus\BA_brain_mask.msk'; % D:\MRI\Bacchus\BA_20140711_ACPC_BRAIN_BrainMask.msk';	
        end
        
    case 'Bacchus_microstim_20170201-now'
		
		settings.Species = 'monkey'; % either 'human' or 'monkey'
		
		% settings for create fmr
		settings.fmr_create.NrOfSkippedVolumes = 4;
		settings.fmr_create.TR			= 2000;
		settings.fmr_create.InterSliceTime 	= 61.8; % TR/n_slices, here 32 slices
		settings.fmr_create.ResolutionX	= 80;  % series info Mosaic rows
		settings.fmr_create.ResolutionY	= 80;
		settings.fmr_create.InplaneResolutionX	= 1.2;
		settings.fmr_create.InplaneResolutionY	= 1.2;
		settings.fmr_create.SliceThickness	= 1.2;
		settings.fmr_create.SliceGap		= 0;
		settings.fmr_create.VoxelResolutionVerified = 1;
		settings.fmr_create.GapThickness	= 0;
		settings.fmr_create.TimeResolutionVerified = 1;
		settings.fmr_create.SliceAcquisitionOrder = 5;
		settings.fmr_create.SliceAcquisitionOrderVerified = 1;
		
		% settings for slice-timing correction of fmr
		settings.fmr_slicetiming.order = 'aint2';
		
		% settings for motion correction of fmr
		settings.fmr_realign.totarget = 1;
		settings.fmr_realign.rtplot = 1;
		
		% settings for spatial and temporal filtering of fmr
		settings.fmr_filter.spat = false;
		settings.fmr_filter.temp = true;
		settings.fmr_filter.tempsc = 3; % cycles; "a cycle means that one sine wave (from 0 to 360 degrees or 0 to 2PI) is spread across the number of time points of the fMRI data,
		% a cycle of 2 means that two sine waves fall within the extent of the data" (http://www.brainvoyager.com/bvqx/doc/UsersGuide/Preprocessing/TemporalHighPassFiltering.html)
   
 		% settings for QA
 		settings.fmr_quality.outlier_detection_method = 'ne_framewise_disp'; % NeuroElf 'ne_fmriquality_method' | 'ne_fmriquality_TC_Quality2_method' | 'ne_framewise_disp' | 'ne_fmriquality_TC_custom_method'

 		% specific settings for method 'ne_framewise_disp'
		settings.fmr_quality.fd_cutoff = 1;
		settings.fmr_quality.fd_radius = 5;

        % general settings for all methods
		settings.fmr_quality.reject_volumes_before_after_outlier	= [1	1];	% volumes to exclude before and after outlier volumes (for .sdm)
		settings.fmr_quality.avg_exclude_before_after_outlier		= [100 100];	% ms, time to exclude from avg before / after outlier
        settings.fmr_quality.plot_events = 'reward'; % if '', no events would be plotted, or 'reward', or regular expression such as 'reach.+mov'
        
        
% up to 2020        
% 		settings.fmr_quality.outlier_detection_method = 'ne_fmriquality_TC_Quality2_method'; % NeuroElf 'ne_fmriquality_method' | 'ne_fmriquality_TC_Quality2_method' | 'ne_framewise_disp' | 'ne_fmriquality_TC_custom_method'
% 		% settings for method 'ne_fmriquality_TC_Quality2_method'
% 		settings.fmr_quality.ne_fmriquality_TC_Quality2_threshold = []; % absolute outlier detection threshold for ne_fmriquality_TC_Quality2_method
% 		settings.fmr_quality.ne_fmriquality_TC_Quality2_threshold_nsd = []; % number of standard deviations of target signal as outlier detection threshold for ne_fmriquality_TC_Quality2_method
% 		settings.fmr_quality.ne_fmriquality_TC_Quality2_threshold_nMAD = [];%2.5; % number of median absolute deviations of target signal as outlier detection threshold for ne_fmriquality_TC_Quality2_method
% 		% see Leys et al. (2013). Detecting outliers: Do not use standard deviation around the mean, use absolute deviation around the median. Journal of Experimental Social Psychology, 49(4), 764�766.
% 		settings.fmr_quality.ne_fmriquality_TC_Quality2_threshold_prct = 1.5; % number of interquartile ranges added/subtracted to/from 75%/25% percentile of target signal to define upper and lower threshold
% 		% see http://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FSLMotionOutliers
% 		settings.fmr_quality.ne_fmriquality_TC_Quality2_n_smooth = 5; % n volumes for smoothing quality timecourse
% 		settings.fmr_quality.reject_volumes_before_after_outlier = [0 0]; % volumes to exclude before and after outlier volumes
% 		% settings for NeuroElf method 'ne_fmriquality_method'
% 		%settings.fmr_quality.outlier_detection_threshold = 1; % outlier detection threshold for ne_method (nr of criteria, default: 3)
% 		%settings.fmr_quality.n_sd = [6 5 5 5 4]; % number of SD for each criterion (default: [6 5 5 5 4]), see ne_fmriquality and http://neuroelf.net/wiki/doku.php?id=fmriquality
% 		% settings for method 'ne_framewise_disp'
% 		%settings.fmr_quality.reject_volumes_before_after_outlier = [1 1];
% 		%settings.fmr_quality.fd_cutoff;
% 		%settings.fmr_quality.fd_radius;
% 		% settings for custom QA method
% 		%settings.fmr_quality.ne_fmriquality_TC_custom_method_function_handle = @lll;
% 		settings.fmr_quality.avg_exclude_before_after_outlier = [100 100]; % ms, time to exclude from avg before / after outlier
		
		% settings for converting behavioral files to BV *.prt
		settings.prt.beh2prt_function_handle = @BA_mat2prt_fixmemstim;%@mat2prt_fixmemstim; %mat2prt_ind; % @mat2prt_es_analysis
		settings.model = ''; % name of the model; if left empty (''), name of settings.prt.beh2prt_function_handle will be used
		
		% settings for converting prt to sdm
		settings.sdm.nvol = 450;
		settings.sdm.prtr = settings.fmr_create.TR;
		settings.sdm.hpttp = 3;
		settings.sdm.hnttp = 10;
		settings.sdm.rcond = []; % exclude "rest"/"baseline" condition (i.e. initial fixation)
		
		% PPI settings
		%         settings.sdm.ppicond = [];
		%         % settings.sdm.ppicond = {'fixation','fixation microstim', 'memory right','memory right microstim', 'memory left', 'memory left microstim'};
		%         settings.sdm.ppivoi = 'D:\MRI\Curius\combined\microstim_20140409-20140528_5_3_100uA\microstim_20140122-20140226_5_3_250uA_nobaseline_TAL_SfN2014.voi';
		%         settings.sdm.ppivoiidx = 1;
		
		% VTC settings, VTC creation does not work for monkey data
		% settings.vtc_create.res		= 2;		% resolution 1 / 2 / 3
		% settings.vtc_create.meth	= 'linear';	% interpolation: 'cubic', 'lanczos3', {'linear'}, 'nearest'
		% settings.vtc_create.space	= 'acpc';	% 'native' (monkeys) | 'acpc' | 'tal'
		% settings.vtc_create.bbox	= [70 55 70; 190 225 166];		% [xstart ystart zstart; xend yend zend]; % 2x3 bounding box (optional, default: small TAL box)
		% settings.vtc_create.dt		= 2;		% datatype override (default: uint16, FV 2)
		settings.vtc_filter.spkern	= [3 3 3];
		
		% settings for multi-study GLM computation
		settings.mdm.seppred = 0; % predictors of equal name are (0) concatenated across all runs, (1) fully separated across runs and subjects, or (2) concatenated only across runs of the same subject, but separate across subjects
		settings.mdm.zTransformation = 1; % apply z-transformation to volume time courses
		settings.mdm.PSCTransformation = 0; % apply percent-signal-change transformation to volume time courses, NOTE: you can only choose ONE type of transformation (z or PSC)!
		settings.mdm.RFX_GLM = 0; % 0 = fixed-effects model (FFX), 1 = random-effects model (RFX)
		settings.mdm.mask = 'Y:\MRI\Bacchus\BA_20140711_ACPC_BRAIN_BrainMask.msk';
		
end