#!/usr/bin/env tcsh

# run simple afni_proc.py wrapper, mostly for QC
# (treating data as rest)

ap_run_simple_rest.tcsh                                                      \
    -subjid    sub-000.simple                                                \
    -anat      sub-000/anat/sub-000_T1w.nii.gz                               \
    -epi       sub-000/func/sub-000_task-av_run-01_bold.nii.gz               \
    -nt_rm     2                                                             \
    -run_proc
