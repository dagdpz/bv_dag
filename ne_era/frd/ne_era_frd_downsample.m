function era = ne_era_frd_downsample(era_file,bin_size)
% prerequisite: PSC
% centers  on the first timepoint of the bin
% discards left-over time points at the end (not at the beginning), because
% these points have been "invented" anyway by interpolation

% bin_size = 5
% era_file = 'Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI\ANEL\mat2prt_reach_decision_vardelay_foravg\ANEL_era_cue_12_no_outliers.mat';
% era_file = 'Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI\CAST\mat2prt_reach_decision_vardelay_foravg\CAST_era_cue_3_no_outliers.mat'; one condition missing
load(era_file); 

n_timepoints = size(era.mean,3);
NaN_filler = NaN(floor(n_timepoints/bin_size),1);

for v = 1:size(era.psc,1) % loop vois
    for c = 1:size(era.psc,2) % loop curves
        
        if isempty(era.psc(v,c).perievents) % of no trials occured
            era.psc_ds(v,c).perievents = []; 
            mean_ds(v,c,:) = NaN_filler;
            se_ds(v,c,:) = NaN_filler;
            
            continue;
        end
        
        clear perievents
        for t = 1:size(era.psc(v,c).perievents,2) % loop trials
            
            % binning
            y = era.psc(v,c).perievents(:,t); % select trial of psc
            y_short = y(1:(end - mod(numel(y),bin_size))); %dicarding left over trials
            psc(:,t) = mean(reshape(y_short(:),bin_size,[]))'; % binning
            
        end
        % psc downsampled
        era.psc_ds(v,c).perievents = psc;
        mean_ds(v,c,:) = mean(psc,2);
        se_ds(v,c,:) = sterr(psc,2,1);
   
        
    end
end

idx_bin = [1 zeros(1,bin_size-1)]; % aligned to first time point of bin
idx_timeaxis = [repmat(idx_bin,1,numel(y_short)./bin_size) zeros(1,mod(numel(y),bin_size))]; %repmating bin_idx and adding left over time points

era.timeaxis_ds = era.timeaxis(logical(idx_timeaxis));
era.mean_ds = mean_ds;
era.se_ds = se_ds;











