function [outliers, DVARS_Stat] = ne_DVARS_outlier_detection(Y,psig)


if nargin < 2
    psig = 5; % Practically significan threshold
end


[DVARS,DVARS_Stat]=DVARSCalc(Y,'verbose',0);

% [V,DSE_Stat]=DSEvars(Y);

% significant outliers
Idx     =   find(DVARS_Stat.pvals<0.05./(DVARS_Stat.dim(2)-1));
 
pIdx = find(DVARS_Stat.DeltapDvar>psig);
pIdx = intersect(Idx,pIdx); %only if they are statistically sig as well!

outliers = pIdx + 1;
