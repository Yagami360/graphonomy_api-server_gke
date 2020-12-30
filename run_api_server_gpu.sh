#!/bin/sh
set -eu

IN_IMAGE_DIR=sample_n5
RESULTS_DIR=results
if [ -d "${RESULTS_DIR}" ] ; then
    rm -r ${RESULTS_DIR}
fi

docker-compose -f docker-compose_gpu.yml stop
docker-compose -f docker-compose_gpu.yml up -d
#docker exec -it -u $(id -u $USER):$(id -g $USER) ${CONTAINER_NAME} bash

python request.py \
    --host 0.0.0.0 --port 5001 \
    --in_image_dir ${IN_IMAGE_DIR} \
    --results_dir ${RESULTS_DIR} \
    --debug
