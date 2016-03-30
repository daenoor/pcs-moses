#!/bin/bash

usage() { echo "Train language model\n\nUsage: $0 -c <corpus name> -t <target language>" 1>&2; exit 1; }

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

		t)	TARGET_LANG=${OPTARG}
			;;

		*)	usage
			;;
	esac
done

env_check

if [ -z "${NAME}" ] || [ -z "${TARGET_LANG}" ]; then
    usage
fi

echo "##### CREATING TARGET LANGUAGE MODEL #####"

mkdir -p ${MOSES_MODEL_DIR}/lm
cd ${MOSES_MODEL_DIR}/lm

echo "##### INSERT START AND END BOUNDARIES #####"
${MOSES_HOME}/irstlm/bin/add-start-end.sh < "../temp/${NAME}.true.${TARGET_LANG}" > "${NAME}.sb.${TARGET_LANG}"
check_result

echo "##### BUILD LM DATA #####"
${MOSES_HOME}/irstlm/bin/build-lm.sh -i "${NAME}.sb.${TARGET_LANG}" -t ./tmp -p -s improved-kneser-ney -o "${NAME}.lm.${TARGET_LANG}"
check_result

echo "##### COMPILE LM #####"
${MOSES_HOME}/irstlm/bin/compile-lm --text=yes "${NAME}.lm.${TARGET_LANG}.gz" "${NAME}.arpa.${TARGET_LANG}"
check_result

echo "##### BUILD BINARY LM #####"
${MOSES_DIR}/bin/build_binary "${NAME}.arpa.${TARGET_LANG}" "${NAME}.blm.${TARGET_LANG}"
check_result

cd -
