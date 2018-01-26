#!/bin/bash

SCRIPTKEY=`date +%s`
mkdir -p job${SCRIPTKEY}

PROCESSING="201801"
BASEP="${HOME}/Documents/MINERvA/AI/minerva_tf"
DATADIR="${BASEP}/tfrec/${PROCESSING}"
LOGFILE="log_examine_tfrec${SCRIPTKEY}.txt"
OUTPAT="result_examine_tfrec${SCRIPTKEY}"

IMGWX=94
IMGWUV=47
NPLANECODES=173
PLANECODES="--n_planecodes $NPLANECODES"
IMGPAR="--imgw_x $IMGWX --imgw_uv $IMGWUV"

SAMPLE="me1Amc"
HDF5TYPE="vtxfndingimgs"
HDF5TYPE="hadmultkineimgs"
FILEPAT="${HDF5TYPE}_127x${IMGWX}_${SAMPLE}"

ARGS="--data_dir $DATADIR --file_root $FILEPAT --compression gz --log_name $LOGFILE --out_pattern $OUTPAT $PLANECODES $IMGPAR"

cat << EOF
python tfrec_examiner.py $ARGS
EOF

PYTHONLIST="
tfrec_examiner.py
mnv_utils.py
MnvDataConstants.py
MnvDataReaders.py
"

pushd job${SCRIPTKEY}
for filename in $PYTHONLIST
do
  cp -v ${HOME}/Documents/MINERvA/AI/ANNMINERvA/TensorFlow/$filename `pwd`
done
python tfrec_examiner.py $ARGS
popd
