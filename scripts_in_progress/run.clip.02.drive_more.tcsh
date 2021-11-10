#!/bin/tcsh

# enter clipping plane mode, and do a few more things in that mode

# run from:
# ~/AFNI_data6/FT_analysis/FT/SUMA/

# make a larger suma window (don't whine about resetting size)
setenv AFNI_ENVIRON_WARNINGS     NO
setenv SUMA_Position_Original    "50 50  701 700"

suma                              \
    -onestate                     \
    -spec std.141.FT_both.spec    \
    -sv FT_SurfVol.nii & 

# right-sagittal view, and zoom out a bit to see better
DriveSuma                                      \
    -com viewer_cont -key "Ctrl+Right"         \
    -com viewer_cont -key "z" -key "z" -key "z" -key "z" -key "z" -key "z"

# enter clipping plane mode; add a couple planes to the existing '1'
DriveSuma                                      \
    -com viewer_cont -key "Shift+Ctrl+c"       \
    -com viewer_cont -key "2"                  \
    -com viewer_cont -key "5"
