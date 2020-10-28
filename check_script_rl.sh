#!/bin/bash
get_DarkRate()
{
    min=100000
    while read name_path
    do
        if [[ $name_path == *"photon"* ]]; then
            name_photon_num=${name_path#*photon_}
            name_photon_num=${name_photon_num%/*}
            echo $name_photon_num
        else
            continue
        fi
        [ $min -gt $name_photon_num ] && min=$name_photon_num
    done <  dir_0_0_0.list
    echo $min
     name_input1="TFile* inputfile = new TFile(\"./photon_${min}_calib0/step4/user_calibCorr.root\", \"read\");"
     name_input2="TFile* inputfile2 = new TFile(\"./C14_calib0/step4/user_calibCorr.root\",\"read\");"
     sed_template=${name_input1}"\n"${name_input2}
    sed -e "s#INPUT_FILE_SED#$sed_template#g" script4_sample.C > script4.C
    root -l -b -q script4.C
}



        for i in `seq  1 500`
		do
            date
            if [ -f "step4_status.txt" ]
            then
                n_line_done=`cat step4_status.txt | grep  "/step4/script3.C done"|wc -l`
                n_line_dir=`cat dir_0_0_0.list |wc -l`
                if [ $n_line_done = $n_line_dir ];then
                    root -l -q  calib_gain.C && echo "calib_gain.C done">>step4_status.txt && [ $1 == 0 ] && get_DarkRate && echo "script4.C done">>step4_status.txt && root -l -q calib_dn.C && echo " calib_dn.C done ">>step4_status.txt && pushd ../.. && root -l -q merge.C && echo "merge.C done" && popd
                    break
                fi
            fi
            sleep 300
        done


#get_DarkRate
    
