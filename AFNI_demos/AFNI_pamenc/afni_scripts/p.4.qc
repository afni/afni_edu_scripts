#!/bin/tcsh

# ===================== based on S.0.template.txt ======================

# - make a group mask

# ======================================================================
# init variables and allow command line options:
#    script_dir, study_root_in, study_root_out, deriv_dir,
#    all_subjects, nsubj
# Note that script_dir will need to be set basically every
#      time, since calling 'init_vars' will be universal.

# --------------------------------------------------
# variables to propagate to other scripts (always pass)

# the location of processing scripts (use full path)
set script_dir = `pwd`

# verbosity level
set verb = 0

set redo = 0

set allow_missing = 0

# taskname to process
set taskname = pamenc

# this corresponds to the command script that is run, c.ss.$cmd_label
# e.g. c.ss.3.make_spec
set cmd_label = 4.qc

# are we swarming this?
set swarm = 0

# --------------------------------------------------
# variables specifiec to this script

# the name of this script
set prog = `basename $0`

# list of subjects to process
set subj_proc_list = ()

# processing directory that goes under derivatives
# ** for this script, dirs must correspond with those in c.ss.$cmd_label
set proc_dir = AFNI_02_$taskname

# ======================================================================
# process command-line arguments
set ac = 1
while ( $ac <= $#argv )
   if ( "$argv[$ac]" == "-help" ) then
      echo "$prog       - run @SSwarper for the given subjects"
      echo ""
      echo "usage: $prog [options...] subj subj ..."
      echo ""
      echo "options specific to this script"
      echo ""
      echo "  -proc_dir DIR     : root directory under 'derivates' for results"
      echo "                      default: $proc_dir"
      echo ""
      echo "general options"
      echo ""
      echo "  -help             : show help and exit"
      echo "  -verb LEVEL       : set verbosity level (2 means show commands)"
      echo "                      default: $verb"
      echo "  -allow_missing    : skip missing subjects, but proceed"
      echo "  -redo             : (delete previous and) re-create results"
      echo "  -script_dir DIR   : specify directory of processing scripts"
      echo "                      default: $script_dir"
      echo "  -swarm            : use HPC swarm for this process"
      echo ""
      exit 0
   else if ( "$argv[$ac]" == "-proc_dir" ) then
      @ ac ++
      if ( $ac > $#argv ) then
         echo "** -proc_dir: missing argument"
         exit 1
      endif
      set proc_dir = $argv[$ac]
   else if ( "$argv[$ac]" == "-allow_missing" ) then
      set allow_missing = 1
   else if ( "$argv[$ac]" == "-redo" ) then
      set redo = 1
   else if ( "$argv[$ac]" == "-script_dir" ) then
      @ ac ++
      if ( $ac > $#argv ) then
         echo "** -script_dir: missing argument"
         exit 1
      endif
      set script_dir = $argv[$ac]
   else if ( "$argv[$ac]" == "-swarm" ) then
      set swarm = 1
   else if ( "$argv[$ac]" == "-verb" ) then
      @ ac ++
      if ( $ac > $#argv ) then
         echo "** -verb: missing argument"
         exit 1
      endif

      # if 2 or more, set echo to see commands
      if ( $verb >= 2 ) set echo
   else
      # everything else should be a subject
      set subj_proc_list = ( $argv[$ac-] )
      break
   endif

   @ ac ++
end

# source the variable init file (to keep them mostly in one place)
# sets: study_root_in, study_root_out, deriv_dir, all_subjects, nsubj
source $script_dir/c.0.init_vars

# ======================================================================
# do some work...

echo "== time == starting : `date`"

# input directory is original, for participants.txt
set in_dir = $deriv_dir/$proc_dir

# output directory will be the same, generating a QC sub-dir
set res_dir = $in_dir
echo "-- $prog : results will go under $res_dir"

# check for old QC dir
if ( -d $res_dir/QC ) then
   if ( $redo ) then
      echo "** have -redo: removing old $res_dir/QC dir..."
      \rm -fr $res_dir/QC
   else
      echo "** have old $res_dir/QC dir"
      echo "   will not proceed without -redo"
      exit 1
   endif
endif

# check I/O dirs
set missing = 0
set done    = 0
set todo    = 0
set nredo   = 0
set subjs_todo = ()
foreach sid ( $subj_proc_list )
   # if redo, delete old
   set final_dir = $res_dir/$sid/$sid.results
   if ( $redo &&  -d $final_dir ) then
      echo "-- deleting AP result for subject $sid for re-run"
      @ nredo += 1
      \rm -fr $final_dir $res_dir/$sid/proc.$sid
   endif

   # check a couple of inputs
   if ( ! -f $res_dir/$sid/$sid.results/out.ss_review.$sid.txt ) then
      echo "** subject $sid missing out.ss_review file"
      @ missing += 1
   else
      set subjs_todo = ( $subjs_todo $sid )
      @ todo += 1
   endif
end


echo ""
echo "-- $prog subjects: $missing missing, $todo ready"
echo ""

   # if redo, delete old mask

# allow missing subjects?  seems like an error, but there could be reasons
if ( $missing > 0 ) then
   if ( $allow_missing ) then
      echo "** $prog : proceeding even with $missing missing subjects ..."
      sleep 3
   else
      echo "** $prog : will not proceed if any subjects are missing"
      exit 1
   endif
endif

# run commands from top-level deriv task dir, and move into group_analysis
cd $res_dir

# NO b.slurm, since this is not subject based
tcsh $script_dir/c.ss.$cmd_label SUBJ_JUNK $in_dir $res_dir

