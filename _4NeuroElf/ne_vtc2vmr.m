function ne_vtc2vmr(vtc_path)


vtc = xff(vtc_path);
vmr = vtc.CreateFuncVMR(1);
vmr.SaveAs([vtc_path(1:end-4) '.vmr']);



