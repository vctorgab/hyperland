#!/bin/bash

# Script de pánico para activar todos los monitores en Hyprland

echo "Deteniendo el script de gestión de monitores..."
pkill -f manage_monitors.py

echo "Activando todos los monitores..."

# 1. Activar el monitor externo (DP-1) a la izquierda
hyprctl keyword monitor "DP-1, 1920x1080@60, 0x0, 1"

# 2. Activar el monitor interno (eDP-1) a la derecha
hyprctl keyword monitor "eDP-1, 3000x2000@60, 1920x0, 2"

# Intentar activar cualquier otro monitor detectado que no sea eDP-1 o DP-1
monitors=$(hyprctl monitors all | grep "Monitor" | awk '{print $2}')
for m in $monitors; do
    if [ "$m" != "eDP-1" ] && [ "$m" != "DP-1" ]; then
        hyprctl keyword monitor "$m, preferred, auto, 1"
    fi
done

# 3. Notificación opcional (si tienes dunst o mako)
notify-send "Panic Button" "Todos los monitores han sido activados" || echo "Monitores activados"
