#!/bin/bash

source ./variables.sh $1

for build in ${BUILDS[@]}; do
    tag=${CONTAINER}/${build}:${GRPC_VERSION}_${BUILD_VERSION}
    echo "building ${build} container with tag ${tag}"
	docker build -t ${tag} \
        -f Dockerfile \
        --build-arg grpc_version=${GRPC_VERSION} \
        --build-arg grpc_java=${GRPC_JAVA_VERSION} \
        --build-arg namely_build=_${BUILD_VERSION} \
        --target ${build} \
        .

    if [ "${LATEST}" = true ]; then
        echo "setting ${tag} to latest"
        docker tag ${tag} ${CONTAINER}/${build}:latest
    else
        echo "Skipping latest tag: ${LATEST}"
    fi
done
