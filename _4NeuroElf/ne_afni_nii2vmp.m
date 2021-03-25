function ne_afni_nii2vmp(nii_path,type,res,suffix,source_vmp_path)
% ne_afni_nii2vmp('test_vmp_NMT_Nwarp_res2.nii','t',2,'_test');
% ne_afni_nii2vmp('test_vmp_NMT_Nwarp_res2.nii','t',2,'_source','microstim-nomicrostim.vmp');

if nargin < 2,
    type = 't'; % t-map
end

if nargin < 3,
    res = 2;
end

if nargin < 4,
    suffix = '';
end

if nargin < 5,
    source_vmp_path = ''; % original vmp before afni processing
end


n = neuroelf;
vmp = n.importvmpfromspms(nii_path,type,[0 0 0; 255 255 255],res,'nearest');

if ~isempty(source_vmp_path), % copy source vmp data into new vmp
    
    source_vmp = xff(source_vmp_path);
    
    XStart  = vmp.XStart;
    XEnd    = vmp.XEnd;
    YStart  = vmp.YStart;
    YEnd    = vmp.YEnd;
    ZStart  = vmp.ZStart;
    ZEnd    = vmp.ZEnd;
    
    for m = 1:vmp.NrOfMaps,
        vmpData(m).VMPData = vmp.Map(m).VMPData;
    end    
        
    vmp.XStart  = XStart;
    vmp.XEnd    = XEnd;
    vmp.YStart  = YStart;
    vmp.YEnd    = YEnd;
    vmp.ZStart  = ZStart;
    vmp.ZEnd    = ZEnd;
    
    for m = 1:vmp.NrOfMaps,
        vmp.Map(m) = source_vmp.Map(m);
        vmp.Map(m).VMPData = vmpData(m).VMPData;
    end
    
    
end

vmp.SaveAs([nii_path(1:end-4) suffix '.vmp']);