#!/bin/bash

EXESCRIPT=tf_slurm_examine_tfrecords.sh
EXESCRIPT=tf_slurm_process_hdf5_to_tfrecord.sh

SCRIPTKEY=`date +%s`
JOBDIR="job${SCRIPTKEY}"
mkdir -p $JOBDIR
cp $EXESCRIPT $JOBDIR

NGPU=1
NODES=gpu1
NODES=gpu2
NODES=gpu4
NODES=gpu3

ARGS="--gres=gpu:${NGPU} --nodelist=${NODES} --export=SCRIPTKEY=${SCRIPTKEY} -A minervag -p gpu $EXESCRIPT"

# show what we will do...
pushd $JOBDIR
cat << EOF
sbatch $ARGS
EOF
# do the thing, etc.
sbatch $ARGS
popd
