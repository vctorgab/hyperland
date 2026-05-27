import subprocess
import time
import os
import logging

# Configuración de logs
LOG_FILE = "/home/gabriel/.config/hypr/scripts/monitor_manager.log"
logging.basicConfig(
    filename=LOG_FILE,
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    force=True
)

# Configuración de monitores
INTERNAL = "eDP-1"
INTERNAL_CONF = "3000x2000@60, 1920x0, 2"
EXTERNAL_CONF = "1920x1080@60, 0x0, 1"

def get_connected_monitors():
    monitors = []
    drm_path = "/sys/class/drm"
    try:
        for d in os.listdir(drm_path):
            if d.startswith("card") and "-" in d:
                parts = d.split("-", 1)
                if len(parts) > 1:
                    name = parts[1]
                    status_file = os.path.join(drm_path, d, "status")
                    if os.path.exists(status_file):
                        with open(status_file, "r") as f:
                            if f.read().strip() == "connected":
                                monitors.append(name)
    except Exception as e:
        logging.error(f"Error detectando monitores: {e}")
    return list(set(monitors))

def configure():
    connected = get_connected_monitors()
    external = [m for m in connected if m != INTERNAL]
    
    logging.info(f"EJECUTANDO CONFIGURACIÓN. Conectados: {connected}")

    if external:
        ext = external[0]
        logging.info(f"Monitor externo detectado: {ext}. Cambiando...")
        # Forzar el externo y desactivar el interno en la misma ráfaga
        subprocess.run(["hyprctl", "keyword", "monitor", f"{ext}, {EXTERNAL_CONF}"], capture_output=True)
        time.sleep(0.5)
        subprocess.run(["hyprctl", "keyword", "monitor", f"{INTERNAL}, disable"], capture_output=True)
    else:
        logging.info("Solo monitor interno detectado.")
        subprocess.run(["hyprctl", "keyword", "monitor", f"{INTERNAL}, {INTERNAL_CONF}"], capture_output=True)

if __name__ == "__main__":
    logging.info("--- Iniciando Monitor Manager V3 (Simple) ---")
    last_state = None
    
    while True:
        try:
            current_connected = get_connected_monitors()
            # El estado es simplemente si hay externos o no
            current_state = any(m != INTERNAL for m in current_connected)
            
            if current_state != last_state:
                logging.info(f"Cambio de estado: {last_state} -> {current_state}")
                configure()
                last_state = current_state
        except Exception as e:
            logging.error(f"Error: {e}")
        
        time.sleep(2)
