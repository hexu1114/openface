#!/usr/bin/env bash

WORK_DIR=$PWD
RAW_DIR="$PWD/data/raw"
RESULT_DIR="$PWD/data/results"

if [ ! -d $RAW_DIR ]; then
    python ../util/byte_to_image.py --inputDir . --outputDir $RAW_DIR --rgb 0
fi

cd ../training

th main.lua -data $RAW_DIR/training -modelDef $WORK_DIR/model/nn4.small2.def.lua -cache $WORK_DIR/data/cache  \
 -save $RESULT_DIR  -nDonkeys 2  -cuda -cudnn -peoplePerBatch 10 -imagesPerPerson 15 -testPy ../evaluation/classify.py \
 -testDir $RAW_DIR/testing -testBatchSize 100 -epochSize 250 -nEpochs 50 -imgDim 28 -channelSize 1