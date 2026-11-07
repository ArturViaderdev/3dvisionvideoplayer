#!/bin/sh
# Instala 3dvision-play en ~/.local/bin. Necesita la capa 3dvisionlinux instalada y mpv.
set -e
cd "$(dirname "$0")"
mkdir -p "$HOME/.local/bin"
cp 3dvision-play "$HOME/.local/bin/3dvision-play"
chmod +x "$HOME/.local/bin/3dvision-play"
echo "Instalado: $HOME/.local/bin/3dvision-play"
# reproductor de Blu-ray 3D (MVC): se compila aqui (necesita g++)
if command -v g++ >/dev/null 2>&1; then
  ./bluray/install.sh
else
  echo "Falta g++ para el reproductor de Blu-ray 3D:  sudo apt install g++"
fi
command -v mpv >/dev/null || echo "Falta mpv:     sudo apt install mpv"
command -v ffprobe >/dev/null || echo "Falta ffmpeg:  sudo apt install ffmpeg  (para detectar el formato y los subtitulos)"
D="${XDG_DATA_HOME:-$HOME/.local/share}/vulkan/implicit_layer.d/3dvision.json"
[ -f "$D" ] || echo "Falta la capa 3D Vision: ejecuta ./install.sh en la carpeta 3dvisionlinux"
