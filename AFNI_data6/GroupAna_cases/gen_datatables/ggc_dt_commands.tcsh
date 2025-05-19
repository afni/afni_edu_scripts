#!/usr/bin/env tcsh

# taken from example F of : gen_group_command.py -help

#     *** this is tcsh syntax (not bash, not zsh) ***

# ----------------------------------------------------------------------
# make lists of beta labels and subject codes
set bstr = '{B,A}_{R,G}_T{1,2,3}'
set sstr = '{0044,0046,0049,0053,0060,0061,0064,0073,0075,0076}'

# ----------------------------------------------------------------------
# create a directory tree for example F1, and then run F1
mkdir all_results
touch all_results/sub-$sstr.nii.gz

   gen_group_command.py                        \
      -command datatable                       \
      -dsets all_results/sub*.nii.gz           \
      -dt_factor_list visit before after       \
      -dt_factor_list color red green          \
      -dt_factor_list task  T1 T2 T3           \
      -subs_betas B_R_T1 B_R_T2 B_R_T3         \
                  B_G_T1 B_G_T2 B_G_T3         \
                  A_R_T1 A_R_T2 A_R_T3         \
                  A_G_T1 A_G_T2 A_G_T3         \
      -write_script dt_1.txt

# ----------------------------------------------------------------------
# create a directory tree for example F2, and then run F2
mkdir -p all_results/data.$bstr
touch all_results/data.$bstr/sub-$sstr.nii.gz

   gen_group_command.py                        \
      -command datatable                       \
      -dt_factor_list visit before after       \
      -dt_factor_list color red green          \
      -dt_factor_list task  T1 T2 T3           \
      -dsets all_results/data.B_R_T1/sub*.gz   \
      -dsets all_results/data.B_R_T2/sub*.gz   \
      -dsets all_results/data.B_R_T3/sub*.gz   \
      -dsets all_results/data.B_G_T1/sub*.gz   \
      -dsets all_results/data.B_G_T2/sub*.gz   \
      -dsets all_results/data.B_G_T3/sub*.gz   \
      -dsets all_results/data.A_R_T1/sub*.gz   \
      -dsets all_results/data.A_R_T2/sub*.gz   \
      -dsets all_results/data.A_R_T3/sub*.gz   \
      -dsets all_results/data.A_G_T1/sub*.gz   \
      -dsets all_results/data.A_G_T2/sub*.gz   \
      -dsets all_results/data.A_G_T3/sub*.gz   \
      -write_script dt_2.txt

# ----------------------------------------------------------------------
# create an additional attributes file, and then run F3
echo Subj Group ValA ValB > subject_attrs.tsv
foreach subj ( $sstr )
    echo sub-$subj G_$subj VA_$subj VB_$subj >> subject_attrs.tsv
end

   gen_group_command.py                        \
      -command datatable                       \
      -dt_tsv subject_attrs.tsv                \
      -dt_factor_list visit before after       \
      -dt_factor_list color red green          \
      -dt_factor_list task  T1 T2 T3           \
      -dsets all_results/data.B_R_T1/sub*.gz   \
      -dsets all_results/data.B_R_T2/sub*.gz   \
      -dsets all_results/data.B_R_T3/sub*.gz   \
      -dsets all_results/data.B_G_T1/sub*.gz   \
      -dsets all_results/data.B_G_T2/sub*.gz   \
      -dsets all_results/data.B_G_T3/sub*.gz   \
      -dsets all_results/data.A_R_T1/sub*.gz   \
      -dsets all_results/data.A_R_T2/sub*.gz   \
      -dsets all_results/data.A_R_T3/sub*.gz   \
      -dsets all_results/data.A_G_T1/sub*.gz   \
      -dsets all_results/data.A_G_T2/sub*.gz   \
      -dsets all_results/data.A_G_T3/sub*.gz   \
      -write_script dt_3.txt


