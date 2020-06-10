###########################################################################

  FATCAT-MVM description and test demo.
  Aug 2014, by PA Taylor and G Chen.

  v1.1

  This directory contains an example data set for taking a group's
  structural connectivity output from 3dTrackID (*.grid files),
  combining it in a simply-formatted table with subject information
  from a CSV file (e.g., dumped from a spreadsheet), and building a
  script to run 3dMVM for statistical modeling.  Importantly, this
  provides a way to combine a network's worth of data (so it is
  something like a set of repeated measures) for investigating
  statistical relations between structural scan info (for example, FA)
  and other measures, observations, test scores, etc.

  This procedure also works directly for investigating functional
  connectivity with *.netcc files output by 3dNetCorr.  For all steps
  described in this demo set, one could equivalently replace *.grid
  file procedures for *.netcc ones.

  Below is a description of: 
      + what data needs to be input (and how formatted);
      + what each program does;
      + a brief description of some options; and
      + what the outputs are.

  For questions about the 3dTrackID/3dNetCorr side of things, contact:
      PA Taylor:  neon.taylor@gmail.com
  For questions about the 3dMVM/modeling side of things, contact:
      G Chen:  gangchen@mail.nih.gov

  Requires:  
           R 3.0 or above.
           Python 2.7 or above.
           AFNI compile date Aug. 11, 2014 or later.

##########################################################################

  This program is part of AFNI-FATCAT:
    Taylor PA, Saad ZS (2013). FATCAT: (An Efficient) Functional And
    Tractographic Connectivity Analysis Toolbox. Brain Connectivity.

  For citing the statistical approach, please use the following:
    Chen, G., Adleman, N.E., Saad, Z.S., Leibenluft, E., Cox, R.W. (2014).
    Applications of Multivariate Modeling to Neuroimaging Group Analysis:
    A Comprehensive Alternative to Univariate General Linear Model. 
    NeuroImage 99:571-588.
    http://afni.nimh.nih.gov/pub/dist/HBM2014/Chen_in_press.pdf

  (And hopefully, the paper applying this method in a group study will be 
    available in the near future.)

###########################################################################

+ OVERVIEW

  We want to combine A) a group's set of *.grid files for a given network
  with B) other subject information of interest for statistical modeling.

  Step 0 (may not be necessary, depending on how uptodate 3dTrackID
  version is), using 'fat_mvm_gridconv.py':

       Read in old *.grid files,

       -> produce: new, fat_mvm_prep.py-readable ones (*_MOD.grid)
       
       If your 3dTrackID grid file does not have lots of information
       commented with '#' characters throughout it, providing names
       and numbers of parameters, as well as the list of ROIs, then
       this is an 'old school' file that needs updating.  If the first
       character of your grid file is a '#', then you don't need to
       perform this step.


  Step 1, using 'fat_mvm_prep.py':

       Read in *.csv file,

       Read in *.grid files,
            o find matrix elements (i.e., ROIs) that have nonzero values
              for *all* subjects-- currently, no missing data modeling
              possible.

       -> produce: 
                 - a data table (*_MVMtbl.txt) readable by 3dMVM, with one
                   row per subject and whose columns contain both CSV- and
                   *.grid-data;
                 - a log file (*_MVMprep.log) containing a recording of
                 - *.grid file and CSV subject matching, a list of matrix
                   element (i.e., ROI) locations found for further 
                   analysis, and a list of parameter names (i.e., which
                   matrices were in the *.grid files).
                   

  Step 2, using 'fat_mvm_scripter.py':

       Read in the list of ROIs for statistical modeling 
            - can be done by providing the *_MVMprep.log file or an explicit
              commandline list; these will be run in individual models-- 
              i.e., one for FA, one for MD, etc.),

       Read in the list of variables for the statisical modeling
            - can be done by providing simple text file (one variable
              per line) or an explicit list in the commandline.
              Variable names must match column names from original CSV
              file (now stored in *_MVMtbl.txt file).  (The
              interaction of variables is not currently parsed for in
              the Python script, but watch this space...  NB:
              interaction of variables *is* allowed in the '-bsVars'
              entries of 3dMVM, so in the meantime you can edit the
              created script to include this; see '3dMVM -help' for
              more description.)

       Read in name of table file (*_MVMtbl.txt),
       -> produce: a script for running 3dMVM. **This is a basic
                   starter script which you can modify if you want.**
                   If you have P parameters (i.e., matrices in a *grid
                   file), N variables selected to model from your CSV
                   data and R ROIs per matrix, then you are will be
                   set up to run P multivariate tests with N+1 effects
                   (plus-one because of the intercept) and at least
                   P*N*R post hoc tests (for each parameter, there is
                   a set of N*R posthoc tests-- if any variables are
                   categorical, then there are posthoc tests run for
                   each category, hence the 'at least', above).
                   
       The idea with the tests is to investigate first whether there
       are any significant relationships between your *whole network*
       of parameters (i.e., the repeated measures) and any of your
       variables.  You can then followup within a network that show
       significant association, using the posthoc tests to see what
       regions appear to be the strongest drivers of the relation.


   Step 3, using the created script: 
       Run the script (and feel free to edit it more beforehand if you
       want-- these tools are just to help get you started, and to
       help you with making table file easily).

########################################################################

DEMO EXAMPLE SET

For any of the three programs (fat_mvm*.py) discussed here, please use
the humble '-h' option to see the help description for more
information.

The data in this FAT_MVM_DEMO/ file is simply:
    + CSV file of 20 subjects' data:     all_subj_info.csv
    + group of 20 *.grid files:          SUBJ_TR_GRID/*.grid

1) Combine the *.grid files and the CSV file of subject data. The
   matching of *.grid file to CSV file 'Subj ID' is done by assuming
   that the 'Subj ID' is somewhere contained explicitly in the path to
   each *.grid file.  If this is not the case, you can provide a two
   column list matching 'Subj ID' to *.grid file (see 'fat_mvm_prep.py
   -h' for more info):

   $ fat_mvm_prep.py -p DEMO -c all_subj_info.csv     \
                     -m 'SUBJ_TR_GRID/*_000_MOD.grid'

   Check and see how the produced DEMO_MVMprep.log and DEMO_MVMtbl.txt
   files look. For the table file: each row contains data for one
   subject; the first column is 'Subj' and contains the ID; the next
   columns contain all the data from the CSV file; then comes the
   'ROI' column, with labels 'A_B' based on the tracked pair of
   targets, A and B; the penultimate column, 'matrPar' has the matrix
   parameter names; and final, the 'Ausgang_val' (output value) from
   3dTrackID for that ROI and parameter.  
   
   The log file contains some commented information, as well as the
   matching that fat_mvm_prep.py determined for the *.grid file names
   and the CSV 'Subj' IDs. *Check the visually*: if they are not
   correct, then you will likely have to provide the matching
   explicitly (see 'fat_mvm_prep.py -h' for help). Hint: your input
   for that would look pretty much like this part of the log file.

   The ROI_list contains the list of matrix elements which had no
   missing values across all subjects.  For tracking, this is
   determined by matrix locations in the 'NT' (=number of tracks)
   matrix with value >0.  For functional matrices, all elements are
   taken.  If you want a (further) subset of ROIs later, you can
   specify it in 'fat_mvm_scripter.py'.

   The Parameter_list shows the labels of matrices that were found.
   By default, each will be used in its own model when using 3dMVM; of
   course, you don't have to look at or use all of them.


2) Set up a script for 3dMVM.  Now we put all the pieces together.  As
   an example of a model, we can pick a few of the available variable
   names from the column headings.  

   $  fat_mvm_scripter.py --vars='Group TEST1 age sex' \
                          --log_file=DEMO_MVMprep.log  \
                          --table=DEMO_MVMtbl.txt      \
                          --prefix=DEMO

   You can see the script which has been built, called
   'DEMO_scri.tcsh'.  You are welcome to modify this if you want.  Due
   to the combinatorial nature of how the posthoc tests are done by
   default, you may want to not include them in the script (see
   'fat_mvm_scripter.py -h' for how).  But let's assume you're happy
   with them for the moment. 

   See how the categorical and quantitative variables are treated a
   bit differently-- the nature of the variable is determined
   internally by whether a column contains all numerical characters
   (-> quantitative) or not (-> categorical).  So, please be kind in
   how you make your spreadsheets, i.e., 'M and F', not '1 and 2'.
   The gltLabels are made as follows: for quantitative variables,
   'ROI-var' shows which ROI 'A_B' is paired with which variable (easy
   enough); for categorical ones, 'ROI-var^cat' has the additional
   information of which category is being modeled hinged on.

3) You can run the script now:

   $  tcsh DEMO_scri.tcsh

   ... and see the statistical fruits of your labor.  For example, you
   can test your hypotheses for which DTI parameters would be
   significantly related to some other variable/test of interest.

   When you run the script, you may at times see warnings-- in
   general, these are ok to see, and they should not result in
   gnashing of teeth and wailing.  They are there for diagnostic
   purposes and the everpopular 'just in case' they are useful.
