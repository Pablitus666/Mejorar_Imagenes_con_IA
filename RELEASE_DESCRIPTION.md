# Modelos de restauración — versión 1

Primera versión de los archivos de modelos utilizados por el proyecto personal **Mejorar Imágenes con IA**.

Estos archivos permiten ejecutar el flujo de restauración basado en CodeFormer sin depender exclusivamente de descargas directas desde las fuentes originales.

## Modelos incluidos

- `codeformer.pth` — modelo principal para restauración facial.
- `detection_Resnet50_Final.pth` — modelo de detección facial.
- `parsing_parsenet.pth` — modelo de análisis y segmentación facial.
- `RealESRGAN_x2plus.pth` — modelo utilizado para la mejora opcional de resolución del fondo.
- `yolov5l-face.pth` — pesos utilizados para la detección facial en el flujo de restauración.

## Integridad de los archivos

El cuaderno verifica los archivos descargados mediante sus hashes SHA-256 antes de utilizarlos. De este modo, puede detectar archivos incompletos o que no coincidan con los valores esperados por el proyecto.

Si un archivo existente no supera la comprobación, el cuaderno intenta obtener una copia válida nuevamente.

La verificación se apoya en una caché de hashes: si el archivo y su firma no cambiaron, se reutiliza el SHA-256 guardado; si cambia, se vuelve a comprobar antes de usar el peso.

## Relación con HYPIR

HYPIR se prepara mediante un flujo independiente. Su código, sus pesos y los componentes base de Stable Diffusion 2.1 se gestionan mediante las fuentes y cachés configuradas por el cuaderno.

**Este Release no incluye los pesos de HYPIR ni los de Stable Diffusion 2.1.** Su redistribución debe evaluarse por separado conforme a las condiciones de sus respectivos proyectos.

## Compatibilidad con el cuaderno principal

El cuaderno principal mantiene los cinco pesos de este Release y sus hashes SHA-256. No se requieren archivos nuevos ni cambios en los pesos; la preparación los descarga, verifica y conserva en la caché de Drive cuando está disponible. HYPIR y Stable Diffusion 2.1 siguen gestionándose por separado.

## Licencias y atribución

CodeFormer se distribuye bajo la NTU S-Lab License 1.0. El uso y la redistribución de su código y de los archivos asociados están sujetos a los términos de la licencia original y a las condiciones aplicables a cada componente.

Los modelos adicionales conservan las condiciones establecidas por sus respectivos proyectos de origen. Consulta las licencias originales antes de reutilizar o redistribuir estos archivos.

Este es un proyecto personal e independiente, no afiliado oficialmente con los autores de CodeFormer ni con los desarrolladores de los modelos relacionados.

**Proyecto:** [Mejorar Imágenes con IA](https://github.com/Pablitus666/Mejorar_Imagenes_con_IA)

**Código original de CodeFormer:** https://github.com/sczhou/CodeFormer

**Licencia de CodeFormer:** https://github.com/sczhou/CodeFormer/blob/master/LICENSE

**Real-ESRGAN:** https://github.com/xinntao/Real-ESRGAN

**HYPIR:** https://github.com/XPixelGroup/HYPIR
