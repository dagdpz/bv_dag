function ne_prt2sdm(prt_fullname,varargin)
% convert *.prt to *.sdm using NeuroElf
% Example:
% ne_prt2sdm('D:\MRI\Curius\20130814\t1.prt','nvol',300,'prtr',2000,'rcond',[]);		% for human
% ne_prt2sdm('D:\MRI\Curius\20130814\t1.prt','nvol',300,'prtr',2000,'rcond',[],'hpttp',3);	% for monkey
% See help below for params that can be used

prt = xff(prt_fullname);

if 0 % add offset to prt
    for k = 1:length(prt.Cond),
        prt.Cond(k).OnOffsets = prt.Cond(k).OnOffsets + 4*2000; % volumes*TR
    end
    prt.Save;
end

sdmfile = prt.CreateSDM(struct(varargin{:}));
sdmfile.SaveAs([prt_fullname(1:end-4),'.sdm']);
disp(['created ' [prt_fullname(1:end-4),'.sdm']]);

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
       
