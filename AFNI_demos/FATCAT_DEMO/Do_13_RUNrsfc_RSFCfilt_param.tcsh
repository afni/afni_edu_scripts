#!/bin/tcsh -f

# ver=3.0

# An example of filtering and calculating some RSFC components as part
# of a last step in resting state processing (things like tissue
# regression, smoothing and detrending have been done already, so they
# are not done here, but one can). As noted in the 3dRSFC helpfile,
# the program mainly a wrapper around the existing 3dBandpass program
# (by R. Cox), with extra functionality added. Since some RSFC
# parameters include both pre- and post-bandpassing information (e.g.,
# fALFF), these procedures were joined together into one program.

# Here, the input data set is in FMRI-native space; it could also have
# been mapped to DWI space before processing if that's useful.

# Produced data sets contain: LFFs (i.e., the filtered time series,
# here containing frequencies between 0.01-0.1 Hz), ALFF, fALFF,
# mALFF, RSFA, fRSFA, and mRSFA.  See 3dRSFC description/helpfile for
# more description if these aren't familiar quantities.

# Also, note that in the nice script-producing producing program in
# AFNI, 'afni_proc.py' by R. Reynolds, one can include a
# '-regress_RSFC' option to do this filtering and RSFC parameter
# calculation in that pipeline.  Please see the 'afni_proc.py' help
# file, and particularly Example 10b, to read more about this.

# can only be run if the input time series has NOT been censored
3dRSFC                          \
    -nodetrend                  \
    -prefix FMRI/REST_filt      \
    0.01 0.1                    \
    REST_proc_unfilt.nii.gz     \
    -overwrite

\gzip  FMRI/REST_filt*BRIK

# In case of (mild-moderate) censoring, then this charmingly named set
# of programs can be a way forward; the censoring file can be added in
# different ways: checking for volumes of all zero values (default),
# by using "-censor_1D ..", or by using "-censor_str ..".  Here we use
# an example censor list (made just by randomly choosing volumes to
# exclude, as an example).
# NOTE that the ALFF values are scaled differently here than for the 
# 3dRSFC case; fALFF and fractional values should be similar, though

3dLombScargle                       \
    -overwrite                      \
    -prefix FMRI/rest_LS            \
    -nifti                          \
    -inset REST_proc_unfilt.nii.gz  \
    -censor_1D censor_list.txt

3dAmpToRSFC                          \
    -overwrite                       \
    -in_amp  FMRI/rest_LS_amp.nii.gz \
    -prefix  FMRI/rest_LS            \
    -band    0.01  0.1               \
    -nifti 

