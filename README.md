# AirPlay gratis en Xiaomi TV Box (y cualquier Android TV / Google TV)

> **TL;DR (English):** Get free, open-source AirPlay screen mirroring on any Android TV / Google TV box by sideloading [android-airplay-server](https://github.com/jqssun/android-airplay-server) via ADB. No root, no ads, no paid apps. Run `./install.sh <BOX_IP>` and you're done.

¿Quieres enviar contenido por **AirPlay** desde tu iPhone, iPad o Mac a tu Xiaomi TV Box y solo encuentras apps de pago o llenas de anuncios? Este repo documenta la solución **gratuita y open source**: instalar [AirPlay Server](https://github.com/jqssun/android-airplay-server) (GPL v3, basada en [UxPlay](https://github.com/FDH2/UxPlay)) mediante *sideload* con ADB.

**Sin root. Sin anuncios. Sin pagos.**

## Qué obtienes

- 📺 **Duplicación de pantalla** (mirroring) desde iOS/iPadOS/macOS, con vídeo H.264 y H.265
- 🎵 **Audio en streaming** (AAC-ELD, AAC-LC, ALAC) con carátulas y controles de reproducción
- 🎮 Interfaz adaptada a Android TV, navegable con el mando

Probado en un Xiaomi TV Box (Android TV 14). Debería funcionar en cualquier box con Android 7.0+, incluidos Fire TV, Chromecast con Google TV, Nvidia Shield, etc.

## Requisitos

- Un ordenador (Mac, Linux o Windows) en la misma red Wi-Fi que el box
- `adb` (Android Platform Tools)
  - macOS: `brew install --cask android-platform-tools`
  - Linux: `sudo apt install adb` (o equivalente)
  - Windows: [descarga oficial](https://developer.android.com/tools/releases/platform-tools)

## Paso 1 — Activa la depuración en el box

Con el mando del box:

1. **Ajustes → Sistema → Información** → pulsa 7 veces sobre **"Compilación"** hasta ver *"Ya eres desarrollador"*
2. **Ajustes → Sistema → Opciones para desarrolladores** → activa **Depuración USB**
3. Apunta la IP del box: **Ajustes → Red e Internet →** tu red Wi-Fi (algo como `192.168.1.x`)

## Paso 2 — Instala con el script

```bash
./install.sh 192.168.1.84   # usa la IP de TU box
```

El script descarga la última versión del APK desde las releases oficiales, conecta por ADB, instala la app y la lanza.

> ⚠️ La primera vez, el box mostrará un diálogo **"¿Permitir la depuración USB?"** — marca *"Permitir siempre desde este ordenador"* y acepta.

### Instalación manual (sin script)

```bash
# Descarga el APK desde https://github.com/jqssun/android-airplay-server/releases/latest
adb connect 192.168.1.84:5555
adb install -r app-release.apk
```

## Paso 3 — Úsalo

1. Abre la app **AirPlay Server** en el box
2. En tu iPhone/iPad: Centro de Control → **Duplicar pantalla** → selecciona el box
3. En tu Mac: icono de AirPlay en la barra de menús

## Problemas frecuentes

| Problema | Solución |
|---|---|
| `failed to authenticate` / `unauthorized` | Acepta el diálogo de depuración en la tele. Si no aparece: Opciones para desarrolladores → *Revocar autorizaciones de depuración USB* y reactiva la depuración |
| El box no aparece en el iPhone | Comprueba que ambos están en la misma red Wi-Fi y que la app está abierta en el box |
| Netflix / Apple TV+ se ven en negro | Es el DRM (FairPlay) de esas plataformas, no un fallo de la app. Usa sus apps nativas del box o el Chromecast integrado |
| El box no responde en el puerto 5555 | Reinicia el box con la depuración USB ya activada |

## Créditos

Todo el mérito del receptor AirPlay es de [jqssun/android-airplay-server](https://github.com/jqssun/android-airplay-server) y de [UxPlay](https://github.com/FDH2/UxPlay). Este repo solo documenta y automatiza su instalación en TV boxes.

## Licencia

Esta guía y el script se publican bajo licencia [MIT](LICENSE). La app AirPlay Server tiene su propia licencia (GPL v3) en su repositorio.
