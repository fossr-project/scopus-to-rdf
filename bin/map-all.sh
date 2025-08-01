#!/usr/bin/env bash

INPUT_DIR="data/source"
# INPUT_DIR="data/source-sample"
OUTPUT_DIR="data/rdf"
MAPPING_DIR="config/mappings"
JSONLD_CONTEXT_PATH="config/context.jsonld"
JSONLD_OUTPUT_DIR="$OUTPUT_DIR/jsonld"
NQ_OUTPUT_DIR="$OUTPUT_DIR"
NQ_OUTPUT="$OUTPUT_DIR/all.nt"
LOG_PERIOD=50

JSONLD_CONTEXT=`cat $JSONLD_CONTEXT_PATH | jq '.' --compact-output`

mkdir -p "$NQ_OUTPUT_DIR"
>$NQ_OUTPUT
for MAPPING in $MAPPING_DIR/*.jq; do
    TYPE=`basename $MAPPING .jq`
    echo ""
    echo "### Type: $TYPE ###"
    for INPUT in $INPUT_DIR/$TYPE/*.jsonl; do
        INPUT_NAME=`basename $INPUT .jsonl`

        mkdir -p "$NQ_OUTPUT_DIR/$TYPE"
        NQ_OUTPUT_FOR_FILE="$NQ_OUTPUT_DIR/$TYPE/$INPUT_NAME.nt"
        >$NQ_OUTPUT_FOR_FILE

        LINES_MAPPED=0
        NUM_LINES=` wc -l $INPUT | awk '{print $1}'`
        printf "# $INPUT_NAME (%'u records)...\n" "$NUM_LINES"
        jq -L $MAPPING_DIR 'include "'$TYPE'"; main | ."@context" = '$JSONLD_CONTEXT'' $INPUT --compact-output | while read -r out; do 
            echo "$out" | jsonld toRdf - --n-quads | tee -a $NQ_OUTPUT_FOR_FILE >>$NQ_OUTPUT
            LINES_MAPPED=$(($LINES_MAPPED + 1))
            if ((LINES_MAPPED % LOG_PERIOD == 0)); then
                printf "> %'u\n" "$LINES_MAPPED"
            fi
        done
        printf "finished!\n\n"
    done
done

