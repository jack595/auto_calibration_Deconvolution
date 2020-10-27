#!/bin/bash

./run_step1.sh
echo "run_step1.sh finished!!"
./gen_elec_list.sh Ge68_ELECSIM_DIR
root -l -q script1.C
echo "script1.C finished!!"
./gen_step2.sh
./sub.sh
cd root
hadd SPE.bck.root SPE_step2_*.root
echo "merging files finished!!"
cd -
root -l -q script2.C

