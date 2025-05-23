 ## Prerequisites For Docker
 1. NVIDIA drivers installed on your host system.
 2. Docker installed on your host system.
 3. NVIDIA Container Toolkit (nvidia-docker2) OR WSL2 installed so that you can use GPU inside
 Docker.

## Installed Nodes
* ComfyUI-Manager
* comfy-portal-endpoint
* ComfyUI-Lora-Manager
* comfyui_essentials
* comfyui_controlnet_aux

### Build Dockerfile
`docker build -t comfyui-gpu .`
`docker tag comfyui-gpu codingwithhassan/comfyui:latest`
`docker push codingwithhassan/comfyui:latest`

### Run Dockerfile
`docker run --gpus all -it -p 8188:8188 --name comfyui-instance comfyui-gpu`

### Run docker-compose
`docker compose up -d`
