#!/bin/bash
paste ./charge_calib/get_Gain/CalibPars.txt ./timeoffset_calib/timeOffset.txt > tmp.txt 
awk '{ print $1,$2,$3,$8,$5,$6 }' tmp.txt > PmtPrtData_deconv.txt 
rm tmp.txt
