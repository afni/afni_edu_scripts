#!/usr/bin/env tcsh

# Getting To Know Your Neighbors (GTKYD)
# 
# The gtkyd_check.py program tabulates 1 or more datasets of a given
# type across 1 or more individuals in a data collection. It outputs a
# spreadsheet (*.xls file), as well as a directory of supplemental
# text files to query.
#
# Then the gen_ss_review_table.py (GSSRT) program is then useful for
# checking those supplementary text files for individual's data that
# might have unwanted properties or unwanted variations/inconsistencies.


# ================ check and compare EPI properties ========================

# make table+supplements of all FMRI dsets 
gtkyd_check.py                                            \
    -infiles           sub-000/func/sub-*task-av*nii*     \
    -outdir            sub-000.gtkyd/all_epi

echo ""

# Review: query for specific data properties that we want to avoid.
gen_ss_review_table.py                                    \
    -outlier_sep space                                    \
    -infiles            sub-000.gtkyd/all_epi/dset*txt    \
    -report_outliers    'subject ID'     SHOW             \
    -report_outliers    'av_space'       EQ    "+tlrc"    \
    -report_outliers    'ad3'            GE    2.8        \
    -report_outliers    'nv'             VARY             \
    -report_outliers    'orient'         VARY             \
    -report_outliers    'tr'             VARY_PM 0.001    \
    |& tee              sub-000.gtkyd/all_epi_gssrt.dat


# comment the next line out to also run for the anatomical data
exit 0

# ================ check and compare T1w properties ========================


# make table+supplements of all anatomical dsets 
gtkyd_check.py                                            \
    -infiles           sub-000/anat/sub-*T1w*nii*         \
    -outdir            sub-000.gtkyd/all_anat

# Review: query for specific data properties that we want to avoid.
gen_ss_review_table.py                                    \
    -outlier_sep space                                    \
    -infiles            sub-000.gtkyd/all_anat/dset*txt   \
    -report_outliers    'subject ID'     SHOW             \
    -report_outliers    'is_oblique'     GT    0          \
    -report_outliers    'obliquity'      GT    0          \
    -report_outliers    'av_space'       EQ    "+tlrc"    \
    -report_outliers    'n3'             VARY             \
    -report_outliers    'nv'             VARY             \
    -report_outliers    'orient'         VARY             \
    -report_outliers    'datum'          VARY             \
    -report_outliers    'ad3'            VARY_PM 0.001    \
    -report_outliers    'ad3'            GT    1.1        \
    |& tee              sub-000.gtkyd/all_anat_gssrt.dat

echo ""
echo "++ Check this file for any unwanted properties:"
echo "   sub-000.gtkyd/all_anat_gssrt.dat"
echo ""
