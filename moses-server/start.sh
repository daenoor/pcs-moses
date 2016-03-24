#!/bin/bash

echo "Starting Moses Server on ${MOSES_PORT}"

$MOSES_DIR/bin/mosesserver -f $MOSES_CONFIG_DIR/moses.ini --server-port $MOSES_PORT --server-log $MOSES_LOG_DIR/server.log
