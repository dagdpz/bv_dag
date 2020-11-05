function [gsh, outlier_volumes] = ne_pl_fmriqasheet(q, fmr_quality)
% fmriqasheet  - create figure with output of fmriquality
% modified from original version Igor Kagan 2014 for ne pipeline
% ne_pl_fmriqasheet(fq, fmr_quality)
%
% FORMAT:       [gsh = ] fmriqasheet(q, fmr_quality)
%
% Input fields:
%
%       q           return structure from fmriquality call
%
% Output fields:
%
%       gsh          figure handle (1x1 double)

% Version:  v0.9b
% Build:    10062817
% Date:     Jun-28 2010, 5:52 PM EST
% Author:   Jochen Weber, SCAN Unit, Columbia University, NYC, NY, USA
% URL/Info: http://neuroelf.net/

% Copyright (c) 2010, Jochen Weber
% All rights reserved.
%
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
		numel(q) ~= 1 || ...
		~isstruct(q) || ...
		~isfield(q, 'Dims') || ...
		~isfield(q, 'Filename') || ...
		~isfield(q, 'Masks') || ...
		~isfield(q, 'Raw') || ...
		~isfield(q, 'Quality')
	error( ...
		'neuroelf:BadArgument', ...
		'Invalid argument to fmriqasheet.' ...
		);
end

% motion detection run?
if isfield(q, 'MotCorr') && ...
		isstruct(q.MotCorr) && ...
		isfield(q.MotCorr, 'Params')
	m = true;
else
	m = false;
end



% get ROOT object properties
rp = get(0);
rs = rp.ScreenSize;
rc = 0.5 .* rs(3:4);
if (rs(3) / rs(4)) >= sqrt(0.5)
	rs = 2 * round(0.45 * [sqrt(0.5) * rs(4), rs(4)]);
else
	rs = 2 * round(0.45 * [rs(3), sqrt(0.5) * rs(3)]);
end

% make figure settings
gsh = figure('NumberTitle', 'off', ...
	'Name', ['fMRI QA sheet v1: ' q.Filename], ...
	'Position', [rc - 0.5 * rs, rs],'Renderer','Painters');

cmap = 'jet';
tccmap = prism(5);
critmap = flipud(gray(6)); critmap = critmap(2:end,:);

% add subplots for output
cols = 2; rows = 4;
targets = [1:2:8, 2:2:8];


% get some numbers
nvol = size(q.TC.Slices, 1);
nslc = size(q.TC.Slices, 2);

str = sprintf('Data dim: %d x %d x %d, nvol: %d \n', q.Dims(1:4));

if strcmp(fmr_quality.outlier_detection_method,'ne_fmriquality_method') % original NE fmriquality method

	odt = fmr_quality.outlier_detection_threshold;
	% plot PSC time courses or slices with outliers marked
	if m
		tcp1 = subplot(rows, cols, targets(1));
	else
		tcp1 = subplot(rows, cols, [1 2]);
	end
	
	
	tcdata = psctrans(q.TC.TF_ForeSlicesWeighted);
	tcdata(:, all(tcdata == 0)) = 100;
	tcdata = tcdata - 100;
	hp = plot(2 * repmat(0:(nslc - 1), nvol, 1) + tcdata,'Color',[0 0 0]);
	hold(tcp1, 'on');
	
	hl = add_volume_markers(find([q.Quality.Outliers.Volumes >= odt])','LineWidth',1,'Color',[0.4784    0.0627    0.8941]);
	set(gca,'children',[hp' hl]);
	
	str = [str sprintf('Outlier volumes: %d (%.1f%%) \n %s',sum(q.Quality.Outliers.Volumes >= odt),100*sum(q.Quality.Outliers.Volumes >= odt)/nvol,...
			mat2str(find([q.Quality.Outliers.Volumes >= odt])'))];

	ht = title(['fMRI QA sheet v1: ' q.Filename sprintf('\n') str sprintf('\n') fmr_quality.outlier_detection_method],'interpreter','none','FontSize',8,'LineWidth',10);

	
	
	tcp2 = subplot(rows, cols, [3 4]); hold on;
	set(gca,'ColorOrder',tccmap);
	plot(q.TC.Quality);
	for k = 1:5,
		add_volume_markers(find([q.Quality.Outliers.Volumes == k])','LineWidth',1,'Color',critmap(k,:));
	end
	legend({'Global' 'Foreground' 'Outliers' 'zScoreGlobal' 'SmoothEst'});
	set(tcp2,'Tag','TC volumes');
	

	% IK commented out:
	% original version using AlphaData of image:
	% olm = uint8(zeros(2 * nslc, nvol, 3));
	% olm(:, :, 1) = 255;
	% olh = image(olm, 'Parent', tcp);
	% olm = repmat(0.25 * log(1 + q.Quality.Outliers.Volumes'), 2 * nslc, 1);
	% set(olh, 'AlphaData', olm);


elseif strcmp(fmr_quality.outlier_detection_method,'ne_fmriquality_TC_Quality2_method')
	
	tcp1 = subplot(rows, cols, [1 2]);
	target_signal = [(q.TC.Quality(:,2))];
	ts_smoothed = clean_convolve(target_signal,ones(1,fmr_quality.ne_fmriquality_TC_Quality2_n_smooth)./fmr_quality.ne_fmriquality_TC_Quality2_n_smooth);
	plot(ts_smoothed,'Color',[0 1 0]); hold on;
	plot(target_signal,'Color',[0 0 0]); hold on;
	
    tcp2 = subplot(rows, cols, [3 4]);
    target_signal = target_signal - ts_smoothed';
    
    if isfield(fmr_quality, 'ne_fmriquality_TC_Quality2_threshold_nsd') && ~isempty(fmr_quality.ne_fmriquality_TC_Quality2_threshold_nsd)
        sd_target_signal = std(target_signal);
        odt = sd_target_signal * fmr_quality.ne_fmriquality_TC_Quality2_threshold_nsd;
    elseif isfield(fmr_quality, 'ne_fmriquality_TC_Quality2_threshold_nMAD') && ~isempty(fmr_quality.ne_fmriquality_TC_Quality2_threshold_nMAD)
        MAD = 1.4826 * median(abs(target_signal - median(target_signal))); % median absolute deviation
        odt = MAD * fmr_quality.ne_fmriquality_TC_Quality2_threshold_nMAD;        
    elseif isfield(fmr_quality, 'ne_fmriquality_TC_Quality2_threshold_prct') && ~isempty(fmr_quality.ne_fmriquality_TC_Quality2_threshold_prct)
        odt(1) = prctile(target_signal,25) - fmr_quality.ne_fmriquality_TC_Quality2_threshold_prct * (prctile(target_signal,75) - prctile(target_signal,25));
        odt(2) = prctile(target_signal,75) + fmr_quality.ne_fmriquality_TC_Quality2_threshold_prct * (prctile(target_signal,75) - prctile(target_signal,25));
    elseif isfield(fmr_quality, 'ne_fmriquality_TC_Quality2_threshold') && ~isempty(fmr_quality.ne_fmriquality_TC_Quality2_threshold)
        odt = fmr_quality.ne_fmriquality_TC_Quality2_threshold;    
    end
    
    plot(target_signal,'Color',[0 0 0]); hold on;
    if isfield(fmr_quality, 'ne_fmriquality_TC_Quality2_threshold_prct') && ~isempty(fmr_quality.ne_fmriquality_TC_Quality2_threshold_prct)
        line([1 nvol],[odt(1) odt(1)],'Color',[1 0 0]);
        line([1 nvol],[odt(2) odt(2)],'Color',[1 0 0]);
        outlier_volumes = find(target_signal < odt(1) | target_signal > odt(2));
    else
        line([1 nvol],[-odt -odt],'Color',[1 0 0]);
        line([1 nvol],[odt odt],'Color',[1 0 0]);
        outlier_volumes = find(abs(target_signal) > abs(odt));
    end
    hl = add_volume_markers(outlier_volumes,'LineWidth',0.5,'Color',[1 0.6 0.8]);
    plot(target_signal,'Color',[0 0 0]);
	
	str = [str sprintf('Outlier volumes: %d (%.1f%%) \n %s',length(outlier_volumes),100*length(outlier_volumes)/nvol,...
		mat2str(outlier_volumes'))];
	
	ht = title(tcp1,['fMRI QA sheet v1: ' q.Filename sprintf('\n') str sprintf('\n') fmr_quality.outlier_detection_method],'interpreter','none','FontSize',8,'LineWidth',10);
	set(tcp2,'Tag','TC volumes');
	
elseif strcmp(fmr_quality.outlier_detection_method,'ne_framewise_disp')
    odt = fmr_quality.fd_cutoff;
    
    tcp1 = subplot(rows, cols, [1 2]);
    target_signal = [q.FD];
    plot(target_signal,'Color',[0 0 0]); hold on;
    
    line([1 nvol],[odt odt],'Color',[1 0 0]);
    outlier_volumes = find(target_signal > odt);
    hl = add_volume_markers(outlier_volumes,'LineWidth',0.5,'Color',[1 0.6 0.8]);
    plot(target_signal,'Color',[0 0 0]);
    
    str = [str sprintf('Outlier volumes: %d (%.1f%%) \n %s',length(outlier_volumes),100*length(outlier_volumes)/nvol,...
        mat2str(outlier_volumes'))];
    
    ht = title(tcp1,['fMRI QA sheet v1: ' q.Filename sprintf('\n') str sprintf('\n') fmr_quality.outlier_detection_method],'interpreter','none','FontSize',8,'LineWidth',10);
    set(tcp1,'Tag','FD volumes');
    
    tcp2 = subplot(rows, cols, [3 4]); hold on;
    set(gca,'ColorOrder',tccmap);
    plot(q.TC.Quality);
    
    legend({'Global' 'Foreground' 'Outliers' 'zScoreGlobal' 'SmoothEst'});
    set(tcp2,'Tag','TC volumes');
    
elseif strcmp(fmr_quality.outlier_detection_method,'ne_DVARS')
    
    outlier_volumes = q.outlier_volumes;
    tcp1 = subplot(rows, cols, [1 2]);
    plot(q.FD,'Color',[0 0 0]); hold on;
    line([1 nvol],[fmr_quality.fd_cutoff fmr_quality.fd_cutoff],'Color',[1 0 0]);
    hl = add_volume_markers(q.outlier_volumes,'LineWidth',0.5,'Color',[1 0.6 0.8]);
    plot(q.FD,'Color',[0 0 0]);
    
    str = [str sprintf('Outlier volumes: %d (%.1f%%) \n %s',length(outlier_volumes),100*length(outlier_volumes)/nvol,...
        mat2str(outlier_volumes'))];
    
    ht = title(tcp1,['fMRI QA sheet v1: ' q.Filename sprintf('\n') str sprintf('\n') fmr_quality.outlier_detection_method],'interpreter','none','FontSize',8,'LineWidth',10);
    set(tcp1,'Tag','FD volumes');
    
    tcp2 = subplot(rows, cols, [3 4]); hold on;
    DeltapDvar = [0 q.DVARS_Stat.DeltapDvar];
    odt = fmr_quality.DVARS_psig;
    plot(DeltapDvar,'Color',[0 0 0]);
    line([1 nvol],[odt odt],'Color',[1 0 0]);
    plot(outlier_volumes,DeltapDvar(outlier_volumes),'Color',[1 0.5 0.5]);
    
    legend({'Delta %Dvar'});
    set(tcp2,'Tag','TC volumes');
    
end




% show overall global signal-to-noise ratio info
ha1 = subplot(rows, cols, [5]);
imshow(repmat(uint8(floor(packmosaic(permute(scaledata(q.Quality.GlobalSNRImage),[2 1 3])))), [1, 1, 1]),[])
colormap(ha1,cmap);
hc1 = colorbar;
title(sprintf('global SNR, mean %6.2f',mean(q.Quality.GlobalSNRImage(q.Masks.Foreground))));

% SNR over time
ha2 = subplot(rows, cols, [6]);
imshow(repmat(uint8(floor(packmosaic(permute(scaledata(q.Quality.LocalSNRImage),[2 1 3])))), [1, 1, 1]),[]);
colormap(ha2,cmap);
hc2 = colorbar;
title(sprintf('SNR over time, mean %6.2f',mean(q.Quality.LocalSNRImage(q.Masks.Foreground))));

% and histogram of SNR
if m
	subplot(rows, cols, targets(7));
else
	subplot(rows, cols, [7 8]);
end
hist(q.Quality.GlobalSNRImage(q.Masks.Foreground), 250);
title('Global SNR histogram');


if 0 % verbose
% print out some info
dline = repmat('-', 1, 72);
disp('fMRI Quality statistics:');
disp(dline);
disp(sprintf(' - data dimensions:   %d x %d x %d', q.Dims(1:3)));
disp(sprintf(' - number of volumes: %d', q.Dims(4)));


disp(sprintf(' - outlier volumes:   %d (%.1f%%) [ %s]', ...
	sum(q.Quality.Outliers.Volumes >= odt),100*sum(q.Quality.Outliers.Volumes >= odt)/nvol, ... % sum(q.Quality.Outliers.Volumes >= odt),100*q.Quality.Outliers.VolumeRatio, ... % IK BUG in NE
	sprintf('%d ', find(q.Quality.Outliers.Volumes >= odt))));
disp(dline);
disp(sprintf(' - average spatial  SNR: %-6.2f', ...
	mean(q.Quality.GlobalSNRImage(q.Masks.Foreground))));
disp(sprintf(' - average temporal SNR: %-6.2f', ...
	mean(q.Quality.LocalSNRImage(q.Masks.Foreground))));
end



% motion correction stuff
if m
	
	if 0 % verbose
	% text info
	maxmot = max(q.MotCorr.Params, [], 1) - min(q.MotCorr.Params, [], 1);
	disp(line);
	disp(sprintf(' - maximal translation: %-5.3fmm  %-5.3fmm  %-5.3fmm', maxmot(1:3)));
	disp(sprintf(' - maximal rotation:    %-5.3fdeg %-5.3fdeg %-5.3fdeg', maxmot(4:6)));
	end
	
	% parameters
	subplot(rows, cols, targets(4));
	plot(q.MotCorr.Params);
	
	% important time courses
	subplot(rows, cols, targets(6));
	plot(3 * repmat(0:(size(q.TC.Quality, 2) - 1), nvol, 1) + q.TC.Quality);
	
	% otherwise some more stuff
else
end

set(ig_get_figure_axes,'box','off','Color',[0.95 0.95 0.95],'TickDir','out');

