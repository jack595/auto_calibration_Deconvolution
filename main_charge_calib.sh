#!/bin/bash

sniper_version="${JUNOTOP_setup_dir}/setup.sh"
source $sniper_version
setup_sniper="source $sniper_version "

if [ ! -d "./charge_calib/get_Gain/" ]; then
    mkdir -p ./charge_calib/get_Gain/
fi
if [ ! -d "./charge_calib/get_MeanGain/" ]; then
    mkdir -p ./charge_calib/get_MeanGain/
fi
cp `ls | grep -v -E "main.*\.sh|.*_grandparent\.sh" |grep -E ".*\.C|.*\.sh"` ./charge_calib/get_Gain/
cp `ls | grep -v -E "main.*\.sh|.*_grandparent\.sh" |grep -E ".*\.C|.*\.sh"` ./charge_calib/get_MeanGain/
path_filter=`head -1 path_filter_and_averagerWaves.sh`
path_spe=`tail -1 path_filter_and_averagerWaves.sh`
    sed -e "s#FILTER_ROOT#$path_filter#g" -e "s#SPE_ROOT#$path_spe#g"  -e "2i $setup_sniper" run-sample-step3_4_grandparent.sh > ./charge_calib/get_Gain/run-sample-step3_4_parent.sh
    sed -e "s#FILTER_ROOT#$path_filter#g" -e "s#SPE_ROOT#$path_spe#g"  -e "2i $setup_sniper" run-sample-step3_4_grandparent.sh > ./charge_calib/get_MeanGain/run-sample-step3_4_parent.sh

cd ./charge_calib/get_Gain/
. ../../WaveReconstruction.sh 1
cd $tool_dir


