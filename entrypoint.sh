#!/bin/sh -l

app_name=$1
branch_name=$2
commit_hash=$3 

app_name=${app_name##*/}
branch_name=${branch_name##*/}

GCLOUD_PROJECT="${GCLOUD_PROJECT:-"golee-infra"}"

set -e


docker -v
gcloud -v

echo -n $GCLOUD_SERVICE_ACCOUNT_KEYFILE > ./gcloud-api-key.json
gcloud auth activate-service-account --key-file gcloud-api-key.json
gcloud config set project $GCLOUD_PROJECT   

VERSION_CODE="$branch_name-$commit_hash"
SERVICE_NAME="$app_name"
REMOTE_IMAGE_PATH="eu.gcr.io/$GCLOUD_PROJECT/$SERVICE_NAME"
REMOTE_IMAGE_PATH_WITH_TAG="$REMOTE_IMAGE_PATH:$VERSION_CODE"

gcloud auth configure-docker

DOCKER_BUILDKIT=1 docker build -t goleedev/$SERVICE_NAME:$VERSION_CODE .
docker tag goleedev/$SERVICE_NAME:$VERSION_CODE $REMOTE_IMAGE_PATH_WITH_TAG
docker tag $REMOTE_IMAGE_PATH_WITH_TAG "${REMOTE_IMAGE_PATH}:latest-${branch_name}"
docker image push --all-tags $REMOTE_IMAGE_PATH

echo "::set-output name=image_path::$REMOTE_IMAGE_PATH_WITH_TAG"
