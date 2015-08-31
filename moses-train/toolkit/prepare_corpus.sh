#!/bin/bash

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

echo "##### PREPARING TRAINING CORPUS #####\n"
mkdir -p temp

echo "##### TOKENIZING CORPUS ######"
${MOSES_DIR}/scripts/tokenizer/tokenizer.perl -l ${TARGET_LANG} < "${NAME}.${TARGET_LANG}" > "temp/${NAME}.tok.${TARGET_LANG}"
${MOSES_DIR}/scripts/tokenizer/tokenizer.perl -l ${SOURCE_LANG} < "${NAME}.${SOURCE_LANG}" > "temp/${NAME}.tok.${SOURCE_LANG}"

echo "##### TRUECASING CORPUS ######"
${MOSES_DIR}/scripts/recaser/train-truecaser.perl --model "temp/truecase-model.${TARGET_LANG}" --corpus "temp/${NAME}.tok.${TARGET_LANG}"
${MOSES_DIR}/scripts/recaser/train-truecaser.perl --model "temp/truecase-model.${SOURCE_LANG}" --corpus "temp/${NAME}.tok.${SOURCE_LANG}"

${MOSES_DIR}/scripts/recaser/truecase.perl --model "temp/truecase-model.${TARGET_LANG}" > "temp/${NAME}.true.${TARGET_LANG}"
${MOSES_DIR}/scripts/recaser/truecase.perl --model "temp/truecase-model.${SOURCE_LANG}" > "temp/${NAME}.true.${SOURCE_LANG}"

echo "##### CLEANING CORPUS #####"
${MOSES_DIR}/scripts/training/clean-corpus-n.perl "temp/${NAME}.true" ${SOURCE_LANG} ${TARGET_LANG} "${NAME}.clean" 1 80

cd -