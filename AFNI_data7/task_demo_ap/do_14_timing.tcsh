#!/usr/bin/env tcsh

# Make timing files
#
# timing_tool.py - create and reformat timing files for EPI datasets

# ============================ TSV to AFNI =================================

cd sub-000/func

echo ""
echo "++ Make timing for AP: convert event TSV files into AFNI timing format"
echo ""

timing_tool.py                            \
    -multi_timing_ncol_tsv  sub-000*.tsv  \
    -write_multi_timing     stim.         \
    -nplaces                1


exit 0


# ============================ AFNI to TSV =================================

# this is not run here, just shown as an example

echo ""
echo "++ Reverse format conversion: AFNI format back to TSV"
echo ""

timing_tool.py                          \
    -multi_timing      stim.times.*     \
    -multi_stim_dur    20               \
    -write_simple_tsv  sub-000_task-av

