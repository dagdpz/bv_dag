function ne_pl_create_vtcs_bv(pathname,isjavascript,anat_special,fmr_pattern,IsHuman,InTal)
% for human data in TAL
% ne_pl_create_vtcs_bv('Z:\MRI\Human\RIME\20140313',1,'','*tf.fmr',1,1)

if nargin < 2,
	isjavascript = 1; % 1 - javascript, 2 - via BV COM
end
if nargin < 3,
	anat_special = '';
end
if nargin < 4,
	fmr_pattern = '*c.fmr';
end
if nargin < 5,
	IsHuman = 0;
end
if nargin < 6,
	InTal 	= 0;
end

if IsHuman
	settings.resolution             = 3;
	settings.interpolation_method   = 1;
	settings.intensity_threshold    = 100;
else
	settings.resolution             = 2;
	settings.interpolation_method   = 1;
	settings.intensity_threshold    = 1000;
end

ini_path = cd;

cd(pathname);


if isjavascript % new version for BV 2.x and javascript
		
	head_str            = ['var session_path = "' strrep(pathname,'\','/') '/";' sprintf('\n') ];
    session_path        = [strrep(pathname,'\','/') '/']; % for BV COM
		
	
	runs_str            = ['var run_path = new Array(n_runs);' sprintf('\n') 'var fmr = new Array(n_runs)' sprintf('\n') 'var vtc = new Array(n_runs);' sprintf('\n')];
	
	run_path_str        = [];
	fmr_str             = [];
	trf_str             = [];
	vtc_str             = [];
	acpc_str	    = [];
	tal_str		    = [];
	
	head_str = [head_str sprintf('\n')];
	
	d = dir;
	k = 1;
	
	for i = 1:length(d),
		
		if d(i).isdir && strcmp(d(i).name,'anat'),
			cd(d(i).name);
			
			
			if ~isempty(anat_special),
				anat_str = ['anat = "' strrep(anat_special,'\','/') '";' sprintf('\n\n')];
				anat = strrep(anat_special,'\','/'); % for BV COM
			else
				
				anat = dir('*ACPC.vmr');
			
			
				if ~isempty(anat),
					anat_str = ['anat = "' strrep(pathname,'\','/') '/anat/' anat.name '";' sprintf('\n\n')];
                    anat = [strrep(pathname,'\','/') '/anat/' anat.name]; % for BV COM

				else
					disp('ERROR: No *.ACPC.vmr found in anat');
					cd(ini_path);
					return;
				end
				
			end
			
			if InTal,
				tal = dir('*.tal');
				if ~isempty(tal),
					tal_str = ['talFile = "' tal.name '";' sprintf('\n\n')];
				end
				acpc = dir('*ACPC.trf');
				if ~isempty(acpc),
					acpc_str = ['acpcFile = "' acpc.name '";' sprintf('\n\n')];
				end
				
				
			end
			
			cd ..
			
		elseif d(i).isdir && isempty(findstr(d(i).name,'images')) && ~strcmp(d(i).name,'.') && ~strcmp(d(i).name,'..')  && ~strcmp(d(i).name,'combined') && ~strncmp(d(i).name,'prtrtc',6),
			cd(d(i).name);
			fmr_ = dir(fmr_pattern);
			if ~isempty(fmr_),
				run_path_str    = [ run_path_str sprintf('\n') 'run_path[' num2str(k-1) ']="' d(i).name '";' ];
				fmr_str         = [ fmr_str sprintf('\n') 'fmr[' num2str(k-1) ']="' fmr_(1).name '";' ];
				vtc_str         = [ vtc_str sprintf('\n') 'vtc[' num2str(k-1) ']="' fmr_(1).name(1:end-3) 'vtc";' ];
                
                % for BV COM
                run_path{k} = d(i).name;
                fmr{k} = fmr_(1).name;
                vtc{k} = [fmr_(1).name(1:end-3) 'vtc'];
                % end for BV COM
                
				k = k + 1;
			end
			
			trf_ = dir('*.trf');
			if ~isempty(trf_),
				trf_str    = [sprintf('\n\n') 'trf="' trf_(1).name(1:end-6) '";' sprintf('\n')]; % without IA/FA.trf
                trf = trf_(1).name(1:end-6); % for BV COM
			end
			
			cd ..
			
		end
		
	end
	
	head_str = [sprintf('\nvar n_runs = %d;\n\n',k-1) head_str]; % update number of runs
	disp('');
	disp('');
	disp('// SET SESSION-SPECIFIC PARAMETERS	');
	if IsHuman,
		disp([head_str anat_str tal_str acpc_str runs_str  run_path_str sprintf('\n') fmr_str trf_str vtc_str sprintf('\n\nHumanCreateVTC();')]);	
	else
		disp([head_str anat_str runs_str run_path_str sprintf('\n') fmr_str trf_str vtc_str sprintf('\n\nSimianCreateVTC();')]);
    end
    disp('// END SET SESSION-SPECIFIC PARAMETERS	');
    
    if isjavascript == 2, % via BV COM, implemented for monkeys
        disp('Running BV COM!!!');
            
        bv = actxserver('BrainVoyagerQX.BrainVoyagerQXScriptAccess.1');
        n_runs = k - 1;
        
        SimianCreateVTC(bv,n_runs,session_path,anat,run_path,fmr,trf,vtc,settings);
        
    end

    
else % older version for Caltech data and BrainVoyager 1.x
	
	
	settings_str = sprintf('\nvar resolution = %d;\nvar interpolation_method = %d;\nvar intensity_threshold = %d;\n', settings.resolution, settings.interpolation_method, settings.intensity_threshold);
	
	head_str            = ['var session_path = "' strrep(pathname,'\','/') '/";' sprintf('\n') ];
	
	runs_str            = ['var run_path = new Array(n_runs);' sprintf('\n') 'var fmr = new Array(n_runs)' sprintf('\n') 'var vtc = new Array(n_runs);' sprintf('\n')];
	
	run_path_str        = [];
	fmr_str             = [];
	trf_str             = [];
	vtc_str             = [];
	acpc_str	    = [];
	tal_str		    = [];
	
	head_str = [head_str sprintf('\n')];
	
	d = dir;
	k = 1;
	
	for i = 1:length(d),
		
		if d(i).isdir && strcmp(d(i).name,'anat'),
			cd(d(i).name);
			
			anat = dir('*ACPC.vmr');
			
			if ~isempty(anat),
				anat_str = ['anat = "' anat.name '";' sprintf('\n\n')];
				
			else
				disp('ERROR: No *.ACPC.vmr found in anat');
				cd(ini_path);
				return;
			end
			
			if InTal,
				tal = dir('*.tal');
				if ~isempty(tal),
					tal_str = ['talFile = "' tal.name '";' sprintf('\n\n')];
				end
				acpc = dir('*ACPC.trf');
				if ~isempty(acpc),
					acpc_str = ['acpcFile = "' acpc.name '";' sprintf('\n\n')];
				end
				
				
			end
			
			cd ..
			
		elseif d(i).isdir && isempty(findstr(d(i).name,'images')) && ~strcmp(d(i).name,'.') && ~strcmp(d(i).name,'..')  && ~strcmp(d(i).name,'combined') && ~strncmp(d(i).name,'prtrtc',6),
			cd(d(i).name);
			fmr = dir(fmr_pattern);
			if ~isempty(fmr),
				run_path_str    = [ run_path_str sprintf('\n') 'run_path[' num2str(k-1) ']="' d(i).name '";' ];
				fmr_str         = [ fmr_str sprintf('\n') 'fmr[' num2str(k-1) ']="' fmr(1).name '";' ];
				vtc_str         = [ vtc_str sprintf('\n') 'vtc[' num2str(k-1) ']="' fmr(1).name(1:end-3) 'vtc";' ];
				
				k = k + 1;
			end
			
			trf = dir('*.trf');
			if ~isempty(trf),
				trf_str    = [sprintf('\n\n') 'trf="' trf(1).name(1:end-6) '";' sprintf('\n')]; % without IA/FA.trf
			end
			
			cd ..
			
		end
		
	end
	head_str = [sprintf('\n var n_runs = %d;\n\n',k-1) head_str]; % update number of runs
	disp('');
	disp('');
	disp('// SET SESSION-SPECIFIC PARAMETERS	');
	disp([settings_str head_str anat_str tal_str acpc_str runs_str run_path_str sprintf('\n') fmr_str trf_str vtc_str sprintf('\n')]);
	disp('// END SET SESSION-SPECIFIC PARAMETERS	');
end

cd(ini_path);


function SimianCreateVTC(bv,n_runs,session_path,anat,run_path,fmr,trf,vtc,settings)

dataType = 1;
resolution = settings.resolution;
interpolation_method = settings.interpolation_method;
intensity_threshold = settings.intensity_threshold;

docVMR = bv.OpenDocument(anat);
docVMR.ExtendedTALSpaceForVTCCreation = false;
docVMR.UseBoundingBoxForVTCCreation = true;

% % Florian lPULVcan3
% docVMR.TargetVTCBoundingBoxXStart = 66;
% docVMR.TargetVTCBoundingBoxYStart = 80;
% docVMR.TargetVTCBoundingBoxZStart = 78; 
% docVMR.TargetVTCBoundingBoxXEnd =  190;
% docVMR.TargetVTCBoundingBoxYEnd =  220;
% docVMR.TargetVTCBoundingBoxZEnd =  140;
% 
% % Redrik lPULVcan1
% docVMR.TargetVTCBoundingBoxXStart = 66;
% docVMR.TargetVTCBoundingBoxYStart = 70;
% docVMR.TargetVTCBoundingBoxZStart = 75; 
% docVMR.TargetVTCBoundingBoxXEnd = 190;
% docVMR.TargetVTCBoundingBoxYEnd = 220;
% docVMR.TargetVTCBoundingBoxZEnd = 137;
% 
% % Redrik rLIPcan1
% docVMR.TargetVTCBoundingBoxXStart = 66;
% docVMR.TargetVTCBoundingBoxYStart = 70;
% docVMR.TargetVTCBoundingBoxZStart = 75; 
% docVMR.TargetVTCBoundingBoxXEnd = 190;
% docVMR.TargetVTCBoundingBoxYEnd = 220;
% docVMR.TargetVTCBoundingBoxZEnd = 137;
% 
% % Curius microstim
% docVMR.TargetVTCBoundingBoxXStart = 70;
% docVMR.TargetVTCBoundingBoxYStart = 55;
% docVMR.TargetVTCBoundingBoxZStart = 70; 
% docVMR.TargetVTCBoundingBoxXEnd = 190;
% docVMR.TargetVTCBoundingBoxYEnd = 225;
% docVMR.TargetVTCBoundingBoxZEnd = 166;

% Hanuman 2decide
docVMR.TargetVTCBoundingBoxXStart = 70;
docVMR.TargetVTCBoundingBoxYStart = 50;
docVMR.TargetVTCBoundingBoxZStart = 80; 
docVMR.TargetVTCBoundingBoxXEnd = 189;
docVMR.TargetVTCBoundingBoxYEnd = 224;
docVMR.TargetVTCBoundingBoxZEnd = 134;

for i=1:n_runs,  
		docVMR.CreateVTCInVMRSpace([session_path run_path{i} '/' fmr{i}],  [session_path run_path{1} '/' trf 'IA.trf'], ...
                                                                           [session_path run_path{1} '/' trf 'FA.trf'], ...
                                                                           [session_path run_path{i} '/' vtc{i}], dataType,resolution, interpolation_method, intensity_threshold);
end
	
docVMR.Close();	

