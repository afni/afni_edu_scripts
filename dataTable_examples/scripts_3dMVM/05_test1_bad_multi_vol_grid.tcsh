#!/usr/bin/env tcsh

##################################
## 04/2024 Justin Rajendra
## 3dMVM testing

## where is everything?
set BaseFolder = '../'
set OutFolder  = 'results'
cd $BaseFolder

## prefix
set OutFile = '05_test1_bad_multi_vol_grid_MVM'
set InFile  = '05_test1_bad_multi_vol_grid'

if ( -f ${OutFolder}/${OutFile}_log.txt ) then
    rm ${OutFolder}/${OutFile}_log.txt
endif

3dMVM -overwrite \
-prefix ${OutFolder}/${OutFile}.nii.gz \
-bsVars "group*group2" \
-qVars "score,rt" \
-dataTable @data_dataTables/${InFile}.tsv
