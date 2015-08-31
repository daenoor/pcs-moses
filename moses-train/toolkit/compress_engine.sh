#!/bin/bash

usage() { echo "Compress translation engine\n\nUsage: $0 -c <corpus name> -s <source language> -t <target language>" 1>&2; exit 1; }

env_check(){
	if [ -z "${MOSES_HOME}" ] || [ -z "${MOSES_MODEL_DIR}" ] || [ -z "${MOSES_DIR}" ]; then
		echo "You need to set MOSES_HOME, MOSES_DIR and MOSES_MODEL_DIR env vars" 1>&2; exit 1;
	fi
}

check_result(){
	if ! [ $? -eq 0 ] 
	then
		echo "Failed"
		exit 1
	fi
}

while getopts ":c:s:t:" o; do
	case "${o}" in
		c)	NAME=${OPTARG}
			;;

		s)	SOURCE_LANG=${OPTARG}
			;;

		t)	TARGET_LANG=${OPTARG}
			;;

		*)	usage
			;;
	esac
done

env_check

if [ -z "${NAME}" ] || [ -z "${SOURCE_LANG}" ] || [ -z "${TARGET_LANG}" ]; then
    usage
fi

cd ${MOSES_MODEL_DIR}/${NAME}/${SOURCE_LANG}-${TARGET_LANG}

echo "##### COMPACTING PHRASE TABLE #####"

