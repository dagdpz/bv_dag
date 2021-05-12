function ne_era_frd_count_trials_of_eras
% this function finds the real amount of trials per condition per subject
% and writes it into an excel sheet at the location of runpath


load('Y:\MRI\Human\fMRI-reach-decision\Experiment\behavioral_data\protocols_v2.mat');
runpath = 'Y:\MRI\Human\fMRI-reach-decision\Experiment\MNI';
%runpath = 'Y:\MRI\Human\fMRI-reach-decision\Experiment\testground\test averaging era subjects';


trigger = {'cue', 'mov'}; % is different because less extracted data points for cue aligned trials (no move period) (see creation of era files from mdm) 
delay = {'3','6','9','12','15','average'};
voi_side = 'lh'; % is the same for left hemisphere as right h
era_outliers = '_no_outliers'; % ''

eff = {'reach' 'sac'};
choi = {'choi' 'instr'};
side = {'l', 'r'};


%%
n_trials = [];
for i = 1:length(prot)
    nu = 1;
    for d = 1:length(delay)
        for t = 1:length(trigger)
            
            % get one era file
            era_file = [runpath filesep prot(i).name filesep 'mat2prt_reach_decision_vardelay_foravg' filesep prot(i).name '_era_' trigger{t} '_' delay{d} '_' voi_side era_outliers '.mat'];
            
            load(era_file);

            for c = 1:length(era.avg.Curve) 
                
                if i == 1
                    cond_name{nu} = era.avg.Curve(c).Name;
                    if d == 6
                        name_parts = strsplit(era.avg.Curve(c).Name,'_');
                        cond_name{nu} = [name_parts{1} '_' name_parts{2} '_' name_parts{3} '_' delay{d} '_' name_parts{5}];
                    end
                end
                
                n_tr(nu) = size(era.psc(1,c).perievents,2);
                
                nu = nu+1;
            end
        end
    end
    
    n_trials = [n_trials n_tr'];
 
end
    
n_trials_table = array2table(n_trials);
n_trials_table.Properties.VariableNames = {prot.name};
n_trials_table.cond_name = cond_name';

% get var names per condition and write in table
for i = 1:length(cond_name)

    name_parts = strsplit(cond_name{i},'_');
    c_eff{i} = name_parts{1};
    c_choi{i} = name_parts{2};
    c_side{i} = name_parts{3};
    c_delay{i} = name_parts{4};
    c_trigger{i} = name_parts{5};
end

n_trials_table.effector = c_eff';
n_trials_table.choi_instr = c_choi';
n_trials_table.side = c_side';        
n_trials_table.delay = c_delay';        
n_trials_table.trigger = c_trigger';   

% write xlsx

writetable(n_trials_table,[runpath filesep 'n_trials_of_era.xlsx']);

disp('done');

        
        
        

