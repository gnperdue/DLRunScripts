#!/bin/bash

SCRIPTKEY=`date +%s`
JOBDIR="job${SCRIPTKEY}"
mkdir -p $JOBDIR
EXESCRIPT=tf_slurm_process_hdf5_to_tfrecord.sh
cp $EXESCRIPT $JOBDIR

NGPU=1
NODES=gpu2
NODES=gpu4

ARGS="--gres=gpu:${NGPU} --nodelist=${NODES} --export=SCRIPTKEY=${SCRIPTKEY} $EXESCRIPT"

# show what we will do...
pushd $JOBDIR
cat << EOF
sbatch $ARGS
EOF
# do the thing, etc.
sbatch $ARGS
popd
