#!/bin/bash
# Run to extract all the docker images and tags used in the current
# cwl repo.
# Kyle Hernandez <kmhernan@uchicago.edu>

set -e

SCRIPTS_DIR=$(dirname $0)
ROOT_DIR=$(cd $SCRIPTS_DIR/.. && pwd -P)
OUT_FILE=${ROOT_DIR}/current_docker_list.txt

#NOTE: you may have to modify this for other repos
find . -name "*.cwl" -exec grep 'dockerPull:' {} \; | awk '{print $2}' | sort | uniq > $OUT_FILE
