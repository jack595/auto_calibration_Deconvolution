#!/bin/bash

#source /junofs/users/zhangxt/github/calibRec_juno/PMTCalib/cmt/setup.sh
(time python $JUNOTOP/offline/Calibration/PMTCalib/share/run.py --calibfile Integral.txt --evtmax -1 --input /afs/ihep.ac.cn/users/v/valprod0/J20v2r0-Pre0/ACU+CLS/Ge68/Ge68_0_0_0/elecsim/root/elecsim-70024.root --step 2 --output ./root/SPE_step2_70024.root) >& ./log/SPE-step2-log-70024.txt
