#!/usr/bin/env tcsh

# taken from example F of : gen_group_command.py -help

#     *** this is tcsh syntax (not bash, not zsh) ***

# ----------------------------------------------------------------------
# data tree created as -help describes, now in make_data_tree.tcsh

# ----------------------------------------------------------------------
# example F1   - one dataset per subject

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
# example F2   - one volume per beta per subject

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
# example F3   - same as F2, but with extra TSV file

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

