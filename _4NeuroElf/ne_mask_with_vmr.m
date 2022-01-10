function ne_mask_with_vmr(filelist, vmr_mask_path)

if ischar(filelist),
   filelist = {filelist};
end

vmr_mask = xff(vmr_mask_path);

for f = 1:length(filelist);
    obj_path = filelist{f};
    obj = xff(obj_path);
    obj.MaskWithVMR(vmr_mask);
    obj.SaveAs([obj_path(1:end-4) '_masked' obj_path(end-3:end)]);
    obj.ClearObject;
end



