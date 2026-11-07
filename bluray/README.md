# 3dvision-bd: 3D Blu-ray player (MVC)

Plays a decrypted 3D Blu-ray **folder** (the one that contains `BDMV`) or **ISO** in real 3D with
NVIDIA 3D Vision glasses, **without re-encoding**: both eyes of the H.264 MVC video are decoded at
their full 1920x1080 and shown through the 3dvisionlinux layer, with the disc's own audio
(DTS-HD MA, TrueHD, Dolby Digital, LPCM...) in the language you choose.

No more converting every disc to SBS with two-pass encoding: point the player at the folder or the
ISO and watch it with the original quality.

## Requirements

- The **3dvisionlinux** layer installed (version with the video mode), monitor at 120 Hz and desktop
  compositing off, as for any other video.
- `mpv`, `ffmpeg`/`ffprobe`, `python3` and `g++` to build the decoder.
- `udisks2` (`udisksctl`) to open ISOs: they are mounted read-only by themselves and unmounted on exit.
  Without it, mount the ISO yourself and pass the folder.
- The disc must be **decrypted** (MakeMKV backup, AnyDVD, etc.). Encrypted discs are not supported.

Installation: `./install.sh` in the `3dvisionvideoplayer` folder builds and installs everything
(`3dvision-bd` and `3dvision-mvcdec` in `~/.local/bin`).

## Usage

    3dvision-bd /path/MOVIE                  the decrypted disc folder (with BDMV inside)
    3dvision-bd /path/DISC.iso               or the ISO
    3dvision-play /path/MOVIE                same thing through the general player
    3dvision-bd --start 1:02:30 /path/MOVIE  start at that point
    3dvision-bd --alang=eng /path/MOVIE      audio language (see below)
    3dvision-bd --swap /path/MOVIE           swap eyes
    3dvision-bd --list /path/MOVIE           only show what it finds: playlist, clips, length, audio tracks

Any other `--option` goes to mpv (for example `--volume=80`).

Keys: left/right -/+10 s, Shift+left/right -/+5 s, up/down +/-1 min, PgUp/PgDn +/-10 min,
space pause, `#` next audio track, `f` fullscreen, q quit.

## Audio language

The player reads the language list of the disc's playlist and starts with the track in **your system
language** (`LANG`, e.g. `es_ES` → Spanish). When the movie starts, the terminal lists the tracks:

    3dvision-bd: pistas de audio (tecla # para cambiar):
    3dvision-bd:   1: eng  DTS-HD Master Audio
    3dvision-bd:   2: rus  Dolby Digital
    3dvision-bd:   3: spa  Dolby Digital
    3dvision-bd: audio: pista 3 (spa Dolby Digital)

- `#` during playback switches to the next track.
- `--alang=eng` picks a language at launch; `--alang=spa,eng` gives an order of preference.
  ISO 639-2 codes, as the disc lists them: `spa`, `eng`, `fra`, `deu`, `ita`, `jpn`...
- `--aid=2` picks a track by its number.
- `--list` shows the languages of a disc without playing it.

## What it supports

- Discs with `STREAM/SSIF/*.ssif` (full disc backups and ISOs) and MakeMKV-style backups that only keep
  the base and dependent `.m2ts` of each clip.
- Movies split into several clips (seamless playlists), played one after another.
- Discs whose base view is the right eye (the playlist's `MVC_Base_view_R_flag`): the eyes are swapped
  automatically.
- Discs with decoy playlists (anti-rip): they are recognised and skipped.

Not supported: disc menus, extras (only the main movie plays) and Blu-ray image subtitles (PGS).

## How it works

1. `3dvision-bd` reads the playlists (`BDMV/PLAYLIST/*.mpls`), picks the main 3D title (longest real
   playlist) and gets its clips, eye order and audio tracks.
2. `3dvision-mvcdec` demultiplexes the base view (PID 0x1011) and the dependent view (PID 0x1012),
   decodes both with the MVC edge264 decoder, pairs each left frame with its right frame by display
   order and writes a 3840x1080 side-by-side stream into a pipe.
3. mpv shows that stream through the 3dvisionlinux layer (`NV3D_INPUT=sbs`) and plays the audio
   straight from the disc's `.m2ts` files, placed by the absolute timestamps of the first frame, so
   it stays in sync even on discs with odd timestamps.
4. Seeking restarts the decoder at the new point: the clip index files (`CLIPINF/*.clpi`, EP_map) say
   exactly which byte of the file holds the nearest keyframe, so the jump is immediate even in the
   middle of a 40 GB file.

Logs, in case something goes wrong: `~/.cache/3dvision/3dvision-bd-mpv.log` (player) and
`~/.cache/3dvision/3dvision-bd-dec.log` (decoder).

## Credits / license

The MVC decoder (an extended edge264, BSD-3, by Thibault Raffaillac) and the Blu-ray 3D demuxers come
from **SyLC 3D Player** by 5ymph0en1x (https://github.com/5ymph0en1x/SyLC, GPLv3), ported here from
Windows to Linux. This folder is therefore GPLv3 (see LICENSE).

---

# 3dvision-bd: reproductor de Blu-ray 3D (MVC)

Reproduce una **carpeta** de Blu-ray 3D desencriptado (la que contiene `BDMV`) o una **ISO** en 3D real
con las gafas NVIDIA 3D Vision, **sin recodificar**: se decodifican los dos ojos del vídeo H.264 MVC a
1920x1080 completos y se muestran con la capa 3dvisionlinux, con el audio original del disco
(DTS-HD MA, TrueHD, Dolby Digital, LPCM...) en el idioma que elijas.

Ya no hace falta convertir cada disco a SBS a doble pasada: le das la carpeta o la ISO y lo ves con la
calidad original.

## Requisitos

- La capa **3dvisionlinux** instalada (versión con el modo de vídeo), monitor a 120 Hz y la composición
  del escritorio desactivada, como para cualquier otro vídeo.
- `mpv`, `ffmpeg`/`ffprobe`, `python3` y `g++` para compilar el decodificador.
- `udisks2` (`udisksctl`) para abrir ISOs: se montan solas en solo lectura y se desmontan al salir.
  Sin él, monta tú la ISO y pasa la carpeta.
- El disco tiene que estar **desencriptado** (copia de MakeMKV, AnyDVD, etc.). Los discos cifrados no
  funcionan.

Instalación: `./install.sh` en la carpeta `3dvisionvideoplayer` lo compila e instala todo
(`3dvision-bd` y `3dvision-mvcdec` en `~/.local/bin`).

## Uso

    3dvision-bd /ruta/PELICULA                  la carpeta del disco desencriptado (con BDMV dentro)
    3dvision-bd /ruta/DISCO.iso                 o la ISO
    3dvision-play /ruta/PELICULA                lo mismo desde el reproductor general
    3dvision-bd --start 1:02:30 /ruta/PELICULA  empezar en ese punto
    3dvision-bd --alang=eng /ruta/PELICULA      idioma del audio (ver abajo)
    3dvision-bd --swap /ruta/PELICULA           invertir ojos
    3dvision-bd --list /ruta/PELICULA           solo muestra qué encuentra: playlist, clips, duración, pistas de audio

Cualquier otra opción `--xxx` se pasa a mpv (por ejemplo `--volume=80`).

Teclas: izq/der -/+10 s, Mayús+izq/der -/+5 s, arriba/abajo +/-1 min, RePág/AvPág +/-10 min,
espacio pausa, `#` siguiente pista de audio, `f` pantalla completa, q salir.

## Idioma del audio

El reproductor lee la lista de idiomas de la playlist del disco y empieza con la pista en **el idioma de
tu sistema** (`LANG`, p. ej. `es_ES` → castellano). Al arrancar, el terminal muestra las pistas:

    3dvision-bd: pistas de audio (tecla # para cambiar):
    3dvision-bd:   1: eng  DTS-HD Master Audio
    3dvision-bd:   2: rus  Dolby Digital
    3dvision-bd:   3: spa  Dolby Digital
    3dvision-bd: audio: pista 3 (spa Dolby Digital)

- `#` durante la reproducción pasa a la siguiente pista.
- `--alang=eng` elige el idioma al arrancar; `--alang=spa,eng` da un orden de preferencia.
  Códigos ISO 639-2, como los lista el disco: `spa`, `eng`, `fra`, `deu`, `ita`, `jpn`...
- `--aid=2` elige una pista por su número.
- `--list` muestra los idiomas de un disco sin reproducirlo.

## Qué admite

- Discos con `STREAM/SSIF/*.ssif` (copias completas e ISOs) y copias tipo MakeMKV que solo guardan los
  `.m2ts` base y dependiente de cada clip.
- Películas partidas en varios clips (playlists encadenadas), que se reproducen seguidas.
- Discos cuya vista base es el ojo derecho (`MVC_Base_view_R_flag` de la playlist): los ojos se
  invierten solos.
- Discos con playlists señuelo (anticopia): se reconocen y se descartan.

No admite: menús del disco, extras (solo se reproduce la película principal) ni los subtítulos de
imagen del Blu-ray (PGS).

## Cómo funciona

1. `3dvision-bd` lee las playlists (`BDMV/PLAYLIST/*.mpls`), elige el título 3D principal (la playlist
   real más larga) y saca sus clips, el orden de los ojos y las pistas de audio.
2. `3dvision-mvcdec` separa la vista base (PID 0x1011) y la dependiente (PID 0x1012), decodifica las dos
   con el decodificador MVC edge264, empareja cada fotograma izquierdo con su derecho por orden de
   presentación y escribe un vídeo lado a lado de 3840x1080 por una tubería.
3. mpv muestra ese vídeo con la capa 3dvisionlinux (`NV3D_INPUT=sbs`) y reproduce el audio directamente
   de los `.m2ts` del disco, colocado por las marcas de tiempo absolutas del primer fotograma, así que
   va sincronizado incluso en discos con marcas de tiempo raras.
4. Al saltar, el decodificador se reinicia en el punto nuevo: los ficheros índice de los clips
   (`CLIPINF/*.clpi`, EP_map) dicen exactamente en qué byte está el fotograma clave más cercano, así que
   el salto es inmediato aunque sea en mitad de un fichero de 40 GB.

Registros, por si algo falla: `~/.cache/3dvision/3dvision-bd-mpv.log` (reproductor) y
`~/.cache/3dvision/3dvision-bd-dec.log` (decodificador).

## Créditos / licencia

El decodificador MVC (edge264 ampliado, BSD-3, de Thibault Raffaillac) y los demultiplexores de Blu-ray
3D vienen de **SyLC 3D Player** de 5ymph0en1x (https://github.com/5ymph0en1x/SyLC, GPLv3), portados
aquí de Windows a Linux. Por eso esta carpeta es GPLv3 (ver LICENSE).
