#!/bin/bash

SCRIPTKEY=`date +%s`
CONFIGFILE=Configs/tf_mnv_vtxfindr_local_iMac2017_prediction.cfg
CONFIGFILE=Configs/tf_mnv_hadmultp_local_iMac2017_training.cfg
CONFIGFILE=Configs/tf_mnv_vtxfindr_local_iMac2017_prediction.cfg
CONFIGFILE=Configs/tf_mnv_vtxfindr_local_iMac2017_training_menndl_633167.cfg
CONFIGFILE=Configs/tf_mnv_vtxfindr_local_iMac2017_training.cfg
CONFIGFILE=Configs/tf_mnv_hadmultp_local_iMac2017_prediction.cfg

python mnv_tf_script_gen.py $CONFIGFILE $SCRIPTKEY

pushd job${SCRIPTKEY}
# cat job${SCRIPTKEY}.sh >& job_log.txt
bash job${SCRIPTKEY}.sh >& job_log.txt
popd
echo -e "\a"
