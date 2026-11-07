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
3dvision-play "https://www.youtube.com/watch?v=..."   # online videos (needs a recent yt-dlp)
3dvision-play --start=00:30:00 --aid=2 movie.mkv   # any other option goes to mpv
```

Automatic format: first from the file name (`HSBS`, `H-SBS`, `Half-SBS`, `HOU`, `FSBS`...), otherwise from the frame size: 32:9 or wider → full SBS; nearly square or taller → full top-bottom; 16:9 → half SBS.

Before playing: monitor at 120 Hz (`tools/set-120hz.sh` from 3dvisionlinux) and desktop compositing off.

Online videos (YouTube and every site yt-dlp supports), also from a browser button: see **online3dvideoplayer**.

## 3D Blu-ray (MVC) without re-encoding

Plays decrypted 3D Blu-ray folders and ISOs directly, in full-resolution 3D and with the disc's original
audio: no need to convert them to SBS first.

    3dvision-play /path/MOVIE              # the decrypted disc folder (with BDMV)
    3dvision-play /path/DISC.iso           # or the ISO (mounted read-only by itself, needs udisks2)
    3dvision-play --start=1:02:30 /path/MOVIE
    3dvision-play --alang=eng /path/MOVIE  # audio language (default: your system language)
    3dvision-bd --list /path/MOVIE         # what it finds: title, clips, length, audio languages

- Both eyes of the H.264 MVC video are decoded at their full 1920x1080 by our own decoder (based on
  SyLC 3D Player's MVC edge264, GPLv3, ported to Linux).
- Finds the main 3D title by itself (skips anti-rip decoy playlists), handles movies split into several
  clips and discs whose base view is the right eye.
- Original audio (DTS-HD MA, TrueHD, Dolby Digital...), in sync; it starts in your system language and
  `#` switches track.
- Fast seeking with the disc's own index: left/right ±10 s, Shift ±5 s, up/down ±1 min, PgUp/PgDn ±10 min.
- No disc menus, extras or PGS subtitles.

Full details: [bluray/README.md](bluray/README.md). `install.sh` builds it (needs `g++`).

## Online videos: recent yt-dlp

`3dvision-play` plays web videos (YouTube and every site supported by **yt-dlp**) through mpv, which uses yt-dlp to get the video. YouTube changes its site often and old yt-dlp versions stop working (errors like *"Requested format is not available"*, *"Sign in to confirm"* or the video simply not starting). The version in Debian/Ubuntu packages is usually too old, so install the latest one in `~/.local/bin` (it takes priority over the system one):

```sh
mkdir -p ~/.local/bin
curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o ~/.local/bin/yt-dlp
chmod +x ~/.local/bin/yt-dlp
yt-dlp --version        # check it is the new one (if not, ~/.local/bin is not in your PATH)
```

Update it from time to time, or whenever YouTube stops working: `yt-dlp -U`.

Quality: up to 4K by default. To change it: `NV3D_YTDL_FORMAT="bestvideo[height<=1080]+bestaudio" 3dvision-play URL`.

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
3dvision-play "https://www.youtube.com/watch?v=..."   # vídeos online (necesita un yt-dlp reciente)
3dvision-play --start=00:30:00 --aid=2 peli.mkv   # cualquier otra opción va a mpv
```

Formato automático: primero por el nombre (`HSBS`, `H-SBS`, `Half-SBS`, `HOU`, `FSBS`...) y si no, por el tamaño: 32:9 o más ancho → SBS completo; casi cuadrado o más alto → arriba/abajo completo; 16:9 → half SBS.

Antes de reproducir: monitor a 120 Hz (`tools/set-120hz.sh` de 3dvisionlinux) y compositor desactivado.

Vídeos online (YouTube y todas las webs que admita yt-dlp), también con un botón en el navegador: ver **online3dvideoplayer**.

## Blu-ray 3D (MVC) sin recodificar

Reproduce directamente carpetas e ISOs de Blu-ray 3D desencriptados, en 3D a resolución completa y con el
audio original del disco: ya no hace falta convertirlos antes a SBS.

    3dvision-play /ruta/PELICULA              # la carpeta del disco desencriptado (con BDMV)
    3dvision-play /ruta/DISCO.iso             # o la ISO (se monta sola en solo lectura, necesita udisks2)
    3dvision-play --start=1:02:30 /ruta/PELICULA
    3dvision-play --alang=eng /ruta/PELICULA  # idioma del audio (por defecto el de tu sistema)
    3dvision-bd --list /ruta/PELICULA         # qué encuentra: título, clips, duración, idiomas de audio

- Los dos ojos del vídeo H.264 MVC se decodifican a 1920x1080 completos con nuestro propio decodificador
  (basado en el edge264 MVC de SyLC 3D Player, GPLv3, portado a Linux).
- Encuentra solo el título 3D principal (descarta las playlists señuelo anticopia), admite películas
  partidas en varios clips y discos cuya vista base es el ojo derecho.
- Audio original (DTS-HD MA, TrueHD, Dolby Digital...), sincronizado; empieza en el idioma de tu sistema
  y `#` cambia de pista.
- Saltos rápidos con el propio índice del disco: izq/der ±10 s, Mayús ±5 s, arriba/abajo ±1 min,
  RePág/AvPág ±10 min.
- Sin menús del disco, extras ni subtítulos PGS.

Todos los detalles: [bluray/README.md](bluray/README.md). `install.sh` lo compila (necesita `g++`).

## Vídeos online: yt-dlp reciente

`3dvision-play` reproduce vídeos de internet (YouTube y todas las webs que admita **yt-dlp**) a través de mpv, que usa yt-dlp para obtener el vídeo. YouTube cambia su web a menudo y las versiones viejas de yt-dlp dejan de funcionar (errores como *"Requested format is not available"*, *"Sign in to confirm"* o simplemente el vídeo no arranca). La versión de los paquetes de Debian/Ubuntu suele estar demasiado vieja, así que instala la última en `~/.local/bin` (tiene prioridad sobre la del sistema):

```sh
mkdir -p ~/.local/bin
curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o ~/.local/bin/yt-dlp
chmod +x ~/.local/bin/yt-dlp
yt-dlp --version        # comprueba que es la nueva (si no, ~/.local/bin no está en tu PATH)
```

Actualízalo de vez en cuando, o cuando YouTube deje de funcionar: `yt-dlp -U`.

Calidad: hasta 4K por defecto. Para cambiarla: `NV3D_YTDL_FORMAT="bestvideo[height<=1080]+bestaudio" 3dvision-play URL`.

## Teclas

Las de mpv: **espacio** pausa, **← →** ±5 s, **↑ ↓** ±1 min, **9 / 0** volumen, **m** silencio, **#** pista de audio, **q** salir. No se muestra el OSD (saldría partido entre los dos ojos).

Las de la capa: **Ctrl+Shift+F7** invertir ojos, **Ctrl+Shift+F8** 3D sí/no, **Ctrl+Shift+Fin** invertir obturador, **Ctrl+Shift+Insert/Supr** retardo del obturador (fantasma).

## Subtítulos

mpv dibujaría los subtítulos sobre la imagen doble (medio texto en cada ojo), así que los suyos están desactivados. Con `--sub` o `--sub-track` el reproductor los graba dentro de cada ojo (filtro `subtitles` de ffmpeg), en el plano de la pantalla. Solo subtítulos de texto (SRT/ASS); los de imagen (PGS de Blu-ray) no. Con subtítulos la decodificación por hardware pasa a modo copia (algo más de CPU).
