# Estructura del repositorio

```text
Mejorar_Imagenes_con_IA/
├── images/                         # Imágenes y capturas del README
├── .opencode/tools/                # Validar-Notebook.ps1 (validación estática)
├── Mejorar_Imagenes_con_IA.ipynb   # Cuaderno principal de Google Colab
├── Prueba_Colab_Diagnostico.ipynb  # Diagnóstico previo del entorno en Colab
├── README.md                       # Descripción, características e instrucciones
├── .gitignore                      # Exclusiones de archivos locales y temporales
├── LICENSES.md                     # Licencias y atribuciones de terceros
├── CONTRIBUTING.md                 # Guía de contribución
├── DEPENDENCIAS.md                 # Información sobre dependencias
├── RELEASE_DESCRIPTION.md          # Descripción documentada del Release de modelos
├── ESTRUCTURA.md                   # Este documento
└── diagnostico_entorno.py          # Diagnóstico del entorno, si se mantiene
```

## Cuadernos

- `Mejorar_Imagenes_con_IA.ipynb` es el flujo completo: preparación, carga de la fotografía, restauración, comparación, descarga y diagnóstico posterior.
- `Prueba_Colab_Diagnostico.ipynb` es un diagnóstico previo de solo lectura: comprueba GPU, versiones, red, pesos y el estado de una preparación anterior, y genera un informe `diagnostico_colab_*.txt`. No instala paquetes ni modifica el proyecto.

## Validación del cuaderno

`.opencode/tools/Validar-Notebook.ps1` (PowerShell 7) revisa la estructura del `.ipynb`, la sintaxis de las celdas con Python, las salidas y los widgets obsoletos, sin instalar dependencias ni ejecutar el cuaderno.

```powershell
pwsh -NoProfile -File .opencode/tools/Validar-Notebook.ps1 -Detailed
```

## Archivos que no se incluyen en Git

El repositorio no debe contener fotografías personales, imágenes de entrada, resultados generados, archivos de trabajo de Photoshop ni copias locales de los pesos de los modelos.

Los archivos de modelos necesarios se obtienen durante la preparación del cuaderno, según la configuración actual del proyecto y los recursos publicados en el Release.

El código fuente de CodeFormer se obtiene durante la preparación cuando el cuaderno está configurado para clonarlo desde su repositorio oficial. Antes de eliminar una copia local de CodeFormer, debe comprobarse que ninguna celda dependa de ella.

Las imágenes de la carpeta `images/` son recursos de documentación del proyecto y sí deben incluirse en el repositorio.

Tampoco se versionan las notas de sesión (`HANDOFF_*.md`), los informes de diagnóstico (`diagnosticos/`, `diagnostico_post_*.txt`, `diagnostico_colab_*.txt`) ni la configuración local del agente (`.opencode/agents/`): son material de trabajo que puede contener rutas locales. El validador de `.opencode/tools/` sí se versiona.