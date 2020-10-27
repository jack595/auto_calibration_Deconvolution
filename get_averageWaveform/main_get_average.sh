#!/bin/bash

./run_step1.sh
echo "run_step1.sh finished!!"
./gen_elec_list.sh /afs/ihep.ac.cn/users/v/valprod0/J20v2r0-Pre0/ACU+CLS/Ge68/Ge68_0_0_0/elecsim/root
root -l -q script1.C
echo "script1.C finished!!"
./gen_step2.sh
./sub.sh
cd root
hadd SPE.bck.root SPE_step2_*.root
echo "merging files finished!!"
cd -
root -l -q script2.C

