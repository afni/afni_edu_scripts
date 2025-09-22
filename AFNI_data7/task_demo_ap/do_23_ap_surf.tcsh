#!/usr/bin/env tcsh

# Run AP: full single subject FMRI processing on the surface

# set subject and group identifiers
set subj  = sub-000
set gname = horses

# set subject-level directories
set sdir_func = ${subj}/func           # dir with basic functional data
set sdir_anat = ${subj}/anat           # dir with basic anatomical data
set sdir_ssw  = SSW/${subj}            # sswarper2-proc anatomical data
set sdir_suma = SUMA                   # FreeSurfer results imported into SUMA

# ============================================================================

# run afni_proc.py to create a single subject processing script

afni_proc.py                                                                  \
    -subj_id                  ${subj}.surf                                    \
    -dsets                    ${sdir_func}/${subj}_task-av_run-01_bold.nii.gz \
                              ${sdir_func}/${subj}_task-av_run-02_bold.nii.gz \
                              ${sdir_func}/${subj}_task-av_run-03_bold.nii.gz \
    -copy_anat                ${sdir_ssw}/anatSS.${subj}.nii                  \
    -anat_has_skull           no                                              \
    -blocks                   tshift align volreg surf blur scale regress     \
    -radial_correlate_blocks  tcat volreg                                     \
    -tcat_remove_first_trs    2                                               \
    -align_unifize_epi        local                                           \
    -align_opts_aea           -cost lpc+ZZ                                    \
                              -giant_move                                     \
                              -check_flip                                     \
    -volreg_align_to          MIN_OUTLIER                                     \
    -volreg_align_e2a                                                         \
    -volreg_compute_tsnr      yes                                             \
    -surf_anat                ${sdir_suma}/${subj}_SurfVol.nii                \
    -surf_spec                ${sdir_suma}/std.60.${subj}_lh.spec             \
                              ${sdir_suma}/std.60.${subj}_rh.spec             \
    -blur_size                6.0                                             \
    -regress_stim_times       ${sdir_func}/times.vis.txt                      \
                              ${sdir_func}/times.aud.txt                      \
    -regress_stim_labels      vis aud                                         \
    -regress_basis            'BLOCK(20,1)'                                   \
    -regress_censor_motion    0.3                                             \
    -regress_censor_outliers  0.05                                            \
    -regress_motion_per_run                                                   \
    -regress_opts_3dD         -jobs 2                                         \
                              -gltsym 'SYM: vis -aud'                         \
                              -glt_label 1 V-A                                \
    -regress_compute_fitts                                                    \
    -regress_make_ideal_sum   sum_ideal.1D                                    \
    -regress_run_clustsim     no                                              \
    -html_review_style        pythonic


