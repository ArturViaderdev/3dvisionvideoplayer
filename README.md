<a id="english"></a>

# 3dvision-play — 3D video player for NVIDIA 3D Vision glasses

**English** · [Español](#español)

Requires the 3D Vision driver for Linux: **[ArturViaderdev/Nvidia3dVisionLinux](https://github.com/ArturViaderdev/Nvidia3dVisionLinux)**.

Plays **side-by-side (SBS)** and **top-bottom** 3D movies on a 120 Hz monitor with 3D Vision shutter glasses: every refresh shows one eye, synchronised with the emitter.

- **Full SBS**: 3840x1080 (each eye 1920x1080 16:9), 5120x1440, 7680x2160 (each eye 4K)...
- **Half SBS**: 1920x1080 with each eye squeezed to 960x1080.
- **Top-bottom** (full 1920x2160 or half 1920x1080).
- Any resolution: scaled to the monitor (e.g. 2560x1440) keeping each eye's aspect ratio.

It uses **mpv** (NVDEC hardware decoding, every format, audio, seeking) and the [**3dvisionlinux**](https://github.com/ArturViaderdev/Nvidia3dVisionLinux) layer, which in this mode does not touch the geometry: it takes the left and right half of every frame and shows each to its eye.

## Installation

```sh
sudo apt install mpv ffmpeg
# in the 3dvisionlinux folder (https://github.com/ArturViaderdev/Nvidia3dVisionLinux) (the layer needs the version with the video mode):
./install.sh
# in this folder:
./install.sh
```

## Usage

```sh
3dvision-play movie.mkv                     # automatic format
3dvision-play --full movie.mkv              # force full SBS
3dvision-play --half movie.mkv              # force half SBS
3dvision-play --tab / --htab movie.mkv      # full / half top-bottom
3dvision-play --sub movie.en.srt movie.mkv  # external subtitles (.srt / .ass) in both eyes
3dvision-play --sub-track 0 movie.mkv       # embedded text subtitles (track 0, 1...)
3dvision-play --swap movie.mkv              # swap eyes
3dvision-play --start=00:30:00 --aid=2 movie.mkv   # any other option goes to mpv
```

Automatic format: first from the file name (`HSBS`, `H-SBS`, `Half-SBS`, `HOU`, `FSBS`...), otherwise from the frame size: 32:9 or wider → full SBS; nearly square or taller → full top-bottom; 16:9 → half SBS.

Before playing: monitor at 120 Hz (`tools/set-120hz.sh` from 3dvisionlinux) and desktop compositing off.

## Keys

mpv: **space** pause, **← →** ±5 s, **↑ ↓** ±1 min, **9 / 0** volume, **m** mute, **#** audio track, **q** quit. The OSD is hidden (it would be split between the two eyes).

Layer: **Ctrl+Shift+F7** swap eyes, **Ctrl+Shift+F8** 3D on/off, **Ctrl+Shift+End** shutter invert, **Ctrl+Shift+Insert/Delete** shutter delay (ghosting).

## Subtitles

mpv would draw subtitles over the double image (half the text in each eye), so its own subtitles are off. With `--sub` or `--sub-track` the player burns them into each eye (ffmpeg `subtitles` filter), on the screen plane. Text subtitles only (SRT/ASS); image subtitles (Blu-ray PGS) are not supported. With subtitles, hardware decoding switches to copy mode (a bit more CPU).

---

<a id="español"></a>

# 3dvision-play — reproductor de vídeo 3D para gafas NVIDIA 3D Vision

[English](#english) · **Español**

Necesita el driver 3D Vision para Linux: **[ArturViaderdev/Nvidia3dVisionLinux](https://github.com/ArturViaderdev/Nvidia3dVisionLinux)**.

Reproduce películas 3D **lado a lado (SBS)** y **arriba/abajo** en el monitor de 120 Hz con las gafas 3D Vision: cada refresco muestra un ojo, sincronizado con el emisor.

- **SBS completo**: 3840x1080 (cada ojo 1920x1080 16:9), 5120x1440, 7680x2160 (cada ojo 4K)...
- **Half SBS**: 1920x1080 con cada ojo comprimido a 960x1080.
- **Arriba/abajo** (completo 1920x2160 o half 1920x1080).
- Cualquier resolución: se escala al monitor (p. ej. 2560x1440) manteniendo la proporción de cada ojo.

Funciona con **mpv** (decodificación por hardware NVDEC, todos los formatos, audio, avance) y la capa [**3dvisionlinux**](https://github.com/ArturViaderdev/Nvidia3dVisionLinux), que en este modo no toca la geometría: coge la mitad izquierda y la derecha de cada imagen y las muestra a cada ojo.

## Instalación

```sh
sudo apt install mpv ffmpeg
# en la carpeta 3dvisionlinux (https://github.com/ArturViaderdev/Nvidia3dVisionLinux) (la capa necesita la versión con el modo de vídeo):
./install.sh
# en esta carpeta:
./install.sh
```

## Uso

```sh
3dvision-play pelicula.mkv                  # formato automático
3dvision-play --full pelicula.mkv           # forzar SBS completo
3dvision-play --half pelicula.mkv           # forzar half SBS
3dvision-play --tab / --htab pelicula.mkv   # arriba/abajo completo / half
3dvision-play --sub peli.es.srt peli.mkv    # subtítulos externos (.srt / .ass) en los dos ojos
3dvision-play --sub-track 0 peli.mkv        # subtítulos internos de texto (pista 0, 1...)
3dvision-play --swap peli.mkv               # invertir ojos
3dvision-play --start=00:30:00 --aid=2 peli.mkv   # cualquier otra opción va a mpv
```

Formato automático: primero por el nombre (`HSBS`, `H-SBS`, `Half-SBS`, `HOU`, `FSBS`...) y si no, por el tamaño: 32:9 o más ancho → SBS completo; casi cuadrado o más alto → arriba/abajo completo; 16:9 → half SBS.

Antes de reproducir: monitor a 120 Hz (`tools/set-120hz.sh` de 3dvisionlinux) y compositor desactivado.

## Teclas

Las de mpv: **espacio** pausa, **← →** ±5 s, **↑ ↓** ±1 min, **9 / 0** volumen, **m** silencio, **#** pista de audio, **q** salir. No se muestra el OSD (saldría partido entre los dos ojos).

Las de la capa: **Ctrl+Shift+F7** invertir ojos, **Ctrl+Shift+F8** 3D sí/no, **Ctrl+Shift+Fin** invertir obturador, **Ctrl+Shift+Insert/Supr** retardo del obturador (fantasma).

## Subtítulos

mpv dibujaría los subtítulos sobre la imagen doble (medio texto en cada ojo), así que los suyos están desactivados. Con `--sub` o `--sub-track` el reproductor los graba dentro de cada ojo (filtro `subtitles` de ffmpeg), en el plano de la pantalla. Solo subtítulos de texto (SRT/ASS); los de imagen (PGS de Blu-ray) no. Con subtítulos la decodificación por hardware pasa a modo copia (algo más de CPU).
