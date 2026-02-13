#! /usr/bin/env bash

VERSION=${VERSION:-1.1}
REPOSITORY=europe-west6-docker.pkg.dev/golee-infra

IMAGE=$REPOSITORY/golee-public-images/ubuntu-with-docker-gcloud
TAG=$IMAGE:$VERSION

echo "Buiding version $VERSION ..."
read -p "Press enter to continue"
docker build -t $TAG .

echo "Publishing to $REPOSITORY ..."
read -p "Press enter to continue"
docker push $TAG

echo "Done."