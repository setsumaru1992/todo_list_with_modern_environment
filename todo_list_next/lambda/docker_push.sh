#!/bin/bash

script_path="$(realpath "$0")"
script_dir=$(dirname $script_path)
script_parent_dir=$(dirname $script_dir)
cd $script_parent_dir

export $(grep -v '^#' ../.env | xargs)

#image_name_with_tag=todo_app_front_lambda:latest
image_name_with_tag=todo_app/front/lambda/managed_by_terraform/dev:latest
docker build -t ${image_name_with_tag} -f lambda/Dockerfile .

aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin ${IMAGE_REGISTORY}
docker tag ${image_name_with_tag} ${IMAGE_REGISTORY}/${image_name_with_tag}
docker push ${IMAGE_REGISTORY}/${image_name_with_tag}
