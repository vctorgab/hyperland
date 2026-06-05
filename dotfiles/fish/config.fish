source /usr/share/cachyos-fish-config/cachyos-config.fish

function fish_greeting
    # Desactivar el saludo inicial (logo de CachyOS)
end

# opencode
fish_add_path /home/gabriel/.opencode/bin


# Added by Antigravity CLI installer
set -gx PATH "/home/gabriel/.local/bin" $PATH

# yazi wrapper: al cerrar yazi, se queda en la carpeta que estabas
function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file=$tmp
    if set cwd (cat -- $tmp); and test -n "$cwd"; and test "$cwd" != "$PWD"
        cd -- "$cwd"
    end
    rm -f -- $tmp
end
