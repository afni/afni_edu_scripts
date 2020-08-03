#!/bin/tcsh

# Advanced example of calculating distance between pairwise
# combinations of many points on a surface. Here, input several (x, y,
# z) locations on each hemisphere, then we find the closest nodes on
# the desired surface, and then find the geodesic distance along the
# surface (= shorted distance constrained to surface) for sets of
# points on each hemisphere independently (i.e., no flying between two
# hemispheres).  This example is entirely scripted (= driving SUMA),
# so I hope you like shell scripting!

# Emphasizing here: we calculated distance along the *pial* surface,
# but we look at the results on the *inflated* surface (because it is
# easier to see the paths, IMHO).  

### where this demo is located to be run:
# cd ~/AFNI_data6/FT_analysis/FT/SUMA

# ------------------------------------------------------------------------

# Choose mesh and surf state.  NB: constrained distance will vary
# along different surface "states" because they have different
# geometry (though, same topology).
set nstd      = 141
set surf_type = pial

# Define endpoints for distance calc. These are in RAI-DICOM notation
# (negative sign for R|A|I, and positive for L|P|S). So these points
# are on *right* hemi.
echo "-49  60  -3" >  XYZ.1D
echo " -5  79  -4" >> XYZ.1D
echo "-37 -48  -3" >> XYZ.1D
echo "-42   9  61" >> XYZ.1D
echo " 49  60  -3" >> XYZ.1D
echo "  5  79  -4" >> XYZ.1D
echo " 37 -48  -3" >> XYZ.1D
echo " 42   9  61" >> XYZ.1D

# Identify nodes of the surface corresponding to each endpoint.  Each
# node index will have a "L" or "R" at the end, specifying which hemi
# it is in.  I also specify coordinates are in RAI-DICOM notation
# (though that is the default). The order of letters after qual should
# match my order of "-i .." arguments: in this case, 
set node_info = `Surf2VolCoord                             \
                    -RAI                                   \
                    -i std.${nstd}.lh.${surf_type}.gii     \
                    -i std.${nstd}.rh.${surf_type}.gii     \
                    -sv FT_SurfVol.nii                     \
                    -qual LR                               \
                    -closest_nodes XYZ.1D`

# Build a list of all nodes in a particular hemisphere
set nodelist_lh = ( )
set nodelist_rh = ( )

foreach ii ( `seq 1 2 ${#node_info}` )
    # separate out hemi and index for each node; well, index can keep
    # the letter part on it (could be removed, if you wanted)
    set hemi = `printf ${node_info[${ii}]} | tail -c 1`
    set idx  = `printf ${node_info[${ii}]}`

    if ( "${hemi}" == "R" ) then
        set nodelist_rh = ( ${nodelist_rh} ${idx} ) 
    else
        set nodelist_lh = ( ${nodelist_lh} ${idx} ) 
    endif

    echo "++ Node: hemi=${hemi}, index=${idx}"
end

# This command outputs two values for each row in the "-closest_nodes
# .."  file: 1) index node number, with the letter of which surface it
# was ("R" here means the second surface, because it was the second
# letter of the "-qual ..." argument); and 2) the distance between my
# entered XYZ coordinate and the given index.

if ( ${#nodelist_lh} ) then
    printf "" > nodelist_lh.1D

    foreach ii ( `seq 1 1 ${#nodelist_lh}` )
        @ j0 = ${ii} + 1
        foreach jj ( `seq ${j0} 1 ${#nodelist_lh}` )
            printf "%10s %10s\n"        \
                ${nodelist_lh[${ii}]}   \
                ${nodelist_lh[${jj}]}   \
                >> nodelist_lh.1D
        end
    end
endif

if ( ${#nodelist_rh} ) then
    printf "" > nodelist_rh.1D

    foreach ii ( `seq 1 1 ${#nodelist_rh}` )
        @ j0 = ${ii} + 1
        foreach jj ( `seq ${j0} 1 ${#nodelist_rh}` )
            printf "%10s %10s\n"        \
                ${nodelist_rh[${ii}]}   \
                ${nodelist_rh[${jj}]}   \
                >> nodelist_rh.1D
        end
    end
endif

# Calc all pairwise distances, and save the traversed path as a "DO" =
# "displayable object" type.
foreach hh ( lh rh )
    SurfDist                                                   \
        -i      std.${nstd}.${hh}.${surf_type}.gii             \
        -input  nodelist_${hh}.1D                              \
        -graph                                                 \
        -node_path_do surfdist_path_${hh}                      \
        > all_distances_${hh}.1D

    echo ""
    echo "-----------------------------------------------------------------------"
    echo "++ distances for ${hh}: all_distances_${hh}.1D"
    echo ""
    
    cat all_distances_${hh}.1D

    echo ""
    echo "-----------------------------------------------------------------------"

end

# Open suma GUI, display geodesic lines traversed on the inflated
# surfaces.
foreach hh ( lh rh )

    # port number for AFNI+SUMA to talk to each other
    set portnum = `afni -available_npb_quiet`

    suma                                                            \
        -echo_edu                                                   \
        -npb   ${portnum}                                           \
        -spec  std.141.FT_${hh}.spec                                \
        -sv    FT_SurfVol.nii &

    # Navigate to a surface state that we want to display on-- here I
    # have chosen the "inflated" surface.  NB: a quirk is that if you
    # hit the '.' or ',' to move to a different surface state, the
    # "displayable object" loaded in the next command won't be
    # visible-- so just choose your state ahead of time (= the Glenian
    # solution).
    DriveSuma                                                      \
        -echo_edu                                                  \
        -npb   ${portnum}                                          \
        -com   viewer_cont -key '.' -key '.'    

    DriveSuma                                                      \
        -echo_edu                                                  \
        -npb   ${portnum}                                          \
        -com   viewer_cont  -load_do surfdist_path_${hh}.1D.do
end



exit 0

