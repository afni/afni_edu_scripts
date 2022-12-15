Demo For the Insta-Correlation tools in AFNI/SUMA:

Unpack the archive ARCHIVE.tgz you have downloaded. 
'ARCHIVE' stands for the archive name without the extension.
There are three archives avaliable. The one with _VOL in the name
is for volume-based GroupInCorr only. The one with _SRF in the name
contains surface-based GroupInCorr only. The one without _VOL and _SRF
in the name contains both. All archives unpack into AFNI_InstaCorrDemo.

   1- tar xvzf ARCHIVE.tgz
   2- cd AFNI_InstaCorrDemo
   
For Volume-based GroupInCorr:
	3a- cd vol
		./@SetupVolGroupInCorr
	4a- Play with volume-based group instacorr demo
		./@RunVolGroupInCorr

For Surface-based GroupInCorr:
	3b- cd srf
		./@SetupSurfGroupInCorr 
	4b- Play with surface-based group instacorr demo
		./@RunSurfGroupInCorr

For Single-subject surface-based InstaCorr:
	(This assumes you ran 3b already)
	3c- cd srf 
      ./@RunSingleSurfInstaCorr -setup_only
   4c- Play with single-subject demo
		./@RunSingleSurfInstaCorr
