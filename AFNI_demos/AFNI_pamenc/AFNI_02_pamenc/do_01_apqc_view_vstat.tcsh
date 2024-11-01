#!/bin/tcsh

# Construct a list of all subject APQC HTML reports to view.  NB: only
# a subset of sub-*/ directories here actually contain the full QC_*/
# report directories.
set all_files = ( sub-*/*.results/QC_*/index.html )

# open several APQC HTMLs together, and have each "jump to" the vstat
# section:
open_apqc.py -jump_to vstat -infiles ${all_files} 

# ... and now you can use Ctrl+Tab and Ctrl+Shift+Tab to cycle forward
# and backward, respectively, through the browser tabs.
#
# You can also double-click on any gold-text heading, and that element
# will move to the top of the page, *as well as in all other tabs that
# were opened at the same time*.

# ==========================================================================
# 
# NOTES
#
# One can jump to any section ID (show in APQC HTML top menu bar), or
# actually most elements within a section. To see what all the "jump
# IDs" are within a set of one or more HTMLs, run:
#
#   open_apqc.py -disp_jump_ids -infiles HTML1 [HTML2 HTML3 ...]
