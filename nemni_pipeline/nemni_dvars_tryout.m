function nemni_dvars_tryout

Path_to_Nifti='D:\MRI\Human\fMRI-reach-decision\mni_Experiment\DAGU\20200123\run05\hum_14773_0020_topupcorr.nii';
V1 = load_untouch_nii(Path_to_Nifti);
V2 = V1.img;
X0 = size(V2,1); Y0 = size(V2,2); Z0 = size(V2,3); T0 = size(V2,4);
I0 = prod([X0,Y0,Z0]);
Y  = reshape(V2,[I0,T0]); clear V2 V1;
%%
[DVARS,Stat]=DVARSCalc(Y,'TestMethod','X2','scale',1/100)

%%
[V,DSE_Stat]=DSEvars(Y,'scale',1/100);

%% 

fMRIDiag_plot(V,Stat)