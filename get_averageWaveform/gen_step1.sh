#!/bin/bash
rm -rf sub_step1.sh

for full_path in `cat elec.list`;
do
    dir=$(dirname $full_path)
    filename=$(basename $full_path) 
  run=${filename#*-}
  run=${run%.*}
  echo ${dir}, ${run}
  sed -e "s#INPUTFILE#$full_path#g" -e "s#RUN#$run#g" run_step1_sample.sh > ./run-step1/run_step1_$run.sh
echo "hep_sub `pwd`/run-step1/run_step1_$run.sh" >> sub_step1.sh
done

chmod +x ./run-step1/run_step1_*.sh
chmod +x sub_step1.sh

