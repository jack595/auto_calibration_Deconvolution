#!/bin/bash
rm -rf sub.sh

for full_path in `cat elec.list`;
do
    dir=$(dirname $full_path)
    filename=$(basename $full_path) 
  run=${filename#*-}
  run=${run%.*}
  echo ${dir}, ${run}
  sed -e "s#DIR#$dir#g" -e "s#RUN#$run#g" run-sample-step2.sh > ./run-step2/SPE-step2-$run.sh
echo "hep_sub `pwd`/run-step2/SPE-step2-${run}.sh" >> sub.sh
done

chmod +x ./run-step2/SPE-step2-*.sh
chmod +x sub.sh

