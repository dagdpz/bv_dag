function I = ne_fmr_to_3Dmosaic(fmr_name)
% I is 3D array, first 2 dimensions - mosaic, 3d dimension - volumes

fmr = xff(fmr_name);
stc = fmr.LoadSTC;
temp = stc.Slice.STCData;
n_vol = size(temp,3);
msize = size(temp,1); % matrix size
n_slices = size(temp,4);
n_rows = ceil(sqrt(n_slices)); % also n_cols, we are assuming square matrix
I = zeros(n_rows*msize,n_rows*msize,n_vol);
for i = 1:n_vol,
	for r = 1:n_rows,
		for c = 1:n_rows,
			if (r-1)*n_rows + c <= n_slices
				I( (r-1)*msize+1:r*msize , (c-1)*msize+1:c*msize, i) = temp(:,:,i,(r-1)*n_rows + c)';
			end
		end
	end
	I(:,:,i) = rectify(I(:,:,i),0);
end