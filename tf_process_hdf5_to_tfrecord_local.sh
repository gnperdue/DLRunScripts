#!/bin/bash

SCRIPTKEY=`date +%s`
mkdir -p job${SCRIPTKEY}

# file creation parameters
NEVTS=100
MAXTRIPS=2
TRAINFRAC=0.88
VALIDFRAC=0.06
STARTIDX=0

# file logistics
PROCESSING="201801"
SAMPLE="me1Amc"
HDF5DIR="${HOME}/Documents/MINERvA/AI/hdf5/${PROCESSING}"
OUTDIR="${HOME}/Documents/MINERvA/AI/minerva_tf/tfrec/${PROCESSING}"
LOGFILE=log_hdf5_to_tfrec_minerva_xtxutuvtv${SCRIPTKEY}.txt
HDF5TYPE="vtxfndingimgs"
HDF5TYPE="hadmultkineimgs"
FILEPAT="${HDF5TYPE}_127x94_${SAMPLE}"

mkdir -p $OUTDIR

ARGS="--nevents $NEVTS --max_triplets $MAXTRIPS --file_pattern $FILEPAT --in_dir $HDF5DIR --out_dir $OUTDIR --train_fraction $TRAINFRAC --valid_fraction $VALIDFRAC --logfile $LOGFILE --compress_to_gz --start_idx $STARTIDX --hdf5_type $HDF5TYPE --test_read"
# --test_read \
# --dry_run

cat << EOF
python hdf5_to_tfrec_minerva_xtxutuvtv.py $ARGS
EOF

PYTHONLIST="
hdf5_to_tfrec_minerva_xtxutuvtv.py
mnv_utils.py
MnvDataConstants.py
MnvDataReaders.py
MnvHDF5.py
"

pushd job${SCRIPTKEY}
for filename in $PYTHONLIST
do
  cp -v ${HOME}/Documents/MINERvA/AI/ANNMINERvA/TensorFlow/$filename `pwd`
done
python hdf5_to_tfrec_minerva_xtxutuvtv.py $ARGS
popd

