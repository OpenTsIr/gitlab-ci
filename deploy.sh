echo "[TASK 1] checking image name"
if [ -z "$IMAGE" ]; then
    echo "  [!] Error, docker image name is not provided."
    exit 1
fi
echo "starting deployment"

echo "[TASK 2] checking registry credentials"
if [[ -z "$DOCKER_USERNAME" || -z "$DOCKER_PASSWORD" ]]; then
    echo "  [!] Error, registry credentials not provided."
    exit 1
fi

echo "starting deployment"

echo "[TASK 3] logging in gitlab registry ..."
echo -n $DOCKER_PASSWORD | base64 -d | docker login registry.gitlab.com --username $DOCKER_USERNAME --password-stdin

echo "[TASK 4] pulling image $IMAGE"
pull=$(docker pull $IMAGE)

if [[ -z "$pull" ]]; then
    echo "  [!] Fail to pull image $IMAGE"
    exit 1
fi

echo "[TASK 5] runnig updated image"
NESTAPP_IMAGE=$IMAGE docker compose up --no-deps nestapp
# The --no-deps will not start linked services

echo "SUCCESSFULLY DONE :)"
