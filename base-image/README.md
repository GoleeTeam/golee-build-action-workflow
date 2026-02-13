# ubuntu-with-docker-gcloud
Base Docker image used by golee-build-action-workflow


Based on ubuntu:latest. Docker and GCloud CLI installed.

---

### Publish

```
# ensure docker CLI can access remote GCR artifacts repository
gcloud auth configure-docker europe-west6-docker.pkg.dev

# build and publish, with given version (eg. 1.1)
VERSION=1.1 ./build-and-publish.sh
```

### Usage

* Pull image with `docker pull europe-west6-docker.pkg.dev/golee-infra/golee-public-images/ubuntu-with-docker-gcloud:1.1`
* Use image in you Dockerfile with `FROM europe-west6-docker.pkg.dev/golee-infra/golee-public-images/ubuntu-with-docker-gcloud:1.1`
