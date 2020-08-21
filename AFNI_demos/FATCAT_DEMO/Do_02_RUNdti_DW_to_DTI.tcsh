#!/bin/tcsh -f

# ver=3.0

# Standard calculation of diffusion tensors (DTs) and associated
# parameters using existing 3dDWtoDTI by D. Glen.

# Output DTI directory has already been made.

# Grad file has already been made using 1dDW_Grad_o_Mat++

# Make use of a brain mask, output eigenvalues, eigenvectors, DTs and
# parameters in separate files.  Use nonlinear fitting to estimate
# DTs (think that's the default, anyways).

# Gradient file and b0+DWIs are given. Because the gradient values (in
# the bmatrix file) have been scaled by the DWI value, we will use the
# "-scale_out_1000" option to have the MD, L1 and RD be of order 1;
# this essentially changes their units from "mm^2/s" to "10^-3
# mm^2/s", which is fine.

3dDWItoDT -echo_edu                  \
    -overwrite                       \
    -prefix DTI/DT                   \
    -mask mask_DWI+orig              \
    -eigs -sep_dsets -nonlinear      \
    -scale_out_1000                  \
    -bmatrix_FULL GRADS_bmatA.dat    \
    AVEB0_DWI.nii.gz 


#And use the version without the Y flipping to illustrate how
#incorrect gradient flipping options manifest themselves
#in whole brain tractography
if ( ! -d DTI.bad ) mkdir DTI.bad

3dDWItoDT -echo_edu                  \
    -overwrite                       \
    -prefix DTI.bad/DT               \
    -mask mask_DWI+orig              \
    -eigs -sep_dsets -nonlinear      \
    -scale_out_1000                  \
    -bmatrix_FULL GRADS_bmatA.dat    \
    AVEB0_DWI.nii.gz
