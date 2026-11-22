#!/usr/bin/env bash
set -euo pipefail

# Windows-inspired XFCE appearance and Spanish language support
# for LinuxServer Webtop (Ubuntu XFCE).
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
  echo "Necesito permisos de administrador para instalar los componentes."
  exit 1
fi

echo "Actualizando paquetes e instalando el idioma español..."
$SUDO apt-get update
$SUDO apt-get install -y locales language-pack-es language-pack-gnome-es

# Generate and set the Spanish (Spain) UTF-8 locale system-wide.
if command -v locale-gen >/dev/null 2>&1; then
  $SUDO locale-gen es_ES.UTF-8
fi
if command -v update-locale >/dev/null 2>&1; then
  $SUDO update-locale LANG=es_ES.UTF-8 LANGUAGE=es_ES:es
fi
printf 'LANG=es_ES.UTF-8\nLANGUAGE=es_ES:es\n' | $SUDO tee /etc/default/locale >/dev/null

# Keep the locale for the Webtop user's future graphical sessions too.
mkdir -p "$HOME"
touch "$HOME/.profile"
if ! grep -q 'LANG=es_ES.UTF-8' "$HOME/.profile"; then
  cat >> "$HOME/.profile" <<'PROFILE'

# Idioma español para las sesiones del escritorio.
export LANG=es_ES.UTF-8
export LANGUAGE=es_ES:es
PROFILE
fi

echo "Instalando Firefox, iconos, fuentes y dock..."
$SUDO apt-get install -y ca-certificates curl gpg
$SUDO install -d -m 0755 /etc/apt/keyrings
curl -fsSL https://packages.mozilla.org/apt/repo-signing-key.gpg | $SUDO tee /etc/apt/keyrings/packages.mozilla.org.asc >/dev/null
echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | $SUDO tee /etc/apt/sources.list.d/mozilla.list >/dev/null
printf 'Package: *\nPin: origin packages.mozilla.org\nPin-Priority: 1000\n' | $SUDO tee /etc/apt/preferences.d/mozilla >/dev/null
$SUDO apt-get update
$SUDO apt-get install -y firefox papirus-icon-theme plank fonts-inter

# Adw-gtk3 is optional; keep the setup working if it is unavailable.
$SUDO apt-get install -y adw-gtk3 || true

if command -v xfconf-query >/dev/null 2>&1; then
  if [ -d /usr/share/themes/adw-gtk3-dark ]; then
    xfconf-query -c xsettings -p /Net/ThemeName --create -t string -s "adw-gtk3-dark" || true
  fi
  if [ -d /usr/share/icons/Papirus-Dark ]; then
    xfconf-query -c xsettings -p /Net/IconThemeName --create -t string -s "Papirus-Dark" || true
  fi
  xfconf-query -c xsettings -p /Gtk/FontName --create -t string -s "Inter 10" || true
fi

# Start Plank automatically on future XFCE desktop logins.
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

# Add desktop shortcuts.
DESKTOP_DIR="$HOME/Desktop"
mkdir -p "$DESKTOP_DIR"
cat > "$DESKTOP_DIR/YouTube.desktop" <<'YOUTUBE'
[Desktop Entry]
Version=1.0
Type=Application
Name=YouTube
Comment=Open YouTube in the web browser
Exec=xdg-open https://www.youtube.com
Icon=web-browser
Terminal=false
Categories=Network;AudioVideo;
YOUTUBE
chmod +x "$DESKTOP_DIR/YouTube.desktop"

cat > "$DESKTOP_DIR/Firefox.desktop" <<'FIREFOX'
[Desktop Entry]
Version=1.0
Type=Application
Name=Firefox
Comment=Open Firefox web browser
Exec=firefox %u
Icon=firefox
Terminal=false
Categories=Network;WebBrowser;
FIREFOX
chmod +x "$DESKTOP_DIR/Firefox.desktop"

echo
echo "Instalación terminada. Cierra sesión y vuelve a entrar para aplicar el idioma español."
echo "El dock Plank se iniciará automáticamente."
