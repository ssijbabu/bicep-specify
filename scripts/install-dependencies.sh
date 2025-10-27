#!/bin/bash

# Check if uv is installed
if ! command -v uv &> /dev/null; then
    echo "uv is not installed. Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
else
    echo "uv is already installed"
fi

# Check if specify-cli is installed
if ! command -v specify &> /dev/null; then
    echo "specify-cli is not installed. Installing specify-cli..."
    uv tool install specify-cli --from git+https://github.com/github/spec-kit.git
else
    echo "specify-cli is already installed"
fi