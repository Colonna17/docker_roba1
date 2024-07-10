FROM nvidia/cuda:11.6.1-devel-ubuntu20.04

RUN apt update && DEBIAN_FRONTEND=noninteractive apt install python3 python3-pip ffmpeg libsm6 libxext6 -y

COPY requirements.txt /

RUN pip install torch==1.12.0+cu116 torchvision==0.13.0+cu116 torchaudio==0.12.0 --extra-index-url https://download.pytorch.org/whl/cu116

RUN pip install -r /requirements.txt

RUN mkdir /.cache && chmod 777 /.cache 
