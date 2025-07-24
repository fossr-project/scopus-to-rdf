#!/usr/bin/env bash

INPUT_DIR="data/source-sample"
OUTPUT_DIR="data/rdf"
MAPPING_DIR="mappings"
JSONLD_CONTEXT_PATH="context.jsonld"
JSONLD_OUTPUT_DIR="$OUTPUT_DIR/jsonld"
NQ_OUTPUT="$OUTPUT_DIR/all.nq"

JSONLD_CONTEXT=`cat $JSONLD_CONTEXT_PATH | jq '.' --compact-output`

>$NQ_OUTPUT
for MAPPING in $MAPPING_DIR/*.jq; do
    TYPE=`basename $MAPPING .jq`
#    ITER=0
    echo "Mapping files of type '$TYPE'..."
    for INPUT in $INPUT_DIR/$TYPE/*.jsonl; do
        echo "Mapping file '$INPUT'..."
        INPUT_NAME=`basename $INPUT .jsonl`
        mkdir -p "$JSONLD_OUTPUT_DIR/$TYPE"
        JSONLD_OUTPUT_PREFIX="$JSONLD_OUTPUT_DIR/$TYPE/$INPUT_NAME"
        # JSONLD_LINE_OUTPUT_PREFIX="$JSONLD_OUTPUT_DIR/$TYPE/${INPUT_NAME}_line"
        # JSONLDL_OUTPUT="$JSONLD_OUTPUT_DIR/$TYPE/${INPUT_NAME}.jsonldl"
#        OUTPUT_PREFIX=$OUTPUT_DIR/$TYPE-$ITER.jsonld
        # jq -f $MAPPING $INPUT --compact-output | awk '{ system("echo '\''"$0"'\'' >'$OUTPUT_PREFIX'_" NR ".jsonld") }'
        # jq -f $MAPPING $INPUT --compact-output | xargs -0 -n1 echo >"${OUTPUT_PREFIX}.jsonld"
        ITER=1
        # jq -f $MAPPING $INPUT --compact-output | while read out; do 
        # jq -L $MAPPING_DIR 'include "'$TYPE'"; main | ."@context" = '$JSONLD_CONTEXT'' $INPUT --compact-output >${JSONLDL_OUTPUT}
        jq -L $MAPPING_DIR 'include "'$TYPE'"; main | ."@context" = '$JSONLD_CONTEXT'' $INPUT --compact-output | while read -r out; do 
            echo "Mapping JSON n. '$ITER'..."
            # printf '%s' "$out" >"${JSONLD_LINE_OUTPUT_PREFIX}_${ITER}.jsonld"
            jq "." <<<"$out" >"${JSONLD_OUTPUT_PREFIX}_${ITER}.jsonld"
            jsonld toRdf - --n-quads  <<<"$out" >>$NQ_OUTPUT
            ITER=$(expr $ITER "+" 1)
        done
#        ITER=$(expr $ITER "+" 1)
    done
#     # echo $OUTPUT_JSON
#     jq -f $MAPPING $INPUT_JSON >$OUTPUT_JSON
done

