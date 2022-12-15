                       ==============================
                         SCATTER PLOT IN CLUSTERIZE
                       ==============================

This directory and these instructions are meant to show you how to use the
AFNI interactive Clusterize feature to plot a mean dataset series extracted
from a cluster ROI vs. a 1D covariate file.  For example, the 1D covariate
file could be a subject-level parameter (e.g., age or verbal IQ), and the
dataset being graphed could be the subject-level results of an FMRI task
analysis.

This directory contains the following datasets and other files:

AAA_README.txt          = this file
MNI152_1mm_uni+tlrc     = MNI template, used for the Underlay

TaskParam+tlrc          = contains 30 sub-bricks, from 3dDeconvolve
TaskParam_cov.1D        = contains 30 numbers, covariate values for the dataset
TaskParam_stats+tlrc    = statistical dataset, for thresholding and clustering

GICrest.cov.txt         = covariates for the 3dGroupInCorr demonstration
GICrest.grpincorr.data  = data for 3dGroupInCorr
GICrest.grpincorr.niml  = header for 3dGroupInCorr data

==================== STEP BY STEP INSTRUCTIONS: TaskParam ======================

In this example, the TaskParam+tlrc data (30 values per voxel) will be scatter
plotted vs. the covariates in the external 1D text file TaskParam_cov.1D (30
lines of text).

** Note: Steps 1-3 can be carried out by running the script ./@RunTask
         Steps 4 and onwards must be carried out interactively

-- Step 1 --
* Run afni

-- Step 2 --
* Click 'UnderLay' to make sure the underlay dataset is MNI152_1mm_uni+tlrc
* Click 'OverLay' to set the the overlay dataset to TaskParam_stats+tlrc

-- Step 3 --
* Open at least 1 image viewer window
* The 'OLay' and 'Thr' sub-bricks should be set to #0 and #1 (_Coef and _Tstat)
* Set the colorization range to 1 or 2, as you please
* Set the threshold to betwee 3.5 and 4.0, as you please

-- Step 4 --
* Click 'Clusterize', and set the 'Voxels' threshold to 100, then click 'Set'
* Click 'Rpt' to open the cluster report table
* Click 'Jump' for cluster #1 to jump to the peak location for that cluster

-- Step 5 --
* In the report table, click 'Aux.Dset' to choose the auxiliary dataset as
  TaskParam+tlrc
* Click 'Plot' for cluster #1 to see the plot of the mean of TaskParam+tlrc
  over cluster #1, plotted for all 30 "time" points in that dataset.  This
  graph will probably not be very interesting.

-- Step 6 --
* To plot the same information against the covariate, first click 'Scat.1D'
  (in the same row as 'Aux.Dset') to choose the x-axis file TaskParam_cov.1D,
  and then click 'Set' in the chooser window that pops up
* Then press the 'Mean' button (left of 'Scat.1D') to choose the item 'S:mean'
* Then click the cluster #1 'Plot' button again
* This type of plot is a scatter plot, with the x-axis from the 'Scat.1D' file
  and the y-axis from the 'Aux.Dset' dataset, each sub-brick averaged over the
  chosen cluster ROI
* In this example, the covariate and the mean over cluster #1 should be highly
  correlated.  The Pearson correlation and a 95% confidence interval are shown
  in the upper label above the graph.  (The confidence interval is calculated
  by a bootstrap resampling method, not by the Gaussian distribution formula.)
* You can change to show the Spearman correlation by using the right-click popup
  menu attached to the very top label in the report window (where information
  about 'Voxels survived' etc. is shown) -- choose the 'Spearman??' item, and
  then re-'Plot' the graph, which will be the same except for the correlation
  and linear fit shown atop the data.  (For Pearson, the linear fit is via
  least squares L2; for Spearman, it is via L1 regression.  These results
  should not be very different unless your data has a few wild outliers.)

==================== STEP BY STEP INSTRUCTIONS: GIC_rest =======================

If you use '-covariates' and '-sendall', 3dGroupInCorr will send to AFNI a set
of 1D files containing the covariates.  You can use one of these as a 'Scat.1D'
file in the Clusterize GUI to plot the individual subject correlations
(averaged across a cluster) vs. the covariate values -- this graph can be
amusing and even useful, as a way to see how the seed-based correlations vary
with the subject-level covariate values.

For the above suggestion to be useful, you will have to select the correct
sub-bricks for plotting via the 'From' and 'To' items in the 'Aux.Dset' row
of controls -- to see which sub-bricks are the individual subject correlations,
you could use 'OLay Info' from the Datamode->Misc menu in the AFNI controller,
or just click on the 'OLay' menu in the Overlay control panel to see the
3dGroupInCorr dataset's structure.

In this example, there are 14 subjects (from the FCON-1000 collection).
The instructions below presume you are somewhat familiar with using
InstaCorr and 3dGroupInCorr.

** Note: Steps 1-2 can be carried out by running the script ./@RunGIC
         Steps 3 and onwards must be carried out interactively

-- Step 0 --
* If the AFNI GUI is open from your earlier fun with TaskParam, close it

-- Step 1 --
* Type (or copy/paste) in the following two commands:
   3dGroupInCorr -setA GICrest.grpincorr.niml -sendall -covariates GICrest.cov.txt &
   afni -niml
* Open (at least) a sagittal and axial image window
* Make sure the underlay is the MNI152_1mm_uni+tlrc dataset

-- Step 2 --
* Use the right-click popup menu over the image viewer, choose 'Jump to (xyz)',
  and enter coordinates '0 50 20' in the coordinate chooser, then press 'Set'
* Again, use the right-click popup image viewer menu and choose 'InstaCorr Set'
* Set the threshold to about 4
* You should see the classic default mode network (DMN) in the image viewers

-- Step 3 --
* Click on 'Clusterize', choose 'Set', then open the cluster report with 'Rpt'
* Choose 'Aux.Dset' as (the only choice) dataset A_GRP_ICORR -- this is the
  same dataset as the overlay
* Using the 'OLay' button in the 'Define Overlay' control panel, you should
  see that the first 4 sub-bricks are the group statistics (over 14 subjects)
  sent from 3dGroupInCorr
* The rest of the sub-bricks, starting at #4, are the individual subject
  correlations, sent via '-sendall'
* Back in the 'Rpt' table, next to 'Aux.Dset' choose 'From' to be 4, indicating
  that the plotting from this dataset will start at sub-brick #4; you can leave
  'To' at 9999 to indicate that all the sub-bricks from #4 to the end will be
  used in the 'Plot' and 'Save' buttons

-- Step 4 --
* Choose 'Scat.1D' to be file 'GIC:DMNcov' -- this is the covariate stored
  in the file GICrest.cov.txt, and was sent over from 3dGroupInCorr when
  that program attached itself to AFNI
* For cluster #1, press 'Plot' to get the mean of the individual subject
  correlations over this ROI; the x-axis will be the subject index, and
  this plot will probably be useless to you
* Now change 'Mean' to 'S:mean' and then re-'Plot' over cluster #1; this
  covariate has been chosen to be correlated with the individual subjects,
  in the DMN, so you should see a strong trend with the same ROI means
  plotted with the x-axis as the covariate

-- Step 5 --
* At this point, you can set the InstaCorr seed at other places and see
  how the scatterplot changes for different seeds and different clusters
