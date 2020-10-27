#!/bin/bash
sniper_version="${JUNOTOP_setup_dir}/setup.sh"
source $sniper_version
for i in `seq  1 1000`
do
    if [ -f "./timeoffset_calib/timeoffset_calib_status.txt" ]
    then
        n_line_done_timeoffset=`cat ./timeoffset_calib/timeoffset_calib_status.txt | grep  "timeoffset calib done"|wc -l`
        n_line_done_calib1=`cat charge_calib/get_Gain/step4_status.txt | grep  "calib_gain.C done"|wc -l`
        if [ $n_line_done_timeoffset -eq 1 ] && [ $n_line_done_calib1 -eq 1 ] ;then
			./merge_corr_pars.sh
            sed -e "s#myinstream.open((hx_DirPath + \"/PmtPrtData_deconv.txt\").c_str(), std::ifstream::in);#myinstream.open(\"$(pwd)/PmtPrtData_deconv.txt\", std::ifstream::in);#g" $2/Calibration/PMTCalibSvc/src/PMTCalibSvc.cc > $1/Calibration/PMTCalibSvc/src/PMTCalibSvc.cc 
            cd ./charge_calib/get_MeanGain/
			cd $1/Calibration/PMTCalibSvc/cmt
			cmt cleanup
			cmt config
			cmt make && cd - && ./WaveReconstruction.sh 0 $1
			
            echo " calib_gain.C done and timeoffset_calib done"
            break
        fi
    fi
    sleep 600
done

