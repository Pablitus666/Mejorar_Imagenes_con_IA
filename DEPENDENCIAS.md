# Auditoría de dependencias — Mejorar_Imagenes_con_IA

## Objetivo
Reducir descargas y dependencias externas innecesarias sin cambiar el flujo de restauración que ya se probó correctamente en Google Colab.

## Estado confirmado del proyecto
- El cuaderno usa CodeFormer para restauración facial.
- El flujo puede usar Real-ESRGAN para mejorar el fondo.
- El cuaderno crea carpetas de entrada/resultados y, en Colab, puede guardar copias en Google Drive.
- La configuración actual puede clonar CodeFormer y descargar pesos si no los encuentra.
- Los pesos de los modelos no están incluidos en este repositorio.

## Dependencias por función
| Componente | Función | Tratamiento recomendado |
|---|---|---|
| Python + PyTorch | Ejecución del modelo y tensores | Mantener la versión compatible con el runtime de Colab; registrar la versión probada antes de fijar versiones |
| CodeFormer | Restauración facial | Prioridad: usar una copia local versionada del código, conservando su licencia y avisos |
| BasicSR | Infraestructura usada por CodeFormer | Instalar desde la versión compatible; verificar la licencia y las dependencias transitivas |
| FaceXLib / facelib | Detección y alineación facial | Registrar origen, versión/commit y licencia antes de copiar al repositorio |
| Real-ESRGAN | Mejora opcional del fondo | Mantener como componente opcional; auditar código, dependencias y licencia |
| Pillow, NumPy, OpenCV, torchvision y demás paquetes | Procesamiento de imágenes y ejecución | Capturar versiones desde una sesión funcional; no inventar pins sin esa captura |
| Pesos `.pth` | Parámetros entrenados de los modelos | No subir todavía: comprobar por separado las condiciones de uso y el tamaño |

## Decisiones de control de versiones
1. No subir imágenes de usuario, resultados, credenciales, cachés ni pesos al repositorio Git normal.
2. No fijar versiones arbitrarias de PyTorch/CUDA: en Colab dependen del runtime y de la GPU.
3. Antes de generar un `requirements.txt` bloqueado, ejecutar el bloque de diagnóstico en la sesión de Colab que ya funciona.
4. Guardar la salida de diagnóstico como evidencia de la configuración probada y luego convertir solo las dependencias necesarias en versiones fijadas.
5. Al incorporar código de terceros, conservar su licencia original y documentar el commit de origen. No asumir que la licencia del código cubre también los pesos.

## Licencias y distribución
La licencia de CodeFormer indica uso no comercial bajo condiciones específicas y requiere contactar a los titulares para uso comercial. Revisar la licencia completa y los avisos de cada componente antes de redistribuirlos. Los pesos se deben evaluar por separado. Esta nota es una guía operativa, no asesoramiento jurídico.

## Siguiente paso verificable
Abrir el cuaderno actual en el runtime de Colab que funciona, ejecutar el bloque `DIAGNÓSTICO DE ENTORNO` incluido en `diagnostico_entorno.py` y guardar la salida. Con esa información se podrá preparar una instalación reproducible sin alterar todavía las celdas de restauración.
