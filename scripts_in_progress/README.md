This directory is for "scripts in progress", that will eventually be distributed in the main Bootcamp dataset.

Clipping plane demo (Linux):
$ cd ~/AFNI_demos/FATCAT_DEMO/SUMA
$ suma -onestate -i *.gii      -drive_com "-com viewer_cont -load_view ex_view2.niml.vvs" &
$ DriveSuma -com viewer_cont -key "Shift+Ctrl+C"
