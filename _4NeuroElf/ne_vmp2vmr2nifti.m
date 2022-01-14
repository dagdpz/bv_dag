function ne_vmp2vmr2nifti(vmp_path,vmr_path,resample2vmr,suffix)

if nargin < 3,
    resample2vmr = 0;
end

if nargin < 4,
    suffix ='';
end


map_index = 1;

vmp = xff(vmp_path);
vmr = xff(vmr_path);



if resample2vmr % Resample VMP to VMR (1x1x1)
    hvmp = vmp.MakeHiResVMP;
end

% Use (otherwise empty) vmr to keep a vmp map

vmr.VMRData = vmr.VMRData*0;
vmr.VMRData(vmp.XStart+1:vmp.XEnd, ...
            vmp.YStart+1:vmp.YEnd, ...
            vmp.ZStart+1:vmp.ZEnd) = vmp.Map(map_index).VMPData; %permute(map_data,[2, 3, 1]); % Y Z X 
        
% map_data = vmp.Map(map_index).VMPData;

% if resample2vmr % Resample VMP to VMR
%     
%     nx = vmp.XEnd - vmp.XStart;
%     ny = vmp.YEnd - vmp.YStart;
%     nz = vmp.ZEnd - vmp.ZStart;
%     [x, y, z]= ndgrid(linspace(1, size(map_data, 1), nx), ...
%         linspace(1, size(map_data, 2), ny), ...
%         linspace(1, size(map_data, 3), nz));
%     map_data = interp3(map_data, x, y, z, 'bicubic');
% end

% % Use (otherwise empty) vmr to keep a vmp map
% vmr.VMRData = vmr.VMRData*0;
% vmr.VMRData(vmp.XStart:vmp.XEnd-1, ...
%             vmp.YStart:vmp.YEnd-1, ...
%             vmp.ZStart:vmp.ZEnd-1) = map_data;
        
% vmr.SaveAs('temp.vmr');

% Save
vmr.ExportNifti([vmp_path(1:end-4) suffix '.nii'],true);