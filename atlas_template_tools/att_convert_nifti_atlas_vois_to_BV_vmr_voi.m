function att_convert_nifti_atlas_vois_to_BV_vmr_voi
%att_convert_nifti_atlas_vois_to_BV_vmr_voi - convert NIfTI vois exported by att_nifti_extract_all_nifti_vois_from_atlas to VMR and then to BV VOI
% can be followed by ne_combine_multiple_vois(findfiles(pwd,'*.voi'),'atlas_combined.voi');


if 1 % Y:\Atlases\human\HCP-MMP1.0 projected on MNI2009a GM (volumetric) in NIfTI format
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

if 0 % Y:\Atlases\macaque\CHARM, Y:\Atlases\macaque\SARM
    load SARMds.mat; % or CHARMds.mat
    
    N = length(ds.Index);
    
    global n
    n = neuroelf;
    
    for k=1:N,
        d = dir([num2str(ds.Index(k)) '_*.nii']);
        vmr_path = ne_convert_MRIcron_nifti_voi_to_vmr(d.name);
        ne_convert_vmr_to_voi(vmr_path);
        
    end
end