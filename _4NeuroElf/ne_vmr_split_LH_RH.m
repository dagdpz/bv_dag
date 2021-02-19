function ne_vmr_split_LH_RH(vmr_path)
% ne_vmr_split_LH_RH - splits vmr to left and right hemisphere vmrs

[pathstr, name] = fileparts(vmr_path);

lvmr=xff(vmr_path);
rvmr=xff(vmr_path);

rvmr.VMRData(:,:,rvmr.DimX/2+1:end) = 0;
lvmr.VMRData(:,:,1:lvmr.DimX/2+1) = 0;

if isempty(pathstr),
    prefix = name;
else
    prefix = [pathstr filesep name];
end

lvmr.SaveAs([prefix '_LH.vmr']);
rvmr.SaveAs([prefix '_RH.vmr']);
