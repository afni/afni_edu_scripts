#!/usr/bin/env tcsh

# Run FS: FreeSurfer's recon-all on the anatomical dataset to create a
#         cortical surface mesh and parcellations

# set subject and group identifiers
set subj  = sub-000
set gname = horses

# set subject-level directories
set sdir_func = ${subj}/func           # dir with basic functional data
set sdir_anat = ${subj}/anat           # dir with basic anatomical data
set sdir_fs   = FS/${subj}             # FS recon-all proc anatomical data
set sdir_suma = ${sdir_fs}/SUMA        # post-FS NIFTI+surf formatted data

# ============================================================================

\mkdir -p ${sdir_fs}

# run Freesurfer's recon-all (must be installed+setup separately)
recon-all                                                             \
    -all                                                              \
    -3T                                                               \
    -sd        ${sdir_fs}                                             \
    -subjid    ${subj}                                                \
    -i         ${sdir_anat}/${subj}_T1w.nii.gz                        \

# ... and convert the outputs to NIFTI volumes and standard meshes
@SUMA_Make_Spec_FS                                                    \
    -fs_setup                                                         \
    -NIFTI                                                            \
    -sid       ${subj}                                                \
    -fspath    ${sdir_fs}/${subj}

# ... and use data in the created ${sdir_fs}/${subj}/SUMA subdirectory
