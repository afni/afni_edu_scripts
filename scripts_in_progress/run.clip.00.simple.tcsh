#!/bin/tcsh

# just try entering clipping plane mode

# run from:
# ~/AFNI_data6/FT_analysis/FT/SUMA/

suma                              \
    -onestate                     \
    -spec std.141.FT_both.spec    \
    -sv FT_SurfVol.nii & 

DriveSuma                                      \
    -com viewer_cont -key "Shift+Ctrl+c"     
