
This "feedback" demo shows use of Dimon to send images to afni's
realtime plugin, which does registration, before extracting ROI
averages and raw voxel data to send to realtime_receiver.py, which
could then be used for feedback.

It is preferable to use 3 terminals to run this, to keep the text
separate.


In terminal A: ./demo.3.fback.1.receiver
(and leave this running).

   This starts the receiver program, which waits to receive data
   from afni's realtime plugin.  Per time point, it will receive:
        - motion parameters
        - ROI averages, for ROI 2 (L_vis) and 3 (R_vis)
        - raw data, for ROI 1 voxels (L_aud)


Then in terminal B: ./demo.3.fback.2.afni
(this can also be left running).

   This start up afni in realtime mode, after setting environment
   variables (which could be set in the realtime plugin interface)
   that will enable registration and the sending of ROIs_and_data
   to realtime_receiver.py.


Then in terminal C: ./demo.3.fback.3.feedme
(this can be run multiple times to repeat the demo).

   This runs Dimon, sending the images under AFNI_data6/EPI_run1
   to afni's realtime plugin.  This simulates what might be collected
   at a scanner.



Verification: ./demo.3.fback.4.stats

   To verify that the values coming out of the realtime system
   (Dimon -> afni -rt -> realtime_receiver.py), one can run 
   3dROIstats to get the expected ROI averages.  The raw time
   series for the 2 voxels in L_aud are already extracted in
   046_032_015.1D and 046_033_015.1D under rt.input.

   Running this script will show what is expected from the realtime
   system, i.e., what should be output from realtime_receiver.py.

   It is computed "after the fact" for demonstration.


R Reynolds   23 Jan 2020 
 
