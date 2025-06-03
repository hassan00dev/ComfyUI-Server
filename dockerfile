FROM --platform=linux/amd64 nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive \
                        TZ=Etc/UTC

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

COPY requirements.txt .

RUN pip3 install --upgrade pip \
 && pip3 install --no-cache-dir -r requirements.txt

COPY . .
COPY --chmod=755 start.sh /start.sh

EXPOSE 8188
EXPOSE 8888

CMD ["/start.sh"]