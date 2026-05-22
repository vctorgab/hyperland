#!/bin/bash

# Directorio de los wallpapers
DIR="/home/gabriel/Downloads"

# Obtener lista de wallpapers dinámicamente (jpg, png, webp, jpeg, mp4, mkv, gif)
shopt -s nullglob
# Agregamos extensiones de video comunes
WALLPAPERS=("$DIR"/*.{jpg,jpeg,png,webp,mp4,mkv,webm,gif})
shopt -u nullglob

# Verificar si se encontraron archivos
if [ ${#WALLPAPERS[@]} -eq 0 ]; then
    notify-send "Wallpaper Error" "No se encontraron wallpapers en $DIR"
    exit 1
fi

# Usar un archivo temporal para guardar el índice actual
CACHE="/tmp/wallpaper_index"

if [ ! -f "$CACHE" ]; then
    echo 0 > "$CACHE"
fi

INDEX=$(cat "$CACHE")

# Validar que el índice no sea mayor que el número de archivos
if [ "$INDEX" -ge "${#WALLPAPERS[@]}" ]; then
    INDEX=0
fi

NEXT_INDEX=$(( (INDEX + 1) % ${#WALLPAPERS[@]} ))
NEXT="${WALLPAPERS[$NEXT_INDEX]}"

# Obtener el monitor activo
MONITOR=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')

# Guardar nuevo índice
echo "$NEXT_INDEX" > "$CACHE"

# Función para detener mpvpaper si está corriendo
cleanup_video() {
    if pgrep -x mpvpaper > /dev/null; then
        pkill -x mpvpaper
    fi
}

# Comprobar la extensión del archivo para decidir qué herramienta usar
EXTENSION="${NEXT##*.}"

case "${EXTENSION,,}" in # Convertir a minúsculas para comparar
    mp4|mkv|webm)
        cleanup_video
        # Ejecutar mpvpaper en el monitor detectado con optimizaciones:
        # --hwdec=auto: Usa aceleración por hardware (GPU) en lugar de CPU
        mpvpaper -o "--hwdec=auto --loop-playlist" "$MONITOR" "$NEXT" &
        notify-send "Wallpaper" "Cambiado a video: $(basename "$NEXT")"
        ;;
    *)
        cleanup_video
        # Aplicar con awww (soporta imágenes y GIFs animados)
        awww img "$NEXT" --transition-type grow --transition-pos center
        notify-send "Wallpaper" "Cambiado a imagen: $(basename "$NEXT")"
        ;;
esac
