To save some disk space, the anat and func/EPI datasets are stored
only as .hdr files, keeping the headers without any actual data.

The images were separated and deleted as in:

   cd sub-10506/anat
   nifti_tool -copy_image -infiles sub-10506_T1w.nii.gz -prefix t.hdr
   rm t.img sub-10506_T1w.nii.gz
   mv t.hdr sub-10506_T1w.hdr

