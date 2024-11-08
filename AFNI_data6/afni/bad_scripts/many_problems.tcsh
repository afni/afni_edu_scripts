#!/bin/tcsh

echo this is my command \ 
     using multiple lines

3dinfo                            \
    -n4                           \
    -prefix                       \
    "../epi_r1+orig"              \
    “../anat+orig“

echo this script is finished
echo goodbye