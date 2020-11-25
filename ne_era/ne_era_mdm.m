function [era] = ne_era_mdm(voipath,avgpath,mdmpath,era_settings_id,varargin)
% This function extracts single-trial BOLD responses from VTCs using
% MDM::VOITimeCourses for each volume of interest (VOI) specified in a
% given VOI file specified as VOIPATH.
% AVGPATH specifies the path to an AVG file that provides the critical time points within the dataset.
% MDMPATH specifies the path to an MDM file that provides the list of VTCs.
% ERA_SETTINGS_ID refers to the dataset's ID in ne_era_settings.m that
% provides the bins/time window that you want to average across (settings.ra_bins_sec).
% VARARGIN
%   ra_bins_sec specifies the bins/time window that you want to average across if ERA_SETTINGS_ID is left empty.
%   tc_interpolate specifies the time resolution you want to get by
%   interpolation in ms. E.g. tc_interpolate = 1000 will result in a sampling rate of 1Hz. NOTE: At the moment only tc_interpolate = 1000 (default) is working properly!
%   datatrans refers to the type of data transformation that you want to
%   apply to the VTC data before event-related averaging (default: 'raw' =
%   none, 'psc' = % signal change, 'z' = z transformation). NOTE: At the moment only using raw data ('raw', default) makes sense!
%   assignment is a vector that assigns the different conditions to their
%   corresponding factor levels for ANOVA (see nway_anova.m).
%
% Example:
%   voipath = 'D:\MRI\Curius\combined\microstim_20140122-20140226_5_3_250uA_nobaseline\11pred\microstim_20140122-20140226_5_3_250uA_nobaseline_TAL_SfN2014.voi';
%   avgpath = 'D:\MRI\Curius\combined\microstim_20140122-20140226_5_3_250uA_nobaseline\11pred\combined_spkern_3-3-3_ne_prt2avg_fixation_memory_microstim.avg';
%   mdmpath = 'D:\MRI\Curius\combined\microstim_20140122-20140226_5_3_250uA_nobaseline\11pred\combined_spkern_3-3-3.mdm';
%   era_settings_id = 'Curius_microstim_20131129-now';


DEBUG = 0;

if nargin < 4,
	era_settings_id = '';
end


%% default parameters
defpar = { ...
	'ra_bins_sec', 'double', [], []; ...  % ra samples in seconds according to time axis, starting from 1st sample
	'tc_interpolate', 'double', 'nonempty', 1000; ... % interpolate timecourse to tc_interpolate ms (0 - no interpolation)
	'datatrans', 'char', 'nonempty', 'raw';...  % transformation applied to time course data: 'psc', 'z', or 'raw' (default)
	%'roisize', 'double', 'nonempty', 0; ...
	%'xyztype', 'char', 'nonempty', 'tal' ; ...
	'avg_BaseDirectory_replacement', 'char',   '', ''; ...
	};

if nargin > 4, % specified dynamic params
	params = checkstruct(struct(varargin{:}), defpar);
elseif nargin == 5, % struct is specified
	params = varargin{1};
else
	params = checkstruct(struct, defpar); % take all default params
end

if ~isempty(era_settings_id),
	run('ne_era_settings');
	params.ra_bins_sec = settings.ra_bins_sec; % bins to average across for ANOVA
end


%% load VOI, AVG, and MDM
if ischar(voipath) % voi
	voi = xff(voipath);
	n_rois = voi.NrOfVOIs;
else
	n_rois = size(xyz,1);
end

% if necessary, convert VOI system coordinates to Talairach coordinates
if ~strcmp(voi.ReferenceSpace, 'TAL')
	disp('---- VOI reference space is not TAL')
	ne_voicoord2tal(voipath);
	voi = xff([voipath(1:end-4) '_TAL.voi']);
end

avg = xff(avgpath);
[peri(1:n_rois,1:avg.NrOfCurves).perievents]                    = deal([]); % for all runs together
[peri_run(1:n_rois,1:avg.NrOfFiles,1:avg.NrOfCurves).mean]      = deal([]); % each run separately
[peri_run(1:n_rois,1:avg.NrOfFiles,1:avg.NrOfCurves).se]        = deal([]); % each run separately

if ~isempty(params.avg_BaseDirectory_replacement),
	avg.BaseDirectory = regexprep(avg.BaseDirectory, params.avg_BaseDirectory_replacement{1},params.avg_BaseDirectory_replacement{2});
end

[missing_files(1:avg.NrOfCurves)] = deal(0);

mdm = xff(mdmpath);
% use desired data transformation
if strcmp(params.datatrans, 'psc') && mdm.PSCTransformation == 0
	mdm.PSCTransformation = 1;
	mdm.zTransformation = 0;
elseif strcmp(params.datatrans, 'z') && mdm.zTransformation == 0
	mdm.PSCTransformation = 0;
	mdm.zTransformation = 1;
elseif strcmp(params.datatrans, 'raw') && (mdm.zTransformation == 1 || mdm.PSCTransformation == 1) % default
	mdm.PSCTransformation = 0;
	mdm.zTransformation = 0;
end

%% extract VOI time courses and single-trial data
disp('---- extracting VOI time courses')
[tc, tcf, tcv, tr] = mdm.VOITimeCourses(voi);

% get TR
TR = tr(1);

% transform AVG values to interpolated values
switch avg.ResolutionOfDataPoints
    case 'Seconds'
        
        if params.tc_interpolate == 0 
            params.tc_interpolate = 1000; % minimum interpolation to match time course sampling rate with AVG time resolution
        end
        
        ini_interp = TR/1000;
        interpol.NrOfTimePoints = avg.NrOfTimePoints*(TR/params.tc_interpolate)/ini_interp - 1000/params.tc_interpolate + 1;
        interpol.PreInterval = avg.PreInterval*1000/params.tc_interpolate;
        interpol.PostInterval = avg.PostInterval*1000/params.tc_interpolate;
        interpol.AverageBaselineFrom = avg.AverageBaselineFrom*1000/params.tc_interpolate;
        interpol.AverageBaselineTo = avg.AverageBaselineTo*1000/params.tc_interpolate;
        
    case 'Volumes' % NOT TESTED YET!        
               
        if params.tc_interpolate > 0            
            interpol.NrOfTimePoints = avg.NrOfTimePoints*(TR/params.tc_interpolate) - TR/params.tc_interpolate + 1;
            interpol.PreInterval = avg.PreInterval*TR/params.tc_interpolate;
            interpol.PostInterval = avg.PostInterval*TR/params.tc_interpolate;
            interpol.AverageBaselineFrom = avg.AverageBaselineFrom*TR/params.tc_interpolate;
            interpol.AverageBaselineTo = avg.AverageBaselineTo*TR/params.tc_interpolate;
        else 
            interpol.NrOfTimePoints = avg.NrOfTimePoints;
            interpol.PreInterval = avg.PreInterval;
            interpol.PostInterval = avg.PostInterval;
            interpol.AverageBaselineFrom = avg.AverageBaselineFrom;
            interpol.AverageBaselineTo = avg.AverageBaselineTo;
        end        
end

for f = 1:avg.NrOfFiles
	disp(['---- processing ' tcf{f}])
	
	curve = avg.Curve;
	for c = 1:avg.NrOfCurves % for each curve
		% disp(['condition ' num2str(c)])
		
		if curve(c).NrOfConditionEvents == 0, % no trials of this type in all files,
			
			% fill with NaNs
			perievents = extract_perievents([],[],TR,interpol);
			for r = 1:n_rois
				peri(r,c).perievents = [peri(r,c).perievents perievents]; % events from all files(runs) together
				[~, peri_run(r,f,c).mean, peri_run(r,f,c).se, peri_run(r,f,c).n_trials] = mean_psc(perievents,interpol);
			end
			
			% check that this curve is not empty (no trials) in this file(run)
		elseif ~isempty(find([curve(c).File.EventPointsInFile] == f-1)) % EventPointsInFile is 0-based
			onsets = curve(c).File([curve(c).File.EventPointsInFile] == f-1).Points';
			
			for r = 1:n_rois
				% disp(['ROI ' num2str(r)])
                perievents = extract_perievents(onsets,tc{f,1}(:,r),TR,interpol,params.tc_interpolate);
				peri(r,c).perievents = [peri(r,c).perievents perievents]; % events from all files(runs) together
                [~, peri_run(r,f,c).mean, peri_run(r,f,c).se, peri_run(r,f,c).n_trials] = mean_psc(perievents,interpol);
			end
			
			% if this curve is empty (no trials) in this file (run)
		elseif isempty(find([curve(c).File.EventPointsInFile] == f-1))
			
			% update missing files for this curve
			missing_files(c) = missing_files(c)+1;
			
			% fill with NaNs
            perievents = extract_perievents([],[],TR,interpol);
			for r = 1:n_rois
				peri(r,c).perievents = [peri(r,c).perievents perievents]; % events from all files(runs) together
                [~, peri_run(r,f,c).mean, peri_run(r,f,c).se, peri_run(r,f,c).n_trials] = mean_psc(perievents,interpol);
			end
			
		end
		
	end % for each curve
end % for each VTC

%% event-related averaging
switch avg.ResolutionOfDataPoints
	case 'Seconds'
		time_resolution = params.tc_interpolate/1000; % in seconds
	case 'Volumes'
		time_resolution = TR/1000; % seconds
end
timeaxis = [0:interpol.NrOfTimePoints-1]*time_resolution - avg.PreInterval; % in seconds

for c = 1:avg.NrOfCurves
	for r = 1:n_rois,
		switch avg.BaselineMode
			case 3 % epoch-based
				if ~isempty(peri(r,c).perievents)
                    [psc(r,c).perievents, mean_(r,c,:),se_(r,c,:),n_(r,c,:)] = mean_psc(peri(r,c).perievents,interpol);
					
					if ~isempty(params.ra_bins_sec)
						params.ra_bins = [find(timeaxis == params.ra_bins_sec(1)):find(timeaxis == params.ra_bins_sec(end))];
						RA(r,c).ra		= mean(psc(r,c).perievents(params.ra_bins,:),1);
						RA(r,c).ra_mean		= mean(RA(r,c).ra);
						RA(r,c).ra_se		= sterr(RA(r,c).ra);
					end
				end
		end
		era.voi(r) = voi.VOI(r);
	end
	
end


%% output
era.avg		= avg;
era.TR		= tr;
era.RA		= squeeze(RA); % n_vois x n_curves
era.raw		= squeeze(peri);
era.psc		= squeeze(psc);
era.peri_run	= squeeze(peri_run);
era.mean	= squeeze(mean_);
era.se		= squeeze(se_);
era.n_trials	= squeeze(n_);
era.params	= params;
era.timeaxis    = timeaxis;


function perievents = extract_perievents(onsets,tc,TR,interpol,tc_interpolate)

if isempty(onsets),
	
    perievents = NaN(interpol.NrOfTimePoints,1);
	
else
	if tc_interpolate, % e.g. to 5 ms, x200 times = TR/5
        
        tci = interp(tc,TR/tc_interpolate);
        onsets_i = round(onsets/tc_interpolate)+1;
        n_vol = length(tc); % in original TR
        
        
        % find valid (complete trial) events
        onsets_i = onsets_i(onsets_i-interpol.PreInterval>0 & onsets_i+interpol.PostInterval<=n_vol*TR/tc_interpolate); % only event onsets that lie within the time range of the EPI
        if numel(onsets_i) > 0
            idx = repmat(onsets_i,interpol.NrOfTimePoints,1) - repmat(fliplr([-(interpol.PostInterval):interpol.PreInterval]),length(onsets_i),1)';
            perievents = tci(idx);
        else perievents = NaN(interpol.NrOfTimePoints,1);
        end
        
        if size(perievents,1) == 1
            perievents = perievents(:); % make column
        end
        
		
		% NOT TESTED YET!
	else % no interpolation 
		% ms -> volumes
		onsets = round(onsets/TR)+1;
		n_vol = length(tc);
		
		% find valid (complete trial) events
		onsets = onsets(onsets-interpol.PreInterval>0 & onsets+interpol.PostInterval<=n_vol);
		
		% simple example: idx = repmat(onsets,4,1) - repmat(fliplr([-2:1]),length(onsets),1)' %
		idx = repmat(onsets,interpol.NrOfTimePoints,1) - repmat(fliplr([-interpol.PostInterval:interpol.PreInterval]),length(onsets),1)';
		perievents = tc(idx); % each column - trial
		
		if size(perievents,1) == 1
			perievents = perievents(:); % make column
		end
		
	end
	
end


function [psc,mean_,se_,n_] = mean_psc(perievents,interpol) %[psc,mean_,se_,n_] = mean_psc(perievents,avg)
% baselines = mean(perievents([avg.PreInterval+avg.AverageBaselineFrom:avg.PreInterval+avg.AverageBaselineTo]+1,:),1);
% baselines = repmat(baselines,avg.NrOfTimePoints,1);

baselines = mean(perievents([interpol.PreInterval+interpol.AverageBaselineFrom:interpol.PreInterval+interpol.AverageBaselineTo]+1,:),1);
baselines = repmat(baselines,interpol.NrOfTimePoints,1);

psc = 100*(perievents - baselines)./baselines; % in [%signal change]
psc = psc(:,~isnan(psc(1,:))); % remove NaNs

mean_ = mean(psc,2); % in % signal change
se_ = sterr(psc,2,1);
n_ = size(perievents,2);
if all(isnan(perievents)),
	n_= 0;
end

