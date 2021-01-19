PROJECT_ID=myproject-292103
REGION=asia-northeast1-a
CLUSTER_NAME=graphonomy-cluster-cpu
SERVICE_NAME=graphonomy-server-cpu

# クラスタ切り替え
gcloud container clusters get-credentials ${CLUSTER_NAME} --zone=${REGION} --project ${PROJECT_ID}

# 入出力ディレクトリ
IN_IMAGE_DIR=sample_n5      # 入力ディレクトリ
RESULTS_DIR=results         # 出力ディレクトリ

# 公開外部アドレス取得
EXTERNAL_IP=`kubectl describe service ${SERVICE_NAME} | grep "LoadBalancer Ingress" | awk '{print $3}'`
PORT=5000

python request.py \
    --host ${EXTERNAL_IP} --port ${PORT} \
    --in_image_dir ${IN_IMAGE_DIR} --results_dir ${RESULTS_DIR} \
    --debug
