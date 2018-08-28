#!/bin/bash

SCRIPTKEY=`date +%s`
CONFIGFILE=Configs/tf_mnv_vtxfindr_local_iMac2017_training_menndl_633167.cfg
CONFIGFILE=Configs/tf_mnv_vtxfindr_local_iMac2017_prediction_using_E.cfg
CONFIGFILE=Configs/tf_mnv_vtxfindr_local_iMac2017_training.cfg
CONFIGFILE=Configs/tf_mnv_vtxfindr_local_iMac2017_prediction_check_using_LOP.cfg
CONFIGFILE=Configs/tf_mnv_vtxfindr_local_iMac2017_mc_prediction_using_LOP.cfg
CONFIGFILE=Configs/tf_mnv_vtxfindr_local_iMac2017_mc_prediction_using_LOP_hdf5.cfg

python mnv_tf_script_gen.py $CONFIGFILE $SCRIPTKEY

pushd job${SCRIPTKEY}
# cat job${SCRIPTKEY}.sh >& job_log.txt
bash job${SCRIPTKEY}.sh >& job_log.txt
popd
echo -e "\a"
