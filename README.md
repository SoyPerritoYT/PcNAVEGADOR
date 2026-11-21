# PC Navegador

Un escritorio Linux real (Ubuntu + XFCE) dentro del navegador, usando LinuxServer Webtop y GitHub Codespaces.

> **Importante:** esto es Linux, no Windows. No es una máquina Windows ni ejecuta programas `.exe` de forma nativa. El servicio depende de Codespaces y de sus cuotas gratuitas; no es un PC 24/7 ilimitado.

## Iniciar el escritorio

1. Abre este repositorio en GitHub.
2. Pulsa **Code → Codespaces → Create codespace on main**.
3. Espera a que Codespaces termine de iniciar el contenedor.
4. Abre la pestaña **Ports** del Codespace.
5. Busca el puerto **3000** (Escritorio Linux / noVNC) y pulsa **Open in Browser**.

El puerto está configurado como **Private**. Mantén esa configuración: no lo cambies a Public.

## Apariencia estilo Windows

Hay un instalador opcional que añade iconos Papirus, fuente Inter y un dock de aplicaciones Plank para dar al escritorio XFCE un aspecto más moderno inspirado en Windows.

Desde una terminal dentro del escritorio Webtop, ejecuta:

```bash
bash .devcontainer/setup-windows-look.sh
```

Cuando termine, reinicia el escritorio/Codespace para que aparezcan todos los cambios. Es una apariencia inspirada en Windows, no una copia exacta de Windows 11.

## Juegos

- **Roblox:** no tiene soporte oficial para Linux; los métodos comunitarios pueden dejar de funcionar y no están garantizados en Codespaces.
- **Minecraft Bedrock (móvil/consola/Windows):** no tiene una versión oficial para Linux. Esta configuración no lo convierte en Minecraft Bedrock.
- **Minecraft Java:** puede funcionar en Linux, pero el rendimiento gráfico de Codespaces puede ser insuficiente.

Este Codespace está pensado para un escritorio remoto y tareas ligeras, no para jugar.

## Qué incluye

- Escritorio gráfico XFCE.
- Terminal y gestor de archivos.
- Navegador y utilidades gráficas incluidas en la imagen Ubuntu-XFCE.
- Acceso mediante el navegador a través de noVNC.

## Costes y límites

- La configuración no añade servicios de pago ni solicita tarjeta.
- GitHub Codespaces tiene una cuota gratuita limitada que puede cambiar según el plan y las condiciones de GitHub.
- Consulta el consumo en **GitHub → Settings → Billing and licensing → Usage**.
- Detén el Codespace cuando termines para no consumir horas innecesariamente.
- El almacenamiento del Codespace no debe considerarse una copia de seguridad permanente. Guarda los archivos importantes en el repositorio privado o descárgalos.

## Seguridad

- El puerto 3000 se reenvía como **Private** para que requiera autenticación de GitHub.
- No publiques el puerto ni guardes contraseñas o datos sensibles en el repositorio.
- No compartas el enlace privado del Codespace.

## Configuración

La configuración está en `.devcontainer/devcontainer.json`. Usa la imagen oficial de LinuxServer Webtop para Ubuntu XFCE.

Documentación:
- [GitHub Codespaces](https://docs.github.com/en/codespaces)
- [LinuxServer Webtop](https://docs.linuxserver.io/images/docker-webtop/)
