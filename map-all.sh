#!/usr/bin/env bash

INPUT_DIR="data/source-sample"
OUTPUT_DIR="data/rdf"
MAPPING_DIR="mappings"
JSONLD_OUTPUT_DIR="$OUTPUT_DIR/jsonld"
NQ_OUTPUT="$OUTPUT_DIR/all.nq"

>$NQ_OUTPUT
for MAPPING in $MAPPING_DIR/*.jq; do
    echo $MAPPING
    TYPE=`basename $MAPPING .jq`
#    ITER=0
    echo $TYPE
    for INPUT in $INPUT_DIR/$TYPE/*.jsonl; do
        echo $INPUT
        INPUT_NAME=`basename $INPUT .jsonl`
        mkdir -p "$JSONLD_OUTPUT_DIR/$TYPE"
        OUTPUT_PREFIX="$JSONLD_OUTPUT_DIR/$TYPE/$INPUT_NAME"
#        OUTPUT_PREFIX=$OUTPUT_DIR/$TYPE-$ITER.jsonld
        echo $OUTPUT_PREFIX
        # jq -f $MAPPING $INPUT --compact-output | awk '{ system("echo '\''"$0"'\'' >'$OUTPUT_PREFIX'_" NR ".jsonld") }'
        # jq -f $MAPPING $INPUT --compact-output | xargs -0 -n1 echo >"${OUTPUT_PREFIX}.jsonld"
        ITER=0
        jq -f $MAPPING $INPUT --compact-output | while read out; do 
            echo "$out" >"${OUTPUT_PREFIX}_${ITER}.jsonld"
            echo "$out" | jsonld toRdf - --n-quads >>$NQ_OUTPUT
            ITER=$(expr $ITER "+" 1)
        done
#        ITER=$(expr $ITER "+" 1)
    done
#     # echo $OUTPUT_JSON
#     jq -f $MAPPING $INPUT_JSON >$OUTPUT_JSON
done

