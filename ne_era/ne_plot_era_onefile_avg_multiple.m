function ne_plot_era_onefile_avg_multiple(target_folder,era_settings_id,avg_path,varargin)

% default parameters, for dynamic params (i.e. those params might change from session to session, even for same dataset)
defpar = { ...
	'plot_graphics', 'char', '', 'tc'; ... % '' | 'tc' | 'bars' | 'both'
	'open_figure', 'double', 'nonempty', 0; ...
	'save_figure', 'char',   '', ''; ... % '.png' | '.pdf' | '.ai' | '.eps'
	'file_type', 'char', 'nonempty', '*.dat'; ...
	};

if nargin > 3, % specified dynamic params
	params = checkstruct(struct(varargin{:}), defpar);
else
	params = checkstruct(struct, defpar); % take all default params
end

ori_dir = pwd;

d = dir([target_folder filesep params.file_type]);

n_files = length(d);

figure('Name',target_folder);

n_row = floor(sqrt(n_files));
n_col = n_row + rem(n_files,n_row);

cd(target_folder);

for k = 1:n_files,
	subplot(n_row,n_col,k);
	ne_plot_era_onefile_avg(d(k).name,era_settings_id,avg_path,params);
end

cd(ori_dir);