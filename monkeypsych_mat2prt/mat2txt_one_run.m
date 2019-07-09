function filename = mat2txt_one_run(mat_file)


% Load the data files
load('-mat', mat_file); % load as structures

nTrials = length(trial);
trialNumber = [trial.n];
taskType = [trial.type];
microstimStatus = [trial.microstim];
successStatus = [trial.success];
stateOnset = {trial.states_onset};
target_locations = task.conditions(:,4);

filename = strcat(mat_file(1:end-4), '_timing.txt');
fid = fopen(filename, 'w+');

for t = 1 : nTrials,
	
	trial_number = trialNumber(1,t);
	task_type = taskType(1,t);
	microstim = microstimStatus(1,t);
	success = successStatus(1,t);
	state_onset = stateOnset{1, t};
	
	if trial(t).condition == 1;
		target_location = target_locations(1,1);
	else if trial(t).condition == 2;
			target_location = target_locations(2,1);
		end
	end
	
	fprintf(fid, '%d', trial_number);
	fprintf(fid, '\t');
	fprintf(fid, '%d', task_type);
	fprintf(fid, '\t');
	fprintf(fid, '%d', microstim);
	fprintf(fid, '\t');
	fprintf(fid, '%d', success);
	fprintf(fid, '\t');
	fprintf(fid, '%d', target_location);
	fprintf(fid, '\t');
	fprintf(fid, '%d \t', round(state_onset*1000));
	fprintf(fid, '\t');
	fprintf(fid, '\n');
	
end

fclose(fid);