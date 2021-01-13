# graphonomy_api-server_gke
[Graphonomy](https://github.com/Gaoyiminggithub/Graphonomy) の推論API。<br>
GKE クラスタ上で動作します。

## ■ 動作環境
- Ubuntu or MacOS :
- gcloud :
- Kubernetes (k8s) : 
- requests : 
- OpenCV : 

## ■ 使い方

### 1. GKE クラスタの構築
`run_gke_gpu.sh` or `run_gke_cpu.sh` スクリプト内の定数 `PROJECT_ID`, `REGION`, `GPU_TYPE` を適切な値に設定後、以下のコマンドを実行することで、GKE クラスタを自動的に構築します

- GPU 搭載 GKE クラスタを構築（GPU で動作させたい場合に使用）
    ```sh
    $ run_gke_gpu.sh
    ```

- GPU 非搭載 GKE クラスタを構築（CPU で動作させたい場合に使用）
    ```sh
    $ run_gke_cpu.sh
    ```

### 2. リクエスト処理
GKE クラスタを構築後、`run_request.sh` スクリプトの定数 `IN_IMAGE_DIR`, `RESULTS_DIR` を適切な値に設定後、以下のコマンドでリクエスト処理を行うことで、Graphonomy からの推論結果（＝パース画像）を取得することができます。

- GKE クラスタの Pod 内コンテナに対してリクエスト処理（GPU で動作させたい場合）
    ```sh
    $ sh run_request_gpu.sh
    ```

- GKE クラスタの Pod 内コンテナに対してリクエスト処理（CPU で動作させたい場合）
    ```sh
    $ sh run_request_cpu.sh
    ```
