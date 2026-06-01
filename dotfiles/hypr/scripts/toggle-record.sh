#!/bin/bash
VIDEO_DIR="$HOME/Videos/Grabaciones"
FLAG="/tmp/hypr-recording.lock"
PID_FILE="/tmp/hypr-recording.pid"

mkdir -p "$VIDEO_DIR"

if [[ -f "$FLAG" ]]; then
    # Detener grabación
    if [[ -f "$PID_FILE" ]]; then
        kill "$(cat "$PID_FILE")" 2>/dev/null
    fi
    pkill wf-recorder 2>/dev/null
    pactl unload-module module-null-sink record 2>/dev/null
    rm -f "$FLAG" "$PID_FILE"
    notify-send -t 2000 "Grabación detenida" "Video guardado en $VIDEO_DIR"
    exit 0
fi

# Iniciar grabación
pactl load-module module-null-sink sink_name=record 2>/dev/null
pactl load-module module-loopback source=@DEFAULT_MONITOR@ sink=record latency_msec=1 2>/dev/null
pactl load-module module-loopback source=@DEFAULT_SOURCE@ sink=record latency_msec=1 2>/dev/null

GEOMETRY=""
MODE="pantalla completa"
if [[ "$1" == "-g" ]]; then
    GEOMETRY="-g $(slurp)"
    MODE="área seleccionada"
fi

touch "$FLAG"
notify-send -t 3000 "🔴 Grabando $MODE" "Audio: sistema + micrófono"

wf-recorder $GEOMETRY -f "$VIDEO_DIR/$(date +'%Y%m%d_%H%M%S').mp4" -x yuv420p --audio=record.monitor &
PID=$!
echo "$PID" > "$PID_FILE"
wait "$PID"

# Limpieza al terminar
pactl unload-module module-null-sink record 2>/dev/null
rm -f "$FLAG" "$PID_FILE"
notify-send -t 2000 "Grabación finalizada"
