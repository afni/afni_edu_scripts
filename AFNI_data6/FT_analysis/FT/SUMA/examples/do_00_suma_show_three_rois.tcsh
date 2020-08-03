#!/bin/tcsh

# This script assumes that you have made 3 (left hemisphere) surface
# ROIs in the directory above, and converted them into full surface
# dsets called:
#     roi1.lh.niml.dset
#     roi2.lh.niml.dset
#     roi3.lh.niml.dset

setenv SUMA_AutoRecordPrefix "image_suma_rois"

# -------------------------------------------------------------------

# port number for AFNI+SUMA to talk to each other
set portnum = `afni -available_npb_quiet`

# open up LH set of surfaces
suma                                                            \
    -echo_edu                                                   \
    -npb   $portnum                                             \
    -spec  std.141.FT_lh.spec                                   \
    -sv    FT_SurfVol.nii                                       &

sleep 1

# Sagittal view, face L
DriveSuma                                                       \
    -echo_edu                                                   \
    -npb   $portnum                                             \
    -com   viewer_cont -key 'Ctrl+left' 

# Open controller
DriveSuma                                                       \
    -echo_edu                                                   \
    -npb   $portnum                                             \
    -com   surf_cont -view_surf_cont y

sleep 1

# Use the '.' keypress to go through spec file list to surf type we
# want for display. 
# And, in order, turn *OFF* visibility of the:  
#    crosshair, selector node, selector faceset, and label
DriveSuma                                                      \
    -echo_edu                                                  \
    -npb $portnum                                              \
    -com viewer_cont -key '.' -key '.'                         \
    -com viewer_cont -key 'F3' -key 'F4' -key 'F5' -key 'F9'

# Open dset 1, and set opacity/disp mode/colorbar
DriveSuma                                                     \
    -echo_edu                                                 \
    -npb $portnum                                             \
    -com surf_cont -load_dset roi1.lh.niml.dset               \
    -com surf_cont -Opa       0.5                             \
    -com surf_cont -Dsp       Col                             \
    -com surf_cont -1_only    n                               \
    -com surf_cont -switch_cmap  red_monochrome     

sleep 1

# Open dset 2, and set opacity/disp mode/colorbar
DriveSuma                                                     \
    -echo_edu                                                 \
    -npb $portnum                                             \
    -com surf_cont -load_dset roi2.lh.niml.dset               \
    -com surf_cont -Opa       0.5                             \
    -com surf_cont -Dsp       Col                             \
    -com surf_cont -1_only    n                               \
   -com surf_cont -switch_cmap  blue_monochrome     

sleep 1

# Open dset 3, and set opacity/disp mode/colorbar
DriveSuma                                                     \
    -echo_edu                                                 \
    -npb $portnum                                             \
    -com surf_cont -load_dset roi3.lh.niml.dset               \
    -com surf_cont -1_only    n                               \
    -com surf_cont -Dsp       Col                             \
    -com surf_cont -Opa       0.5                             \
    -com surf_cont -switch_cmap  amber_monochrome     

sleep 1

# Sagittal profile L,  SNAP
DriveSuma                                                     \
    -echo_edu                                                 \
    -npb $portnum                                             \
    -com viewer_cont -key 'Ctrl+left'                         \
    -com viewer_cont -key 'Ctrl+r'

echo ""
echo "---------------------------"
echo "++ Done.  Saved SUMA image."

exit 0
