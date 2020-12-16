function era = ne_era_frd_downsample(era_file,bin_size)
% prerequisite: means + se's are already created


load(era_file); 

for v = 1:size(era.mean,1) % loop vois
    for c = 1:size(era.mean,2) % loop curves
        
        
        
        y = era.mean(v,c,:);
        y_short = y(1:(end - mod(numel(y),bin_size)));
        era.mean_ds(v,c,:) = mean(reshape(y_short(:),bin_size,[]));
        
        
        
        idx_bin = [1 zeros(1,bin_size-1)]; % aligned to first sample of bin
        idx_timeaxis = repmat(idx_bin,1,numel(y_short)./bin_size);
        era.timeaxis_ds(v,c,:) = era.timeaxis(logical([idx_timeaxis zeros(1,mod(numel(y),bin_size))]));


    end
end




