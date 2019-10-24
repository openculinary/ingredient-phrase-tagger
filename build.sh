REGISTRY='registry.openculinary.org'
PROJECT='reciperadar'
SERVICE=$(basename `git rev-parse --show-toplevel`)

IMAGE_NAME=${REGISTRY}/${PROJECT}/${SERVICE}
IMAGE_COMMIT=$(git rev-parse --short HEAD)

container=$(buildah from docker.io/mtlynch/ingredient-phrase-tagger:latest)
buildah run ${container} -- mkdir model
buildah run ${container} -- ./bin/train-prod-model model
buildah run ${container} -- /bin/sh -c 'ln model/*.crfmodel model/latest'
buildah commit --squash --rm ${container} ${IMAGE_NAME}:${IMAGE_COMMIT}
buildah tag ${IMAGE_NAME}:${IMAGE_COMMIT} ${IMAGE_NAME}:latest
