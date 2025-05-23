#!/usr/bin/env tcsh

##################################
## 04/2024 Justin Rajendra
## 3dMVM testing

## where is everything?
set BaseFolder = '../'
set OutFolder  = 'results'
cd $BaseFolder

## prefix
set OutFile = '02_test1_bad_file_3dMVM'
set InFile  = '02_test1_bad_file'

if ( -f ${OutFolder}/${OutFile}_log.txt ) then
    rm ${OutFolder}/${OutFile}_log.txt
endif

3dMVM -overwrite \
-prefix ${OutFolder}/${OutFile}.nii.gz \
-bsVars "group*group2" \
-qVars "score,rt" \
-dataTable @data_dataTables/${InFile}.tsv
