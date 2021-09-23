FROM europe-west6-docker.pkg.dev/golee-infra/golee-public-images/ubuntu-with-docker-gcloud:1.0

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]