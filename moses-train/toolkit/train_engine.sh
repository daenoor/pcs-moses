#!/bin/bash

usage() { echo "Train translation engine\n\nUsage: $0 -c <corpus name> -s <source language> -t <target language>" 1>&2; exit 1; }

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

echo "##### TRAINING TRANSLATION ENGINE FOR TRANSLATION FROM ${SOURCE_LANG} TO ${TARGET_LANG} #####"
echo "Make yourself a cup of coffee and relax. This will take a long time"

mkdir -p ${MOSES_MODEL_DIR}/${NAME}/${SOURCE_LANG}-${TARGET_LANG}
cd ${MOSES_MODEL_DIR}/${NAME}/${SOURCE_LANG}-${TARGET_LANG}

if [ -z "${MGIZA_CPUS}" ]; then
	MGIZA_CPUS=2
fi

~/mosesdecoder/scripts/training/train-model.perl -root-dir train \
 --parallel -mgiza -mgiza-cpus ${MGIZA_CPUS} \
 -corpus ${MOSES_MODEL_DIR}/$NAME.clean \
 -f ${SOURCE_LANG} -e ${TARGET_LANG} -alignment grow-diag-final-and -reordering msd-bidirectional-fe \ 
 -lm 0:3:${MOSES_MODEL_DIR}/lm/${NAME}.blm.${TARGET_LANG}:8 \
 -external-bin-dir ${MOSES_HOME}/train-tools  > training.out

 check_result

 cd -