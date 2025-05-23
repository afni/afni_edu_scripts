#!/usr/bin/env tcsh

##################################
## 04/2024 Justin Rajendra
## 3dMVM testing

## where is everything?
set BaseFolder = '../'
set OutFolder  = 'results'
cd $BaseFolder

## prefix
set OutFile = '01_test1_bad_not_rect_MVM'
set InFile  = '01_test1_bad_not_rect'

if ( -f ${OutFolder}/${OutFile}_log.txt ) then
    rm ${OutFolder}/${OutFile}_log.txt
endif

3dMVM -overwrite \
-prefix ${OutFolder}/${OutFile}.nii.gz \
-bsVars "group*group2" \
-qVars "score,rt" \
-dataTable @data_dataTables/${InFile}.tsv
