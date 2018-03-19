#!/bin/bash

SCRIPTKEY=`date +%s`
mkdir -p job${SCRIPTKEY}

PLAYLIST="me1Adata"
TFRECTYPE="mnvimgs"

PLAYLIST="me1Amc_missingfiles"
TFRECTYPE="hadmultkineimgs"

PROCESSING="201801"
BASEP="${HOME}/Documents/MINERvA/AI/minerva_tf"
DATADIR="${BASEP}/tfrec/${PROCESSING}/${PLAYLIST}"
LOGFILE="log_examine_tfrec${SCRIPTKEY}.txt"
OUTPAT="result_examine_tfrec${SCRIPTKEY}"

IMGWX=94
IMGWUV=47
NPLANECODES=173
PLANECODES="--n_planecodes $NPLANECODES"
IMGPAR="--imgw_x $IMGWX --imgw_uv $IMGWUV"

FILEPAT="${TFRECTYPE}_127x${IMGWX}_${PLAYLIST}"

# default is eventids
CHECKFIELD="--field n_hadmultmeas"
CHECKFIELD=""

ARGS="--data_dir $DATADIR --file_root $FILEPAT --compression gz --log_name $LOGFILE --out_pattern $OUTPAT $PLANECODES $IMGPAR --tfrec_type $TFRECTYPE $CHECKFIELD"

cat << EOF
python tfrec_examiner.py $ARGS
EOF

pushd job${SCRIPTKEY}
cp -rv ${HOME}/Documents/MINERvA/AI/ANNMINERvA/mnvtf `pwd`
cp -v ${HOME}/Documents/MINERvA/AI/ANNMINERvA/tfrec_examiner.py `pwd`
python tfrec_examiner.py $ARGS
popd
