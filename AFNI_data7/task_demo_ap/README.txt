This tree is an updated form of AFNI_data6.

   do_01_gtkyd.tcsh           - script : getting to know your data
   do_12_fs.tcsh              - script : FS's recon-all (was run)
   do_13_ssw.tcsh             - script : skullstrip and warp anat (was run)
   do_14_timing.tcsh          - script : convert TSV to AFNI timing (was run)
   do_20_ap_simple.tcsh       - script : ap_run_simple_rest.tcsh command
   do_21_ap_affine.tcsh       - script : affine (faster) afni_proc.py
   do_22_ap_nonlinear.tcsh    - script : better NL registration version
   do_23_ap_surf.tcsh         - script : surface-based afni_proc.py
   example_snapshots          - dir    : images from specific operations
   QC_sub-000.affine          - dir    : prior QC results from do_21 execution
   save.proc.sub-000.affine   - script : proc from do_21_ap_affine.tcsh
   sub-000                    - dir    : BIDS subject data tree
   SSW                        - dir    : sswarper2 results
   SUMA                       - dir    : FreeSurfer 


A copy of the results from do_21_ap_affine.tcsh can be obtained off of the
website as well, probably once a terminal is in this particular directory.
This is a 1.6 GB package.  So consider the commands:

   cd AFNI_data7/task_demo_ap
   afni_open -aw sub-000.affine.results.tgz
   tar xfz sub-000.affine.results.tgz
   rm sub-000.affine.results.tgz

