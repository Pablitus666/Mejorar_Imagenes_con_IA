# 🖼️ Mejorar_Imagenes_con_IA

Cuaderno de Google Colab para restaurar fotografías con inteligencia artificial mediante CodeFormer, con ampliación de imágenes, mejora opcional del fondo y restauración adicional de rostros.

---

![Platform](https://img.shields.io/badge/platform-Google%20Colab-F9AB00?style=flat&logo=googlecolab&logoColor=white)
![Language](https://img.shields.io/badge/language-Python-3776AB?style=flat&logo=python&logoColor=white)
![Notebook](https://img.shields.io/badge/format-Jupyter%20Notebook-F37626?style=flat&logo=jupyter&logoColor=white)
![AI](https://img.shields.io/badge/AI-CodeFormer-6C63FF?style=flat)
![Upscaling](https://img.shields.io/badge/upscaling-2x%20%2F%204x-blue?style=flat)
![EXIF](https://img.shields.io/badge/EXIF-orientation%20corrected-success?style=flat)
![Storage](https://img.shields.io/badge/storage-Google%20Drive-4285F4?style=flat&logo=googledrive&logoColor=white)
![Status](https://img.shields.io/badge/status-Stable-brightgreen?style=flat)

---

![Social Preview](images/Preview.png)

---

## ✨ Funciones

- ⚙️ Preparación automática del entorno de ejecución en Google Colab.
- 📦 Descarga del repositorio de CodeFormer y de los cinco modelos necesarios para la restauración.
- 🔐 Verificación de los pesos mediante SHA-256 para detectar archivos incompletos o alterados.
- 📤 Carga de una fotografía por vez o selección de una imagen disponible en la carpeta de entrada.
- 🧭 Corrección de la orientación EXIF antes de procesar las fotografías.
- 🎚️ Control de fidelidad para ajustar el equilibrio entre la imagen original y la reconstrucción generativa.
- 🔎 Ampliación de imágenes a 2x o 4x.
- 🌄 Mejora opcional del fondo mediante Real-ESRGAN.
- 🙂 Restauración facial y mejora adicional de rostros detectados.
- 🖼️ Comparación visual del original y el resultado restaurado.
- 📥 Descarga de la imagen final desde Google Colab.
- ☁️ Copia de originales y resultados en Google Drive cuando está conectado.

## 🚀 Empezar en Google Colab

1. Abre el repositorio: [Mejorar_Imagenes_con_IA](https://github.com/Pablitus666/Mejorar_Imagenes_con_IA).
2. Abre el cuaderno `.ipynb` desde GitHub o descárgalo y cárgalo en [Google Colab](https://colab.research.google.com/).
3. En **Entorno de ejecución → Cambiar tipo de entorno de ejecución**, selecciona una GPU si está disponible.
4. Ejecuta la celda **01 · Preparar el entorno** y espera a que finalicen las comprobaciones.
5. En **02 · Elegir una fotografía**, sube una imagen o selecciona una disponible.
6. En **03 · Ajustar la restauración**, configura la fidelidad, la ampliación y las mejoras opcionales.
7. Ejecuta **04 · Restaurar la imagen**.
8. Revisa el resultado en **05 · Comparar el antes y el después**.
9. Ejecuta **06 · Descargar la imagen restaurada** cuando estés conforme con el resultado.

La disponibilidad de GPU depende de Google Colab y no está garantizada. Sin GPU, el procesamiento puede ser considerablemente más lento.

### Primera ejecución

La preparación puede tardar varios minutos porque instala o comprueba las dependencias, obtiene el repositorio oficial de CodeFormer y descarga los pesos necesarios.

Los cinco archivos de pesos se verifican mediante SHA-256. Si un archivo existente no coincide con el hash esperado, el cuaderno intenta descargarlo nuevamente.

Si Google Colab reinicia el entorno, vuelve a ejecutar la preparación antes de continuar. Los archivos de `/content` son temporales y pueden desaparecer al reiniciarse la sesión.

## 🎚️ Opciones de restauración

| Opción | Descripción |
|---|---|
| Fidelidad | Ajusta el grado de reconstrucción frente a la conservación de la imagen original. |
| Ampliación 2x | Produce una imagen ampliada con un consumo de recursos generalmente menor que 4x. |
| Ampliación 4x | Produce una imagen considerablemente mayor y puede requerir más memoria y tiempo. |
| Mejora del fondo | Activa Real-ESRGAN para mejorar las zonas que no son rostros. |
| Mejora adicional de rostros | Activa el procesamiento adicional de los rostros detectados. |

### Recomendaciones

- Empieza con una fidelidad de `0.7` y ampliación 2x; ajusta los valores según el resultado.
- Conserva siempre la fotografía original.
- Las mejoras adicionales pueden aumentar el tiempo de procesamiento y el uso de memoria.
- En imágenes de más de 20 megapíxeles, empieza por 2x si dispones de recursos limitados.
- La ampliación 4x con ambas mejoras puede superar la memoria disponible, especialmente en imágenes grandes.
- Comprueba los rostros y detalles importantes: los modelos generativos pueden reconstruir detalles que no estaban claramente presentes en la fotografía original.

## 🧭 Orientación EXIF

Las fotografías tomadas con teléfonos móviles y cámaras pueden almacenar su orientación en los metadatos EXIF, en lugar de tener los píxeles físicamente rotados.

Antes de convertir la imagen de entrada a PNG, el cuaderno aplica `ImageOps.exif_transpose()` y después convierte la imagen a RGB. Así, CodeFormer recibe la fotografía con la orientación corregida.

El cuaderno admite formatos habituales como JPG, JPEG, PNG, WEBP, BMP y TIFF, siempre que Pillow pueda abrirlos correctamente.

La corrección de orientación se ha probado con fotografías de distintas orientaciones. Esto no garantiza que todos los archivos con metadatos inusuales o dañados puedan procesarse sin incidencias.

## 📁 Carpetas utilizadas en Colab

| Ubicación | Uso |
|---|---|
| `/content/Mejorar_Imagenes_con_IA/entrada` | Fotografías de entrada. |
| `/content/Mejorar_Imagenes_con_IA/resultados` | Resultados del proyecto durante la sesión. |
| `/content/Mejorar_Imagenes_con_IA/CodeFormer` | Código de CodeFormer y pesos de los modelos. |
| `/content/drive/MyDrive/Mejorar_Imagenes_con_IA/originales` | Copias de los originales en Google Drive. |
| `/content/drive/MyDrive/Mejorar_Imagenes_con_IA/resultados` | Copias permanentes de los resultados en Google Drive. |

Las carpetas bajo `/content` pertenecen al entorno temporal de Colab. Si Google Drive está conectado, el cuaderno copia allí los originales cargados y las imágenes restauradas. Comprueba que la copia se haya completado antes de cerrar la sesión.

## 🧩 Tecnologías y dependencias

- **Google Colab y Jupyter Notebook:** entorno de ejecución e interfaz.
- **Python:** lógica de preparación y procesamiento.
- **CodeFormer:** restauración facial y reconstrucción de detalles.
- **Real-ESRGAN:** mejora opcional del fondo.
- **PyTorch:** ejecución de los modelos.
- **Pillow:** lectura, conversión y corrección de orientación de imágenes.
- **ipywidgets:** controles interactivos.
- **Matplotlib:** comparación visual del original y el resultado.

El cuaderno descarga el repositorio oficial de CodeFormer y utiliza pesos alojados en el Release del proyecto. Consulta `LICENSES.md` y las licencias de los componentes correspondientes antes de redistribuir código, modelos o versiones modificadas.

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
- Revisa los cambios antes de realizar un commit. `.gitignore` ayuda a evitar la inclusión accidental de archivos locales, pero no sustituye una revisión manual.

## 🗺️ Estado del proyecto

**Estado: estable, con pruebas funcionales satisfactorias en Google Colab.**

- [x] Preparación del entorno y comprobación de dependencias.
- [x] Descarga y verificación SHA-256 de los cinco pesos.
- [x] Selección y carga de una fotografía por vez.
- [x] Control de fidelidad y ampliación 2x/4x.
- [x] Mejora opcional del fondo y de los rostros.
- [x] Corrección de la orientación EXIF antes del procesamiento.
- [x] Generación y validación de la imagen restaurada.
- [x] Comparación visual del antes y el después.
- [x] Descarga del resultado.
- [x] Copia en Google Drive cuando está conectado.
- [x] Pruebas funcionales con fotografías de diferentes dimensiones y orientaciones.

El estado estable refleja las pruebas realizadas hasta el momento. No implica que se hayan probado todas las combinaciones de modelos, formatos, resoluciones y recursos disponibles en Google Colab.

## 📌 Repositorio

[github.com/Pablitus666/Mejorar_Imagenes_con_IA](https://github.com/Pablitus666/Mejorar_Imagenes_con_IA)

---

## 👨‍💻 Autor

**Walter Pablo Téllez Ayala**  
Software Developer  
📍 Bolivia 🇧🇴 <img src="https://flagcdn.com/w20/bo.png" width="20"/><br>
📧 pharmakoz@gmail.com

© 2026 — Improbe Images

---
