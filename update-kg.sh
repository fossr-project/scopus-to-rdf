#!/usr/bin/env bash

CONF_FILE_PATH="fuseki-conf.ttl"
FUSEKI_CONF_PATH="/opt/homebrew/var/fuseki/configuration/"
FUSEKI_DB_PATH="/opt/homebrew/var/fuseki/databases/"
DS_NAME="scopus-kg"
NQ_FILE_PATH="data/rdf/all.nq"

DS_CONF_PATH="$FUSEKI_CONF_PATH$DS_NAME.ttl"

brew services stop fuseki

cp $CONF_FILE_PATH $DS_CONF_PATH
rm -rf "$FUSEKI_DB_PATH$DS_NAME" ||:

brew services start fuseki
brew services stop fuseki

tdb2.tdbloader --tdb $DS_CONF_PATH $NQ_FILE_PATH

brew services start fuseki

