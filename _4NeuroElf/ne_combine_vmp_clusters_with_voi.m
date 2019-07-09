function ne_combine_vmp_clusters_with_voi(vmp_path,voi_path,subj,mapno,varargin)

defpar = { ...
	'localmax', 'double', 'nonempty', 25; ...		%
	'localmin', 'double', 'nonempty', 16; ...		% 
	'minsize', 'double', 'nonempty', 16; ...		% 16 for FL
	'rsize', 'double', 'nonempty', 4; ...			% 
	'rshape', 'char', 'nonempty', 'sphere'; ...		% 
	'verbose', 'logical', 'nonempty', true; ...		%
	'include_whole_if_less', 'double', 'nonempty', 16; ...	% if number of found voxels is less than this value, take all voxels (do not restrict to voxels around peak)
	'clusters_per_voi', 'double', 'nonempty', 1; ...	% max number of clusters per voi
	'resulting_voi_name', 'char','nonempty', '';...
	};

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


N_vois_with_clusters = 0;
N_total_clusters = 0;

first_voi = 1;
for v = 1:voi.NrOfVOIs,
	vmp_voi_masked = vmp.CopyObject;
	msk = voi.CreateMSK(vmp_voi_masked,v);
	vmp_voi_masked = vmp_voi_masked.MaskWithMSK(msk);
	[cs_ct, ctab_ct, vmp_ct, voi_ct] = vmp_voi_masked.ClusterTable(mapno, [],...
	[struct('clconn','edge','icbm2tal',[false],'localmsz',[true],'lupcrd','peak','sorting','maxstats','tdclient',[false],...
	'localmax',params.localmax,'localmin',params.localmin,'minsize',params.minsize)]);

	if ~isempty(cs_ct),
		N = min([params.clusters_per_voi, size(unique(vertcat(cs_ct.rwpeak),'rows'),1)]); % number of clusters to take, excluding big clusters if followed by subclusters
		N_clus = size(cs_ct,1);
		
		n_sel = 0;
		k = 1;
		voi_ct_sel = voi_ct.CopyObject;
		voi_ct_sel.VOI = voi_ct_sel.VOI(1);
		voi_ct_sel.NrOfVOIs = 1;
		while n_sel < N,
			take_this_cluster = 1;
			if k < N_clus && strcmp(cs_ct(k).localmax,' ') % not a subcluster, and potentially is followed by subclusters
				if ~strcmp(cs_ct(k+1).localmax,' ') % indeed followed by subclusters, do not take
					take_this_cluster = 0;
				end
			end
			if take_this_cluster
				n_sel = n_sel + 1;
				voi_ct_sel.VOI(n_sel) = voi_ct.VOI(k);
				voi_ct_sel.VOI(n_sel).Name = [subj '_' voi.VOINames{v} '-' voi_ct_sel.VOI(n_sel).Name];
				
				if voi_ct_sel.VOI(n_sel).NrOfVoxels > params.include_whole_if_less
					voi_ct_sel.Combine(n_sel,'restrict',[struct('rcenter', cs_ct(k).rwpeak,'rinplace',[false],'rshape',params.rshape,'rsize',params.rsize)]);
					voi_ct_sel.VOI(n_sel) = []; % remove original
				end
				
			end
			k = k + 1;
			
			
		end
		voi_ct_sel.NrOfVOIs = N;
		
		
		
		if first_voi,
			cvoi = voi_ct;
			cvoi.VOI = voi_ct_sel.VOI;
			cvoi.NrOfVOIs = N;
			first_voi = 0;
		else
			cvoi.VOI(cvoi.NrOfVOIs+1:cvoi.NrOfVOIs+N) = voi_ct_sel.VOI;
			cvoi.NrOfVOIs = cvoi.NrOfVOIs + N;
		end
		if params.verbose,
			disp(sprintf('%d \t %s \t %d',v,voi.VOINames{v},N));
		end
		N_vois_with_clusters = N_vois_with_clusters + 1;
		N_total_clusters = N_total_clusters + N;
	else
		if params.verbose,
			disp(sprintf('%d \t %s \t %d',v,voi.VOINames{v},0));
		end
	end
	
end

if ~first_voi, % found at least one voi
	if isempty(params.resulting_voi_name),
		params.resulting_voi_name = [vmp_name '_clusters_from_' voi_name];
	end
	cvoi.SaveAs([params.resulting_voi_name '.voi']);
	if params.verbose,
		disp(sprintf('Saved %d clusters in %d vois to %s',N_total_clusters,N_vois_with_clusters,[params.resulting_voi_name '.voi']));
	end
end
	

	
	



