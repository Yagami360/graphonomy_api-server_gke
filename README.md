# graphonomy_api-server_gke
[Graphonomy](https://github.com/Gaoyiminggithub/Graphonomy) の推論スクリプト [`inference.py`](https://github.com/Gaoyiminggithub/Graphonomy/blob/master/exp/inference/inference.py) の推論API。GKE 上で動作します。

## ■ 動作環境
- requests : 
- OpenCV : 

## ■ 使い方

```sh
```

### ◎ 個別に行う場合
1. docker image の作成
    ```sh
    docker-compose -f docker-compose_gpu.yml stop
    docker-compose -f docker-compose_gpu.yml up -d
    ```

1. 作成した docker image を GCP の Container Registry にアップロード
1. GKE でクラスタ作成
    1. Deployment を作成する
    1. Deployment を公開する
1. リクエストスクリプトを実行する
