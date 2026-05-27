#!/bin/bash

# Script V4 para ciclar entre modos de monitor:
# 1. Solo Interno (eDP-1) -> Siguiente: Solo Externo
# 2. Solo Externo (DP-1) -> Siguiente: Ambos
# 3. Ambos -> Siguiente: Solo Interno

INTERNAL="eDP-1"
INTERNAL_CONF="3000x2000@60, 1920x0, 2"
EXTERNAL="DP-1"
EXTERNAL_CONF="1920x1080@60, 0x0, 1"

# Detener el gestor automático
pkill -f manage_monitors.py

# Detectar cuáles están ACTIVOS actualmente (hyprctl monitors solo lista los encendidos)
IS_INTERNAL_ACTIVE=$(hyprctl monitors | grep "Monitor $INTERNAL")
IS_EXTERNAL_ACTIVE=$(hyprctl monitors | grep "Monitor $EXTERNAL")

if [ ! -z "$IS_INTERNAL_ACTIVE" ] && [ ! -z "$IS_EXTERNAL_ACTIVE" ]; then
    # AMBOS ACTIVOS -> Siguiente: Solo Interno
    echo "Modo actual: Ambos. Cambiando a Solo Interno."
    hyprctl keyword monitor "$INTERNAL, 3000x2000@60, 0x0, 2"
    hyprctl keyword monitor "$EXTERNAL, disable"
    notify-send "Monitor" "Modo: Solo Interno"
elif [ ! -z "$IS_INTERNAL_ACTIVE" ]; then
    # SOLO INTERNO -> Siguiente: Solo Externo
    echo "Modo actual: Solo Interno. Cambiando a Solo Externo."
    hyprctl keyword monitor "$EXTERNAL, 1920x1080@60, 0x0, 1"
    hyprctl keyword monitor "$INTERNAL, disable"
    notify-send "Monitor" "Modo: Solo Externo"
else
    # SOLO EXTERNO (o cualquier otro caso) -> Siguiente: Ambos
    echo "Modo actual: Solo Externo. Cambiando a Ambos."
    hyprctl keyword monitor "$INTERNAL, $INTERNAL_CONF"
    hyprctl keyword monitor "$EXTERNAL, $EXTERNAL_CONF"
    notify-send "Monitor" "Modo: Extendido (Ambos)"
fi
