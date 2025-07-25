#!/usr/bin/env bash

INPUT_DIR="data/source"
OUTPUT_DIR="data/source-sample"
MAPPING_DIR="mappings"

for MAPPING in $MAPPING_DIR/*.jq; do
    TYPE=`basename $MAPPING .jq`
#    ITER=0
    echo "Sampling files of type '$TYPE'..."
    for INPUT_JSON in $INPUT_DIR/$TYPE/*.jsonl; do
        OUTPUT_JSON=$OUTPUT_DIR/$TYPE/`basename $INPUT_JSON`
        head -n 1000 $INPUT_JSON >$OUTPUT_JSON
    done

done
