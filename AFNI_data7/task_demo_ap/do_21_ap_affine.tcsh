#!/usr/bin/env tcsh

# Run AP: single subject processing, quicker affine processing case

# set subject and group identifiers
set subj  = sub-000
set gname = horses

# set subject-level directories
set sdir_func = ${subj}/func           # basic functional data
set sdir_anat = ${subj}/anat           # basic anatomical data
set sdir_ssw  = SSW/${subj}            # sswarper2-proc anatomical data

# ============================================================================

# run afni_proc.py to create a single subject processing script

afni_proc.py                                                                 \
    -subj_id                  ${subj}.affine                                 \
    -dsets                    ${sdir_func}/${subj}_task-av_run-01_bold.nii.gz \
                              ${sdir_func}/${subj}_task-av_run-02_bold.nii.gz \
                              ${sdir_func}/${subj}_task-av_run-03_bold.nii.gz \
    -copy_anat                ${sdir_ssw}/anatSS.${subj}.nii                 \
    -blocks                   tshift align tlrc volreg mask blur scale       \
                              regress                                        \
    -radial_correlate_blocks  tcat volreg regress                            \
    -tcat_remove_first_trs    2                                              \
    -align_unifize_epi        local                                          \
    -align_opts_aea           -cost lpc+ZZ                                   \
                              -giant_move                                    \
                              -check_flip                                    \
    -tlrc_base                MNI152_2009_template.nii.gz                    \
    -volreg_align_to          MIN_OUTLIER                                    \
    -volreg_align_e2a                                                        \
    -volreg_tlrc_warp                                                        \
    -volreg_compute_tsnr      yes                                            \
    -mask_epi_anat            yes                                            \
    -blur_size                4.0                                            \
    -regress_stim_times       ${sdir_func}/times.vis.txt                     \
                              ${sdir_func}/times.aud.txt                     \
    -regress_stim_labels      vis aud                                        \
    -regress_basis            'BLOCK(20,1)'                                  \
    -regress_censor_motion    0.3                                            \
    -regress_censor_outliers  0.05                                           \
    -regress_motion_per_run                                                  \
    -regress_opts_3dD         -jobs 2                                        \
                              -gltsym 'SYM: vis -aud'                        \
                              -glt_label 1 V-A                               \
                              -gltsym 'SYM: 0.5*vis +0.5*aud'                \
                              -glt_label 2 mean.VA                           \
    -regress_compute_fitts                                                   \
    -regress_make_ideal_sum   sum_ideal.1D                                   \
    -regress_est_blur_epits                                                  \
    -regress_est_blur_errts                                                  \
    -regress_run_clustsim     no                                             \
    -html_review_style        pythonic                                       \
    -execute

