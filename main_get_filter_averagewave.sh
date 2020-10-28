#!/bin/bash

if [  -f SPE_filter_status.txt ];then
    rm SPE_filter_status.txt
fi


#Ge68_Dir="/afs/ihep.ac.cn/users/v/valprod0/J20v2r0-Pre0/ACU+CLS/Ge68/Ge68_0_0_0/elecsim/root"

Ge68_Dir=$1
raw2d_input=`ls $Ge68_Dir|head -1`
sed -e "s#Ge68_ELECSIM_DIR#$Ge68_Dir#g" main_sample_get_average.sh > ./get_averageWaveform/main_get_average.sh 
sed -e "s#RAW2D_INPUT#${Ge68_Dir}/${raw2d_input}#g" ./get_filter/sample_get_raw2D.C > ./get_filter/get_raw2D.C
pushd get_averageWaveform
chmod 755 main_get_average.sh
nohup ./main_get_average.sh &
popd
pushd get_filter
root -l -q get_raw2D.C && root -l -q getFilterSetting4_m.C && echo "filter done" >> ../SPE_filter_status.txt
popd

for i in `seq 1 1000`
do
    echo `date`--`pwd`--"checking filter and SPE"
    if [ -f SPE_filter_status.txt ];then
        status_SPE=`cat SPE_filter_status.txt | grep "SPE.root done" | wc -l`
        status_filter=`cat SPE_filter_status.txt | grep "filter done" | wc -l`
    else
        status_SPE=0
        status_filter=0
    fi
    if [[ $status_SPE == 1 && $status_filter == 1 ]];then
        echo `pwd`/get_filter/filter4_m.root > path_filter_and_averagerWaves.sh
        echo `pwd`/get_averageWaveform/SPE.root >> path_filter_and_averagerWaves.sh
        break
    fi
    sleep 120
done
