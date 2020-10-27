#!/bin/bash
if [ -f problem_log.txt ];then
    rm problem_log.txt
fi
if [ -f resub.sh ];then
    rm resub.sh
fi

echo -e  $(ls caliblog-*.txt)|tr ' ' '\n'>log.list
while read name_log
do
    run=${name_log%.*}
    run=${run#*-}
    echo $run
    tail -n 10 ${name_log} | grep -wq "SNiPER::Context Terminated Successfully"  || (echo $name_log >> problem_log.txt && echo "hep_sub SPE-step3_4-${run}.sh">>resub.sh)
done <log.list
if [ -f resub.sh ];then
    chmod 755 resub.sh
else
    echo "all log of step3 are showing they are terminated properly!"
fi



