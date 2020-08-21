#!/bin/tcsh -f

# ver=3.0

# Mini-probabilistic tracking example: this method uses determinstic
# tractography + a simple extension of including few Monte Carlo
# iterations of perturbed tensor values (via uncertainty estimations).
# This can be useful to get a broader (more robust?) sense of tract
# locations, intermediate to (and faster than) full probabilistic
# tracking itself-- hence it is referred to as the
# `mini-probabilistic' option.  The same deterministic algorithm
# options from before are used.

# Previously, in Do_05*.tcsh, we looked at AND-logic connections among
# the four networks of interest. Let's do a few iterations in MINIP
# mode, and compare results.

set uncfile = `\ls DTI/o.UNCERT*HEAD`

3dTrackID -mode MINIP                 \
    -dti_in DTI/DT                    \
    -netrois "ROI_ICMAP_GMI+orig"     \
    -logic AND                        \
    -no_indipair_out                  \
    -dump_rois AFNI_MAP               \
    -nifti                            \
    -mini_num 7                       \
    -uncert "${uncfile[1]}"    \
    -prefix DTI/o.NETS_AND_MINIP      \
    -write_opts                       \
    -overwrite             -echo_edu  

# visualize all WM connections as surfaces of volumetric WM
# connections (could also just view as tracts)
fat_proc_connec_vis                             \
    -in_rois DTI/o.NETS_AND_MINIP/NET_000_*     \
    -prefix  DTI/o.NETS_AND_MINIP_surfs         \
    -trackid_no_or     

# ... and view with, for example:
###   suma -onestate -i DTI/o.NETS_AND_MINIP_surfs/wmc*.gii -vol DTI/DT_FA+orig

cat <<EOF

++ Consider viewing some of the mini-probabilistic tracking output with,
   for example, this:

     suma -onestate -i DTI/o.NETS_AND_MINIP_surfs/wmc*.gii -vol DTI/DT_FA+orig

EOF
