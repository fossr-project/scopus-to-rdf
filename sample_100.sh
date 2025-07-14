#!/usr/bin/env bash

INPUT_DIR="data/fossr_data"
OUTPUT_DIR="data/fossr_data"

for INPUT_JSON in $INPUT_DIR/*.json; do
    OUTPUT_JSON=$OUTPUT_DIR/`basename $INPUT_JSON`ld
    # echo $OUTPUT_JSON
    head -n 100 $INPUT_JSON >$OUTPUT_JSON
done
