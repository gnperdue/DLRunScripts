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
PROCESSING="201808"
STARTIDX=0
TESTREAD="--test_read"
TESTREAD=""

PLAYLIST="me1Cdata_missingfiles"
PLAYLIST="me6Bdata"
HDF5TYPE="mnvimgs"
TFRECSTRUCTURE="mnvimgs"
TRAINFRAC=0.0
VALIDFRAC=0.0

PLAYLIST="me1Cmc_targetonly"
PLAYLIST="me6Amc"
HDF5TYPE="hadmultkineimgs"
TFRECSTRUCTURE="hadmultkineimgs"
TRAINFRAC=0.88
VALIDFRAC=0.06

INPUTFILEPAT="${HDF5TYPE}_127x94_${PLAYLIST}"
HDF5DIR="/data/perdue/minerva/hdf5/${PROCESSING}"
OUTDIR="/data/minerva/perdue/minerva/tensorflow/data/${PROCESSING}/${PLAYLIST}"
LOGFILE="log_hdf5_to_tfrec_minerva_xtxutuvtv${SCRIPTKEY}.txt"

# LUSTRE TEST - DELETE LATER
# HDF5DIR="/lfstev/e-938/perdue/test/hdf5"
# OUTDIR="/lfstev/e-938/perdue/test/tfrecord"
# INPUTFILEPAT="hadmultkineimgs_127x94_me1Pmc_tiny"
# PLAYLIST="me1Pmc"
# -END LUSTRE TEST

# file creation parameters
NEVTS=10000
MAXTRIPS=1000

# 0 -> 24
# STARTIDX=0
# MAXTRIPS=25

# 25 -> 49
# STARTIDX=25
# MAXTRIPS=25

# 50 -> 74
# STARTIDX=50
# MAXTRIPS=25

# 75 -> 99
# STARTIDX=75
# MAXTRIPS=25

# 0 -> 49
# STARTIDX=0
# MAXTRIPS=50

# 50 -> 99
# STARTIDX=50
# MAXTRIPS=50

# 100 -> 149
# STARTIDX=100
# MAXTRIPS=50

# 150 -> 199
STARTIDX=150
MAXTRIPS=50

# 200 -> 249
# STARTIDX=200
# MAXTRIPS=50

# which singularity image
SNGLRTY="/data/perdue/singularity/gnperdue-singularity_imgs-master-py2_tf17.simg"
SNGLRTY="/data/perdue/singularity/gnperdue-singularity_imgs-master-py2_tf18.simg"
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

ARGS="--nevents $NEVTS --max_triplets $MAXTRIPS --input_file_pattern $INPUTFILEPAT --in_dir $HDF5DIR --out_dir $OUTDIR --train_fraction $TRAINFRAC --valid_fraction $VALIDFRAC --logfile $LOGFILE --compress_to_gz $TESTREAD --start_idx $STARTIDX --playlist $PLAYLIST --tfrec_struct $TFRECSTRUCTURE"

# show what we will do...
cat << EOF
singularity exec --nv $SNGLRTY python hdf5_to_tfrec_minerva_xtxutuvtv.py $ARGS
EOF

singularity exec --nv $SNGLRTY python hdf5_to_tfrec_minerva_xtxutuvtv.py $ARGS

nvidia-smi -L >> $LOGFILE
nvidia-smi >> $LOGFILE

echo "finished "`date`" "`date +%s`""
exit 0
