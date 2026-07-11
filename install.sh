#!/usr/bin/env bash
# Instala AirPlay Server (open source) en un Android TV box vía ADB.
# Uso: ./install.sh <IP_DEL_BOX> [puerto]
set -euo pipefail

REPO="jqssun/android-airplay-server"
PKG="io.github.jqssun.airplay"

IP="${1:-}"
PORT="${2:-5555}"

if [[ -z "$IP" ]]; then
  echo "Uso: $0 <IP_DEL_BOX> [puerto]"
  echo "Ejemplo: $0 192.168.1.84"
  exit 1
fi

if ! command -v adb >/dev/null 2>&1; then
  echo "❌ adb no está instalado."
  echo "   macOS:  brew install --cask android-platform-tools"
  echo "   Linux:  sudo apt install adb"
  exit 1
fi

echo "▶ Buscando la última release de $REPO..."
APK_URL=$(curl -fsSL "https://api.github.com/repos/$REPO/releases/latest" \
  | grep -o '"browser_download_url": *"[^"]*app-release\.apk"' \
  | grep -o 'https://[^"]*')

if [[ -z "$APK_URL" ]]; then
  echo "❌ No se pudo obtener la URL del APK. Descárgalo manualmente de:"
  echo "   https://github.com/$REPO/releases/latest"
  exit 1
fi

APK="$(mktemp -d)/app-release.apk"
echo "▶ Descargando $APK_URL"
curl -fL --progress-bar -o "$APK" "$APK_URL"

echo "▶ Conectando con $IP:$PORT..."
adb connect "$IP:$PORT" >/dev/null

# Espera a que el usuario acepte el diálogo de autorización en la tele
for i in $(seq 1 30); do
  STATE=$(adb devices | awk -v d="$IP:$PORT" '$1==d {print $2}')
  case "$STATE" in
    device) break ;;
    unauthorized)
      [[ $i -eq 1 ]] && echo "⏳ Acepta el diálogo '¿Permitir depuración USB?' en la tele..."
      ;;
    *)
      adb connect "$IP:$PORT" >/dev/null 2>&1 || true
      ;;
  esac
  sleep 2
done

if [[ "$(adb devices | awk -v d="$IP:$PORT" '$1==d {print $2}')" != "device" ]]; then
  echo "❌ No se pudo autorizar la conexión. Comprueba que la Depuración USB está activada"
  echo "   y acepta el diálogo en la pantalla del box."
  exit 1
fi

echo "▶ Instalando en el box..."
adb -s "$IP:$PORT" install -r "$APK"

echo "▶ Lanzando AirPlay Server..."
adb -s "$IP:$PORT" shell monkey -p "$PKG" -c android.intent.category.LAUNCHER 1 >/dev/null 2>&1

rm -f "$APK"
echo ""
echo "✅ Listo. Abre el Centro de Control en tu iPhone/iPad/Mac → Duplicar pantalla → elige tu box."
