#!/bin/tcsh

# Construct a list of all subjects to view-- well, a sublist for no
# deep reason...
set all_files = `\ls sub-600[678]*/*.results/QC_*/index.html`

# Loop over all the subjects in the list
foreach ii ( `seq 1 1 $#all_files` )

    set ff = ${all_files[$ii]}
    echo "++ Opening: $ff"
    sleep 0.1

    # Open the first HTML a new window, the rest in a new tab
    if ( $ii == 1 ) then
        firefox -new-window ${ff}\#vstat
    else
        firefox -new-tab    ${ff}\#vstat
    endif

end
