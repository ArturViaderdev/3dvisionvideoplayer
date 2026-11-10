#!/bin/sh
# Instala el reproductor en ~/.local/bin: 3dvision-play (linea de comandos), 3dvision-gui (ventana para
# elegir el video, enlaces web y DeoVR), 3dvision-web (videos online y DeoVR) y una entrada en el menu.
# Necesita la capa 3dvisionlinux instalada y mpv.
set -e
cd "$(dirname "$0")"
BIN="$HOME/.local/bin"
SHARE="${XDG_DATA_HOME:-$HOME/.local/share}"
mkdir -p "$BIN" "$SHARE/applications"
cp 3dvision-play 3dvision-gui 3dvision-web "$BIN/"
chmod +x "$BIN/3dvision-play" "$BIN/3dvision-gui" "$BIN/3dvision-web"
echo "Instalado: $BIN/3dvision-play, 3dvision-gui, 3dvision-web"
cat > "$SHARE/applications/3dvisionvideoplayer.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=3D Vision Video Player
GenericName=3D video player for NVIDIA 3D Vision
Comment=Plays SBS, top/bottom, 3D Blu-ray, YouTube 3D and DeoVR with 3D Vision glasses
Exec=$BIN/3dvision-gui %f
Icon=video-display
Terminal=false
Categories=AudioVideo;Video;Player;
MimeType=video/x-matroska;video/mp4;video/quicktime;video/x-msvideo;video/mp2t;video/webm;application/x-iso9660-image;inode/directory;
EOF
command -v update-desktop-database >/dev/null 2>&1 && update-desktop-database "$SHARE/applications" 2>/dev/null || true
echo "Menu: 3D Vision Video Player"
# reproductor de Blu-ray 3D (MVC): se compila aqui (necesita g++)
if command -v g++ >/dev/null 2>&1; then
  ./bluray/install.sh
else
  echo "Falta g++ para el reproductor de Blu-ray 3D:  sudo apt install g++"
fi
command -v mpv >/dev/null || echo "Falta mpv:     sudo apt install mpv"
command -v ffprobe >/dev/null || echo "Falta ffmpeg:  sudo apt install ffmpeg  (para detectar el formato y los subtitulos)"
python3 -c "import tkinter" 2>/dev/null || echo "Falta python3-tk para la ventana:  sudo apt install python3-tk"
python3 -c "import keyring" 2>/dev/null || command -v secret-tool >/dev/null 2>&1 || echo "Opcional, para recordar la contrasena de DeoVR:  sudo apt install python3-keyring"
D="${XDG_DATA_HOME:-$HOME/.local/share}/vulkan/implicit_layer.d/3dvision.json"
[ -f "$D" ] || echo "Falta la capa 3D Vision: ejecuta ./install.sh en la carpeta 3dvisionlinux"
case ":$PATH:" in *":$BIN:"*) ;; *) echo "AVISO: $BIN no esta en el PATH (cierra sesion y vuelve a entrar)";; esac
