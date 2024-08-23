#!/bin/bash

# This does both steps for us
./00-create-ecr.sh
./01-build-tag-push.sh

docker images