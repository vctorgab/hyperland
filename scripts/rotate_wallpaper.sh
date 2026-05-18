#!/bin/bash

# Directorio de los wallpapers
DIR="/home/gabriel/Downloads"
WALLPAPERS=("$DIR/1.jpg" "$DIR/2.jpg" "$DIR/3.jpg")

# Usar un archivo temporal para guardar el índice actual
CACHE="/tmp/wallpaper_index"

if [ ! -f "$CACHE" ]; then
    echo 0 > "$CACHE"
fi

INDEX=$(cat "$CACHE")
NEXT_INDEX=$(( (INDEX + 1) % ${#WALLPAPERS[@]} ))
NEXT="${WALLPAPERS[$NEXT_INDEX]}"

# Aplicar con awww
awww img "$NEXT" --transition-type grow --transition-pos center

# Guardar nuevo índice
echo "$NEXT_INDEX" > "$CACHE"
