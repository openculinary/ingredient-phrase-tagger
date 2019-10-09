REGISTRY='registry.gitlab.com'
PROJECT='openculinary'

IMAGE_NAME=${REGISTRY}/${PROJECT}/$(basename `git rev-parse --show-toplevel`)
IMAGE_COMMIT=$(git rev-parse --short HEAD)

if [ -n "${GITLAB_USER_ID}" ]; then
    # Override the default 'overlay' storage driver, which fails GitLab builds
    export STORAGE_DRIVER='vfs'

    # Workaround from https://major.io for 'overlay.mountopt' option conflict
    sed -i '/^mountopt =.*/d' /etc/containers/storage.conf

    # Authenticate for any privileged operations
    REGISTRY_AUTH_FILE=${HOME}/auth.json echo "${CI_REGISTRY_PASSWORD}" | buildah login -u "${CI_REGISTRY_USER}" --password-stdin ${CI_REGISTRY}
fi

container=$(buildah from docker.io/mtlynch/ingredient-phrase-tagger:latest)
buildah run ${container} -- mkdir model
buildah run ${container} -- ./bin/train-prod-model model
buildah run ${container} -- /bin/sh -c 'ln model/*.crfmodel model/latest'
buildah commit --squash --rm ${container} ${IMAGE_NAME}:${IMAGE_COMMIT}
buildah tag ${IMAGE_NAME}:${IMAGE_COMMIT} ${IMAGE_NAME}:latest

if [ -n "${GITLAB_USER_ID}" ]; then
    buildah push ${IMAGE_NAME}:${IMAGE_COMMIT}
    buildah push ${IMAGE_NAME}:latest
fi
