#!/bin/bash

# Directorio de los wallpapers
DIR="/home/gabriel/Downloads"

# Obtener lista de wallpapers dinámicamente (jpg, png, webp, jpeg)
shopt -s nullglob
WALLPAPERS=("$DIR"/*.{jpg,jpeg,png,webp})
shopt -u nullglob

# Verificar si se encontraron imágenes
if [ ${#WALLPAPERS[@]} -eq 0 ]; then
    notify-send "Wallpaper Error" "No se encontraron imágenes en $DIR"
    exit 1
fi

# Usar un archivo temporal para guardar el índice actual
CACHE="/tmp/wallpaper_index"

if [ ! -f "$CACHE" ]; then
    echo 0 > "$CACHE"
fi

INDEX=$(cat "$CACHE")

# Validar que el índice no sea mayor que el número de archivos (por si se borraron archivos)
if [ "$INDEX" -ge "${#WALLPAPERS[@]}" ]; then
    INDEX=0
fi

NEXT_INDEX=$(( (INDEX + 1) % ${#WALLPAPERS[@]} ))
NEXT="${WALLPAPERS[$NEXT_INDEX]}"

# Aplicar con awww
awww img "$NEXT" --transition-type grow --transition-pos center

# Guardar nuevo índice
echo "$NEXT_INDEX" > "$CACHE"
