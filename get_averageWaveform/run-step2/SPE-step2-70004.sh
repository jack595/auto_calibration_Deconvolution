#!/bin/bash

#source /junofs/users/zhangxt/github/calibRec_juno/PMTCalib/cmt/setup.sh
(time python $JUNOTOP/offline/Calibration/PMTCalib/share/run.py --calibfile Integral.txt --evtmax -1 --input /afs/ihep.ac.cn/users/v/valprod0/J20v2r0-Pre0/ACU+CLS/Ge68/Ge68_0_0_0/elecsim/root/elecsim-70004.root --step 2 --output ./root/SPE_step2_70004.root) >& ./log/SPE-step2-log-70004.txt
