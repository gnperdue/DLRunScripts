#!/bin/bash

SCRIPTKEY=`date +%s`
mkdir -p job${SCRIPTKEY}

DPATH="/Users/perdue/Documents/MINERvA/AI/minerva_tf/predictions/aghosh"
INPT="${DPATH}/DANN_me1Btrain_me1Adatapred.txt,${DPATH}/DANN_me1Btrain_me1Adatapred_last24events.txt"

cat << EOF
    python txt_to_sqlite.py -i $INPT
EOF

PYTHONLIST="
txt_to_sqlite.py
mnv_utils.py
MnvRecorderSQLite.py
"

pushd job${SCRIPTKEY}
for filename in $PYTHONLIST
do
  cp -v ${HOME}/Documents/MINERvA/AI/ANNMINERvA/TensorFlow/$filename `pwd`
done
# default output name, n_classes, format all okay
python txt_to_sqlite.py -i $INPT
popd
