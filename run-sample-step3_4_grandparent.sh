#!/bin/bash


#(time python $TUTORIALROOT/share/tut_elec2calib.py --evtmax -1 --input DIR/elecsim-RUN.root --output calib-RUN.root --user-output user-calib-RUN.root) >& caliblog-RUN.txt
(time python $TUTORIALROOT/share/tut_elec2calib.py --evtmax -1 --Calib 1 --CalibFile SPE_ROOT --Filter FILTER_ROOT  --input STEP3_DIR/elecsim-RUN.root --output calib-RUN.root --user-output user-calib-RUN.root) >& caliblog-RUN.txt && (time python $JUNOTOP/offline/Calibration/PMTCalibAlg/share/run.py --evtmax -1 --SPE 1 --input STEP4_DIR/calib-RUN.root --user-output ./step4/user_calibCorr_RUN.root) >& ./step4/calibCorr-log-RUN.txt
