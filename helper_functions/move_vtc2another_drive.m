function move_vtc2another_drive(basedir,new_basedir,makecopy,subj,vtc_pattern,runs)
% move_vtc2another_drive('D:\MRI\Curius\20140213','Z:\MRI\Curius\20140213',1)
% If you want to copy the files to the new directory: makecopy = 1
% If you want to move the files to the new directory: makecopy = 0

% Specify additional inputs subj and vtc_pattern if you want to look at a
% particular set of vtc files. Both inputs together define the common name of vtc
% files that you want to average. 
% Example: move_vtc2another_drive('D:\MRI\Curius\20140213','Z:\MRI\Curius\20140213',1,'CU_analysis2_*','*_mc_tf.vtc')
% Specify input argument runs if you want to look at particular runs only.
% Input numbers correspond to run numbers.
% Example: move_vtc2another_drive('D:\MRI\Curius\20140213','Z:\MRI\Curius\20140213',1,'CU_analysis2','mc_tf.vtc', [2 3])


if nargin < 4,
	subj = ''; % take all vtc
	
end
if nargin < 5,
	vtc_pattern = '*.vtc';
end
if nargin < 6,
	runs = [];
	
end


ori_dir = pwd;
cd(basedir);

d = dir;

idx = [];
for i = 1:length(d)
	if d(i).isdir && length(d(i).name) == 5,
		if strcmp(d(i).name(1:3),'run'),
			idx = [idx i];
		end
	end
end
d = d(idx);

if ~isempty(runs), % take only some runs
	d = d(runs);
end

if length(idx) > 0
	for i = 1:length(d)
		cd(d(i).name);
		dsub2 = dir([subj vtc_pattern]);
		
		if length(dsub2)>0
			for s2 = 1:length(dsub2)
				old_name = dsub2(s2).name;
				new_name = [new_basedir filesep d(i).name filesep old_name];
				if makecopy,
					[success,message] = copyfile(old_name,new_name);
					action = 'copied ';
				else
					[success,message] = ig_movefile(old_name,new_name);
					action = 'moved ';
				end
				
				if success
					disp([action old_name '->' new_name]);
				else
					disp(message);
				end
				
			end
		end
		cd ..
		
	end
end



cd(ori_dir);
disp([basedir ' processed']);
