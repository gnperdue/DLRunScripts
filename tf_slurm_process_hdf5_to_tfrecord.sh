#!/bin/bash

if [[ ${SCRIPTKEY} == "" ]]; then
  echo "Require the script key environment variable to run..."
  exit 1
fi
JOBBASEDIR=`pwd`
JOBDIR="${JOBBASEDIR}/job${SCRIPTKEY}"

# file logistics
SAMPLE="me1Amc"
PROCESSING="201801"
# STARTIDX=89
STARTIDX=0
HDF5DIR="/data/perdue/minerva/hdf5/${PROCESSING}"
OUTDIR="/data/perdue/minerva/tensorflow/data/${PROCESSING}/${SAMPLE}"
LOGFILE="log_hdf5_to_tfrec_minerva_xtxutuvtv${SCRIPTKEY}.txt"
HDF5TYPE="vtxfndingimgs"
HDF5TYPE="hadmultkineimgs"
FILEPAT="${HDF5TYPE}_127x94_${SAMPLE}"
FILEPAT="${HDF5TYPE}_127x94_${SAMPLE}_tiny"

# file creation parameters
NEVTS=20000
NEVTS=10000
MAXTRIPS=1
MAXTRIPS=1000
TRAINFRAC=0.0
VALIDFRAC=0.0
TRAINFRAC=0.88
VALIDFRAC=0.06
TESTREAD="--test_read"
TESTREAD=""

# which singularity image
SNGLRTY="/data/perdue/singularity/tf_1_4.simg"
CODEDIR="/home/perdue/ANNMINERvA/TensorFlow"

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
cd /home/perdue/ANNMINERvA/TensorFlow
echo "Code source is `pwd`"
check_repo

# check repo status - run script code
cd ${JOBDIR}
echo "Work is `pwd`"
check_repo

mkdir -p $OUTDIR

PYTHONLIST="
hdf5_to_tfrec_minerva_xtxutuvtv.py
mnv_utils.py
MnvDataConstants.py
MnvDataReaders.py
MnvHDF5.py
"
for filename in $PYTHONLIST
do
  cp -v ${CODEDIR}/$filename `pwd`
done

ARGS="--nevents $NEVTS --max_triplets $MAXTRIPS --file_pattern $FILEPAT --in_dir $HDF5DIR --out_dir $OUTDIR --train_fraction $TRAINFRAC --valid_fraction $VALIDFRAC --logfile $LOGFILE --compress_to_gz $TESTREAD --start_idx $STARTIDX"

# show what we will do...
cat << EOF
singularity exec $SNGLRTY python hdf5_to_tfrec_minerva_xtxutuvtv.py $ARGS
EOF

singularity exec $SNGLRTY python hdf5_to_tfrec_minerva_xtxutuvtv.py $ARGS

nvidia-smi -L >> $LOGFILE
nvidia-smi >> $LOGFILE

echo "finished "`date`" "`date +%s`""
exit 0
