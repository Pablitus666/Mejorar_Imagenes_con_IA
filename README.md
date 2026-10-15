# 🖼️ Mejorar_Imagenes_con_IA

Cuaderno de Google Colab para restaurar fotografías con inteligencia artificial mediante CodeFormer, con opciones de ampliación y mejora adicional de fondo y rostros.

## ✨ Funciones

- Preparación del entorno de ejecución en Google Colab.
- Carga de una fotografía por vez o selección de una imagen disponible en la carpeta de entrada.
- Ajuste de fidelidad y ampliación de **2× o 4×**.
- Opciones para mejorar el fondo con Real-ESRGAN y aplicar mejora adicional a los rostros.
- Comparación visual del original y el resultado restaurado.
- Descarga del resultado y copia permanente en Google Drive cuando Drive está conectado.

## 🚀 Empezar en Google Colab

1. Abre el archivo [`Mejorar_Imagenes_con_IA.ipynb`](./Mejorar_Imagenes_con_IA.ipynb) en GitHub.
2. Pulsa **Open in Colab** si aparece la opción, o abre [Google Colab](https://colab.research.google.com/) y carga el cuaderno desde GitHub.
3. En **Entorno de ejecución → Cambiar tipo de entorno de ejecución**, elige GPU si está disponible. La disponibilidad de GPU depende de Google Colab y no está garantizada.
4. Ejecuta las celdas en orden, desde la preparación del entorno hasta la descarga.
5. Sube una fotografía, ajusta las opciones y ejecuta la restauración.

La primera preparación puede descargar el código y los pesos necesarios. Esto requiere conexión a Internet. Si Colab reinicia el entorno, puede ser necesario volver a ejecutar la preparación.

## 📁 Carpetas utilizadas en Colab

El cuaderno trabaja con estas ubicaciones:

- Entrada temporal: `/content/Mejorar_Imagenes_con_IA/entrada`
- Resultados temporales: `/content/Mejorar_Imagenes_con_IA/resultados`
- Originales en Google Drive: `/content/drive/MyDrive/Mejorar_Imagenes_con_IA/originales`
- Resultados en Google Drive: `/content/drive/MyDrive/Mejorar_Imagenes_con_IA/resultados`

Los archivos bajo `/content` pertenecen al entorno temporal de Colab y pueden desaparecer al reiniciarse. Guarda las fotografías y resultados importantes en Drive.

## 🎚️ Consejos de uso

- Prueba primero con una fotografía y conserva el original.
- Una fidelidad más baja puede permitir una reconstrucción más intensa; revisa cada resultado porque el efecto depende de la imagen.
- La ampliación 4× genera archivos más grandes y puede tardar más que 2×.
- Las mejoras adicionales pueden aumentar el tiempo de ejecución y el uso de memoria.
- La restauración generativa puede reconstruir detalles que no estaban claramente presentes en el original. Comprueba rostros y detalles importantes antes de utilizar o compartir el resultado.

## 🧩 Dependencias y atribución

El cuaderno utiliza CodeFormer y puede utilizar Real-ESRGAN, además de PyTorch y otras bibliotecas de Python. Consulta [`LICENSES.md`](./LICENSES.md) antes de redistribuir código, pesos o versiones modificadas.

Este repositorio organiza el cuaderno y la experiencia de uso. No implica que el proyecto sea propietario de CodeFormer, Real-ESRGAN, sus pesos o las bibliotecas de terceros.

## 🔐 Datos y privacidad

No subas fotografías privadas, resultados, credenciales ni tokens al repositorio. Las imágenes que quieras conservar deben guardarse en tu almacenamiento personal de Google Drive, no en GitHub. El archivo `.gitignore` ayuda a evitar la inclusión accidental de datos locales, pero revisa siempre los cambios antes de hacer un commit.

## 🗺️ Estado del proyecto

- [x] Flujo de restauración probado en Google Colab.
- [x] Ajustes de fidelidad, ampliación y mejoras adicionales.
- [x] Comparación visual y descarga.
- [ ] Integración y versionado propio de componentes: pendiente de revisión de licencias.
- [ ] Política de licencia para el código original de este proyecto: pendiente de decisión.

## 📌 Repositorio

[github.com/Pablitus666/Mejorar_Imagenes_con_IA](https://github.com/Pablitus666/Mejorar_Imagenes_con_IA)
