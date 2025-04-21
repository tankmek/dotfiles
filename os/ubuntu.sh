#!/usr/bin/env bash

set -eou pipefail

 "[*] Updating system and installing packages..."

sudo apt update
sudo apt install -y \
    git \
    curl \
    vim \
    python3-pip \
    build-essential \
    fonts-firacode \
    bat \
    unzip \
    ripgrep \
    fd-find \
    pipx \
    wget \
    software-properties-common

echo "[*] Ubuntu dependencies installed!"
