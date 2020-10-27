#!/bin/bash

#source /junofs/users/zhangxt/github/calibRec_juno/PMTCalib/cmt/setup.sh
(time python $JUNOTOP/offline/Calibration/PMTCalib/share/run.py --calibfile Integral.txt --evtmax -1 --input DIR/elecsim-RUN.root --step 2 --output ./root/SPE_step2_RUN.root) >& ./log/SPE-step2-log-RUN.txt
