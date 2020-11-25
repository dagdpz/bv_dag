function ne_mdm_check_files(mdm_path)
% check if files in mdm exist

mdm = xff(mdm_path);

n_runs = size(mdm.XTC_RTC,1);

for r = 1:n_runs,
    
    for c = 1:2,
        if ~exist(mdm.XTC_RTC{r,c},'file'),
            disp([mdm.XTC_RTC{r,c} ' is not found']);
        end
    end
end
