#!/bin/bash
export tool_dir=`pwd`
export my_offline_dir=/afs/ihep.ac.cn/users/l/luoxj/junofs_500G/J20v2Pre0/offline
export JUNOTOP_dir=/cvmfs/juno.ihep.ac.cn/centos7_amd64_gcc830/Pre-Release/J20v2r0-Pre0/offline
export JUNOTOP_setup_dir=${JUNOTOP_dir%/*}
export Timeoffset_calib_source_path=/afs/ihep.ac.cn/users/v/valprod0/J20v2r0-Pre0/Laser/266nm/photon_22000/266nm_0_0_0/elecsim/root/
export JUNODataPath=/afs/ihep.ac.cn/users/v/valprod0/J20v2r0-Pre0
export DataPathToGetAverageWave="/afs/ihep.ac.cn/users/v/valprod0/J20v2r0-Pre0/ACU+CLS/Ge68/Ge68_0_0_0/elecsim/root"

source ${JUNOTOP_setup_dir}/setup.sh

##do not use nohup below because we need it to pause the jobs
./main_get_filter_averagewave.sh $DataPathToGetAverageWave


#kill the previous process(prepare for calibration)
kill $(ps aux | grep check_script_rl.sh | tr -s ' '| cut -d ' ' -f 2)
kill $(ps aux | grep sub_step.sh | tr -s ' '| cut -d ' ' -f 2)
kill $(ps aux | grep check_Gain_Timeoffset_File.sh | tr -s ' '| cut -d ' ' -f 2)

#########Time offset Calib############

if [ ! -d timeoffset_calib ];then
    mkdir timeoffset_calib
fi
sed -e "s#JUNOTOP#${JUNOTOP_dir%/*}#g" ./TimeOffset_sample.sh > ./timeoffset_calib/TimeOffset.sh

cd timeoffset_calib
chmod 755 TimeOffset.sh
cp ../channel_roofit_sample.C .
cp ../timeoffset_run.py ./run.py
cp ../draw_timeoffset_result.py .
. ../gen_elec_list.sh $Timeoffset_calib_source_path 
sed -e "s#DIR_ROOT#`pwd`/#g" channel_roofit_sample.C > channel_roofit.C
hep_sub ./TimeOffset.sh 
cd $tool_dir

###########################################

n_check_filter
#########Gain Calib#######################
./main_charge_calib.sh
###########################################

#########Mean Gain Calib###################
nohup ./check_Gain_Timeoffset_File.sh $my_offline_dir $JUNOTOP_dir &
#############################################

