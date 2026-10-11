#!/usr/bin/env bash
set -e

IMAGE_NAME="squezeeek/hello-panda"
TAG="latest"
CONTAINER_NAME="test-app"
HOST_PORT="8080"
CONTAINER_PORT="8080"

echo "=== [1/4] Збірка Docker-образу  ==="
docker build -t "${IMAGE_NAME}:${TAG}" .

echo "=== [2/4] Відправка образу в Docker Hub ==="
docker push "${IMAGE_NAME}:${TAG}"

echo "=== [3/4] Зупинка та видалення старого контейнера  (якщо є) ==="
if [ "$(docker ps -aq -f name=^/${CONTAINER_NAME}$)" ]; then
    docker rm -f "${CONTAINER_NAME}"
fi

echo "=== [4/4] Запуск оновленого контейнера ==="
docker run -d \
    --name "${CONTAINER_NAME}" \
    -p "${HOST_PORT}:${CONTAINER_PORT}" \
    --restart unless-stopped \
    "${IMAGE_NAME}:${TAG}"

echo "=== Деплой успішно закінчен! Перевіряємо статус: ==="
docker ps -f name="${CONTAINER_NAME}"
