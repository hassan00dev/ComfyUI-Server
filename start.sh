#!/bin/bash

echo "Starting setup..."

MODEL_DIR="/workspace/ComfyUI/models/checkpoints"
VAE_DIR="/workspace/ComfyUI/models/vae"
LORA_DIR="/workspace/ComfyUI/models/loras"

mkdir -p "$MODEL_DIR" "$VAE_DIR" "$LORA_DIR"

# Function to download from Hugging Face
download_hf() {
    echo "Downloading from Hugging Face: $1"
    HUGGINGFACE_HUB_TOKEN="$HUGGINGFACE_TOKEN" huggingface-cli download "$1" \
        --repo-type model \
        --local-dir "$2" \
        --local-dir-use-symlinks False || echo "⚠️ Failed to download $1"
}

# Function to download from Civitai
download_civitai() {
    echo "Downloading from Civitai: $2"
    curl -L -H "Authorization: Bearer $CIVITAI_API_TOKEN" \
         -o "$1/$2" \
         "$3" || echo "⚠️ Failed to download $2"
}

# ==== NODE PACKS ====
git clone https://github.com/ltdrdata/ComfyUI-Manager.git /workspace/ComfyUI/custom_nodes/ComfyUI-Manager
pip3 install --no-cache-dir -r /workspace/ComfyUI/custom_nodes/ComfyUI-Manager/requirements.txt

git clone https://github.com/ShunL12324/comfy-portal-endpoint.git /workspace/ComfyUI/custom_nodes/comfy-portal-endpoint

git clone https://github.com/willmiao/ComfyUI-Lora-Manager.git /workspace/ComfyUI/custom_nodes/ComfyUI-Lora-Manager
pip3 install --no-cache-dir -r /workspace/ComfyUI/custom_nodes/ComfyUI-Lora-Manager/requirements.txt

git clone https://github.com/cubiq/ComfyUI_essentials.git /workspace/ComfyUI/custom_nodes/ComfyUI_essentials
pip3 install --no-cache-dir -r /workspace/ComfyUI/custom_nodes/ComfyUI_essentials/requirements.txt

git clone https://github.com/Fannovel16/comfyui_controlnet_aux.git /workspace/ComfyUI/custom_nodes/comfyui_controlnet_aux
pip3 install --no-cache-dir -r /workspace/ComfyUI/custom_nodes/comfyui_controlnet_aux/requirements.txt

# === Download Hugging Face models ===
download_hf SG161222/Realistic_Vision_V5.1_noVAE "$MODEL_DIR"
download_hf runwayml/stable-diffusion-v1-5 "$MODEL_DIR"
download_hf stabilityai/sd-vae-ft-mse "$VAE_DIR"

# === Download Civitai models ===
download_civitai "$MODEL_DIR" "DreamShaper_8.safetensors" "https://civitai.com/api/download/models/128713?type=Model&format=SafeTensor&size=full&fp=fp16"
download_civitai "$VAE_DIR" "vae-ft-mse.safetensors" "https://civitai.com/api/download/models/94492?type=VAE&format=SafeTensor"
download_civitai "$LORA_DIR" "AnimeLora_v2.safetensors" "https://civitai.com/api/download/models/122658?type=LoRA"

echo "✅ All downloads complete."

# === Launch ComfyUI in background ===
echo "🖼️ Launching ComfyUI on port 8188..."
cd /workspace/ComfyUI
python3 main.py --dont-print-server --listen 0.0.0.0 --port 8188 &

# === Launch Jupyter Notebook ===
echo "📓 Launching Jupyter Notebook on port 8888..."
jupyter notebook --ip=0.0.0.0 --port=8888 --no-browser --NotebookApp.token='' --NotebookApp.password='' --allow-root