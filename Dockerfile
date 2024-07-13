FROM nvidia/cuda:11.6.1-cudnn8-runtime-ubuntu20.04

# Aggiorna e installa i pacchetti necessari
RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y \
    python3 \
    python3-pip \
    ffmpeg \
    libsm6 \
    libxext6 \
    wget \
    build-essential \
    software-properties-common

# Aggiungi il repository per gcc-9/g++-9 e installa
RUN add-apt-repository ppa:ubuntu-toolchain-r/test && \
    apt update && \
    apt install -y gcc-9 g++-9 && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 60 --slave /usr/bin/g++ g++ /usr/bin/g++-9

# Installa Miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /miniconda.sh && \
    bash /miniconda.sh -b -p /opt/conda && \
    rm /miniconda.sh && \
    /opt/conda/bin/conda clean -tipsy && \
    ln -s /opt/conda/bin/conda /usr/local/bin/conda && \
    ln -s /opt/conda/bin/python /usr/local/bin/python && \
    ln -s /opt/conda/bin/pip /usr/local/bin/pip

# Aggiorna Conda
RUN conda update -n base -c defaults conda

# Copia il file requirements.txt
COPY requirements.txt /

# Installa le dipendenze con pip
RUN pip install torch==1.13.1+cu116 torchvision==0.14.1+cu116 torchaudio==0.13.1 --extra-index-url https://download.pytorch.org/whl/cu116

RUN pip install -r /requirements.txt

# Crea e imposta i permessi per la cartella cache
RUN mkdir /.cache && chmod 777 /.cache