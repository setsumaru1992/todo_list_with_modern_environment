#!/bin/bash

# 事前実行:
# docker build -t todo_app_back . (動作確認 docker run --rm -it -p 30418:30418 todo_app_back)
# 環境変数読み込み: `export $(grep -v '^#' .env | xargs)`
aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin ${IMAGE_REGISTORY}
docker tag todo_app_back:latest ${IMAGE_REGISTORY}/todo_app_back:latest
docker push ${IMAGE_REGISTORY}/todo_app_back:latest
