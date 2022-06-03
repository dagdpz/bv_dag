function ne_msk_invert(mask_path)


msk = xff(mask_path);

ind1 = find(msk.Mask>0);
ind0 = find(msk.Mask==0);


msk.Mask(ind1) = 0;
msk.Mask(ind0) = 1;

msk.SaveAs([mask_path(1:end-4) '_inverted.msk']);



