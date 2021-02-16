function Xz = z_score(X)
%does the same thing zscore does, but can be used on cells
if iscell(X)
    Xz = {};
    for i = 1:length(X)
        m = repmat(mean(X{i}), size(X{i},1),1);
        sd = repmat(std(X{i}), size(X{i},1),1);
        Xz{i} = (X{i}-m)./sd;
    end
else
    m = repmat(mean(X), size(X,1),1);
    sd = repmat(std(X), size(X,1),1);
    Xz = (X-m)./sd;
end