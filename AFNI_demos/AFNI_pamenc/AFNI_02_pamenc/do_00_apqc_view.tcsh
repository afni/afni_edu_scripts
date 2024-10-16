#!/bin/tcsh

# Construct a list of all subjects to view-- well, a sublist for no
# deep reason...
set all_files = `\ls sub-600[678]*/*.results/QC_*/index.html`

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
#   open_apqc.py -infiles `find ./sub-600[678]*/ -name "index.html" | sort`
#
# Similarly, to open all of the HTMLs:
#
#   open_apqc.py -infiles `find ./ -name "index.html" | sort`
#
# Or, to just open one, just provide the path (could also use wildcards):
#
#   open_apqc.py -infiles sub-10506/sub-10506.results/QC_sub-10506/index.html
