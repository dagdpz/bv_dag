function numbers = ne_mdm_getSessionsRunsTrials(mdmpath, avgname, modelname)

mdm = xff(mdmpath);

sessions_runs = cellfun(@(x) x(strfind(x, '\2')+1:strfind(x, '\2')+8), mdm.XTC_RTC(:,1), 'UniformOutput',0);
sessions = unique(sessions_runs);

for s = 1:length(sessions)
    
    if nargin < 3
        avg = xff([mdm.XTC_RTC{s,1}(1:strfind(mdm.XTC_RTC{s,1}, '\2')) sessions{s} filesep avgname '.avg']);
    else
        avg = xff([mdm.XTC_RTC{s,1}(1:strfind(mdm.XTC_RTC{s,1}, '\2')) sessions{s} filesep modelname filesep avgname '.avg']);
    end
    
    avgc = avg.Curve;
    
    nrruns = cellfun(@(x) ~isempty(strfind(x, sessions{s})), sessions_runs);
    nrruns = sum(nrruns);
    
    numbers{s,1} = sessions{s};
    numbers{s,2} = nrruns;
    numbers{s,3} = {avgc.Name};
    numbers{s,4} = [avgc.NrOfConditionEvents];
    numbers{s,5} = sum(numbers{s,4});
end
