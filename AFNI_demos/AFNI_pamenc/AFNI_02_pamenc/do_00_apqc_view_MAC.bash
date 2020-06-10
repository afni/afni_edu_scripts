#!/bin/bash

# This script for opening sequence of APQC HTMLs on a Mac.  Note the
# use of Safari, at the moment, because that should be installed by
# default.

# Construct a list of all subjects to view-- well, a sublist for no
# deep reason...
all_files=( `\ls sub-600[678]*/*.results/QC_*/index.html` )

here=$PWD

#open -a Safari

for ff in  ${all_files[@]}
do
    echo "++ Opening : $ff"
    #sleep 0.1

    osascript -e "tell application \"Safari\" to open location \"file://${here}/${ff}\""

done

