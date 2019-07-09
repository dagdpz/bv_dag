function ne_filter_vtc(vtc_fullname,new_suffix,varargin)
% if new_suffix = '' then automatic name will be appended based on filtering 
% Example: ne_filter_vtc('F:\MRI\Curius\20131016_H\run02\fu_reg.vtc','','spat',1,'spkern',[2 2 2],'temp',1,'tempdct',3);
% VTC::Filter                 - filter a VTC                                 / Syntax: [vtc =] vtc.Filter(opts)

vtc = xff(vtc_fullname);
disp(['Filtering ' vtc_fullname]);
vtc.Filter(struct(varargin{:}));
if isempty(new_suffix),
	for k = 1:length(varargin),
		new_suffix = [new_suffix '_' num2str(varargin{k})];
	end
	new_suffix = strrep(new_suffix, '  ', ' ');
	new_suffix = strrep(new_suffix, ' ', '-');
end

vtc.SaveAs([vtc_fullname(1:end-4) new_suffix '.vtc']);
disp([vtc_fullname(1:end-4) new_suffix '.vtc saved']);	
vtc.ClearObject;



%% http://neuroelf.net/wiki/doku.php?id=obj.help

%% vtc.Help('Filter')
% ans =
%  VTC::Filter  - filter a VTC
%  
%  FORMAT:       [vtc =] vtc.Filter(opts)
%  
%  Input fields:
%  
%        opts        mandatory struct but with optional fields
%         .nuisreg   either a VxN double matrix or single/list of SDM/s
%         .spat      enable spatial filtering (default: false)
%         .spkern    smoothing kernel in mm (default: [6, 6, 6])
%         .temp      enable temporal filtering (default: false)
%         .tempdct   DCT-based filtering (min. wavelength, default: Inf)
%         .tempdt    detrend (default: true, is overriden by dct/sc)
%         .templp    temporal lowpass (smoothing) kernel in secs (def: 0)
%         .tempsc    sin/cos set of frequencies (number of pairs, def: 0)
%  
%  Output fields:
%  
%        vtc         filtered VTC
