FROM docker.privaclouds.com/moses-base:latest

ENV MOSES_HOME=/home/moses \
	MGIZA_CPUS=8 \
	PYTHONUNBUFFERED=0

ENV	MOSES_DIR="${MOSES_HOME}/mosesdecoder" \
	MOSES_MODEL_DIR="${MOSES_HOME}/models"

RUN mkdir -p "${MOSES_MODEL_DIR}"

COPY toolkit /home/moses/toolkit/
COPY entrypoint.py /sbin/entrypoint.py
RUN chmod 755 /sbin/entrypoint.py

VOLUME ["${MOSES_MODEL_DIR}"]

WORKDIR ${MOSES_MODEL_DIR}

ENTRYPOINT ["/sbin/entrypoint.py"]
