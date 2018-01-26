#!/bin/bash

SCRIPTKEY=`date +%s`
mkdir -p job${SCRIPTKEY}

NGPU=1
NODES=gpu2
NODES=gpu4

# show what we will do...
cat << EOF
sbatch --gres=gpu:${NGPU} \
  --nodelist=${NODES} \
  --export=SCRIPTKEY=${SCRIPTKEY} \
  tf_slurm_process_hdf5_to_tfrecord.sh
EOF

# do the thing, etc.
sbatch --gres=gpu:${NGPU} \
  --nodelist=${NODES} \
  --export=SCRIPTKEY=${SCRIPTKEY} \
  tf_slurm_process_hdf5_to_tfrecord.sh

