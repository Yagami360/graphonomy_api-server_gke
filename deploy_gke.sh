#!/bin/sh
set -eu

PROJECT_ID=myproject-292103
REGION=asia-northeast1-a
IMAGE_NAME=graphonomy_wrapper_image
CLUSTER_NAME=graphonomy-api-cluster
NUM_NODES=3
PORT=80
TARGET_PORT=5002

# docker image の作成
#docker-compose -f docker-compose_cpu.yml stop
#docker-compose -f docker-compose_cpu.yml up -d

# 作成した api コードの docker image を作成し、GCP の Container Registry にアップロード
gcloud builds submit --tag gcr.io/${PROJECT_ID}/${IMAGE_NAME}

# デフォルト値の設定
gcloud config set project ${PROJECT_ID}
gcloud config set compute/zone ${REGION}
gcloud config list

# １つのノードのクラスタを作成（デフォルトでは３ノード）
gcloud container clusters create ${CLUSTER_NAME} --num-nodes=${NUM_NODES}

# クラスタの認証情報を取得する
gcloud container clusters get-credentials ${CLUSTER_NAME}

# Deployment を作成する（＝作成したクラスタに、コンテナ化された docker image をデプロイする）
kubectl create deployment ${CLUSTER_NAME} --image=gcr.io/${PROJECT_ID}/${IMAGE_NAME}
kubectl describe deployments

# Deployment を公開する
kubectl expose deployment ${CLUSTER_NAME} --type LoadBalancer --port ${PORT} --target-port ${TARGET_PORT}
kubectl get pods
kubectl get service ${CLUSTER_NAME}

EXTERNAL_IP=34.85.65.57     # 自動化したい

# 公開サイトにアクセスして動作確認する
# http://${EXTERNAL_IP}/ にアクセス

# 作成した Pod のコンテナにアクセス

# リクエスト処理
IN_IMAGE_DIR=sample_n5
RESULTS_DIR=results

python request.py \
    --host ${EXTERNAL_IP} --port ${TARGET_PORT} \
    --in_image_dir ${IN_IMAGE_DIR} \
    --results_dir ${RESULTS_DIR} \
    --debug

