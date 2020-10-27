#!/bin/bash
rm -rf sub.sh
j=0
dir_step3=`pwd`
i=0
if [ ! -d "step4" ]; then
    mkdir step4
fi
for filename in `cat elec.list`;
do
    #find the position of "-" and ".root" so that we are able to extract the run number and path
    end_num=`echo ${filename} | grep -b -o "\.root" | cut -d: -f1`
    start_num=`echo ${filename} | grep -b -o "-" | cut -d: -f1` 
    #because here we have two "-" so we get two num seperated by space, so below we use awk to get the second num
    # echo $end_num
    start_num=$((`echo $start_num | awk '{print $2}'`+1)) 
    num_length=$(($end_num-$start_num))
    # echo $start_num
    
#   start_num=$(($end_num-5))
    run=${filename:$start_num:$num_length}
    dir=$(dirname $filename)
#  dir=${filename:0:75}
#  run=${filename:84:5}
    if [ $i -lt 3 ];then
        echo ${filename}
        echo ${dir}, ${run}
    fi
    i=$(($i + 1))
  sed -e "s#STEP4_DIR#${dir_step3}#g" -e "s/RUN/${run}/g" \
    -e "s#STEP3_DIR#${dir}#g" run-sample-step3_4.sh > SPE-step3_4-${run}.sh
echo "hep_sub SPE-step3_4-${run}.sh" >> sub.sh

#    if [ $j = 0 ];then
#    rm ./step4/sub.sh
#    fi
#  sed -e "s/RUN/${run}/g" \
#    -e "s#STEP4_DIR#${dir_step3}#g" ../run-sample-step4.sh > ./step4/SPE-step4-$run.sh
#    echo "hep_sub SPE-step4-${run}.sh" >> ./step4/sub.sh

    j=$(($j+1)) 
done

chmod +x SPE-step3_4*.sh
chmod +x sub.sh
