FROM --platform=linux/amd64 nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    python3 \
    python3-pip \
    python3-dev \
    wget \
    curl \
    libgl1 \
    build-essential \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace/ComfyUI

COPY . .
COPY start.sh /start.sh
RUN chmod +x /start.sh

RUN pip3 install --upgrade pip
RUN pip3 install torch==2.1.0+cu118 torchvision==0.16.0+cu118 --index-url https://download.pytorch.org/whl/cu118
RUN pip3 install --no-cache-dir -r requirements.txt

RUN pip install --upgrade --force-reinstall -r requirements.txt --target .\modules

EXPOSE 8188
ENTRYPOINT ["/start.sh"]