#!/usr/bin/env bash
# Uso: WASI_SDK=/ruta/wasi-sdk ./build_doom.sh [ruta/a/doomgeneric/doomgeneric]
set -euo pipefail
: "${WASI_SDK:?Define WASI_SDK con la ruta de wasi-sdk}"
DG="${1:-doomgeneric/doomgeneric}"   # git clone https://github.com/ozkl/doomgeneric

cp doomgeneric_roblox.c "$DG/"
sed -i 's/^#define DOOMGENERIC_RESX.*/#define DOOMGENERIC_RESX 320/; s/^#define DOOMGENERIC_RESY.*/#define DOOMGENERIC_RESY 200/' "$DG/doomgeneric.h"

# Todos los .c salvo las plataformas y el sonido SDL/Allegro. Compara con OBJS del Makefile del repo.
SRCS=$(ls "$DG"/*.c | grep -Ev 'doomgeneric_(xlib|sdl|linuxvt|win|allegro|emscripten|soso|sosox)|i_sdl|i_allegro')

"$WASI_SDK/bin/clang" --target=wasm32-wasi --sysroot="$WASI_SDK/share/wasi-sysroot" \
  -mcpu=mvp -mexec-model=reactor -Os -w -std=gnu99 -fcommon \
  -I"$DG" $SRCS \
  -Wl,-z,stack-size=1048576 -Wl,--initial-memory=33554432 -Wl,--max-memory=67108864 \
  -o doom.wasm

ls -l doom.wasm
echo "Ahora traduce: usa el binario Luau de Wasynth sobre doom.wasm y guarda la salida en src/client/DoomWasm.lua"
