#!/usr/bin/env bash

# INPUT_DIR="data/source"
INPUT_DIR="data/source-sample"
OUTPUT_DIR="data/rdf"
MAPPING_DIR="config/mappings"
JSONLD_CONTEXT_PATH="config/context.jsonld"
JSONLD_OUTPUT_DIR="$OUTPUT_DIR/jsonld"
NQ_OUTPUT_DIR="$OUTPUT_DIR"
NQ_OUTPUT="$OUTPUT_DIR/all.nt"
LOG_PERIOD=50
NUM_JOBS=64

JSONLD_CONTEXT=`cat $JSONLD_CONTEXT_PATH | jq '.' --compact-output`

map_by_modulo() {
    JOB_NUMBER="$1"
    LINES_MAPPED=0
    printf "> Job $JOB_NUMBER/$NUM_JOBS started\n"
    jq -L $MAPPING_DIR 'include "'$TYPE'"; main | ."@context" = '$JSONLD_CONTEXT'' $INPUT --compact-output | while read -r out; do 
        if ((LINES_MAPPED % NUM_JOBS == JOB_NUMBER)); then
            echo "$out" | jsonld toRdf - --n-quads | tee -a $NQ_OUTPUT_FOR_FILE >>$NQ_OUTPUT
        fi
        LINES_MAPPED=$(($LINES_MAPPED + 1))
        if ((LINES_MAPPED % LOG_PERIOD == 0)); then
            printf "> $JOB_NUMBER/$NUM_JOBS: %'u\n" "$LINES_MAPPED"
        fi
    done
    printf "> Job $JOB_NUMBER/$NUM_JOBS finished\n"
}

mkdir -p "$NQ_OUTPUT_DIR"
>$NQ_OUTPUT
echo "###############################"
echo "### Mapping process started ###"
echo "###############################"
for MAPPING in $MAPPING_DIR/*.jq; do
    TYPE=`basename $MAPPING .jq`
    echo ""
    echo "## Type: $TYPE ##"
    for INPUT in $INPUT_DIR/$TYPE/*.jsonl; do
        INPUT_NAME=`basename $INPUT .jsonl`

        mkdir -p "$NQ_OUTPUT_DIR/$TYPE"
        NQ_OUTPUT_FOR_FILE="$NQ_OUTPUT_DIR/$TYPE/$INPUT_NAME.nt"
        >$NQ_OUTPUT_FOR_FILE

        NUM_LINES=`wc -l $INPUT | awk '{print $1}'`
        printf "# $INPUT_NAME (%'u records)...\n" "$NUM_LINES"

        for JOB_NUMBER in $(eval echo "{0..$NUM_JOBS}"); do
            map_by_modulo "$JOB_NUMBER" &
        done

        wait
        printf "finished!\n\n"
    done
done
echo "#################################"
echo "### Mapping process completed ###"
echo "#################################"
echo ""


