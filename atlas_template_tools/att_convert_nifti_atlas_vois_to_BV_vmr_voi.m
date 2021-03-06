function att_convert_nifti_atlas_vois_to_BV_vmr_voi(mat2load,subj)
%att_convert_nifti_atlas_vois_to_BV_vmr_voi - convert NIfTI vois exported by att_nifti_extract_all_nifti_vois_from_atlas to VMR and then to BV VOI
% can be followed by ne_combine_multiple_vois(findfiles(pwd,'*.voi'),'atlas_combined.voi');

if nargin < 1,
    mat2load  = '';
end

if nargin < 2,
    subj = '';
end

if 0 % Y:\Atlases\human\MNI_Glasser_HCP_2019_v1.0
    
    d = dir('*.nii');
    
    N = length(d);
    
    global n
    n = neuroelf;
    
    for k=1:N,
        vmr_path = ne_convert_MRIcron_nifti_voi_to_vmr(d(k).name,'','human');
        ne_convert_vmr_to_voi(vmr_path);
        
    end
end

if 0 % Y:\Atlases\human\HCP-MMP1.0 projected on MNI2009a GM (volumetric) in NIfTI format
    % not working, since labels in nii should be fixed by ceil(ni.VoxelData/(2*32768)) 
    
    d = dir('*.nii');
    
    N = length(d);
    
    global n
    n = neuroelf;
    
    for k=1:N,
        vmr_path = ne_convert_MRIcron_nifti_voi_to_vmr(d(k).name,'','human');
        ne_convert_vmr_to_voi(vmr_path);
        
    end
end

if 0 % Y:\Atlases\human\CerebrA
    d = dir('*_?.nii');
    
    N = length(d);
    
    global n
    n = neuroelf;
    
    for k=1:N,
        vmr_path = ne_convert_MRIcron_nifti_voi_to_vmr(d(k).name,'','human');
        ne_convert_vmr_to_voi(vmr_path);
        
    end
end

if 0 % Y:\Atlases\macaque\Calabrese2015\atlas_voi
    load civm_rhesus_v1_ontology.mat;
    
    N = length(ds.Value);
    
    global n
    n = neuroelf;
    
    for k=1:N,
        d = dir([num2str(ds.Value(k)) '_*.nii']);
        vmr_path = ne_convert_MRIcron_nifti_voi_to_vmr(d.name);
        ne_convert_vmr_to_voi(vmr_path,ceil(ds.rgb(k,:)*255));
        
    end
end

if 1 % Y:\Atlases\macaque\CHARM_SARM
    if ~isempty(mat2load)
        load(mat2load);
    else
        % load('Y:\Atlases\macaque\CHARM_SARM\CHARMds.mat');
        % load('Y:\Atlases\macaque\CHARM_SARM\SARMds.mat');
    end
    
    if isempty(subj)
        subj = 'NMT';
    end
    
    N = length(ds.Index);
    
    % global n
    % n = neuroelf;
    
    for k=1:N,
        d = dir([subj '_' num2str(ds.Index(k)) '-*.nii']);
        if ~isempty(d), % voi exists
            vmr_path = ne_convert_MRIcron_nifti_voi_to_vmr(d.name);
            ne_convert_vmr_to_voi(vmr_path);
        end
        
    end
end