function era = ne_era(voi_def,avgpath,era_settings_id,varargin)
% extracts era and single trial timecourse data from vtcs using info in .voi and .avg file
%  era = ne_era('pulv_r_test.voi','avg_vols.avg','','TR',2,'ra_bins',[8:13]);
%
% Inputs:
%	voi_def: path to voi file
%       OR // not implemented yet for NE //
%	xyz - ROI coodinates, can be in 'sys', 'tal64', or 'tal', defined by xyztype
%       roisize - in mm, i.e. 3 would be 3 mm side cube

DEBUG = 0;

if nargin < 3,
	era_settings_id = '';
end


% default parameters
defpar = { ...
	'TR', 'double', 'nonempty', 0; ... % will be read from ne_era_settings or vtc if not defined
	'ra_bins', 'double', [], []; ...  % ra samples, starting from 1st sample
	'tc_interpolate', 'double', 'nonempty', 0; ... % interpolate timecourse to tc_interpolate ms (0 - no interpolation)
        'roisize', 'double', 'nonempty', 0; ... 
        'xyztype', 'char', 'nonempty', 'tal' ; ...
        'avg_BaseDirectory_replacement', 'char',   '', ''; ... 
        };

if nargin > 3, % specified dynamic params
        params = checkstruct(struct(varargin{:}), defpar);
elseif nargin == 4, % struct is specified
        params = varargin{1};
else
        params = checkstruct(struct, defpar); % take all default params
end

if ~isempty(era_settings_id), 
	run('ne_era_settings'); % TR and ra_bins come from ne_era_settings
else
	TR = params.TR;
	ra_bins = params.ra_bins; % starting from 1st sample
end

TR = TR*1000; % ms

avg = xff(avgpath);

if ischar(voi_def) % voi
	voi = xff(voi_def);
	n_rois = voi.NrOfVOIs;
else
	n_rois = size(xyz,1)
end

[peri(1:n_rois,1:avg.NrOfCurves).perievents]                    = deal([]); % for all runs together
[peri_run(1:n_rois,1:avg.NrOfFiles,1:avg.NrOfCurves).mean]      = deal([]); % each run separately
[peri_run(1:n_rois,1:avg.NrOfFiles,1:avg.NrOfCurves).se]        = deal([]); % each run separately


if ~isempty(params.avg_BaseDirectory_replacement),
	avg.BaseDirectory = regexprep(avg.BaseDirectory, params.avg_BaseDirectory_replacement{1},params.avg_BaseDirectory_replacement{2});
end

[missing_files(1:avg.NrOfCurves)] = deal(0);

v = neuroelf_version;

for f = 1:avg.NrOfFiles
	
	vtcpath = [avg.BaseDirectory  filesep char(avg.FileNames(f))];
	if isunix, regexprep(vtcpath,'\\','/'); end
	
	% tc = bvqxt_read_vtc(vtcpath,xyz,roisize,xyztype); % tc can be a vector or array (n_rois x ...)
	vtc = xff(vtcpath);
	
	if ~TR, % extract TR from vtc if not given by user
		TR = vtc.TR;
	end
	
	if strcmp('0.9c',v) || strcmp(voi.ReferenceSpace,'TAL'),
		tc = vtc.VOITimeCourse(voi)'; % each row - one roi tc
	else
		tc = vtc.VOITimeCourseOrig(voi)'; 
	end
	
	if 1, disp(['loaded file ' vtcpath]); end
	
	n_rois = size(tc,1);
	
	
	for c = 1:avg.NrOfCurves % for each curve
		
		k = f-missing_files(c);
		
		if DEBUG, save lll; disp(sprintf('Curve %d File %d Points %d',c,k,avg.Curve(c).File(k).EventPointsInFile)); end;
		
		if avg.Curve(c).NrOfConditionEvents == 0, % no trials of this type in all files,
			
			% fill with NaNs
			perievents = extract_perievents([],[],TR,avg);
			for r = 1:n_rois
				peri(r,c).perievents = [peri(r,c).perievents perievents]; % events from all files(runs) together
				[~, peri_run(r,f,c).mean, peri_run(r,f,c).se, peri_run(r,f,c).n_trials] = mean_psc(perievents,avg);
			end
			
			% check that this curve is not empty (no trials) in this file(run)
		elseif avg.Curve(c).File(k).EventPointsInFile == k-1+missing_files(c),
			idx = avg.Curve(c).File(k).EventPointsInFile + 1 - missing_files(c); % EventPointsInFile is 0-based
			onsets = avg.Curve(c).File(idx).Points';
			
			for r = 1:n_rois
				perievents = extract_perievents(onsets,tc(r,:),TR,avg,params.tc_interpolate);
				peri(r,c).perievents = [peri(r,c).perievents perievents]; % events from all files(runs) together
				[~, peri_run(r,f,c).mean, peri_run(r,f,c).se, peri_run(r,f,c).n_trials] = mean_psc(perievents,avg);
			end
			
			
		elseif ~isempty(avg.Curve(c).File(k).EventPointsInFile)
			
			% update missing files for this curve
			missing_files(c) = missing_files(c)+1;
			
			% fill with NaNs
			perievents = extract_perievents([],[],TR,avg);
			for r = 1:n_rois
				peri(r,c).perievents = [peri(r,c).perievents perievents]; % events from all files(runs) together
				[~, peri_run(r,f,c).mean, peri_run(r,f,c).se, peri_run(r,f,c).n_trials] = mean_psc(perievents,avg);
			end
			
		end
		
	end % for each curve
	
	
end % for each vtc file(run)


for c = 1:avg.NrOfCurves
	for r = 1:n_rois,
		switch avg.BaselineMode
			case 3 % epoch-based
				if ~isempty(peri(r,c).perievents)
					[psc(r,c).perievents, mean_(r,c,:),se_(r,c,:),n_(r,c,:)] = mean_psc(peri(r,c).perievents,avg);
					
					if ~isempty(ra_bins)
						RA(r,c).ra		= mean(psc(r,c).perievents(ra_bins,:),1);
						RA(r,c).ra_mean		= mean(RA(r,c).ra);
						RA(r,c).ra_se		= sterr(RA(r,c).ra);
					end
				end
		end
		era.voi(r) = voi.VOI(r);
	end
	
end



era.avg		= avg;
era.TR		= TR/1000; % s
era.ra_bins	= ra_bins;
era.RA		= squeeze(RA); % n_vois x n_curves
era.raw		= squeeze(peri);
era.psc		= squeeze(psc);
era.peri_run	= squeeze(peri_run);
era.mean	= squeeze(mean_);
era.se		= squeeze(se_);
era.n_trials	= squeeze(n_);





%--------------------------------------------------------
function perievents = extract_perievents(onsets,tc,TR,avg,tc_interpolate)

if nargin < 5,
	tc_interpolate = 0;
end

if isempty(onsets),
	
	perievents = NaN(avg.NrOfTimePoints,1);
	
else
	if tc_interpolate, % e.g. to 5 ms, x200 times = TR/5
		
		tci = interp(tc,TR/tc_interpolate);
		onsets_i = round(onsets/tc_interpolate)+1;
		n_vol = length(tc); % in original TR

		% find valid (complete trial) events
		onsets_i = onsets_i(find(onsets_i-avg.PreInterval*TR/tc_interpolate>0 & onsets_i+avg.PostInterval*TR/tc_interpolate<=n_vol*TR/tc_interpolate));
		idx = repmat(onsets_i,avg.NrOfTimePoints*TR/tc_interpolate,1) - repmat(fliplr([-(avg.PostInterval+1)*TR/tc_interpolate:avg.PreInterval*TR/tc_interpolate-1]),length(onsets_i),1)';
		perievents = tci(idx);
		perievents = perievents([1:TR/tc_interpolate:end],:);
		
	else % no interpolation
		% ms -> volumes
		onsets = round(onsets/TR)+1;
		n_vol = length(tc);

		% find valid (complete trial) events
		onsets = onsets(find(onsets-avg.PreInterval>0 & onsets+avg.PostInterval<=n_vol));

		% simple example: idx = repmat(onsets,4,1) - repmat(fliplr([-2:1]),length(onsets),1)' %
		idx = repmat(onsets,avg.NrOfTimePoints,1) - repmat(fliplr([-avg.PostInterval:avg.PreInterval]),length(onsets),1)';
		perievents = tc(idx); % each column - trial
		
	end
	
	if size(perievents,1) == 1
		perievents = perievents(:); % make column
	end
	
	
	
end

%--------------------------------------------------------
function [psc,mean_,se_,n_] = mean_psc(perievents,avg)
baselines = mean(perievents([avg.PreInterval+avg.AverageBaselineFrom:avg.PreInterval+avg.AverageBaselineTo]+1,:),1);
baselines = repmat(baselines,avg.NrOfTimePoints,1);

psc = 100*(perievents - baselines)./baselines; % in [%signal change]
psc = psc(:,~isnan(psc(1,:))); % remove NaNs

mean_ = mean(psc,2); % in % signal change
se_ = sterr(psc,2,1);
n_ = size(perievents,2);
if all(isnan(perievents)),
	n_= 0;
end