// SET SESSION-SPECIFIC PARAMETERS	

var n_runs = 5;

var session_path = "G:/MRI/Hanuman/20101026/";

anat = "G:/MRI/Hanuman/2decide/HA_20101028_ACPC_1mm.vmr";

var run_path = new Array(n_runs);
var fmr = new Array(n_runs)
var vtc = new Array(n_runs);

run_path[0]="run1_20101026Ha_Hanuman.1288143971";
run_path[1]="run2_20101026Ha_Hanuman.1288145215";
run_path[2]="run3_20101026Ha_Hanuman.1288146440";
run_path[3]="run4_20101026Ha_Hanuman.1288147676";
run_path[4]="run5_20101026Ha_Hanuman.1288153485";

fmr[0]="HA_MEMSAC2DECIDE_run1_SCLAI_3DMCT_LTR_THP3c.fmr";
fmr[1]="HA_MEMSAC2DECIDE_run2_SCLAI_3DMCT_LTR_THP3c.fmr";
fmr[2]="HA_MEMSAC2DECIDE_run3_SCLAI_3DMCT_LTR_THP3c.fmr";
fmr[3]="HA_MEMSAC2DECIDE_run4_SCLAI_3DMCT_LTR_THP3c.fmr";
fmr[4]="HA_MEMSAC2DECIDE_run5_SCLAI_3DMCT_LTR_THP3c.fmr";

trf="HA_MEMSAC2DECIDE_run1_SCLAI_3DMCT_LTR_THP3c-TO-HA_20101026_ACPC_";

vtc[0]="HA_MEMSAC2DECIDE_run1_SCLAI_3DMCT_LTR_THP3c.vtc";
vtc[1]="HA_MEMSAC2DECIDE_run2_SCLAI_3DMCT_LTR_THP3c.vtc";
vtc[2]="HA_MEMSAC2DECIDE_run3_SCLAI_3DMCT_LTR_THP3c.vtc";
vtc[3]="HA_MEMSAC2DECIDE_run4_SCLAI_3DMCT_LTR_THP3c.vtc";
vtc[4]="HA_MEMSAC2DECIDE_run5_SCLAI_3DMCT_LTR_THP3c.vtc";

SimianCreateVTC();
// END SET SESSION-SPECIFIC PARAMETERS	



	
function SimianCreateVTC() 
{


//var anat = "D:/data/MRI/Redrik/rLIPcan1/RE_20090722_ACPC.vmr";
//var anat = "H:/data1/MRI/Redrik/20090722anat/RE_20090722_ACPC_original.vmr";
//var anat = "D:/data/MRI/Redrik/rLIPcan1/2016/RE_20090722_ACPC_BRAIN_2016.vmr";

var dataType = 1;
var resolution = 2;
var interpolation_method = 1;
var intensity_threshold = 1000;

docVMR = BrainVoyagerQX.OpenDocument(anat);
docVMR.ExtendedTALSpaceForVTCCreation = false;
docVMR.UseBoundingBoxForVTCCreation = true;

/*/ Florian lPULVcan3
docVMR.TargetVTCBoundingBoxXStart = 66;
docVMR.TargetVTCBoundingBoxYStart = 80;
docVMR.TargetVTCBoundingBoxZStart = 78; 
docVMR.TargetVTCBoundingBoxXEnd =  190;
docVMR.TargetVTCBoundingBoxYEnd =  220;
docVMR.TargetVTCBoundingBoxZEnd =  140;
*/

/*/ Redrik lPULVcan1
docVMR.TargetVTCBoundingBoxXStart = 66;
docVMR.TargetVTCBoundingBoxYStart = 70;
docVMR.TargetVTCBoundingBoxZStart = 75; 
docVMR.TargetVTCBoundingBoxXEnd = 190;
docVMR.TargetVTCBoundingBoxYEnd = 220;
docVMR.TargetVTCBoundingBoxZEnd = 137;
*/

/*/ Redrik rLIPcan1
docVMR.TargetVTCBoundingBoxXStart = 66;
docVMR.TargetVTCBoundingBoxYStart = 70;
docVMR.TargetVTCBoundingBoxZStart = 75; 
docVMR.TargetVTCBoundingBoxXEnd = 190;
docVMR.TargetVTCBoundingBoxYEnd = 220;
docVMR.TargetVTCBoundingBoxZEnd = 137;
*/

/*/ Curius microstim
docVMR.TargetVTCBoundingBoxXStart = 70;
docVMR.TargetVTCBoundingBoxYStart = 55;
docVMR.TargetVTCBoundingBoxZStart = 70; 
docVMR.TargetVTCBoundingBoxXEnd = 190;
docVMR.TargetVTCBoundingBoxYEnd = 225;
docVMR.TargetVTCBoundingBoxZEnd = 166;
*/


// Hanuman 2decide
docVMR.TargetVTCBoundingBoxXStart = 70;
docVMR.TargetVTCBoundingBoxYStart = 50;
docVMR.TargetVTCBoundingBoxZStart = 80; 
docVMR.TargetVTCBoundingBoxXEnd = 189;
docVMR.TargetVTCBoundingBoxYEnd = 224;
docVMR.TargetVTCBoundingBoxZEnd = 134;



	for (i=0; i<n_runs; i++)  
	{ 
		//docVMR.CreateVTCInACPCSpace(session_path+ run_path[i] +"/" + fmr[i] ,  session_path+ run_path[0] +"/" +trf+"IA.trf", session_path+ run_path[0] +"/" +trf+"FA.trf", "", session_path+ run_path[i] +"/" + vtc[i], dataType,resolution, interpolation_method, intensity_threshold);
		// nameFMR, nameIAfile, nameFAfile, nameACPCfile, nameVTCinACPC, dataType, resolution, interpolation, threshold

		docVMR.CreateVTCInVMRSpace(session_path+ run_path[i] +"/" + fmr[i] ,  session_path+ run_path[0] +"/" +trf+"IA.trf", session_path+ run_path[0] +"/" +trf+"FA.trf", session_path+ run_path[i] +"/" + vtc[i], dataType,resolution, interpolation_method, intensity_threshold);
	}
	
	docVMR.Close();	

}
	