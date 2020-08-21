#!/bin/tcsh -f

# ver=3.0

# (I'll assume you looked at the Do_01_*dti*.tcsh file for converting
# dcm2nii bvecs to something useful for DTI analysis.)

# Here, we also use 1dDW_Grad_o_Mat++, but a couple extra considerations
# are necessary for the gradient info for the chosen package for HARDI
# model reconstruction, DTI-Studio (Yeh et al., 2010).  

# Namely, we need a column of b-value information as well.  Thus, we
# just need to modify the command slightly, to: first read *in* the
# bvals, and then to print *out* the column.  Also, we need the top
# row of zeros to match the zeroth brik reference signal of
# AVEB0_DWI.nii.gz; to do the latter, we'll sneakily change the slice
# selections in [square brackets] to include only one of the
# zero-values, and then keep it.

# All that being noted, here we go again:

1dDW_Grad_o_Mat++                     \
    -in_row_vec    bvec'[0..30]'      \
    -in_bvals      bval'[0..30]'      \
    -flip_y                           \
    -out_col_vec   HARDI/b_table.txt  \
    -out_col_bval
