function ne_vtc_bounding_box(vtc_fullname,varargin)
% Show VTC bounding box
vtc = xff(vtc_fullname);
disp(sprintf('%s BB %d %d %d %d %d %d | BV internal: %d %d %d %d %d %d', vtc_fullname, vtc.XStart, vtc.XEnd, vtc.YStart, vtc.YEnd, vtc.ZStart, vtc.ZEnd, ...
                                                                                       vtc.ZStart, vtc.ZEnd, vtc.XStart, vtc.XEnd, vtc.YStart, vtc.YEnd));
vtc.ClearObject;

% use vtc.BoundingBox

%% http://neuroelf.net/wiki/doku.php?id=obj.help

%% vtc.Help('BoundingBox')
% ans =
%  AFT::BoundingBox  - get bounding box
%  
%  FORMAT:       bbox = obj.BoundingBox;
%  
%  No input fields
%  
%  Output fields:
%  
%        bbox        struct with fields
%         .BBox      2x3 offset and offset + size - 1
%         .FCube     framing cube
%         .DimXYZ    data dimensions
%         .ResXYZ    data resolution
%         .QuatB2T   BV2Tal quaternion
%         .QuatT2B   Tal2BV quaternion
%  
%  TYPES: AVA, CMP, DDT, GLM, HDR, HEAD, MSK, NLF, SRF, TVL, VDW, VMP, VMR, VTC
%  
%  Note: output is in BV's *internal* notation (axes not in TAL order!)
