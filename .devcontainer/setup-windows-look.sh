#!/usr/bin/env bash
set -euo pipefail

# Windows-inspired XFCE appearance for LinuxServer Webtop (Ubuntu XFCE).
# Run this from a terminal inside the Webtop desktop.

if ! command -v apt-get >/dev/null 2>&1; then
  echo "Este instalador está preparado para la imagen Ubuntu XFCE."
  exit 1
fi

if [ "$(id -u)" -eq 0 ]; then
  SUDO=""
elif command -v sudo >/dev/null 2>&1; then
  SUDO="sudo"
else
  echo "Necesito sudo para instalar el tema y los iconos."
  exit 1
fi

echo "Instalando iconos, fuentes y dock..."
$SUDO apt-get update
$SUDO apt-get install -y papirus-icon-theme plank fonts-inter

# Adw-gtk3 is optional; keep the setup working if it is unavailable in this Ubuntu release.
$SUDO apt-get install -y adw-gtk3 || true

if command -v xfconf-query >/dev/null 2>&1; then
  # Use the modern dark Adwaita variant when installed, otherwise keep the default theme.
  if [ -d /usr/share/themes/adw-gtk3-dark ]; then
    xfconf-query -c xsettings -p /Net/ThemeName --create -t string -s "adw-gtk3-dark" || true
  fi
  if [ -d /usr/share/icons/Papirus-Dark ]; then
    xfconf-query -c xsettings -p /Net/IconThemeName --create -t string -s "Papirus-Dark" || true
  fi
  xfconf-query -c xsettings -p /Gtk/FontName --create -t string -s "Inter 10" || true
fi

# Start a simple centered-style dock automatically on future desktop logins.
mkdir -p "$HOME/.config/autostart"
cat > "$HOME/.config/autostart/plank.desktop" <<'DESKTOP'
[Desktop Entry]
Type=Application
Name=Dock
Comment=Windows-inspired application dock
Exec=plank
OnlyShowIn=XFCE;
X-GNOME-Autostart-enabled=true
DESKTOP

echo
echo "Listo. Cierra sesión/reinicia el escritorio o reinicia el Codespace para ver los cambios."
echo "El dock Plank se iniciará automáticamente."
