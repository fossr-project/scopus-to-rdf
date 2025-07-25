#!/usr/bin/env bash

INPUT_DIR="data/source-sample"
OUTPUT_DIR="data/rdf"
MAPPING_DIR="mappings"
JSONLD_CONTEXT_PATH="context.jsonld"
JSONLD_OUTPUT_DIR="$OUTPUT_DIR/jsonld"
NQ_OUTPUT_DIR="$OUTPUT_DIR/nq"
NQ_OUTPUT="$OUTPUT_DIR/all.nq"

percentBar ()  { 
    local prct totlen=$((8*$2)) lastchar barstring blankstring;
    printf -v prct %.2f "$1"
    ((prct=10#${prct/.}*totlen/10000, prct%8)) &&
        printf -v lastchar '\\U258%X' $(( 16 - prct%8 )) ||
            lastchar=''
    printf -v barstring '%*s' $((prct/8)) ''
    printf -v barstring '%b' "${barstring// /\\U2588}$lastchar"
    printf -v blankstring '%*s' $(((totlen-prct)/8)) ''
    printf -v "$3" '%s%s' "$barstring" "$blankstring"
}

JSONLD_CONTEXT=`cat $JSONLD_CONTEXT_PATH | jq '.' --compact-output`

>$NQ_OUTPUT
for MAPPING in $MAPPING_DIR/*.jq; do
    TYPE=`basename $MAPPING .jq`
#    ITER=0
    echo ""
    echo "### Type: $TYPE ###"
    for INPUT in $INPUT_DIR/$TYPE/*.jsonl; do
        INPUT_NAME=`basename $INPUT .jsonl`
        # echo "$INPUT... "
        mkdir -p "$JSONLD_OUTPUT_DIR/$TYPE"
        JSONLD_OUTPUT_PREFIX="$JSONLD_OUTPUT_DIR/$TYPE/$INPUT_NAME"

        mkdir -p "$NQ_OUTPUT_DIR/$TYPE"
        NQ_OUTPUT_FOR_FILE="$NQ_OUTPUT_DIR/$TYPE/$INPUT_NAME.nq"
        >$NQ_OUTPUT_FOR_FILE

        # JSONLD_LINE_OUTPUT_PREFIX="$JSONLD_OUTPUT_DIR/$TYPE/${INPUT_NAME}_line"
        # JSONLDL_OUTPUT="$JSONLD_OUTPUT_DIR/$TYPE/${INPUT_NAME}.jsonldl"
#        OUTPUT_PREFIX=$OUTPUT_DIR/$TYPE-$ITER.jsonld
        # jq -f $MAPPING $INPUT --compact-output | awk '{ system("echo '\''"$0"'\'' >'$OUTPUT_PREFIX'_" NR ".jsonld") }'
        # jq -f $MAPPING $INPUT --compact-output | xargs -0 -n1 echo >"${OUTPUT_PREFIX}.jsonld"
        LINES_MAPPED=0
        # jq -f $MAPPING $INPUT --compact-output | while read out; do 
        # jq -L $MAPPING_DIR 'include "'$TYPE'"; main | ."@context" = '$JSONLD_CONTEXT'' $INPUT --compact-output >${JSONLDL_OUTPUT}
        NUM_LINES=` wc -l $INPUT | awk '{print $1}'`
        # echo "Num lines: $NUM_LINES"
        jq -L $MAPPING_DIR 'include "'$TYPE'"; main | ."@context" = '$JSONLD_CONTEXT'' $INPUT --compact-output | while read -r out; do 
            ITER=$(expr $LINES_MAPPED "+" 1)
            # echo "Mapping JSON n. '$ITER'..."
            # PERC_DONE=`echo "$LINES_MAPPED * 100.0 / $NUM_LINES" | bc -l`
            PERC_DONE=$((LINES_MAPPED * 100 / $NUM_LINES))
            # echo "Perc. done '$PERC_DONE'"

            percentBar $PERC_DONE 24 bar
            printf "\r$INPUT_NAME... \e[44;33;1m%s\e[0m %s/%s" "$bar" $LINES_MAPPED $NUM_LINES
            # printf '\r\e[47;30m %s\e[0m %s/%s' "$bar" $LINES_MAPPED $NUM_LINES

            # jq "." <<<"$out" >"${JSONLD_OUTPUT_PREFIX}_${ITER}.jsonld"
            jsonld toRdf - --n-quads  <<<"$out" | tee -a $NQ_OUTPUT_FOR_FILE >>$NQ_OUTPUT
            LINES_MAPPED=$(($LINES_MAPPED + 1))
        done
        printf "\r$INPUT_NAME... done!                                    \n"
        # PERC_DONE=$((LINES_MAPPED * 100 / $NUM_LINES))
        # percentBar $PERC_DONE 24 bar
        # printf '\r\e[44;33;1m %s\e[0m %s/%s\n' "$bar" $LINES_MAPPED $NUM_LINES
#        ITER=$(expr $ITER "+" 1)
    done
done

