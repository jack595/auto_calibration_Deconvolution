#!/bin/bash
#这个脚本是为了实现电荷重建与反卷积算法的合并而写的，因为六种刻度源数据，所以必须写一个脚本来批量处理，对应的是张玄同师兄教程的电荷重建的step1和step4中需要批量运行反卷积代码的部分，这个脚本可以把$TUTORIALROOT/share/tut_elec2calib.py批量运行。第一次运行时是以Calib=1运行的，即刻度模式，这一步是为了得到Gain，即运行完这个脚本还需要继续x运行师兄的接下来两步$JUNOTOP/offline/Calibration/PMTCalibAlg/share/run.py，得到MeanGain；得到MeanGain以后修改PMTCalibSvc再运行一次这个脚本，以Calib=0运行，这个再走一次流程，我们就可以得到暗噪声与相对探测效率
#source /cvmfs/juno.ihep.ac.cn/centos7_amd64_gcc830/Pre-Release/J20v1r0-Pre2/setup.sh

original_path=`pwd`
#JUNODataPath=/afs/ihep.ac.cn/users/v/valprod0/J20v2r0-Pre0
#JUNODataPath=$3
echo "current dir: `pwd`"
echo $JUNODataPath
if [ -f script3.txt ];then
    rm script3.txt
fi
if [ -f step4_status.txt  ];then
    rm step4_status.txt
fi

cp ../../gen_0_0_0_dir_calib0.sh .
cp ../../gen_0_0_0_dir.sh .

if [ $1 -eq 1 ]; then
    rm dir_0_0_0.list
    if [ ! -f dir_0_0_0.list ]; then
        ./gen_0_0_0_dir.sh $JUNODataPath `pwd`
    fi
elif [ $1 -eq 0 ]; then
    rm dir_0_0_0.list
    if [ ! -f dir_0_0_0.list ]; then
        ./gen_0_0_0_dir_calib0.sh $JUNODataPath `pwd`
    fi
fi
    
cat dir_0_0_0.list | while read dir_source
do
    if [[ ! $dir_source == *"C14"* ]];then
        name_source=${dir_source%/*}
    else
        name_source=$dir_source
    fi
    name_source=${name_source##*/}
    name_dir_calib1=${name_source}_calib$1
    echo $name_source,`pwd`
    if [ ! -d $name_dir_calib1 ]; then
        mkdir $name_dir_calib1
    fi
    cd $name_dir_calib1

    source ${original_path}/gen_elec_list.sh ${JUNODataPath}/${dir_source#*/}/elecsim/root/
    echo ${JUNODataPath}/${dir_source#*/}/elecsim/root/
    
    cp ../gen_step3_4.sh .
    cp ../run-sample-step3_4_parent.sh .
    chmod 755 run-sample-step3_4_parent.sh
    if [ $1 -eq 1 ]; then
        mv ./run-sample-step3_4_parent.sh run-sample-step3_4.sh 
        echo "Calibration mode is ongoing, parameter Calib=1,using Svc in JUNOTOP"
        #read -s -n1 -p "按任意键继续 ... "
    elif [ $1 -eq 0 ];then
        echo "Calibration mode is off, assuming we have got the parameter--MeanGain, parameter Calib=0,using Svc in WORKTOP"
        if [ ! -n "$2" ] ;then
            echo "In Calib 0 mode,we need second parameter to provide the my_offline path!!!!!!!!"
            exit 1
        fi
        sed -e "3i source $2/Calibration/PMTCalib/cmt/setup.sh" -e "s#--Calib 1#--Calib 0#g" ./run-sample-step3_4_parent.sh > ./run-sample-step3_4.sh
        #sed -e '3i source /afs/ihep.ac.cn/users/l/luoxj/besfs_50G/juno-dev/offline/Calibration/PMTCalib/cmt/setup.sh' ./run-sample-step3_4.sh > ./run-sample-step3_4.sh
    else
        echo "The first parameter should be 0 or 1,relating with the parameter --Calib in file run-sample-step3_4.sh"
        exit 1
        #read -s -n1 -p "按任意键继续 ... "
    fi
    source gen_step3_4.sh
    source sub.sh

    cd $original_path
    
done
sed -e "s/CALIBNUM/$1/g" ./sub_step_sample.sh >sub_step.sh
chmod 755 sub_step.sh
nohup ./sub_step.sh 4 &

