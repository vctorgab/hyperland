#!/bin/bash
# Obtener el estado de la ventana actual (0=tiled, 1=maximized, 2=fullscreen)
STATE=$(hyprctl activewindow -j | jq '.fullscreen')

# Cambiar a la siguiente ventana
hyprctl dispatch cyclenext

# Esperar un momento para que el foco se actualice
sleep 0.05

# Si la anterior estaba maximizada o en pantalla completa, maximizar la nueva
if [ "$STATE" -ne 0 ]; then
    NEW_STATE=$(hyprctl activewindow -j | jq '.fullscreen')
    if [ "$NEW_STATE" -eq 0 ]; then
        hyprctl dispatch fullscreen 1
    fi
fi
