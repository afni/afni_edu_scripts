#!/usr/bin/env tcsh


# convert the event TSV files into AFNI timing format
timing_tool.py                            \
    -multi_timing_ncol_tsv  sub-000*.tsv  \
    -write_multi_timing     stim.         \
    -nplaces                1


exit 0

# Below (not run) contains an example of the opposite conversion
# ----------------------------------------------------------------------------

# reverse: AFNI format back to TSV
timing_tool.py                          \
    -multi_timing      times.*          \
    -multi_stim_dur    20               \
    -write_simple_tsv  sub-000_task-av

