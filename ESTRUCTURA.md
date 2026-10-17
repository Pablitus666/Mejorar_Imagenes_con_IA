# Estructura del repositorio

```text
Mejorar_Imagenes_con_IA/
├── images/                         # Imágenes y capturas del README
├── Mejorar_Imagenes_con_IA.ipynb   # Cuaderno principal de Google Colab
├── README.md                       # Descripción, características e instrucciones
├── .gitignore                      # Exclusiones de archivos locales y temporales
├── LICENSES.md                     # Licencias y atribuciones de terceros
├── CONTRIBUTING.md                 # Guía de contribución
├── DEPENDENCIAS.md                 # Información sobre dependencias
├── RELEASE_DESCRIPTION.md          # Descripción documentada del Release de modelos
├── ESTRUCTURA.md                   # Este documento
└── diagnostico_entorno.py          # Diagnóstico del entorno, si se mantiene
```

## Archivos que no se incluyen en Git

El repositorio no debe contener fotografías personales, imágenes de entrada, resultados generados, archivos de trabajo de Photoshop ni copias locales de los pesos de los modelos.

Los archivos de modelos necesarios se obtienen durante la preparación del cuaderno, según la configuración actual del proyecto y los recursos publicados en el Release.

El código fuente de CodeFormer se obtiene durante la preparación cuando el cuaderno está configurado para clonarlo desde su repositorio oficial. Antes de eliminar una copia local de CodeFormer, debe comprobarse que ninguna celda dependa de ella.

Las imágenes de la carpeta `images/` son recursos de documentación del proyecto y sí deben incluirse en el repositorio.