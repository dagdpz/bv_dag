% load the required files
vmr = xff('*.vmr', 'Please select the VMR file to use as a reference...');
fmr = xff('*.fmr', 'Please select the FMR file to sample into VTC space...');
ia = xff('*IA*.trf', 'Please select the initial alignment (_IA.trf) file...');
fa = xff('*FA*.trf', 'Please select the fine alignment (_FA.trf) file...');
acpc = {xff('*ACPC*.trf', 'Please select the ACPC transformation file...')};
if ~isempty(acpc{1})
    tal = {xff('*.tal', 'Please select the TAL transformation file...')};
    if isempty(tal{1})
        tal = {};
        space = '_ACPC';
    else
        space = '_TAL';
    end
else
	tal = {}; % IK
    acpc = {};
    space = '';
end
 
% make a call to vmr.CreateVTC (will save VTC already!)
vtc = vmr.CreateVTC(fmr, {ia, fa, acpc{:}, tal{:}}, ...
    strrep(fmr.FilenameOnDisk, '.fmr', [space '.vtc']), ...
    2, 'cubic', [], 2);
 
% clear objects
% xffclearobjects({vtc, tal{:}, acpc{:}, fa, ia, fmr, vmr});