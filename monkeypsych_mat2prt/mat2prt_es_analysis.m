function prt_fullpath = mat2prt_es_analysis(mat_fullpath,run_name)
% converts monkeypsych_dev generated mat files to prt file, with functions
% used by Elena Spanou in her analysis

timing_fullpath = mat2txt_one_run(mat_fullpath);
prt_fullpath = monkeypsych_dev_microstim_NO_pre_memory_NO_cue_0to9(timing_fullpath,run_name);
