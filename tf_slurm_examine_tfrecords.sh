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
PLAYLIST="me1Pdata"
TFRECTYPE="mnvimgs"

PLAYLIST="me1Gmc"
TFRECTYPE="hadmultkineimgs"

FILEPAT="${TFRECTYPE}_127x94_${PLAYLIST}"

# default is eventids
CHECKFIELD="--field n_hadmultmeas"
CHECKFIELD=""

# img pars
IMGWX=94
IMGWUV=47
NPLANECODES=173
PLANECODES="--n_planecodes $NPLANECODES"
IMGPAR="--imgw_x $IMGWX --imgw_uv $IMGWUV"

# more file logistics
PROCESSING="201801"
BASEP="/data/minerva/perdue/minerva/tensorflow"
DATADIR="${BASEP}/data/${PROCESSING}/${PLAYLIST}"
LOGFILE="log_examine_tfrec_127x${IMGWX}x${IMGWUV}_${PLAYLIST}_${SCRIPTKEY}.txt"
OUTPAT="results_examine_tfrec_127x${IMGWX}x${IMGWUV}_${PLAYLIST}_${SCRIPTKEY}"


# pick up singularity v2.2
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

cp -rv ${CODEDIR}/mnvtf `pwd`
cp -v ${CODEDIR}/tfrec_examiner.py `pwd`

ARGS="--data_dir $DATADIR --file_root $FILEPAT --compression gz --log_name $LOGFILE --out_pattern $OUTPAT $PLANECODES $IMGPAR --tfrec_type $TFRECTYPE $CHECKFIELD"

# show what we will do...
cat << EOF
singularity exec $SNGLRTY python tfrec_examiner.py $ARGS
EOF

singularity exec $SNGLRTY python tfrec_examiner.py $ARGS

nvidia-smi -L >> $LOGFILE
nvidia-smi >> $LOGFILE

echo "finished "`date`" "`date +%s`""
exit 0
