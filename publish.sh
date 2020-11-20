#!/bin/bash -eu

# Publish any versions of the docker image not yet pushed to jenkins/jenkins
# Arguments:
#   -n dry run, do not build or publish images
#   -d debug

set -eou pipefail

: "${DOCKERHUB_ORGANISATION:=codenest}"
: "${DOCKERHUB_REPO:=helm}"

HELM_REPO="${DOCKERHUB_ORGANISATION}/${DOCKERHUB_REPO}"

cat <<EOF
Docker repository in Use:
* HELM_REPO: ${HELM_REPO}
EOF

docker-build() {
    local tag=$1

    docker buildx build --push \
               --platform linux/amd64,linux/arm/v7,linux/arm64 \
               -t ${HELM_REPO}:${tag} \
               .
}

# Try tagging with and without -f to support all versions of docker
docker-tag() {
    local from="${HELM_REPO}:$1"
    local to="$2/${DOCKERHUB_REPO}:$3"
    local out

    docker pull "$from"
    if out=$(docker tag -f "$from" "$to" 2>&1); then
        echo "$out"
    else
        docker tag "$from" "$to"
    fi
}

tag-and-push() {
    local source=$1
    local target=$2
    
    echo "Creating tag ${target} pointing to ${source}"
    docker-tag "${source}" "${DOCKERHUB_ORGANISATION}" "${target}"
    destination="${REPO:-${HELM_REPO}}:${target}"
    echo "Pushing ${destination}"
    docker push "${destination}"
}

publish-latest() {
    tag-and-push "${version}" "latest"
}

publish() {
    local version=$1
    echo "publishing: $version"

    # push latest (for master) or the name of the branch (for other branches)
    docker-build "${version}"
    tag-and-push "${version}" "${version}"
}

version=$(curl -Ls https://github.com/helm/helm/releases | grep 'href="/helm/helm/releases/tag/v3.[0-9]*.[0-9]*\"' | grep -v no-underline | head -n 1 | cut -d '"' -f 2 | awk '{n=split($NF,a,"/");print a[n]}' | awk 'a !~ $0{print}; {a=$0}')

publish "${version}"
publish-latest
