#!/bin/bash
if [ -f problem_log.txt ];then
    rm problem_log.txt
fi
if [ -f resub.sh ];then
    rm resub.sh
fi
if [[ ! -n $1 || ! -n $2 ]];then
    echo "Two parameters are supposed to be input, the first one is the format of the jobs script and the second is the output log format."
    echo "For example,  check \"*.sh\" \"*log.txt\""
    exit 1
fi
n_jobs=`ls $1|wc -l`
echo -e  $(ls $2)|tr ' ' '\n'>log.list
while read name_log
do
    run=${name_log%.*}
    run=${run#*-}
    tail -n 10 ${name_log} | grep -wq "SNiPER::Context Terminated Successfully" && n_jobs=$(($n_jobs-1)) || (echo $name_log >> problem_log.txt && echo "hep_sub SPE-step3_4-${run}.sh">>resub.sh)
done <log.list
rm log.list
if [[ -f resub.sh && $n_jobs -gt 0 ]];then
    chmod 755 resub.sh
    echo "False"
else
    echo "True"
fi




