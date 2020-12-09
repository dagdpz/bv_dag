function ne_combine_vmp_with_voi(vmp_path,voi_path,subj,mapno,varargin)
%ne_combine_vmp_with_voi  - extract clusters (no subcluster) within each voi, and save clusters to another voi
%
% USAGE:	
%		ne_combine_vmp_with_voi('test.vmp','test_r_tal.voi','',1,'combine_clusters',false);
%		ne_combine_vmp_with_voi('test.vmp','test_r_tal.voi');
%       ne_combine_vmp_with_voi('test.vmp','test_r_tal.voi','BA',1,'showneg',true);
% 
% INPUTS:
%		input 1		- explanation
%		...
%
% OUTPUTS:	
%		output1		- explanation
%		...
%
% REQUIRES:	...
%  
% See also NE_COMBINE_VMP_CLUSTERS_WITH_VOI
%
%
% Author(s):	Igor Kagan, DAG, DPZ
% URL:		http://www.dpz.eu/dag
% 
% Change log:
% yyyymmdd:	Created function (author's firstname familyname)
% ...
% $Revision: 1.0 $  $Date: 2011/01/31 20:47:25 $
%
% ADDITIONAL INFO:
% ...

defpar = { ...
	'localmax', 'double', 'nonempty', Inf; ...		%
	'localmin', 'double', 'nonempty', 1; ...		% 
	'minsize', 'double', 'nonempty', 1; ...         % 
    'showpos', 'logical', 'nonempty', true; ...	% 
    'showneg', 'logical', 'nonempty', false; ...	% 
    'sorting', 'char', 'nonempty', 'maxstats'; ...	% 'maxstat', {'maxstats'}, 'size', 'x', 'y', 'z'
    
    
	'verbose', 'logical', 'nonempty', true; ...		%
	'clusters_per_voi', 'double', 'nonempty', 5; ...	% max number of clusters per voi
    'combine_clusters', 'logical', 'nonempty', true; ...	% 
	'resulting_voi_name', 'char','nonempty', '';...
	};

if nargin < 4,
    mapno = 1;
end

if isempty(subj)
    subj_str = '';
else
    subj_str = [subj '_'];
end

if nargin > 4, % specified dynamic params
	params = checkstruct(struct(varargin{:}), defpar);
else
	params = checkstruct(struct, defpar);
end    
    
if isxff(vmp_path),
	vmp = vmp_path;
	vmp_name = 'vmp';
else
	vmp = xff(vmp_path);

	[dummy,vmp_name,dummy] = fileparts(vmp_path);
end

if isxff(voi_path),
	voi = voi_path;
	voi_name = 'voi';
	
else
	voi = xff(voi_path);
	[dummy,voi_name,dummy] = fileparts(voi_path);
end

% vmpmsk = vmp.CreateMSK(mapno);

vmp = vmp.MakeHiResVMP(mapno);

N_vois_with_clusters = 0;
N_total_clusters = 0;

first_voi = 1;
for v = 1:voi.NrOfVOIs,
	vmp_voi_masked = vmp.CopyObject;
	msk = voi.CreateMSK(vmp_voi_masked,v);
	vmp_voi_masked = vmp_voi_masked.MaskWithMSK(msk);
	[cs_ct, ctab_ct, vmp_ct, voi_ct] = vmp_voi_masked.ClusterTable(mapno, [],...
	[struct('clconn','edge','icbm2tal',[false],'localmsz',[false],'lupcrd','peak','sorting',params.sorting,'tdclient',[false],...
	'localmax',params.localmax,'localmin',params.localmin,'minsize',params.minsize,'showpos',params.showpos,'showneg',params.showneg)]);

	if ~isempty(cs_ct),
		N = min([params.clusters_per_voi, size(unique(vertcat(cs_ct.rwpeak),'rows'),1)]); % number of clusters to take
        
        voi_ct_sel = voi_ct.CopyObject;
        voi_ct_sel.VOI = voi_ct_sel.VOI(1:N);
        
        if N > 1 && params.combine_clusters,
            voi_ct_sel = voi_ct_sel.Combine(1:N,'union');
            voi_ct_sel.VOI(end).Name = [subj_str voi(v).Name '_combined'];
            voi_ct_sel.VOI = voi_ct_sel.VOI(end);
            voi_ct_sel.NrOfVOIs = 1;
            str = ['[' num2str(N) ' combined]'];          
        else
            voi_ct_sel.NrOfVOIs = N;
            
            for c = 1:N,
                 voi_ct_sel.VOI(c).Name = [subj_str voi(v).Name '_' voi_ct_sel.VOI(c).Name];
            end
            str = ''; 
        end
		
		if first_voi,
			cvoi = voi_ct;
			cvoi.VOI = voi_ct_sel.VOI;
			cvoi.NrOfVOIs = voi_ct_sel.NrOfVOIs;
			first_voi = 0;
		else
			cvoi.VOI(cvoi.NrOfVOIs+1:cvoi.NrOfVOIs+voi_ct_sel.NrOfVOIs) = voi_ct_sel.VOI;
			cvoi.NrOfVOIs = cvoi.NrOfVOIs + voi_ct_sel.NrOfVOIs;
		end
		if params.verbose,
			disp(sprintf('%d\t%s\t%d clusters %s',v,voi.VOINames{v},voi_ct_sel.NrOfVOIs,str));
		end
		N_vois_with_clusters = N_vois_with_clusters + 1;
		N_total_clusters = N_total_clusters + N;
	else
		if params.verbose,
			disp(sprintf('%d\t%s\t %d clusters',v,voi.VOINames{v},0));
		end
	end
	
end

if ~first_voi, % found at least one voi
	if isempty(params.resulting_voi_name),
		params.resulting_voi_name = [vmp_name '_from_' voi_name];
	end
	cvoi.SaveAs([params.resulting_voi_name '.voi']);
	if params.verbose,
		disp(sprintf('Saved %d clusters in %d vois to %s',N_total_clusters,N_vois_with_clusters,[params.resulting_voi_name '.voi']));
	end
end
	

	
	



