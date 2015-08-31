FROM moses-base:latest

ENV MOSES_HOME=/home/moses

ENV	MOSES_DIR="${MOSES_HOME}/mosesdecoder" \
	MOSES_CONFIG_DIR="${MOSES_HOME}/config" \
	MOSES_MODEL_DIR="${MOSES_HOME}/models" \
	MOSES_LOG_DIR="${MOSES_HOME}/log" \
	MOSES_PORT=8888

RUN mkdir -p "${MOSES_MODEL_DIR}"

COPY start.sh ${MOSES_HOME}/start.sh
RUN chmod 755 ${MOSES_HOME}/start.sh

VOLUME ["${MOSES_MODEL_DIR}", "${MOSES_CONFIG_DIR}", "${MOSES_LOG_DIR}"]

WORKDIR ${MOSES_HOME}

ENTRYPOINT ['start.sh']