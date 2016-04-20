#!/usr/bin/env bash

usage() { echo "Prepare corpus\n\nUsage: $0 -c <corpus name> -s <source language> -t <target language>" 1>&2; exit 1; }

env_check(){
	if [ -z "${MOSES_HOME}" ] || [ -z "${MOSES_MODEL_DIR}" ] || [ -z "${MOSES_DIR}" ]; then
		echo "You need to set MOSES_HOME, MOSES_DIR and MOSES_MODEL_DIR env vars" 1>&2; exit 1;
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

cd ${MOSES_MODEL_DIR}


echo "##### Create folders #####"
mkdir -p ${MOSES_MODEL_DIR}/release/config
mkdir -p ${MOSES_MODEL_DIR}/release/logs
mkdir -p ${MOSES_MODEL_DIR}/release/models/${SOURCE_LANG}-${TARGET_LANG}


echo "##### Copy Language Model #####"
cp lm/${NAME}.blm.${TARGET_LANG} release/models/

echo "##### Copy Translation Model #####"
cp ${NAME}/${SOURCE_LANG}-${TARGET_LANG}/train/model/phrase-table.gz release/models/${SOURCE_LANG}-${TARGET_LANG}/

echo "##### Copy Reordering Model #####"
cp ${NAME}/${SOURCE_LANG}-${TARGET_LANG}/train/model/reordering-table.wbe-msd-bidirectional-fe.gz release/models/${SOURCE_LANG}-${TARGET_LANG}/

echo "##### Prepare Moses.ini"
cp ${NAME}/${SOURCE_LANG}-${TARGET_LANG}/train/model/moses.ini release/config/

PATTERN="${MOSES_MODEL_DIR}/${NAME}/${SOURCE_LANG}-${TARGET_LANG}/train/model/"
REPLACE="${MOSES_MODEL_DIR}/${SOURCE_LANG}-${TARGET_LANG}/"
sed "s|${PATTERN}|${REPLACE}|" -i.bak release/config/moses.ini

PATTERN="${MOSES_MODEL_DIR}/lm"
REPLACE="${MOSES_MODEL_DIR}"
sed "s|${PATTERN}|${REPLACE}|" -i.bak release/config/moses.ini
rm release/config/moses.ini.bak

tar cvf release.tar release/
sha1sum release.tar > release.checksum

cd -
