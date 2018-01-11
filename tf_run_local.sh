#!/bin/bash

# MODELBASE=20180111
SCRIPTKEY=`date +%s`
CONFIGFILE=Configs/tf_mnv_st_epsilon_local_iMac2017.cfg

python mnv_tf_script_gen.py $CONFIGFILE $SCRIPTKEY

pushd job${SCRIPTKEY}
bash job${SCRIPTKEY}.sh >& job_log.txt
popd
echo -e "\a"
