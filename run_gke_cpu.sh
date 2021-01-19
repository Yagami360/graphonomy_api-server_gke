#!/bin/sh
set -eu

PROJECT_ID=myproject-292103
REGION=asia-northeast1-a
#REGION=asia-northeast1-c
#REGION=us-central1-a
#REGION=us-central1-c
#REGION=asia-east1-a

CLUSTER_NAME=graphonomy-cluster-cpu
POD_NAME=graphonomy-pod-cpu
SERVICE_NAME=graphonomy-server-cpu
NUM_NODES=1
PORT=5000

# デフォルト値の設定
gcloud config set project ${PROJECT_ID}
gcloud config set compute/zone ${REGION}
gcloud config list

# docker image を GCP の Container Registry にアップロード
#gcloud builds submit --config cloudbuild.yml

# クラスタを作成
gcloud container clusters create ${CLUSTER_NAME} \
    --num-nodes=${NUM_NODES} \
    --machine-type n1-standard-4

# Pod を作成する
kubectl apply -f k8s/deployment_cpu.yml
sleep 10
kubectl get pods

# Service を公開する
kubectl apply -f k8s/service_cpu.yml
sleep 60
kubectl get service ${SERVICE_NAME}

# 公開外部アドレス取得
EXTERNAL_IP=`kubectl describe service ${SERVICE_NAME} | grep "LoadBalancer Ingress" | awk '{print $3}'`

# 公開外部アドレスの URL にアドレスして動作確認する
#curl http://${EXTERNAL_IP}:${PORT}

# 公開外部アドレスにリクエスト処理して、レスポンスを受け取る
python request.py \
    --host ${EXTERNAL_IP} --port ${PORT} \
    --in_image_dir sample_n5 \
    --results_dir results \
    --debug

# 作成した Pod のコンテナログを確認
POD_NAME_1=`kubectl get pods | awk '{print $1}' | sed -n 2p`
kubectl logs ${POD_NAME_1}

# 作成した Pod のコンテナにアクセス
#kubectl exec -it ${POD_NAME_1} /bin/bash
