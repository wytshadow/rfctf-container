#!/bin/sh
set -e
VERS="0.2"
DISTRO="client_server"
docker build . --pull -f "Dockerfile.${DISTRO}" -t rfhs/${DISTRO}:${VERS}
docker tag rfhs/${DISTRO}:${VERS} rfhs/${DISTRO}:latest
if [ "$(hostname)" = "Nu" ] ; then
  docker push rfhs/${DISTRO}
  docker push rfhs/${DISTRO}:latest
fi
