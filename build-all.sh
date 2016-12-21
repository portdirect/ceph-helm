#/bin/bash
function list_dirs () {
  find . -maxdepth 1 -type d | tail -n +2 | sed 's|^./||g'
}

function build_charts () {
  echo "Building Charts"
  cd helm-charts;
  list_dirs | while read CHART; do
    if [ -f ${CHART}/Makefile ]; then make -C ${CHART}; fi
    if [ -f ${CHART}/requirements.yaml ]; then helm dep up ${CHART}; fi
    helm package ./${CHART}
  done
  cd ..
}

function build_docker_helpers () {
  echo "Building Plugin Docker Images"
  cd dockerfiles/helm-plugins;
  list_dirs | while read DOCKER_IMAGE; do
    docker build ${DOCKER_IMAGE} -t docker.io/gantry/${DOCKER_IMAGE}:latest
  done
  cd ../..
}

function install_plugin () {
  echo "Installing Plugin"
  cd helm-plugins;
  list_dirs | while read PLUGIN; do
    cp -av ${PLUGIN} $(helm home)/plugins
  done
  cd ..
}

build_charts
build_docker_helpers
install_plugin
