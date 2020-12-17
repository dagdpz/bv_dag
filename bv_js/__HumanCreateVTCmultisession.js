// SET SESSION-SPECIFIC PARAMETERS	

var n_runs = 4;

var session_path = "Z:/MRI/Human/RIME/20140313/";

anat = "Z:/MRI/Human/RIME/20140313/anat/RIME_20140313_aACPC.vmr";

talFile = "RIME_20140313_aACPC.tal";

acpcFile = "RIME_20140313_aACPC.trf";

var run_path = new Array(n_runs);
var fmr = new Array(n_runs)
var vtc = new Array(n_runs);

run_path[0]="run01";
run_path[1]="run02";
run_path[2]="run03";
run_path[3]="run04";

fmr[0]="RIME_20140313_run01_st_mc_tf.fmr";
fmr[1]="RIME_20140313_run02_st_mc_tf.fmr";
fmr[2]="RIME_20140313_run03_st_mc_tf.fmr";
fmr[3]="RIME_20140313_run04_st_mc_tf.fmr";

trf="RIME_20140313_run01_SCSA_3DMCTS_THPGLMF2c-TO-RIME_20140313_";

vtc[0]="RIME_20140313_run01_st_mc_tf.vtc";
vtc[1]="RIME_20140313_run02_st_mc_tf.vtc";
vtc[2]="RIME_20140313_run03_st_mc_tf.vtc";
vtc[3]="RIME_20140313_run04_st_mc_tf.vtc";

HumanCreateVTC();
// END SET SESSION-SPECIFIC PARAMETERS

	
function HumanCreateVTC() 
{

var dataType = 1;
var resolution = 3;
var interpolation_method = 1;
var intensity_threshold = 100;

docVMR = BrainVoyagerQX.OpenDocument(anat);
docVMR.ExtendedTALSpaceForVTCCreation = false;
docVMR.UseBoundingBoxForVTCCreation = false;




	for (i=0; i<n_runs; i++)  
	{ 

		docVMR.CreateVTCInTALSpace(session_path+ run_path[i] +"/" + fmr[i] ,  session_path+ run_path[0] +"/" +trf+"IA.trf", session_path+ run_path[0] +"/" +trf+"FA.trf", session_path+ "anat/" +acpcFile, session_path+ "anat/" +talFile, session_path+ run_path[i] +"/" + vtc[i], dataType,resolution, interpolation_method, intensity_threshold);
		//docVMR.CreateVTCInTALSpace(nameFMR, nameIAfile, nameFAfile, nameACPCfile, nameTALfile, nameVTCinTAL, dataType, resolution, interpolation, threshold);
		
	}
	
	docVMR.Close();	

}
	