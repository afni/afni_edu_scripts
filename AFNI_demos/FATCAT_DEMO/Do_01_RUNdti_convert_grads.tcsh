#!/bin/tcsh -f

# ver=3.0

# Read in the b-vector file that was output by dcm2nii (here called
# simply 'bvec') when converting dicoms, and output a usable gradient
# file for 3dDWItoDT and 3dDWUncert.  There are 2 parts to this process.

# --------------------------- part 1 --------------------------------

# Different scanners and software have different systems of
# interpreting directionality in gradient files; for some, a negative
# first column is "leftward", for others it is "rightward", etc.
# Needless to say, with 3 dimensions, this can be challenging to sort
# out.  This is just a difference in convention, but it is important
# to know that you have data in the correct convention for your
# present needs (NB: even TORTOISE and AFNI have different
# interpretations of these things.)

# We present here an example of checking (with reasonably high
# accuracy) whether you need to "flip" a gradient 
# https://afni.nimh.nih.gov/pub/dist/doc/htmldoc/FATCAT/GradFlipTest.html


@GradFlipTest                                                \
    -in_row_vec bvec'[0..30]'                                \
    -in_bvals   bval'[0..30]'                                \
    -in_dwi     AVEB0_DWI.nii.gz                             \
    -mask       mask_DWI+orig.                               \
    -scale_out_1000                                          \
    -prefix     CheckGradFlips.txt                           \
    -wdir       _tmp_CheckGradFlips


cat <<EOF

++ And after running "@GradFlipTest ..", you should be able to view
   the flip recommendation in this file:

     CheckGradFlips.txt

   ... and the more detailed output, including "suma .." commands to
   view all the intermediate cases and verify things visually for
   yourself, is contained in this file:

     CheckGradFlips_echo.txt

EOF

# --------------------------- part 2 --------------------------------

# How to acquire DWI data is a big topic of discussion, but we discuss
# that in other parts of the AFNI+TORTOISE DTI Day of the Bootcamp. We
# will just note that the present DWI dataset is not optimally
# acquired, by modern standards.  The voxelsize and bvalue magnitudes
# are reasonable, but there should be several b=0 s/mm^2 volumes,
# preferably some intermediate b-values (like b=300 s/mm^2 and b=500
# s/mm^2) to improve fitting and reliability; It used to be that
# sometimes people would average multiple b=0 s/mm^2 volumes before
# tensor fitting, but that is no longer the recommended case.
# Additionally, one would like to have a matched DWI dataset with
# opposite phase encoding, for B0 inhomogeneity distortion correction.
# Finally, one would like to have an accompanying T2w anatomical
# acquired with fat suppression, to use as a reference volume for
# distortion correction with TORTOISE.

# We can convert the row-oriented bvecs and bvals into either column
# gradients or column bmatrix values, and either of those could be
# scaled or unscaled by the bvalues.  Here, we choose to use the
# AFNI-style bmatrix, and to scale by bvalues.  

# Note that there are also more grads than B0+DWI values here, a
# consequence of us having chosen a subset of the full acquisition for
# speed of processing time and size of datasets.  Therefore, we use
# AFNI-style subbrick selectors on the bvec and bvalue files here to
# select out the appropriate number corresponding to the number of
# utilized DWI volumes (31 total).  Here, we are selecting from rows,
# so we use square brackets '[ ]'; if we had been selecting from
# columnswe would have used curly brackets '{ }'.  Note that some form
# of quote is necessary to wrap around the brackets, so that the shell
# does not interpret them before the AFNI I/O can.

# Bonus consideration: there's a fun scanner-conversion-toolbox
# interaction that means that oftentimes, one of the gradients needs
# to be 'flipped' (accomplished by multiplying one of the components
# by '-1'). The only way I know of finding out what needs to be done
# is by processing one data set through to whole brain tractography,
# and making sure the length of the corpus callosum looks nice (it
# won't show up in FA maps, it's something that affects the
# eigenvectors, and I haven't perfected the art of reading those for
# this effect). At least the effect is usually consistent on a given
# scanner. Having processed *this* data set, I know that it's in need
# of a y-flip, which is done here.  (**See the accompanying
# Do_01a_RUNdti_check_grad_flip.tcsh script to see how we check for
# what-- if any-- flip is needed.)

# Sidenote: due to the symmetries of the system/measures, any flipping
# any two components is equivalent to flipping the third.  That is, we
# could flip *either* solely the y-component here, *or* both the x-
# and z-components.  The signs of gradients would differ, but all
# tensor estimates and parameters would be the same.  Ok then.

# All that being noted, here we go:

1dDW_Grad_o_Mat++                     \
    -in_row_vec    bvec'[0..30]'      \
    -in_bvals      bval'[0..30]'      \
    -flip_y                           \
    -out_col_matA  GRADS_bmatA.dat

#Create a version without the Y flipping to illustrate how
#incorrect gradient flipping options manifest themselves
#in whole brain tractography
1dDW_Grad_o_Mat++                     \
    -in_row_vec    bvec'[0..30]'      \
    -in_bvals      bval'[0..30]'      \
    -out_col_matA  GRADS_bmatA.bad.dat
