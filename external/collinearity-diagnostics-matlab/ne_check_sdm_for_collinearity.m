function info = ne_check_sdm_for_collinearity(sdm_fullpath,n_condition_indices,n_pred2plot)
% ne_check_sdm_for_collinearity('D:\MRI\Bacchus\20141106\Bacchus_2014-11-06_run01_task_BA_20141106_run01_MCparams_outlier_preds.sdm',5,8);
% ne_check_sdm_for_collinearity('Z:\MRI\Curius\20141017\DesignMatrix.txt',5,3);
% ne_check_sdm_for_collinearity(X,5,3); % X should be array with predictors as columns

if nargin < 2
	n_condition_indices = 10;
end

if ischar(sdm_fullpath),

	if strfind(sdm_fullpath,'.sdm'),
		sdm = xff(sdm_fullpath);
		X = sdm.SDMMatrix;
		labels = sdm.PredictorNames;
	elseif strfind(sdm_fullpath,'.txt'),
		X = load(sdm_fullpath, '-ascii');
		labels = textscan(num2str([1:size(X,2)]),'%s');
		labels = labels{1}';
	end
	
else
	X = sdm_fullpath;
	labels = textscan(num2str([1:size(X,2)]),'%s');
	labels = labels{1}';
end

% find non-zero predictors
idx_n0 = find(any(X,1));

% check that n_condition_indices and n_pred2plot are in the appropriate range:
% no more than the number of non-empty columns (predictors) in SDMMatrix

n_condition_indices	= min([n_condition_indices size(idx_n0,2)]);

if nargin < 3
	n_pred2plot     = length(idx_n0);
else
	n_pred2plot	= min([n_pred2plot length(idx_n0)]);
end


X = X(:,idx_n0);
labels = labels(idx_n0);

info = colldiag(X ,labels);


% colldiag_tableplot(info); % full plot, too much data if many predictors

% sort both condition_indices and predictors by relevance
colldiag_tableplot(info,1,n_condition_indices,1,n_pred2plot);

% sort only condition_indices by relevance
% colldiag_tableplot(info,1,n_condition_indices,0,n_pred2plot);