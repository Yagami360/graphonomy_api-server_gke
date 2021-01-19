#!/bin/sh
set -eu

PROJECT_ID=myproject-292103
REGION=asia-northeast1-a
#REGION=asia-northeast1-c
#REGION=us-central1-a
#REGION=us-central1-c
#REGION=asia-east1-a
GPU_TYPE=nvidia-tesla-t4
#GPU_TYPE=nvidia-tesla-k80

CLUSTER_NAME=graphonomy-cluster-gpu
POOL_NAME=graphonomy-pool-gpu
POD_NAME=graphonomy-pod-gpu
SERVICE_NAME=graphonomy-server-gpu
NUM_NODES=1
PORT=5000

# デフォルト値の設定
gcloud config set project ${PROJECT_ID}
gcloud config set compute/zone ${REGION}
gcloud config list

# docker image を GCP の Container Registry にアップロード
gcloud builds submit --config cloudbuild.yml

# クラスタを作成
gcloud container clusters create ${CLUSTER_NAME} \
    --num-nodes=${NUM_NODES} \
    --machine-type n1-standard-1

# GPU ノードプールを作成
gcloud container node-pools create ${POOL_NAME} \
    --accelerator type=${GPU_TYPE},count=1 \
    --cluster ${CLUSTER_NAME} \
    --num-nodes ${NUM_NODES} --min-nodes ${NUM_NODES} --max-nodes ${NUM_NODES} \
    --enable-autoscaling \
    --machine-type n1-standard-4

# k8s の DaemonSet での Pod 経由で GPU ドライバーをインストール
kubectl apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/container-engine-accelerators/master/nvidia-driver-installer/cos/daemonset-preloaded.yaml
sleep 60
kubectl get pods -n=kube-system

# Pod を作成する
kubectl apply -f k8s/deployment_gpu.yml
sleep 120
kubectl get pods

# Service を公開する
kubectl apply -f k8s/service_gpu.yml
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

# nvidia-smi コマンドで GPU ドライバが正しくインストールされているか確認
#nvidia-smi
