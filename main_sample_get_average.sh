#!/bin/bash

mkdir log
mkdir root
mkdir run-step1
mkdir run-step2

./gen_elec_list.sh Ge68_ELECSIM_DIR
./gen_step1.sh && ./sub_step1.sh
for i in `seq 1 200`
do
    echo `date`--`pwd`--"checking step1"
    if [[ `./check_run.sh "./run-step1/run_step1_*.sh" "./log/SPE-log-step1_*.txt"` == "True" ]];then
        hadd -f ./root/SPE_step1.root ./root/SPE_step1_*.root && root -l -q script1.C && echo "script1.C finished!!" && ./gen_step2.sh && ./sub.sh
        break
    fi
    sleep 120
done

for i in `seq 1 200`
do
    echo `date`--`pwd`--"checking step2"
    if [[ `./check_run.sh "./run-step2/SPE-step2-*.sh" "./log/SPE-step2-log-*.txt"` == "True" ]];then
        hadd -f ./root/SPE.bck.root ./root/SPE_step2_*.root && root -l -q script2.C && echo "SPE.root done">>../SPE_filter_status.txt
        break
    fi
    sleep 120
done

