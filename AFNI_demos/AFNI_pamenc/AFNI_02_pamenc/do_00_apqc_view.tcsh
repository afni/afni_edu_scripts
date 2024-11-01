#!/bin/tcsh

# Construct a list of all subject APQC HTML reports to view.  NB: only
# a subset of sub-*/ directories here contain actually the full QC_*/
# report directories.
set all_files = ( sub-*/*.results/QC_*/index.html )

# open a batch of APQC HTMLs with a single server instance, so they
# can be linked
open_apqc.py -infiles ${all_files}

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
# This cmd does the same as the above, just with a different mechanism:
#
#   open_apqc.py -infiles `find ./sub-*/ -name "index.html" | sort`
#
# Or, to just open one, provide the single path (could also use wildcards):
#
#   open_apqc.py -infiles sub-10506/sub-10506.results/QC_sub-10506/index.html
