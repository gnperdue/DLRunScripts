#!/bin/bash

# We need the SCRIPTKEY to be set in the environment and expect to begin the
# job in the execution directory (the sbatch wrapper script should put us
# there).
if [[ ${SCRIPTKEY} == "" ]]; then
  echo "Require the script key environment variable to run..."
  exit 1
fi
JOBDIR=`pwd`

# file logistics
PROCESSING="201801"
STARTIDX=0
STARTIDX=79
TESTREAD="--test_read"
TESTREAD=""

SAMPLE="me1Adata"
HDF5TYPE="mnvimgs"
TRAINFRAC=0.0
VALIDFRAC=0.0

SAMPLE="me1Amc"
HDF5TYPE="hadmultkineimgs"
TRAINFRAC=0.88
VALIDFRAC=0.06

FILEPAT="${HDF5TYPE}_127x94_${SAMPLE}"
HDF5DIR="/data/perdue/minerva/hdf5/${PROCESSING}"
OUTDIR="/data/perdue/minerva/tensorflow/data/${PROCESSING}/${SAMPLE}"
LOGFILE="log_hdf5_to_tfrec_minerva_xtxutuvtv${SCRIPTKEY}.txt"

# file creation parameters
NEVTS=10000
MAXTRIPS=1000

# pick up singularity v2.2 ??
export PATH=/usr/local/singularity/bin:$PATH
# which singularity image
SNGLRTY="/data/perdue/singularity/tf_1_4.simg"
CODEDIR="/home/perdue/ANNMINERvA"

echo "started "`date`" "`date +%s`""
nvidia-smi -L

function check_repo
{
  GIT_VERSION=`git describe --abbrev=12 --dirty --always`
  echo "Git repo version is $GIT_VERSION"
  DIRTY=`echo $GIT_VERSION | perl -ne 'print if /dirty/'`
  if [[ $DIRTY != "" ]]; then
    echo "Git repo contains uncomitted changes!"
    echo ""
    echo "Changed files:"
    git diff --name-only
    echo ""
  fi
}

# check repo status - execution code
cd $CODEDIR
echo "Code source is `pwd`"
check_repo

# check repo status - run script code
cd ${JOBDIR}
echo "Work is `pwd`"
check_repo

mkdir -p $OUTDIR

cp -rv ${CODEDIR}/mnvtf `pwd`
cp -v ${CODEDIR}/hdf5_to_tfrec_minerva_xtxutuvtv.py `pwd`

ARGS="--nevents $NEVTS --max_triplets $MAXTRIPS --file_pattern $FILEPAT --in_dir $HDF5DIR --out_dir $OUTDIR --train_fraction $TRAINFRAC --valid_fraction $VALIDFRAC --logfile $LOGFILE --compress_to_gz $TESTREAD --start_idx $STARTIDX --hdf5_type $HDF5TYPE"

# show what we will do...
cat << EOF
singularity exec $SNGLRTY python hdf5_to_tfrec_minerva_xtxutuvtv.py $ARGS
EOF

singularity exec $SNGLRTY python hdf5_to_tfrec_minerva_xtxutuvtv.py $ARGS

nvidia-smi -L >> $LOGFILE
nvidia-smi >> $LOGFILE

echo "finished "`date`" "`date +%s`""
exit 0
