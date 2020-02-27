function ne_pl_qa(session_path, fmr_fullpath, run_name, session_settings_id)
% uses neuroelf fmriquality or other methods to run QA and get (motion) outlier volumes

run('ne_pl_session_settings');
[dummy,name] = fileparts(fmr_fullpath);

switch settings.fmr_quality.outlier_detection_method
	
	case 'ne_fmriquality_method'
		if strcmp('0.9c',neuroelf_version),
			[fq, ~] = ne_fmriquality(fmr_fullpath,settings.fmr_quality);
		else
			netools = neuroelf;
			[fq, ~] = netools.fmriquality(fmr_fullpath,settings.fmr_quality); % no custom n_sd settings implemented yet
		end
% 		[fq, ~] = ne_fmriquality(fmr_fullpath,settings.fmr_quality); % modified from original neuroelf function
 		ne_pl_fmriqasheet(fq,settings.fmr_quality); % modified from original neuroelf function
		outlier_volumes = find([fq.Quality.Outliers.Volumes >= settings.fmr_quality.outlier_detection_threshold])';	
		
	case 'ne_fmriquality_TC_Quality2_method'
		if strcmp('0.9c',neuroelf_version),
			[fq, ~] = fmriquality(fmr_fullpath,settings.fmr_quality);
		else
			netools = neuroelf;
			[fq, ~] = netools.fmriquality(fmr_fullpath,settings.fmr_quality);
		end
		% modified from original neuroelf function
		[gsh, outlier_volumes] = ne_pl_fmriqasheet(fq,settings.fmr_quality);
		
		% add neighboring volumes to outliers
		outlier_volumes = add_neighboring_volumes(outlier_volumes,settings.fmr_quality.reject_volumes_before_after_outlier,length(fq.TC.Quality)); 
		
	case 'ne_framewise_disp'
		if strcmp('0.9c',neuroelf_version),
			[fq, ~] = fmriquality(fmr_fullpath,settings.fmr_quality);
		else
			netools = neuroelf;
			[fq, ~] = netools.fmriquality(fmr_fullpath,settings.fmr_quality);
		end
		
		MoCoSDM = [session_path filesep name '_MCparams.sdm'];
		if exist(MoCoSDM,'file'),
			[outlier_volumes, fq.FD] = ne_FD_outlier_detection(MoCoSDM, settings.fmr_quality.fd_cutoff, settings.fmr_quality.fd_radius);
			outlier_volumes = add_neighboring_volumes(outlier_volumes,settings.fmr_quality.reject_volumes_before_after_outlier,fq.Dims(4));
		end
		[gsh] = ne_pl_fmriqasheet(fq,settings.fmr_quality);
		
	case 'ne_fmriquality_TC_custom_method'
		% use a custom function
	
		
	case 'one_slice_ROI'
		[fq, outlier_volumes] = ne_pl_run_qa(run_path,n_slice,n_slices,n_skip, chan,analyze_tc,settings.fmr_quality);
		
			
end

if isfield(settings.fmr_quality,'plot_events'),
    prt_fullpath = findfiles(session_path,['*' run_name '.prt']);    
    if ~isempty(prt_fullpath),
        ax = findobj(get(gsh,'Children'),'Tag','TC volumes'); 
        if ~isempty(ax) % activate TC volumes axes
            ne_add_prt_condition_2tc(prt_fullpath{1},settings.fmr_quality.plot_events,'volumes',settings.fmr_create.TR);
        end
        ax = findobj(get(gsh,'Children'),'Tag','FD volumes');
        if ~isempty(ax),
            axes(ax); % activate TC volumes axes
            ne_add_prt_condition_2tc(prt_fullpath{1},settings.fmr_quality.plot_events,'volumes',settings.fmr_create.TR);
        end    
    end
end

% previous version for monkey fMRI - now obsolete, use the approach above
if 0 % add reward markers
	axes(findobj(get(gsh,'Children'),'Tag','TC volumes')); % activate TC volumes axes
	prt_fullpath = findfiles(session_path,['*' run_name '.prt']);
	if ~isempty(prt_fullpath),
		ne_add_prt_condition_2tc(prt_fullpath{1},'reward','volumes',settings.fmr_create.TR);
	end
end
	
% save *_outlier_volumes.mat
% use "SDMMatrix_2" and "PredictorNames_2" names to conform to expectations of ne_add_pred2sdm
PredictorNames_2 = '';
SDMMatrix_2 = zeros(fq.Dims(4),length(outlier_volumes));
for v = 1:length(outlier_volumes)
	SDMMatrix_2(outlier_volumes(v),v)=1;
	PredictorNames_2{v} = sprintf('ov%d',outlier_volumes(v));
end



save([session_path filesep name '_outlier_volumes.mat'],'outlier_volumes','SDMMatrix_2','PredictorNames_2','settings','fq','fmr_fullpath');

orient('tall');
saveas(gcf, [session_path filesep name '_QA'  '.pdf'], 'pdf');
close(gcf);

disp(['fmriquality for ' [fmr_fullpath ' completed']]);


function out = add_neighboring_volumes(in,ba,n_vol)
% in		- original volumes
% ba		- add before and after each volume
% n_vol		- max number of volumes

in = in(:)'; % make sure "in" is row

out = sort(unique(cell2mat(arrayfun(@colon,in-ba(1),in+ba(2),'Uniform', false))));
% out = sort(unique(reshape(o,1,size(o,1)*size(o,2)))); % only need to reshape if "in" is a column
out = out(out>0 & out<n_vol);

