#!/bin/sh
# Builds and installs the 3D Blu-ray (MVC) player: 3dvision-mvcdec + 3dvision-bd.
set -e
cd "$(dirname "$0")"
./build.sh
mkdir -p "$HOME/.local/bin" "$HOME/.local/share/3dvision"
cp build/3dvision-mvcdec "$HOME/.local/bin/"
cp 3dvision-bd "$HOME/.local/bin/"
cp 3dvision-bd.lua "$HOME/.local/share/3dvision/"
chmod +x "$HOME/.local/bin/3dvision-mvcdec" "$HOME/.local/bin/3dvision-bd"
echo "Instalado: 3dvision-bd (Blu-ray 3D) y 3dvision-mvcdec en $HOME/.local/bin"
