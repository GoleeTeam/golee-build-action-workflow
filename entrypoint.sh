#!/bin/sh -l

app_name=$1
branch_name=$2
commit_hash=$3 

app_name=${app_name##*/}
branch_name=${branch_name##*/}

GCLOUD_PROJECT="${GCLOUD_PROJECT:-"golee-infra"}"

apt-get update
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
# Google Cloud SDK
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" |  tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -


apt-get update
apt-get install -y docker-ce-cli
apt-get install -y google-cloud-sdk

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

docker build -t goleedev/$SERVICE_NAME:$VERSION_CODE .
docker tag goleedev/$SERVICE_NAME:$VERSION_CODE $REMOTE_IMAGE_PATH_WITH_TAG
docker tag $REMOTE_IMAGE_PATH_WITH_TAG "${REMOTE_IMAGE_PATH}:latest-${branch_name}"
docker image push --all-tags $REMOTE_IMAGE_PATH

echo "::set-output name=image_path::$REMOTE_IMAGE_PATH_WITH_TAG"