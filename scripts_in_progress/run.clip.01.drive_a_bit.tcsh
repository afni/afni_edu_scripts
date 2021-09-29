#!/bin/tcsh

# enter clipping plane mode, then run driving script
# depends on having some *.vvs files from this repo present

# run from:
# ~/AFNI_data6/FT_analysis/FT/SUMA/

suma                              \
    -onestate                     \
    -spec std.141.FT_both.spec    \
    -sv FT_SurfVol.nii & 

DriveSuma                                      \
    -com viewer_cont -key "Shift+Ctrl+c"       \
    -com viewer_cont -load_view ex_view2.niml.vvs &
