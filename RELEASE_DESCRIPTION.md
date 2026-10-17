## Modelos de restauración — versión 1

Primera versión de los archivos de modelos utilizados por el proyecto personal **Mejorar Imágenes con IA**.

Estos archivos contienen los pesos necesarios para ejecutar el cuaderno de Google Colab basado en **CodeFormer**, evitando depender exclusivamente de las descargas directas desde las fuentes originales.

### Modelos incluidos

- `codeformer.pth` — modelo principal para la restauración facial.
- `detection_Resnet50_Final.pth` — modelo de detección facial.
- `parsing_parsenet.pth` — modelo de análisis y segmentación facial.
- `RealESRGAN_x2plus.pth` — modelo opcional para mejorar la resolución del fondo.
- `yolov5l-face.pth` — pesos utilizados para la detección facial en el flujo de restauración.

### Integridad de los archivos

El cuaderno verifica los archivos descargados mediante sus hashes SHA-256 antes de utilizarlos, para comprobar que coincidan con los valores esperados por el proyecto.

### Licencia y atribución

CodeFormer se distribuye bajo la **NTU S-Lab License 1.0**. La redistribución para fines no comerciales está sujeta a los términos y condiciones de la licencia original, incluidos los avisos de copyright y las condiciones aplicables.

Los modelos adicionales conservan las condiciones de licencia establecidas por sus respectivos proyectos de origen. Consulta las licencias originales antes de reutilizar o redistribuir estos archivos.

Este es un proyecto personal e independiente, no afiliado oficialmente con los autores de CodeFormer ni con los desarrolladores de los modelos relacionados.

**Proyecto:** [Mejorar Imágenes con IA](https://github.com/Pablitus666/Mejorar_Imagenes_con_IA)

**Código original de CodeFormer:** https://github.com/sczhou/CodeFormer

**Licencia de CodeFormer:** https://github.com/sczhou/CodeFormer/blob/master/LICENSE

**Real-ESRGAN:** https://github.com/xinntao/Real-ESRGAN