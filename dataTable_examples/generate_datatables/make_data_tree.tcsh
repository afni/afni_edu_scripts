#!/usr/bin/env tcsh

# ---------------------------------------------------------------------------
# This script is used to make a data tree of (empty) NIFTI datasets,
# for use with examples from
#    gen_group_command.py -command datatable ...
# See section F from "gen_group_command.py -help" (or -hweb):
#    https://afni.nimh.nih.gov/pub/dist/doc/htmldoc/programs/alpha/gen_group_command.py_sphx.html
# ---------------------------------------------------------------------------

# make lists of beta labels and subject codes
set bstr = '{B,A}_{R,G}_T{1,2,3}'
set sstr = '{0044,0046,0049,0053,0060,0061,0064,0073,0075,0076}'

# create a directory tree for example F1, and then run F1
mkdir all_results
touch all_results/sub-$sstr.nii.gz

# ------ run command F1 here

# create a directory tree for example F2, and then run F2
mkdir -p all_results/data.$bstr
touch all_results/data.$bstr/sub-$sstr.nii.gz

# ------ run command F2 here

# create an additional attributes file, and then run F3
echo Subj Group ValA ValB > subject_attrs.tsv
foreach subj ( $sstr )
    echo sub-$subj G_$subj VA_$subj VB_$subj >> subject_attrs.tsv
end

