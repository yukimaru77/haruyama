# ようこそ春山研へ

## まずはパソコンのセットアップをしよう

## Ubuntuのインストール

Ubuntuは誰でも無料で使えるLinux OSです。windowsやmacと同じでグラフィカルな操作(マウスでアプリを使ったりすること)ができます。Ubuntuは機械学習用途で最も使われていたり、dockerが(ネイティブで)使えたりとメリットが多いです。

## Ubuntuの日本語化

https://lilaboc.work/archives/29007972.html

## chromeのインストール

https://inno-tech-life.com/dev/linux/ubuntu_chrome/

なお、他に好きなブラウザがあるならそちらで構いません。Braveとか個人的にはおすすめです。

## dockerのインストール

```
sudo apt-get remove docker docker-engine docker.io containerd runc
```

```
sudo apt-get update
sudo apt-get install \
	ca-certificates \
	curl \
	gnupg \
	lsb-release
```
```
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```
```
echo \
	"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
	$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

```
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
```

確認する。
```
sudo docker run hello-world
```

```
Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
 ```
 こんな感じのが出れば正解。dockerを使うたびにsudoを毎回打つのはめんどいのでなしでできるようにする。
```
sudo groupadd docker | sudo usermod -aG docker $USER | sudo reboot
```

## nvidia-container-runtimeのインストール

```
curl -s -L https://nvidia.github.io/nvidia-container-runtime/gpgkey |
sudo apt-key add -
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-container-runtime/$distribution/nvidia-container-runtime.list |
sudo tee /etc/apt/sources.list.d/nvidia-container-runtime.list
sudo apt-get update
```

```
sudo apt-get install nvidia-container-runtime
```

```
sudo reboot
```

ちなみに一般論として"ランタイム"とはソフトウェアが動く環境のことを指す。つまり、nvidia-container-runtimeとはnvidia-containerが動く環境をインストールしている。nvidiaとはGPUの会社の名前である。dockerはGPUに対応していないためわざわざnvidia-container-runtimeでDockerが動く環境を用意している。

## Nvidia-driverのインストール

ここは注意が必要。まず、以下のサイトを開いてみよう。
https://pytorch.org/get-started/locally/

その後、一番左下のCUAD 〇〇を読む。例えば画像ならCUDA 11.7となる。このCUAD 〇〇はあとでも必要になるので覚えておこう。

![代替えテキスト](https://github.com/yukimaru77/haruyama/blob/master/pytorch_version.png)


Pytorchとは、機械学習をするために必要なライブラリの一つです。GPUをプログラミングで使うには、CUDAというものが必要(ただしCUDA自体はDocker側でやるので今は大丈夫)で、CUDAのバージョンがPytorchでは指定されている。現在(2023/4/7)ではCUDA 11.7を使うらしい。さらにCUDAを使うにはNvidia-driverという、ものが必要になり、CUDAのバージョンによってNvidia-driverのバージョンも変わってくる。以下のサイトで確認今はしよう。CUDA 11.7はNvidia driverのバージョンが450.80.02以上でなければ行けないらしい。
https://docs.nvidia.com/cuda/cuda-toolkit-release-notes/index.html

![代替えテキスト](https://github.com/yukimaru77/haruyama/blob/master/cuda_version.png)


```
sudo apt install -y ubuntu-drivers-common
```

```
ubuntu-drivers devices
```

すると以下のような出力が出てくる。(出てくる数字はみんなのと違うので自分のを見るように。)
```
== /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0 ==
modalias : pci:v000010DEd00002508sv000017AAsd0000C97Abc03sc00i00
vendor   : NVIDIA Corporation
driver   : nvidia-driver-510 - distro non-free
driver   : nvidia-driver-470 - distro non-free
driver   : nvidia-driver-525-server - distro non-free
driver   : nvidia-driver-515-server - distro non-free
driver   : nvidia-driver-515-open - distro non-free
driver   : nvidia-driver-525 - distro non-free
driver   : nvidia-driver-525-open - distro non-free recommended
driver   : nvidia-driver-515 - distro non-free
driver   : nvidia-driver-470-server - distro non-free
driver   : xserver-xorg-video-nouveau - distro free builtin
```
この中でrecommendedと付いているバージョンを見る。今回は525のものについている。ここで先程確認したCUADの要請を満たすか確認する。自分の場合は450.80.02以上であればいいので525でok。ここでだめなら違うものを選ぼう。

```
sudo apt install --no-install-recommends nvidia-driver-バージョン(自分なら525)
```
以下のコマンドで再起動する。
```
sudo reboot
```

```
nvidia-smi
```


と入力し以下のような画面が出れば成功。
```
Sat Apr  8 04:11:15 2023       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 525.105.17   Driver Version: 525.105.17   CUDA Version: 12.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  NVIDIA GeForce ...  Off  | 00000000:01:00.0  On |                  N/A |
| 31%   28C    P8    11W / 120W |    363MiB /  8192MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1951      G   /usr/lib/xorg/Xorg                137MiB |
|    0   N/A  N/A      2078      G   /usr/bin/gnome-shell               86MiB |
|    0   N/A  N/A      3449      G   ...RendererForSitePerProcess       51MiB |
|    0   N/A  N/A      3727      G   ...437159759780931409,131072       84MiB |
+-----------------------------------------------------------------------------+
```

注意点としてDriver Version: 525.105.17   CUDA Version: 12.0と出力されているが、CUDA Version: 12.0とはNvidia-driverのバージョンが525.105.17のときに使えるCUADの最高のバージョンであり、 __入っているCUDAのバージョンではない__ ことに注意する。だってそもそもCUDAなんてまだ入れてないしね。`nvcc -V`がCIDAのバージョン確認コマンド。

## Docker-composeのインストール

Docker-composeは入れなくてもいいのだがDockerが簡単に使えるようになるので入れておこう。

```
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
```

```
sudo chmod +x /usr/local/bin/docker-compose
```

以上で完了。使えるか確認してみよう。
```
docker-compose -v
```
これで正常な反応が出ればおっけー。

## Docker fileの用意

新しくディレクトリを作ろう。今回はtestとしておく。
```
mkdir test
```
その後、testディレクトリに移動。
```
cd tset
```

[ここから](https://github.com/yukimaru77/haruyama/blob/master/Dockerfile)Dockerfileをダウンロードしてtestディレクトリの中に入れよう。ここでDocker fileの先頭を見てみよう
```
# Nvidia CUDAの〇〇.○.0-devel-ubuntu18.04をベースイメージにする
FROM nvidia/cuda:○○.○.0-devel-ubuntu18.04
```
上記のようになっているので先程確認した自分が入れるべきCUDAのバージョンを○○.○に入れる。自分なら11.7なので
```
# Nvidia CUDAの11.7.0-devel-ubuntu18.04をベースイメージにする
FROM nvidia/cuda:11.7.0-devel-ubuntu18.04
```

また、[ここから](https://github.com/yukimaru77/haruyama/blob/master/Docker-compose.yml)ocker-compose.ymlをダウンロードしてこれもtestディレクトリの中に入れよう。
```
pwd
```
でtestディレクトリにいるのを確認できたら、
```
docker-compose up --build
```
と入力してみよう。初回はかなり待たされるはず。以上でdockerコンテナが立ち上がったはずだ。
