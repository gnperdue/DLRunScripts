#!/bin/bash

echo "started "`date`" "`date +%s`""

nvidia-smi -L

# pick up singularity v2.2
export PATH=/usr/local/singularity/bin:$PATH
# which singularity image
SNGLRTY="/data/goran/TomaszGolan-mlmpr-master.simg"
CAFFE="/opt/caffe/build/tools/caffe"

LMDBDIR=/data/perdue/mnist
NETWORKDIR=/data/perdue/mnist

echo " &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& "
echo "                     Train                             "

singularity exec $SNGLRTY $CAFFE train \
  -solver $NETWORKDIR/lenet_solver.prototxt

echo " &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& "
echo "                     Test                              "

singularity exec $SNGLRTY $CAFFE test \
  -model $NETWORKDIR/lenet_train_test.prototxt \
  -weights $NETWORKDIR/snapshots_iter_10000.caffemodel \
  -gpu 0

exit 0
