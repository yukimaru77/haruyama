# Nvidia CUDAの〇〇.○.0-devel-ubuntu18.04をベースイメージにする
FROM nvidia/cuda:○○.○.0-devel-ubuntu18.04

# 必要なパッケージをインストール
RUN apt-get update && apt-get install -y \
sudo \
wget \
graphviz

# 作業ディレクトリを/optに指定
WORKDIR /opt

# Anacondaをダウンロードし/opt/anaconda3にインストール
RUN wget https://repo.anaconda.com/archive/Anaconda3-2022.10-Linux-x86_64.sh && \
sh Anaconda3-2022.10-Linux-x86_64.sh -b -p /opt/anaconda3 && \
rm -f Anaconda3-2022.10-Linux-x86_64.sh

# PATHを設定
ENV PATH /opt/anaconda3/bin:$PATH

# 必要なPythonパッケージをpipでインストール
# 他に必要なライブラリがあったらここ↓に追記する。
RUN pip install --upgrade pip && pip install \
torch torchvision torchaudio torchviz torchinfo graphviz japanize-matplotlib