#!/bin/bash
if [[ $#<=0 ]]; then
    echo "You have not input calib source name."
    exit 1
fi

source /cvmfs/juno.ihep.ac.cn/centos7_amd64_gcc830/Pre-Release/J20v2r0-Pre0/setup.sh
cd /junofs/users/jiangw/JUNOofflineProcess/FFT_v2
path0=`pwd`
mkdir -p $1

for n in {1..4}
do
    mkdir -p $1/run_step${n}
    cd $1/run_step${n}
    mkdir -p log
    mkdir -p root
    mkdir -p user-root
    cd -
done

bash gen_step1.sh $1
bash $1/run_step1/sub.sh


#cd run_step1
#(time python $JUNOTOP/offline/Calibration/PMTCalib/share/run.py --evtmax -1 --input ${path0}/$1_elec.list --step 1 --root/output SPE_step1.root) >& log/SPE-log-step1.txt

