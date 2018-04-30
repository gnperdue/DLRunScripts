#!/bin/bash

SCRIPTKEY=`date +%s`
mkdir -p job${SCRIPTKEY}

# file logistics
PROCESSING="201804"
NEVTS=10000
MAXTRIPS=1000
STARTIDX=24

PLAYLIST="me1Gdata_missingfiles"
HDF5TYPE="mnvimgs"
TFRECSTRUCTURE="mnvimgs"
TRAINFRAC=0.0
VALIDFRAC=0.0

PLAYLIST="me1Lmc"
HDF5TYPE="hadmultkineimgs"
TFRECSTRUCTURE="hadmultkineimgs"
TRAINFRAC=0.88
VALIDFRAC=0.06

INPUTFILEPAT="${HDF5TYPE}_127x94_${PLAYLIST}"
HDF5DIR="${HOME}/Documents/MINERvA/AI/hdf5/${PROCESSING}"
OUTDIR="${HOME}/Documents/MINERvA/AI/minerva_tf/tfrec/${PROCESSING}/${PLAYLIST}"
LOGFILE=log_hdf5_to_tfrec_minerva_xtxutuvtv${SCRIPTKEY}.txt

mkdir -p $OUTDIR

ARGS="--nevents $NEVTS --max_triplets $MAXTRIPS --input_file_pattern $INPUTFILEPAT --in_dir $HDF5DIR --out_dir $OUTDIR --train_fraction $TRAINFRAC --valid_fraction $VALIDFRAC --logfile $LOGFILE --compress_to_gz --start_idx $STARTIDX --tfrec_struct $TFRECSTRUCTURE --playlist $PLAYLIST"
# --test_read \
# --dry_run

cat << EOF
python hdf5_to_tfrec_minerva_xtxutuvtv.py $ARGS
EOF

pushd job${SCRIPTKEY}
cp -rv ${HOME}/Documents/MINERvA/AI/ANNMINERvA/mnvtf `pwd`
cp -v ${HOME}/Documents/MINERvA/AI/ANNMINERvA/hdf5_to_tfrec_minerva_xtxutuvtv.py `pwd`
python hdf5_to_tfrec_minerva_xtxutuvtv.py $ARGS
popd

