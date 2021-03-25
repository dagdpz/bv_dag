function ne_voi_apply_cmap(voi_path,map_name)
% ne_voi_apply_cmap('Y:\Atlases\macaque\NMT_v2\NMT_v2.0_sym\BV_NE\CHARM\level_6\level_6_l.voi','jet');
% ne_voi_apply_cmap('Y:\Atlases\macaque\NMT_v2\NMT_v2.0_sym\BV_NE\CHARM\level_6\level_6_r.voi','jet');

voi = xff(voi_path);
N = voi.NrOfVOIs;

eval(sprintf('cmap = %s(N);',map_name));
    
for k = 1:N,
    voi.VOI(k).Color = fix(255*cmap(k,:)); 
end

voi.SaveAs(voi_path);
disp(['Saved modified ' voi_path]);