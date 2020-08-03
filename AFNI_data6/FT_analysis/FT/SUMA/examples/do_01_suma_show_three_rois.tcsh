#!/bin/tcsh

# This script assumes that you have made 3 (left hemisphere) surface
# ROIs in the directory above, and converted them into full surface
# dsets called:
#     roi1.lh.niml.dset
#     roi2.lh.niml.dset
#     roi3.lh.niml.dset

set all_dset = ( roi1.lh.niml.dset \
                 roi2.lh.niml.dset \
                 roi3.lh.niml.dset )

set all_cbar = ( red_monochrome    \
                 blue_monochrome   \
                 amber_monochrome  )

echo "HEY ${#all_dset}"

if ( ${#all_dset} != ${#all_cbar} ) then
    echo "** ERROR: need same number of colorbars as dsets"
    exit 1
endif

# Size of the image window (bigger -> higher res), given as:
#     leftcorner_X  leftcorner_Y  windowwidth_X  windowwith_Y
# ... and a small quirk: the width is tweaked in a DriveSuma command
# below to have width=800 (instead of 801), basically to refresh the
# viewer, so the brain is centered.  The exact numbers don't matter,
# but I just wanted a tiny change in view, and if the viewer size is
# *only* set below, then the suma controller annoyingly blocks view of
# the viewer.
setenv SUMA_Position_Original "0 0  801 500" 
#setenv SUMA_Light0Position "10 1 1"

setenv SUMA_AutoRecordPrefix "I_HEART_SUMA"

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

# Sagittal view, face L, and zoom in a bit
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
    -com viewer_cont -key 'F3' -key 'F4' -key 'F5' -key 'F9'   \
    -com viewer_cont -key 'Z' -key 'Z' -key 'Z' -key 'Z'       \
    -com viewer_cont -key 'Z' -key 'Z' -viewer_width 800

# load up each of the main ROIs
foreach ii ( `seq 1 1 ${#all_dset}` )

    set dset_ii = ${all_dset[${ii}]}
    set cbar_ii = ${all_cbar[${ii}]}

    echo "++ Load dset:  ${dset_ii}"

    # Open dset 1, and set opacity/disp mode/colorbar
    DriveSuma                                                     \
        -echo_edu                                                 \
        -npb $portnum                                             \
        -com surf_cont -load_dset ${dset_ii}                      \
        -com surf_cont -Opa       0.5                             \
        -com surf_cont -Dsp       Col                             \
        -com surf_cont -1_only    n                               \
        -com surf_cont -switch_cmap ${cbar_ii}
end

sleep 1

# Open dset 4, and set opacity/disp mode/colorbar (could be put into
# loop above with another array for "Dsp" opts)
DriveSuma                                                     \
    -echo_edu                                                 \
    -npb $portnum                                             \
    -com surf_cont -load_dset std.141.lh.aparc.a2009s.annot.niml.dset  \
    -com surf_cont -1_only    n                               \
    -com surf_cont -Dsp       Con                    

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
