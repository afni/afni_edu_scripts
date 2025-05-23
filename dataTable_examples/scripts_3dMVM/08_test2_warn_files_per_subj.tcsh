#!/usr/bin/env tcsh

##################################
## 04/2024 Justin Rajendra
## 3dMVM testing

## where is everything?
set BaseFolder = '../'
set OutFolder  = 'results'
cd $BaseFolder

## prefix
set OutFile = '08_test2_warn_files_per_subj_MVM'
set InFile  = '08_test2_warn_files_per_subj'

if ( -f ${OutFolder}/${OutFile}_log.txt ) then
    rm ${OutFolder}/${OutFile}_log.txt
endif

3dMVM -overwrite \
-prefix ${OutFolder}/${OutFile}.nii.gz \
-bsVars "group_bs" \
-wsVars "group_ws" \
-qVars "score,rt" \
-dataTable @data_dataTables/${InFile}.tsv
