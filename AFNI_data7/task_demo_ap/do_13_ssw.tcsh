#!/usr/bin/env tcsh

# Run SSW: skullstrip and warp the anatomical dataset to standard space

# set subject and group identifiers
set subj  = sub-000
set gname = horses

# set subject-level directories
set sdir_func = ${subj}/func           # dir with basic functional data
set sdir_anat = ${subj}/anat           # dir with basic anatomical data
set sdir_ssw  = SSW                    # sswarper2-proc anatomical data

# ============================================================================

sswarper2                                              \
    -base           MNI152_2009_template_SSW.nii.gz    \
    -subid          ${subj}                            \
    -input          ${sdir_anat}/${subj}_T1w.nii.gz    \
    -odir           ${sdir_ssw}
