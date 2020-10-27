#!/bin/bash
source JUNOTOP/setup.sh

rm timeoffset_calib_status.txt

(time python run.py --evtmax -1 --input_list elec.list --option linear --positions 0 0 0 --hitsOption all --trigger force --forceTriggerSigma 0.0 ) &> log.txt	

root -l -b -q 'channel_roofit.C' && echo "timeoffset calib done">>timeoffset_calib_status.txt


