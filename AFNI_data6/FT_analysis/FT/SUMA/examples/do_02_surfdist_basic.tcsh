#!/bin/tcsh

# Basic example of calculating distance between two points on a
# surface.  Here, input 2 (x, y, z) locations, then we find the
# closest nodes on the desired surface, and then find the geodesic
# distance along the surface (= shorted distance constrained to
# surface).  

# This example is mildly interactive, so we will be making a text file
# and copy+pasting as we go, rather than running the whole script.

echo "+* This script is interactive-- don't just run the whole thing."
echo "   Read the script, and copy+paste in batches."
exit 1

### where this demo is located to be run:
# cd ~/AFNI_data6/FT_analysis/FT/SUMA

# -------------------------------------------------------------------

# 1) Define endpoints for distance calc. These are in RAI-DICOM
#    notation (negative sign for R|A|I, and positive for L|P|S). So
#    these points are on *right* hemi, and we will just use the "rh"
#    surface, below.

echo "-49 60 -3" >  XYZ.1D
echo " -5 79 10" >> XYZ.1D


# 2) Identify nodes of the surface corresponding to each endpoint.
#    Each node index will have a "L" or "R" at the end, specifying
#    which hemi it is in.  I also explicitly specify that coordinates
#    are in RAI-DICOM notation (though that is the default). The order
#    of letters after qual should match my order of "-i .." arguments:
#    in this case, left then right.

Surf2VolCoord                                                \
    -RAI                                                     \
    -i std.60.lh.pial.gii                                    \
    -i std.60.rh.pial.gii                                    \
    -sv FT_SurfVol.nii                                       \
    -qual LR                                                 \
    -closest_nodes XYZ.1D

# 3) Now take the node indices (which should be 29439R and 31716R)
#    and put them into one line of a file, called 'nodelist.1D'"

# ---- you should have made nodelist.1D to continue... ----


# 4) This command outputs two values for each row in the
#    "-closest_nodes .."  file: 1) index node number, with the letter
#    of which surface it was ("R" here means the second surface,
#    because it was the second letter of the "-qual ..." argument);
#    and 2) the distance between my entered XYZ coordinate and the
#    given index. We also create the path itself, to display in the GUI

SurfDist                                              \
    -i     std.60.rh.pial.gii                         \
    -input nodelist.1D                                \
    -node_path_do surfdist_path_example               \
    -graph

# 5) Display result in suma GUI (NB: not specifying "-npb ..", so make
#    sure no other suma GUIs are open!

suma                                                            \
    -echo_edu                                                   \
    -i     std.60.rh.pial.gii                                   \
    -sv    FT_SurfVol.nii &

### NB: could insert this here, to view path on a different state
### surf, like "inflated"
#DriveSuma                                                      \
#    -echo_edu                                                  \
#    -com   viewer_cont -key '.' -key '.'    

DriveSuma                                                      \
    -echo_edu                                                  \
    -com   viewer_cont  -load_do surfdist_path_example.1D.do

