#!/bin/bash

SCRIPTKEY=`date +%s`
mkdir -p job${SCRIPTKEY}

# file creation parameters
NEVTS=1000
MAXTRIPS=2
TRAINFRAC=0.88
VALIDFRAC=0.06
STARTIDX=2

# file logistics
PROCESSING="201710"
HDF5DIR="${HOME}/Documents/MINERvA/AI/hdf5/${PROCESSING}"
FILEPAT="vtxfndingimgs_127x94_me1Bmc"
OUTDIR="${HOME}/Documents/MINERvA/AI/minerva_tf/tfrec/${PROCESSING}"
LOGFILE=log_hdf5_to_tfrec_minerva_xtxutuvtv${SCRIPTKEY}.txt
HDF5TYPE="vtxfndingimgs"

mkdir -p $OUTDIR

ARGS="--nevents $NEVTS --max_triplets $MAXTRIPS --file_pattern $FILEPAT --in_dir $HDF5DIR --out_dir $OUTDIR --train_fraction $TRAINFRAC --valid_fraction $VALIDFRAC --logfile $LOGFILE --compress_to_gz --start_idx $STARTIDX --hdf5_type $HDF5TYPE --test_read"
echo $ARGS
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

