# Guía de Configuración de Live Wallpapers en Hyprland

Este documento explica cómo configurar un sistema de fondos de pantalla que alterna entre imágenes estáticas y videos (Live Wallpapers) usando una tecla de acceso rápido.

## 1. Requisitos (Herramientas necesarias)

Para que este sistema funcione, necesitas tener instaladas las siguientes herramientas en tu sistema (ejemplo para Arch/CachyOS):

*   **awww**: Manejador de fondos de pantalla estáticos (y GIFs).
    ```bash
    sudo pacman -S awww
    ```
*   **mpvpaper**: Permite reproducir videos como fondo de pantalla usando `mpv`.
    ```bash
    paru -S mpvpaper
    ```
*   **jq**: Procesador de JSON para detectar el monitor activo automáticamente.
    ```bash
    sudo pacman -S jq
    ```

## 2. El Script de Rotación

El corazón del sistema es un script que detecta si el archivo es una imagen o un video y usa la herramienta correcta.

**Ubicación sugerida:** `~/.local/bin/rotate_wallpaper.sh`

```bash
#!/bin/bash

# 1. Configuración del Directorio
DIR="$HOME/Downloads"
CACHE="/tmp/wallpaper_index"

# 2. Obtener lista de archivos (Imágenes + Videos)
shopt -s nullglob
WALLPAPERS=("$DIR"/*.{jpg,jpeg,png,webp,mp4,mkv,webm,gif})
shopt -u nullglob

if [ ${#WALLPAPERS[@]} -eq 0 ]; then
    notify-send "Error" "No hay archivos en $DIR"
    exit 1
fi

# 3. Manejo del Índice
[ ! -f "$CACHE" ] && echo 0 > "$CACHE"
INDEX=$(cat "$CACHE")
[ "$INDEX" -ge "${#WALLPAPERS[@]}" ] && INDEX=0

NEXT_INDEX=$(( (INDEX + 1) % ${#WALLPAPERS[@]} ))
NEXT="${WALLPAPERS[$NEXT_INDEX]}"
echo "$NEXT_INDEX" > "$CACHE"

# 4. Detectar Monitor Activo
MONITOR=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')

# 5. Función de Limpieza
# Es vital cerrar mpvpaper antes de poner una imagen o cambiar de video
cleanup() {
    pkill -x mpvpaper
}

# 6. Aplicar Wallpaper según extensión
EXTENSION="${NEXT##*.}"

case "${EXTENSION,,}" in
    mp4|mkv|webm)
        cleanup
        mpvpaper -o "--loop-playlist" "$MONITOR" "$NEXT" &
        notify-send "Wallpaper" "Video: $(basename "$NEXT")"
        ;;
    *)
        cleanup
        awww img "$NEXT" --transition-type grow --transition-pos center
        notify-send "Wallpaper" "Imagen: $(basename "$NEXT")"
        ;;
esac
```

*No olvides darle permisos de ejecución:* `chmod +x ~/.local/bin/rotate_wallpaper.sh`

## 3. Configuración en Hyprland

Añade estas líneas a tu `~/.config/hypr/hyprland.conf`:

### Inicio automático
Asegúrate de que el demonio de `awww` inicie al arrancar:
```conf
exec-once = awww-daemon
```

### Atajo de teclado
Configura una tecla (en este caso `Super + N`) para rotar el fondo:
```conf
bind = $mainMod, N, exec, ~/.local/bin/rotate_wallpaper.sh
```

## Notas adicionales
- El script detecta en qué monitor tienes el foco y cambia el video solo en ese.
- Si usas múltiples monitores, `awww` suele cambiar en todos, mientras que `mpvpaper` está configurado en este script para el monitor actual.
