function sdm = ne_add_pred2sdm(sdm_fullname,sdm_rtc_mat_fullname,Zscore,new_sdm_name_suffix)
% add confound predictors from sdm_rtc_mat_fullname to sdm_fullname sdm file

if nargin < 3,
	Zscore = 1;
end

if nargin < 4,
	new_sdm_name_suffix = ''; % use sdm_rtc_mat_fullname as suffix for the new sdm
end

[~,sdm_rtc_mat_filename] = fileparts(sdm_rtc_mat_fullname);
sdm_path = fileparts(sdm_fullname);

sdm = xff(sdm_fullname);
NrOfPredictors_1 = sdm.NrOfPredictors; 
if strcmp(sdm_rtc_mat_fullname(end-3:end),'.mat'),
	load(sdm_rtc_mat_fullname); % should contain SDMMatrix_2 PredictorNames_2
	NrOfPredictors_2 = size(SDMMatrix_2,2); % cols
	 
else
	sdm2 = xff(sdm_rtc_mat_fullname);
	NrOfPredictors_2 = sdm2.NrOfPredictors;
	SDMMatrix_2 = sdm2.SDMMatrix;
	PredictorNames_2 = sdm2.PredictorNames;

	for k=1:length(PredictorNames_2),
		PredictorNames_2{k} = [PredictorNames_2{k} '-' sdm_rtc_mat_filename];
	end
end

if Zscore,
	SDMMatrix_2 = zscore(SDMMatrix_2);
end

sdm.NrOfPredictors = NrOfPredictors_1 + NrOfPredictors_2;
sdm.SDMMatrix = [sdm.SDMMatrix SDMMatrix_2];
sdm.PredictorNames = [sdm.PredictorNames PredictorNames_2];
if sdm.IncludesConstant,
	new_order = [1:NrOfPredictors_1-1  NrOfPredictors_1+1:NrOfPredictors_1+NrOfPredictors_2 NrOfPredictors_1];
	
	sdm.PredictorNames = sdm.PredictorNames(new_order);
	sdm.SDMMatrix = sdm.SDMMatrix(:,new_order);
	
end

if isempty(new_sdm_name_suffix),
	new_sdm_fullname = [sdm_fullname(1:end-4) '_' sdm_rtc_mat_filename '.sdm'];
else
	new_sdm_fullname = [sdm_fullname(1:end-4) '_' new_sdm_name_suffix '.sdm'];
end
sdm.SaveAs(new_sdm_fullname);
disp(['saved ' new_sdm_fullname]);

%% http://neuroelf.net/wiki/doku.php?id=obj.help

%% prt.Help('CreateSDM')
%  PRT::CreateSDM  - create an SDM from a PRT
%  
%  FORMAT:       sdm = prt.CreateSDM(params);
%  
%  Input fields:
%  
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
       
