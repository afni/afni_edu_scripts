#!/bin/tcsh

# ----------------------------------------------------------------------
# modify per command

set nneeded = 3
set use_args = "SID INDATA_ROOT OUTDATA_ROOT"

set sid = "$1"
set indata_root = "$2"
set outdata_root = "$3"

# note: INDATA_ROOT  should be original tree, including EPI
# note: OUTDATA_ROOT should be derivatives dir, we will assume children

# inputs: 
#    AFNI_01_SSwarper   - anats: orig, SS, warped; warps
#    Freesurfer_01_afni - masks and FS datasets
#    main data root     - EPI
#    AFNI_02_MGT_NL     - cur dir - timing files
#
# ==> let $indata_root be 'derivatives', so we don't need to pass all


# ----------------------------------------------------------------------
# static test

if ( $#argv < $nneeded ) then
    set script = `basename $0`
    echo $script : need $nneeded parameters
    echo ""
    echo "usage: $script $use_args"
    echo ""
    echo "command : $argv"
    echo ""
    exit 1
endif


# ----------------------------------------------------------------------
# set subject lists
setenv OMP_NUM_THREADS 15


# input directory is single-subject result tree
set in_dir = $indata_root

# output directory will be QC dir, in prep for group analysis
set res_dir = $outdata_root


# run commands from top-level deriv task dir, and move into group_analysis
cd $in_dir
set rdir = QC
if ( ! -d $rdir ) \mkdir -v $rdir

set echo


# note AFNI bin dir and template
set abin = `which 3dresample`
set abin = $abin:h
set template = MNI152_2009_template_SSW.nii.gz

echo "-- checking for template $template"
if ( -f $abin/$template && ! -f $rdir/$template ) then
   \cp -v $abin/$template $rdir
endif

gen_ss_review_table.py                                          \
        -outlier_sep space                                      \
        -report_outliers 'AFNI version' VARY                    \
        -report_outliers 'num regs of interest' VARY            \
        -report_outliers 'final voxel resolution' VARY          \
        -report_outliers 'num TRs per run' VARY                 \
        -infiles sub*/s*.results/out.ss*.txt                    \
        -write_outliers $rdir/outliers.a.VARY.txt               \
        -overwrite | tee $rdir/out.outliers.a.VARY.txt

gen_ss_review_table.py                                          \
        -outlier_sep space                                      \
        -report_outliers 'censor fraction' GE 0.15              \
        -report_outliers 'average censored motion' GE 0.1       \
        -report_outliers 'max censored displacement' GE 8       \
        -infiles sub*/s*.results/out.ss*.txt                    \
        -write_outliers $rdir/outliers.b.short.txt              \
        -overwrite

set bad_subs = ( `awk '{if (NR>2) print $1}' $rdir/outliers.b.short.txt` )
awk '{if (NR>2) print $1}' $rdir/outliers.b.short.txt \
    > $rdir/outliers.c.drop.subs.txt
echo ""
echo "=== subjects to drop: $bad_subs"
echo ""


# generate review table spreadsheet
echo "-- generate reivew table and label list"
gen_ss_review_table.py -tablefile $rdir/ss_review_table.xls \
        -infiles sub*/s*.results/out.ss*.txt
# and note labels
gen_ss_review_table.py -showlabs -infiles sub*/s*.results/out.ss*.txt \
        >& $rdir/ss_review_labels.txt

# ACF params and average
echo "-- collect and average ACF parameters"
grep -h ACF sub*/*.results/out.ss*.txt | awk -F: '{print $2}' \
        > $rdir/out.ACF.vals.1D
grep -h ACF sub*/*.results/out.ss*.txt | awk -F: '{print $2}' \
        | 3dTstat -mean -prefix - 1D:stdin\' > $rdir/out.ACF.means.1D

# masks
echo "-- making intersection, mean and 70% masks"
set nmasks = `echo sub*/*.results/mask_epi_anat*.HEAD | wc -w`
3dTstat -mean -prefix $rdir/mask.mean 'sub*/*.results/mask_epi_anat*.HEAD'
3dmask_tool -input sub*/*.results/mask_epi_anat*.HEAD \
            -prefix $rdir/group_mask.7 -frac 0.7
3dmask_tool -input sub*/*.results/mask_epi_anat*.HEAD \
            -prefix $rdir/group_mask.inter -frac 1.0
# use 70% mask for group
set group_mask = group_mask.7

# get anats and EPI for registration comparison
echo "-- making mean and TCAT anat and EPI dsets"
3dTcat -prefix $rdir/all.EPI.vr.tcat     sub*/*.results/final_epi_vr*.HEAD
3dTcat -prefix $rdir/all.anat.final.tcat sub*/*.results/anat_final*.HEAD

3dMean -prefix $rdir/all.EPI.mean  sub*/*.results/final_epi_vr*.HEAD
3dMean -prefix $rdir/all.anat.mean sub*/*.results/anat_final*.HEAD


# might make a probability map of FS ROIs, but do it in another script



# clustsim?  Naybe not in the case of ETAC no blur
if ( 1 ) then
   echo "-- running clustsim"
   cd $rdir
   mkdir files_ClustSim
   set params = ( `cat out.ACF.means.1D` )
   3dClustSim -both -mask $group_mask+tlrc -acf $params \
           -cmd 3dClustSim.ACF.cmd -prefix files_ClustSim/ClustSim.ACF
   1d_tool.py -infile files_ClustSim/ClustSim.ACF.NN1_bisided.1D \
           -csim_show_clustsize > out.clustmethod.txt
   cd -
endif

# here are some copies of other commands
exit 0

cd $in_dir
aiv -pad sub-*/sub-*.results/Grayplot.errts.*.png



