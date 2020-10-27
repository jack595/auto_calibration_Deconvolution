#!/bin/bash
#这个脚本是WaveReconstruction的子脚本，通过被前者调用从而来提交step4的作业，目前有用的命令是./sub_step_sample.sh 4
#作用：反卷积之后很多文件需要合并，从而我们合并后的步骤又要重新单独写，不能让之前的那么多节点进行，所以需要判断log文件是否正常结束，然后如果全都正常则提交我们的hep_script3，它会把文件合并，以及剩余的积分谱拟合操作做完，最后成功后，会输出成功的信息到status.txt中，最后顶层j的目录有个脚本会检查是否六种刻度源全部成功，然后提交提取Gain的脚本calib_gain.C,最终我们就得到了刻度参数的txt文件
#source /cvmfs/juno.ihep.ac.cn/centos7_amd64_gcc830/Pre-Release/J20v1r0-Pre2/setup.sh

original_path=`pwd`
JUNOPath=/afs/ihep.ac.cn/users/v/valprod0/J20v2r0-Pre0
list_name_source=""

if [ ! -f dir_0_0_0.list ]; then
    echo "cannot find dir_0_0_0.list!!! Please run WaveRestruction.sh"
    exit 1
fi
 while read dir_source
do
    if [[ ! $dir_source == *"C14"* ]];then
        name_source=${dir_source%/*}
    else
        name_source=$dir_source
    fi
    name_source=${name_source##*/}
    name_dir_calib1=${name_source}_calibCALIBNUM
    list_name_source=${list_name_source}"\" , \""${name_source}
    echo $list_name_source
    #echo $name_source,`pwd`
    #if [ ! -d $name_dir_calib1 ]; then
    #    mkdir $name_dir_calib1
    #fi
    cd $name_dir_calib1
    if [ $1 = 3 ]; then
        ./sub.sh
    elif [ $1 = 4 ]; then 
        cd step4
        cp ../../hadd_step4.sh .
        chmod 755 hadd_step4.sh

        #./sub.sh

        #./sub.sh
		for i in `seq  1 100`
		do
            echo `date`_____`pwd`
            if [ -f problem_log.txt ];then
                rm problem_log.txt
            fi
            n_jobs_run=`ls ../SPE-step3_4*.sh |wc -l`
            n_log_txt=`ls calibCorr-log-*.txt | wc -l` 
			n_not_success=$n_jobs_run
            if [[ $n_jobs_run == $n_log_txt ]];then
		         echo -e  $(ls calibCorr-log-*.txt)|tr ' ' '\n'>log.list
		           while read name_log
		         do
		         	tail -n 10 ${name_log} | grep -wq "SNiPER::Context Terminated Successfully"  && echo $n_not_success && n_not_success=$(($n_not_success-1)) || echo $name_log >> problem_log.txt
		         done < log.list
                 echo $n_not_success
		         if [[ $n_not_success == 0 ]]; then
		         	echo "`pwd` logs show all step4 jobs terminated successfully!"
                     cp ../../script3.C . && cp ../../hep_script3.sh .
                     chmod 755 hep_script3.sh
                     hep_sub ./hep_script3.sh 
		         	#nohup ./hadd_step4.sh &
                     #cp ${original_path}/check_hadd_rl_script.sh .
                     #chmod 755 check_hadd_rl_script.sh
                     # ./check_hadd_rl_script.sh

		         	break
		         fi  
            fi
            sleep 600
		done
       


    else
        echo "one parameter are supposed to be input,3 or 4. for example, ./sub_step4.sh 3"
        exit 1
    fi
    

    cd $original_path    
done < dir_0_0_0.list 

n_line_dir=`cat dir_0_0_0.list | wc -l` 

list_name_source=${list_name_source#*,}
list_name_source="{"$list_name_source"\" , \"Averaged\" }"
nn_str="const int nn = $(($n_line_dir+1));"
file_TString="TString fname[nn] = ${list_name_source};"
legend_TString="TString fname2[nn] = ${list_name_source};"
sed_template=$nn_str"\n"$file_TString"\n"$legend_TString

sed -e "s#SED_TEMPLATE#$sed_template#g" calib_gain_sample.C >calib_gain.C 

#calib_mode=CALIBNUM
#if [[ $calib_mode == 1 ]];then
#    sed -e "s#SED_TEMPLATE#$sed_template#g" calib_gain_sample.C >calib_gain.C 
#elif [[ $calib_mode == 0 ]];then
#    C14_nn_str="const int nn = 2;"
#    C14_file_TString="TString fname[nn] = { \"C14\",\"Averaged\" };"
#    C14_legend_TString="TString fname2[nn] = { \"C14\",\"Averaged\" };"
#    C14_sed_template=$nn_str"\n"$file_TString"\n"$legend_TString
#    sed -e "s#SED_TEMPLATE#$C14_sed_template#g" calib_gain_sample.C >calib_gain.C 
#fi

cp ../../calib_dn_sample.C .
sed -e "s#SED_TEMPLATE#$sed_template#g" calib_dn_sample.C >calib_dn.C
chmod 755 check_script_rl.sh
nohup ./check_script_rl.sh CALIBNUM &




