#!/bin/bash

echo "started "`date`" "`date +%s`""

nvidia-smi -L

# pick up singularity v2.2
export PATH=/usr/local/singularity/bin:$PATH
# which singularity image
SNGLRTY="/data/goran/TomaszGolan-mlmpr-master.simg"
CAFFE="/opt/caffe/build/tools/caffe"

CAFFEMINERVA=/data/perdue/minerva/caffe
SOLVERDIR=$CAFFEMINERVA/solvers
PROTODIR=$CAFFEMINERVA/proto
SNAPSHOTDIR=$CAFFEMINERVA/snapshots

# iters are defined in the solver
SOLVER=$SOLVERDIR/vertex_epsilon_adv.solver
ITERS=2000
PROTO_TRAIN=$PROTODIR/vertex_epsilon_adv.prototxt
PROTO_TEST=$PROTODIR/vertex_epsilon_adv_test.prototxt
SNAPS=$SNAPSHOTDIR/vertex_epsilon_adv_iter_${ITERS}.caffemodel

echo " &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& "
echo "                     Train                             "

singularity exec $SNGLRTY $CAFFE train -solver $SOLVER

echo " &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& "
echo "                     Test                              "

singularity exec $SNGLRTY $CAFFE test \
  -model $PROTO_TEST \
  -weights $SNAPS -gpu 0

exit 0
