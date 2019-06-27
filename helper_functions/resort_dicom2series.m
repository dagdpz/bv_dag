function resort_dicom2series(dicom_dir,varargin)
% resort dicom files: one series -> one folder
% e.g. resort_dicom2series('D:\MRI\Curius\20130130\uncombined')
% Igor Kagan, 20130131


%%
ori_dir = pwd;
cd(dicom_dir);
d = dir;

disp('Resorting to different series, please wait...');
if isempty(strfind(d(3).name,'-')), % numeric file names without series number
	disp('Detected numeric file names without series number, using DICOM header');
	for k=3:length(d),
		
		info = dicominfo(d(k).name);
		series_num(k-2) = info.SeriesNumber;
		% tag each file with its series
		movefile(d(k).name,[sprintf('series%04d_',series_num(k-2)) d(k).name]);
		
	end
	unique_series_num = unique(series_num);
	for k=1:length(unique_series_num),
		disp(sprintf('Creating %04d',unique_series_num(k)));
		mkdir(dicom_dir,sprintf('%04d',unique_series_num(k)));
		movefile(sprintf('series%04d_*',unique_series_num(k)),sprintf('%04d',unique_series_num(k)));
	end
	
else % subj-series-volume/slice format

    % if number of characters in DICOM file names is equal across files
	names = cell2mat({d(3:end).name}'); % IK
    
    % if number of characters in DICOM file names differs between files
%     tempnames = {d(3:end).name}'; % LG
%     tempnames = cellfun(@(x) x(1:14), tempnames, 'UniformOutput',0); % LG
%     names = cell2mat(tempnames); % LG
    
	div_idx = strfind(names(1,:),'-');
    if numel(div_idx) == 2
        ser = names(:,div_idx(1)+1:div_idx(2)-1); % UMG
        filepattern = '*-%s-*';
    elseif numel(div_idx) == 3
        ser = names(:,div_idx(2)+1:div_idx(3)-1); % DZP
        filepattern = '*-*-%s-*';
    else disp('ERROR: unknown dicom naming')
        return
    end
    
	unique_series_num = unique(ser,'rows');
	for k=1:length(unique_series_num),
		disp(sprintf('Creating %s',unique_series_num(k,:)));
		mkdir(dicom_dir,sprintf('%s',unique_series_num(k,:)));
        movefile(sprintf(filepattern,unique_series_num(k,:)),sprintf('%s',unique_series_num(k,:)));
	end
	
end
	
	

cd(ori_dir);
