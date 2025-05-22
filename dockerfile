# Already installed nvidia cuda drivers to leverage GPU
FROM --platform=linux/amd64 nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04

# environment variables
ENV DEBIAN_FRONTEND=noninteractive \
                        TZ=Etc/UTC

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    python3 \
    python3-pip \
    python3-dev \
    wget \
    libgl1 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace/ComfyUI
COPY . .
RUN pip3 install --upgrade pip
RUN pip3 install --no-cache-dir -r requirements.txt

RUN huggingface-cli download fofr/comfyui checkpoints/anything-v3-fp16-pruned.safetensors --repo-type model --local-dir /workspace/ComfyUI/models/checkpoints/ --local-dir-use-symlinks False

RUN git clone https://github.com/ltdrdata/ComfyUI-Manager.git /workspace/ComfyUI/custom_nodes/ComfyUI-Manager
RUN git clone https://github.com/willmiao/ComfyUI-Lora-Manager.git /workspace/ComfyUI/custom_nodes/ComfyUI-Lora-Manager

EXPOSE 8188
ENTRYPOINT ["python3", "main.py", "--dont-print-server"]
CMD ["--listen", "0.0.0.0", "--port", "8188"]