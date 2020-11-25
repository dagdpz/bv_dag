function [FileVersion,NrOfCurves,StdDevErrs,NrOfCurveDataPoints,CurveName,TimeCourseThick,TimeCourseColorR,TimeCourseColorG,TimeCourseColorB,StdDevErrThick,StdDevErrColorR,StdDevErrColorG,StdDevErrColorB,NrOfSegIntervals,SegInt,data1,data2,n_trials] = ne_read_era(fname,ra,curves2plot)
dbstop if error

if nargin < 2,
	ra = 0; % don't use response amplitude
end
if nargin < 3,
	curves2plot = []; % read all curves
end

if ~isempty(findstr(fname,'.mat')), % mat file from ***_compute_blockwise_MRI.m
	
	load(fname); 
	
	FileVersion = 'mat1';
	NrOfCurves = size(allsessions(1).mean,1);
	cmap = 255*pulv_inj_colormap(NrOfCurves);
	StdDevErrs = 1;
	for i = 1:NrOfCurves,
		NrOfCurveDataPoints(i)	= size(allsessions(1).mean,2);
		TimeCourseThick(i)	= 3;
		TimeCourseColorR(i)	= cmap(i,1);
		TimeCourseColorG(i)	= cmap(i,2);
		TimeCourseColorB(i)	= cmap(i,3);
		StdDevErrThick(i)	= 2;
		StdDevErrColorR(i)	= cmap(i,1);
		StdDevErrColorG(i)	= cmap(i,2);
		StdDevErrColorB(i)	= cmap(i,3);
		NrOfSegIntervals(i)	= NaN;
		SegInt(i)		= NaN;
		
		if ra
			data1(:,i) = grand_era(i).ra_mean;
			data2(:,i) = grand_era(i).ra_se;
			NrOfCurveDataPoints(i) = 1;
			
		else
			
			data1(:,i) = grand_era(i).mean;
			data2(:,i) = grand_era(i).se;
		end
		n_trials(i) = grand_era(i).n;
	end

	
	
else % dat file exported from BV
	
	
	fid=fopen(fname,'r+');
	
	
	FileVersion 	= read_line(fid, 'FileVersion',1);
	FileVersion = str2num(FileVersion);
	
	if FileVersion == 1,
% 		NrOfCurves      = read_line(fid, 'NrOfCurves');
% 		fgetl(fid);
% 		StdDevErrs      = read_line(fid, 'StdDevErrs');
% 		
% 		for i = 1:NrOfCurves
% 			NrOfCurveDataPoints_	= fgetl(fid); NrOfCurveDataPoints(i) = str2num(NrOfCurveDataPoints_(20:end)); % foocking special case
% 			TimeCourseThick(i)	= read_line(fid, 'TimeCourseThick');
% 			TimeCourseColorR(i)	= read_line(fid, 'TimeCourseColorR');
% 			TimeCourseColorG(i)	= read_line(fid, 'TimeCourseColorG');
% 			TimeCourseColorB(i)	= read_line(fid, 'TimeCourseColorB');
% 			StdDevErrThick(i)	= read_line(fid, 'StdDevErrThick');
% 			StdDevErrColorR(i)	= read_line(fid, 'StdDevErrColorR');
% 			StdDevErrColorG(i)	= read_line(fid, 'StdDevErrColorG');
% 			StdDevErrColorB(i)	= read_line(fid, 'StdDevErrColorB');
% 			NrOfSegIntervals(i)	= read_line(fid, 'NrOfSegIntervals');
% 			for j = 1:NrOfSegIntervals(i)
% 				SegInt(j).int	= str2num(fgetl(fid));
% 				SegInt(j).rgb	= str2num(fgetl(fid));
% 			end
% 			fgetl(fid); % <data>
% 			for k = 1:NrOfCurveDataPoints(i),
% 				fd  = fgetl(fid);
% 				if ~isempty(findstr(fd,'#')),
% 					i_space = findstr(fd,' ');
% 					fd = [fd(1:i_space(1)) '  0.0'];
% 				end
% 				d = str2num(fd);
% 				data1(k,i) = d(1);	% data
% 				data2(k,i) = d(2);	% error bars
% 			end
% 			fgetl(fid); % <data>
% 			fgetl(fid);
% 		end % for each curve
		
	elseif FileVersion == 2,
		
		fgetl(fid);
		NrOfCurves      = read_line(fid, 'NrOfCurves');
		fgetl(fid);
		StdDevErrs      = read_line(fid, 'StdDevErrs');
		
		for i = 1:NrOfCurves
			temp = fgetl(fid);
			temp = strrep(temp,'"','');
			CurveName{i} = temp(31:end);
			NrOfCurveDataPoints(i)  = read_line(fid, 'NrOfCurveDataPoints');
			TimeCourseThick(i)	= read_line(fid, 'TimeCourseThick');
			TimeCourseColorR(i)	= read_line(fid, 'TimeCourseColorR');
			TimeCourseColorG(i)	= read_line(fid, 'TimeCourseColorG');
			TimeCourseColorB(i)	= read_line(fid, 'TimeCourseColorB');
			StdDevErrThick(i)	= read_line(fid, 'StdDevErrThick');
			StdDevErrColorR(i)	= read_line(fid, 'StdDevErrColorR');
			StdDevErrColorG(i)	= read_line(fid, 'StdDevErrColorG');
			StdDevErrColorB(i)	= read_line(fid, 'StdDevErrColorB');
			for r = 1:9, fgetl(fid); end;
			NrOfSegIntervals(i)	= read_line(fid, 'NrOfSegIntervals');
            if NrOfSegIntervals(i) > 0
                for j = 1:NrOfSegIntervals(i)
                    SegInt(j).int	= str2num(fgetl(fid));
                    SegInt(j).rgb	= str2num(fgetl(fid));
                end
            else SegInt = [];
            end
			fgetl(fid); % <data>
			for k = 1:NrOfCurveDataPoints(i),
				fd  = fgetl(fid);
				if ~isempty(findstr(fd,'#')),
					i_space = findstr(fd,' ');
					fd = [fd(1:i_space(1)) '  0.0'];
				end
				d = str2num(fd);
				data1(k,i) = d(1);	% data NrOfCurveDataPoints X NrOfCurves
				data2(k,i) = d(2);	% error bars
			end
			fgetl(fid); % <data>
			fgetl(fid);
		end % for each curve
		
		
	end
	n_trials(1:NrOfCurves) = deal(NaN);
	fclose(fid);
	
end

if ~isempty(curves2plot), % include only certain curves
		NrOfCurveDataPoints = NrOfCurveDataPoints(curves2plot);
                CurveName = CurveName(curves2plot);
		TimeCourseThick = TimeCourseThick(curves2plot);
		TimeCourseColorR = TimeCourseColorR(curves2plot);
		TimeCourseColorG = TimeCourseColorG(curves2plot);
		TimeCourseColorB = TimeCourseColorB(curves2plot);
		StdDevErrThick = StdDevErrThick(curves2plot);
		StdDevErrColorR = StdDevErrColorR(curves2plot);
		StdDevErrColorG = StdDevErrColorG(curves2plot);
		StdDevErrColorB = StdDevErrColorB(curves2plot);
		NrOfSegIntervals = NrOfSegIntervals(curves2plot);
		SegInt = SegInt(curves2plot);
		n_trials = n_trials(curves2plot);
		data1 = data1(:,curves2plot);
		data2 = data2(:,curves2plot);
		NrOfCurves = length(curves2plot);
end


function value = read_line(fid, name, isstring)
% read line in format "name: value"
if nargin < 3,
	isstring = 0;
end
l = fgetl(fid);
value = l(length(name)+3:end);
if ~isstring,
	value = str2num(value);
end
