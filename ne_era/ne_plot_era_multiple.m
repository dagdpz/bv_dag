function ne_plot_multiple_era(target_folder,file_type,varargin)

defpar = { ...
    'vtc_pattern', 'char', 'nonempty', '*.vtc'; ...		
    'prt_pattern', 'char', 'nonempty', '*.prt'; ...
};

if nargin > 5, % specified dynamic params
	params = checkstruct(struct(varargin{:}), defpar);
else
	params = checkstruct(struct, defpar); % take all default params
end

if nargin < 2,
	file_type = '*.dat';
end

ori_dir = pwd;

d = dir(target_folder,file_type);

n_files = length(d);

figure('Name',target_folder);

n_row = floor(sqrt(n_files));
n_col = n_row + rem(n_files,n_row);

cd(target_folder);

for k = 1:n_files,
	subplot(n_row,n_col,k);
	ne_plot_era_onefile(d(k).name,IsHuman,save_plots,open_fig,to_plot)
end

cd(ori_dir);