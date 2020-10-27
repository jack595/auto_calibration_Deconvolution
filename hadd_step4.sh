#!/bin/bash
rm hadd_status.txt
hadd -f  user_calibCorr.root user_calibCorr_*.root && echo "hadd jobs finished" > hadd_status.txt && echo "`pwd`/hadd.sh done">>../../step4_status.txt
