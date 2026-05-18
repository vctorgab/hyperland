# 🚀 Hyprland + CachyOS Config (vctorgab)

Este repositorio contiene la configuración personalizada para un entorno Hyprland optimizado en CachyOS (basado en Arch Linux), diseñado para ser moderno, funcional y con una estética inspirada en Pixel UI.

## 🛠️ Componentes Principales
- **Compositor:** Hyprland (v0.55.2+)
- **Login:** SDDM con el tema **Pixie** (Material Design 3)
- **Bloqueo:** `hyprlock` con desenfoque dinámico.
- **Menú de Apagado:** `wlogout` personalizado y transparente.
- **Gestos:** Gestos nativos de 3 y 4 dedos (Firefox + Escritorios).
- **Shell:** Fish con soporte para `opencode`.

---

## 📦 1. Requisitos e Instalación

Primero, instala todos los paquetes necesarios. CachyOS ya incluye la mayoría, pero asegúrate de tener estos:

### Paquetes del Repositorio (Pacman)
```bash
sudo pacman -S --noconfirm hyprlock wlogout wtype xdotool
```

### Paquetes del AUR (Paru/Yay)
```bash
paru -S --noconfirm pixie-sddm-git
```

---

## 📂 2. Estructura de Archivos

Para replicar esta configuración, copia los archivos a las siguientes rutas:

| Archivo en el Repo | Destino en el Sistema |
| :--- | :--- |
| `dotfiles/hypr/hyprland.conf` | `~/.config/hypr/hyprland.conf` |
| `dotfiles/hypr/hyprlock.conf` | `~/.config/hypr/hyprlock.conf` |
| `dotfiles/wlogout/*` | `~/.config/wlogout/` |
| `dotfiles/fish/config.fish` | `~/.config/fish/config.fish` |
| `scripts/rotate_wallpaper.sh` | `~/.local/bin/rotate_wallpaper.sh` |
| `wallpapers/*.jpg` | `~/Downloads/` |

### Configuración del Sistema (SDDM)
Para activar el tema de inicio de sesión **Pixie**:
1. Copia `sddm/theme.conf` a `/etc/sddm.conf.d/theme.conf`.
2. Asegúrate de que `/etc/sddm.conf` tenga la línea `Current=pixie` bajo la sección `[Theme]`.

---

## ⌨️ 3. Atajos de Teclado Clave
- **Super + L:** Bloquear pantalla.
- **Super + M:** Menú de apagado visual (wlogout).
- **Ctrl + Super + Flecha Arriba:** Maximizar ventana (estilo Windows).
- **Ctrl + Super + Flecha Abajo:** Restaurar ventana.
- **Super + Q:** Abrir terminal (Kitty).
- **Super + E:** Explorador de archivos (Dolphin).
- **Super + N:** Cambiar fondo de pantalla aleatoriamente.

---

## 🖱️ 4. Gestos del Touchpad (Nativos)
- **4 dedos (Horizontal):** Cambiar de escritorio (Workspace).
- **3 dedos (Arriba):** Nueva pestaña en Firefox.
- **3 dedos (Abajo):** Cerrar pestaña en Firefox.
- **3 dedos (Izquierda/Derecha):** Navegar entre pestañas de Firefox.

---

## ✅ 5. Pasos Finales
1. Dale permisos de ejecución al script de fondos:
   ```bash
   chmod +x ~/.local/bin/rotate_wallpaper.sh
   ```
2. Añade tu usuario al grupo `input` para los gestos (aunque Hyprland 0.55+ ya suele manejarlo):
   ```bash
   sudo gpasswd -a $USER input
   ```
3. Reinicia la sesión para aplicar todos los cambios.

---
*Configurado con ❤️ por Gabriel (vctorgab)*
