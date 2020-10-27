#!/bin/bash
name_source=$(dirname `pwd`)
name_source=$(basename $name_source)
name_source=${name_source%_*}
echo $name_source
( source hadd_step4.sh ) && ( root -l -q script3.C ) && (echo "single `pwd`/script3.C just done ,next step to mv the file")  && (mv outf.root ../../${name_source}_outf.root) && (echo "`pwd`/script3.C done">>../../step4_status.txt)
