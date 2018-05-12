#!/bin/bash

SCRIPTKEY=`date +%s`
CONFIGFILE=Configs/tf_mnv_vtxfindr_wilson_cluster_training_LOP.cfg
CONFIGFILE=Configs/tf_mnv_vtxfindr_wilson_cluster_training_ABCDG.cfg
CONFIGFILE=Configs/tf_mnv_vtxfindr_wilson_cluster_training_EF.cfg
CONFIGFILE=Configs/tf_mnv_vtxfindr_wilson_cluster_training_MN.cfg
CONFIGFILE=Configs/tf_mnv_vtxfindr_wilson_cluster_data_prediction_using_ABCDG.cfg
CONFIGFILE=Configs/tf_mnv_vtxfindr_wilson_cluster_mc_prediction_using_ABCDG.cfg
CONFIGFILE=Configs/tf_mnv_vtxfindr_wilson_cluster_data_prediction_using_EF.cfg
CONFIGFILE=Configs/tf_mnv_vtxfindr_wilson_cluster_mc_prediction_using_EF.cfg
CONFIGFILE=Configs/tf_mnv_vtxfindr_wilson_cluster_mc_prediction_using_MN.cfg
CONFIGFILE=Configs/tf_mnv_vtxfindr_wilson_cluster_data_prediction_using_MN.cfg
CONFIGFILE=Configs/tf_mnv_vtxfindr_wilson_cluster_mc_prediction_using_LOP.cfg
CONFIGFILE=Configs/tf_mnv_vtxfindr_wilson_cluster_data_prediction_using_LOP.cfg
python mnv_tf_script_gen.py $CONFIGFILE $SCRIPTKEY

NGPU=1
NODES=gpu2
NODES=gpu4

# show what we will do...
cat << EOF
sbatch --gres=gpu:${NGPU} --nodelist=${NODES} -p gpu job${SCRIPTKEY}.sh
EOF

# do the thing, etc.
pushd job${SCRIPTKEY}
# cat job${SCRIPTKEY}.sh >& job_log.txt
sbatch --gres=gpu:${NGPU} --nodelist=${NODES} -p gpu job${SCRIPTKEY}.sh
popd

