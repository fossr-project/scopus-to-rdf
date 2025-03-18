#!/usr/bin/env bash

INPUT_DIR="data/data_scopus"
OUTPUT_DIR="data/rdf"

for INPUT_JSON in $INPUT_DIR/*.json; do
    OUTPUT_JSON=$OUTPUT_DIR/`basename $INPUT_JSON`ld
    # echo $OUTPUT_JSON
    jq -f 'map.jq' $INPUT_JSON >$OUTPUT_JSON
done
