#!/usr/bin/env tcsh

# Run the 'simple' afni_proc.py wrapper command, for quick (and yes,
# simple) processing.
# 
# This processes the data like resting state FMRI, even if it is task.
# This is useful for having AP generate quantitative checks through the
# processing stages and for generating the APQC HTML to investigate.


ap_run_simple_rest.tcsh                                                      \
    -subjid    sub-000.simple                                                \
    -anat      sub-000/anat/sub-000_T1w.nii.gz                               \
    -epi       sub-000/func/sub-000_task-av_run-01_bold.nii.gz               \
    -nt_rm     2                                                             \
    -run_proc
