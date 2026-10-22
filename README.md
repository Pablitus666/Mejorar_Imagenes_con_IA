# 🖼️ Improve Images

Cuaderno de Google Colab para restaurar y ampliar fotografías con inteligencia artificial mediante **CodeFormer** e **HYPIR**, con mejora opcional del fondo y restauración adicional de rostros según el flujo seleccionado.

---

![Platform](https://img.shields.io/badge/platform-Google%20Colab-F9AB00?style=flat&logo=googlecolab&logoColor=white)
![Language](https://img.shields.io/badge/language-Python-3776AB?style=flat&logo=python&logoColor=white)
![Notebook](https://img.shields.io/badge/format-Jupyter%20Notebook-F37626?style=flat&logo=jupyter&logoColor=white)
![AI](https://img.shields.io/badge/AI-CodeFormer%20%7C%20HYPIR-6C63FF?style=flat)
![Upscaling](https://img.shields.io/badge/upscaling-2x%20%2F%204x-blue?style=flat)
![EXIF](https://img.shields.io/badge/EXIF-orientation%20corrected-success?style=flat)
![Storage](https://img.shields.io/badge/storage-Google%20Drive-4285F4?style=flat&logo=googledrive&logoColor=white)
![Status](https://img.shields.io/badge/status-Stable-brightgreen?style=flat)

---

![Social Preview](images/Preview.png)

---

## ✨ Funciones

- ⚙️ Preparación automática del entorno de ejecución en Google Colab.
- 📦 Descarga del repositorio de CodeFormer y de los cinco modelos necesarios para la restauración de ese flujo.
- 🧠 Integración de HYPIR para restauración generativa de detalles.
- 🔐 Verificación de los pesos alojados en el Release del proyecto mediante SHA-256 para detectar archivos incompletos o alterados.
- 📤 Carga de una fotografía por vez o selección de una imagen disponible en la carpeta de entrada.
- 🧭 Corrección de la orientación EXIF antes de procesar las fotografías.
- 🎚️ Control de fidelidad para ajustar el equilibrio entre la imagen original y la reconstrucción generativa, según el modelo seleccionado.
- 🔎 Ampliación de imágenes a 2x o 4x cuando está disponible en el flujo seleccionado.
- 🌄 Mejora opcional del fondo mediante Real-ESRGAN en el flujo compatible.
- 🙂 Restauración facial y mejora adicional de rostros detectados en el flujo compatible.
- 🧩 Combinación configurable del resultado de HYPIR con una versión ampliada de la imagen original.
- ⚡ Modo rápido opcional de HYPIR, con menos solapamiento entre regiones; puede afectar a detalles locales.
- ♻️ Caché de inferencia de HYPIR para reutilizar resultados cuando coinciden la imagen de entrada y los parámetros relevantes.
- ☁️ Caché persistente de código y modelos en Google Drive para reducir descargas repetidas entre sesiones.
- 🔎 Aviso de escala efectiva cuando CodeFormer amplía internamente imágenes con un lado menor a 512 px.
- ⏱️ Medición de tiempos de preparación e inferencia en HYPIR y CodeFormer.
- 🧪 Diagnóstico posterior de la sesión, con informe descargable de versiones, rutas y pesos.
- 🖼️ Comparación visual del original y el resultado restaurado.
- 📥 Descarga de la imagen final desde Google Colab.
- ☁️ Copia de originales y resultados en Google Drive cuando está conectado.

## 🚀 Empezar en Google Colab

### 📥 Descargar el cuaderno desde Releases

El cuaderno se distribuye como archivo ZIP dentro del Release [`modelos-v1`](https://github.com/Pablitus666/Mejorar_Imagenes_con_IA/releases/tag/modelos-v1), junto con los pesos de CodeFormer.

1. Descarga [`Mejorar_Imagenes_con_IA.zip`](https://github.com/Pablitus666/Mejorar_Imagenes_con_IA/releases/download/modelos-v1/Mejorar_Imagenes_con_IA.zip).
2. Descomprime el archivo. Dentro encontrarás `Mejorar_Imagenes_con_IA.ipynb`.
3. Entra en [Google Colab](https://colab.research.google.com/) y elige **Archivo → Subir cuaderno**.
4. Selecciona el archivo `Mejorar_Imagenes_con_IA.ipynb`.

**Integridad del ZIP** (125 KB):

- SHA-256: `1251d384add65c3f3eef23e45c397f76f967879e0dd0b029194856115f8ae8e6`

Puedes comprobarlo antes de subirlo:

```powershell
Get-FileHash .\Mejorar_Imagenes_con_IA.zip -Algorithm SHA256
```

```bash
sha256sum Mejorar_Imagenes_con_IA.zip
```

> El ZIP contiene únicamente el cuaderno. En el mismo Release están los pesos de CodeFormer; HYPIR y Stable Diffusion 2.1 se descargan desde sus propias fuentes durante la preparación.

### ▶️ Ejecutar el cuaderno

1. En **Entorno de ejecución → Cambiar tipo de entorno de ejecución**, selecciona una GPU si está disponible.
2. Ejecuta la celda **01 · Preparar el entorno** y espera a que finalicen las comprobaciones.
3. En **02 · Elegir una fotografía**, sube una imagen o selecciona una disponible.
4. En **03 · Ajustar la restauración**, elige el modelo y configura las opciones disponibles.
5. Ejecuta **04 · Restaurar la imagen**.
6. Revisa el resultado en **05 · Comparar el antes y el después**.
7. Ejecuta **06 · Descargar la imagen restaurada** cuando estés conforme con el resultado.
8. Opcional: ejecuta **07 · Diagnóstico posterior** para guardar un informe del entorno y las versiones de la sesión.

La disponibilidad de GPU depende de Google Colab y no está garantizada. Sin GPU, el procesamiento puede ser considerablemente más lento.

### Primera ejecución

La preparación puede tardar varios minutos porque instala o comprueba dependencias, obtiene código de los repositorios oficiales y descarga los pesos necesarios.

**CodeFormer** obtiene el código del repositorio oficial. Los cinco archivos de pesos configurados para este flujo se descargan desde el Release del proyecto y se verifican mediante SHA-256. Si un archivo existente no coincide con el hash esperado, el cuaderno intenta descargarlo nuevamente.

La verificación SHA-256 de los pesos utiliza una caché persistente. Si el archivo y su firma no cambiaron, reutiliza el hash guardado y evita releerlo completo en cada sesión; si detecta un cambio, vuelve a comprobarlo antes de usarlo.

**HYPIR** utiliza una revisión concreta del repositorio oficial (`b61d107`) descargada como ZIP. El archivo se conserva en la caché de Google Drive para evitar volver a descargarlo en sesiones posteriores. Los pesos de HYPIR y el modelo base Stable Diffusion 2.1 se gestionan mediante sus propias rutas y cachés.

Si Google Colab reinicia el entorno, vuelve a ejecutar la preparación antes de continuar. Los archivos de `/content` son temporales y pueden desaparecer al reiniciarse la sesión.

## 🎚️ Opciones de restauración

| Opción | Descripción |
|---|---|
| Modelo CodeFormer | Restauración facial clásica, orientada a reconstruir rostros. |
| Modelo HYPIR | Restauración generativa de detalles mediante un modelo basado en Stable Diffusion 2.1. |
| Fidelidad / combinación | Ajusta los controles disponibles para equilibrar la imagen original y la reconstrucción. |
| Ampliación 2x | Produce una imagen ampliada con un consumo de recursos generalmente menor que 4x. |
| Ampliación 4x | Produce una imagen considerablemente mayor y puede requerir más memoria y tiempo, según el flujo utilizado. |
| Mejora del fondo | Activa Real-ESRGAN en el flujo compatible para mejorar las zonas que no son rostros. |
| Mejora adicional de rostros | Activa el procesamiento adicional de los rostros detectados en el flujo compatible. |
| Modo rápido HYPIR | Reduce el solapamiento entre regiones procesadas; puede reducir el tiempo, pero afectar a detalles locales o producir uniones más visibles. |
| Caché de inferencia HYPIR | Reutiliza una inferencia anterior si la imagen y los parámetros relevantes coinciden. |

### Recomendaciones

- Empieza con una fidelidad de `0.7` y ampliación 2x en el flujo CodeFormer; ajusta los valores según el resultado.
- Conserva siempre la fotografía original.
- Compara CodeFormer y HYPIR cuando ambos sean adecuados para la imagen: sus resultados y objetivos son diferentes.
- Para priorizar la calidad de HYPIR, conserva el modo habitual con mayor solapamiento. El modo rápido sigue disponible como alternativa opcional.
- Las mejoras adicionales pueden aumentar el tiempo de procesamiento y el uso de memoria.
- En imágenes de más de 20 megapíxeles, empieza por una ampliación menor si dispones de recursos limitados.
- Si el lado menor de la imagen es inferior a 512 px, CodeFormer lo amplía internamente a 512 px antes de aplicar la escala elegida; el resultado puede ser mayor que 2x o 4x. El cuaderno muestra el tamaño efectivo estimado antes de procesar.
- La ampliación 4x y las mejoras adicionales pueden superar la memoria disponible, especialmente en imágenes grandes.
- Comprueba los rostros y detalles importantes: los modelos generativos pueden reconstruir detalles que no estaban claramente presentes en la fotografía original.

### Caché de inferencia de HYPIR

El cuaderno puede reutilizar el resultado de una inferencia anterior cuando la imagen de entrada y los parámetros relevantes coinciden. Si cambia la imagen o un parámetro que determina la inferencia, será necesario procesarla de nuevo. Los cambios que solo afectan a la combinación visual final pueden aprovechar la inferencia guardada cuando corresponda.

La caché evita trabajo repetido, pero no elimina el coste de la primera inferencia. Los archivos de caché dependen de las rutas configuradas y del almacenamiento disponible.

### Diagnóstico posterior

La celda **07 · Diagnóstico posterior** registra, en la misma sesión, las versiones instaladas, las rutas, los pesos, los marcadores y los tiempos de preparación. Genera `diagnosticos/diagnostico_post_*.txt` en Google Drive cuando está montado y lo descarga. No instala dependencias ni altera el flujo: solo escribe el informe, que es opcional y sirve para conservar evidencia del entorno.

## 🧭 Orientación EXIF

Las fotografías tomadas con teléfonos móviles y cámaras pueden almacenar su orientación en los metadatos EXIF, en lugar de tener los píxeles físicamente rotados.

Antes de convertir la imagen de entrada a PNG, el cuaderno aplica `ImageOps.exif_transpose()` y después convierte la imagen a RGB. Así, el flujo recibe la fotografía con la orientación corregida.

El cuaderno admite formatos habituales como JPG, JPEG, PNG, WEBP, BMP y TIFF, siempre que Pillow pueda abrirlos correctamente.

La corrección de orientación se ha probado con fotografías de distintas orientaciones. Esto no garantiza que todos los archivos con metadatos inusuales o dañados puedan procesarse sin incidencias.

## 📁 Carpetas utilizadas en Colab

| Ubicación | Uso |
|---|---|
| `/content/Mejorar_Imagenes_con_IA/entrada` | Fotografías de entrada. |
| `/content/Mejorar_Imagenes_con_IA/resultados` | Resultados del proyecto durante la sesión. |
| `/content/Mejorar_Imagenes_con_IA/CodeFormer` | Código de CodeFormer y componentes asociados. |
| `/content/Mejorar_Imagenes_con_IA/HYPIR` | Código de HYPIR extraído para la sesión. |
| `/content/drive/MyDrive/Mejorar_Imagenes_con_IA/originales` | Copias de los originales en Google Drive. |
| `/content/drive/MyDrive/Mejorar_Imagenes_con_IA/resultados` | Copias permanentes de los resultados en Google Drive. |
| `/content/drive/MyDrive/Mejorar_Imagenes_con_IA/cache/codigo_hypir` | ZIP de la revisión fijada del código de HYPIR. |
| `/content/drive/MyDrive/Mejorar_Imagenes_con_IA/modelos/HYPIR_sd2.pth` | Ubicación configurada para los pesos de HYPIR. |
| `/content/drive/MyDrive/Mejorar_Imagenes_con_IA/cache/huggingface` | Caché persistente de componentes de Hugging Face, incluido el modelo base. |

Las carpetas bajo `/content` pertenecen al entorno temporal de Colab. El cuaderno prepara copias locales de algunos componentes para acelerar el acceso durante la sesión. Si Google Drive está conectado, se conservan allí los archivos configurados como persistentes. Comprueba que la copia de los resultados se haya completado antes de cerrar la sesión.

## 🧩 Tecnologías y dependencias

- **Google Colab y Jupyter Notebook:** entorno de ejecución e interfaz.
- **Python:** lógica de preparación y procesamiento.
- **CodeFormer:** restauración facial.
- **HYPIR:** restauración generativa de imágenes.
- **Stable Diffusion 2.1:** modelo base utilizado por el flujo HYPIR.
- **Real-ESRGAN:** mejora opcional del fondo en el flujo compatible.
- **PyTorch:** ejecución de los modelos.
- **Pillow:** lectura, conversión y corrección de orientación de imágenes.
- **ipywidgets:** controles interactivos.
- **Hugging Face Diffusers y Transformers:** componentes del entorno de HYPIR.
- **Matplotlib:** comparación visual del original y el resultado.

El cuaderno obtiene código y modelos desde fuentes externas y utiliza versiones fijadas de algunas dependencias para mantener la compatibilidad. Consulta `LICENSES.md` si está presente y las licencias de cada componente antes de redistribuir código, modelos o versiones modificadas.

Este repositorio organiza el flujo de trabajo y la experiencia de uso. No implica la propiedad de los modelos, pesos ni bibliotecas de terceros.

## 📷 Capturas de pantalla

<p align="center">
  <img src="images/screenshot.png?v=2" alt="Captura de pantalla del cuaderno de restauración de imágenes con IA" width="800">
</p>

---

## 🔐 Datos y privacidad

- No subas fotografías privadas, credenciales, tokens ni otros datos sensibles al repositorio.
- Conserva las fotografías y los resultados en tu almacenamiento personal, como Google Drive.
- La preparación descarga componentes externos y la ejecución utiliza la infraestructura de Google Colab; por tanto, el proyecto no es un flujo completamente offline.


## 🗺️ Estado del proyecto

**Estado: estable, con pruebas funcionales satisfactorias en Google Colab.**

**Enfoque actual:** memoria, integridad y conservación de originales.

- [x] Preparación del entorno y comprobación de dependencias.
- [x] Descarga y verificación SHA-256 de los cinco pesos configurados para CodeFormer.
- [x] Selección y carga de una fotografía por vez.
- [x] Control de fidelidad y opciones de ampliación del flujo correspondiente.
- [x] Integración de CodeFormer y HYPIR.
- [x] Modo rápido opcional de HYPIR.
- [x] Caché del código de HYPIR y componentes en Google Drive.
- [x] Caché de inferencia de HYPIR validada en pruebas.
- [x] Corrección de la orientación EXIF antes del procesamiento.
- [x] Generación y validación de imágenes restauradas.
- [x] Comparación visual del antes y el después.
- [x] Descarga del resultado.
- [x] Copia en Google Drive cuando está conectado.
- [x] Pruebas funcionales con fotografías de diferentes dimensiones y orientaciones.
- [x] Identificación de imágenes por contenido y validación de parámetros y dimensiones antes de reutilizar resultados.
- [x] Copia verificada de la caché de Stable Diffusion 2.1 al almacenamiento temporal de cada sesión.
- [x] Caché SHA-256 v2 de los pesos, con reutilización del hash cuando la firma no cambió.
- [x] Aviso de escala efectiva cuando el lado menor es inferior a 512 px.
- [x] Diagnóstico posterior de la sesión con informe descargable.
- [x] Pruebas reales con 0.04 MP y 1.2 MP, en 2x y 4x, con HYPIR y CodeFormer.

El estado estable refleja las pruebas realizadas hasta el momento. No implica que se hayan probado todas las combinaciones de modelos, formatos, resoluciones y recursos disponibles en Google Colab.

## 📌 Repositorio

[github.com/Pablitus666/Mejorar_Imagenes_con_IA](https://github.com/Pablitus666/Mejorar_Imagenes_con_IA)

---

## 👨‍💻 Autor

**Walter Pablo Téllez Ayala**  
Software Developer  
📍 Bolivia 🇧🇴 <img src="https://flagcdn.com/w20/bo.png" width="20" alt="Bandera de Bolivia">  
📧 pharmakoz@gmail.com

© 2026 — **Improve Images**

---

## Modelos de restauración — versión 1

Primera versión de los archivos de modelos utilizados por el proyecto personal **Improve Images**.

Estos archivos contienen los pesos necesarios para ejecutar el cuaderno de Google Colab basado en **CodeFormer**, evitando depender exclusivamente de las descargas directas desde las fuentes originales.

### Modelos incluidos

- `codeformer.pth` — modelo principal para la restauración facial.
- `detection_Resnet50_Final.pth` — modelo de detección facial.
- `parsing_parsenet.pth` — modelo de análisis y segmentación facial.
- `RealESRGAN_x2plus.pth` — modelo opcional para mejorar la resolución del fondo.
- `yolov5l-face.pth` — pesos utilizados para la detección facial en el flujo de restauración.

El cuaderno principal mantiene estos cinco archivos y sus hashes SHA-256; no requiere pesos adicionales para el flujo CodeFormer.

### Integridad de los archivos

El cuaderno verifica los archivos descargados mediante sus hashes SHA-256 antes de utilizarlos, para comprobar que coincidan con los valores esperados por el proyecto.

### Licencia y atribución

CodeFormer se distribuye bajo la **NTU S-Lab License 1.0**. La redistribución y el uso están sujetos a los términos y condiciones de la licencia original, incluidos los avisos de copyright y las condiciones aplicables.

Los modelos adicionales conservan las condiciones de licencia establecidas por sus respectivos proyectos de origen. Consulta las licencias originales antes de reutilizar o redistribuir estos archivos.

Este es un proyecto personal e independiente, no afiliado oficialmente con los autores de CodeFormer ni con los desarrolladores de los modelos relacionados.

### Cuaderno de Google Colab

Este Release también incluye `Mejorar_Imagenes_con_IA.zip`, con el cuaderno listo para descargar y subir a Google Colab. Consulta la sección **Empezar en Google Colab** para los pasos de descarga, el enlace directo y la verificación SHA-256.

**Proyecto:** [Improve Images](https://github.com/Pablitus666/Mejorar_Imagenes_con_IA)  
**Código original de CodeFormer:** https://github.com/sczhou/CodeFormer  
**Licencia de CodeFormer:** https://github.com/sczhou/CodeFormer/blob/master/LICENSE  
**Real-ESRGAN:** https://github.com/xinntao/Real-ESRGAN  
**HYPIR:** https://github.com/XPixelGroup/HYPIR
