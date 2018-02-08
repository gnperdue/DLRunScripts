#!/bin/bash

SCRIPTKEY=`date +%s`
mkdir -p job${SCRIPTKEY}

PROCESSING="201801"
BASEP="${HOME}/Documents/MINERvA/AI/minerva_tf"
DATADIR="${BASEP}/tfrec2/${PROCESSING}"
LOGFILE="log_examine_tfrec${SCRIPTKEY}.txt"
OUTPAT="result_examine_tfrec${SCRIPTKEY}"

IMGWX=94
IMGWUV=47
NPLANECODES=173
PLANECODES="--n_planecodes $NPLANECODES"
IMGPAR="--imgw_x $IMGWX --imgw_uv $IMGWUV"

PLAYLIST="me1Adata"
TFRECTYPE="mnvimgs"

PLAYLIST="me1Amc"
TFRECTYPE="vtxfndingimgs"
TFRECTYPE="hadmultkineimgs"

FILEPAT="${TFRECTYPE}_127x${IMGWX}_${PLAYLIST}"

ARGS="--data_dir $DATADIR --file_root $FILEPAT --compression gz --log_name $LOGFILE --out_pattern $OUTPAT $PLANECODES $IMGPAR --tfrec_type $TFRECTYPE"

cat << EOF
python tfrec_examiner.py $ARGS
EOF

pushd job${SCRIPTKEY}
cp -rv ${HOME}/Documents/MINERvA/AI/ANNMINERvA/mnvtf `pwd`
cp -v ${HOME}/Documents/MINERvA/AI/ANNMINERvA/tfrec_examiner.py `pwd`
python tfrec_examiner.py $ARGS
popd
