"""
DIAGNÓSTICO DE ENTORNO — Mejorar_Imagenes_con_IA
Pegar el bloque marcado en una celda nueva de Google Colab, en la sesión
conocida como funcional. Este script solo informa; no instala ni modifica nada.
"""
# --- DIAGNÓSTICO DE ENTORNO: pegar en una celda de Colab ---
import sys
import platform
import importlib.metadata as metadata

print("Python:", sys.version.replace("\n", " "))
print("Plataforma:", platform.platform())

try:
    import torch
    print("PyTorch:", torch.__version__)
    print("CUDA disponible:", torch.cuda.is_available())
    print("CUDA compilada en PyTorch:", torch.version.cuda)
    if torch.cuda.is_available():
        print("GPU:", torch.cuda.get_device_name(0))
except Exception as e:
    print("PyTorch: ERROR", repr(e))

packages = [
    # Stack que ya aporta Google Colab; el cuaderno no lo reinstala.
    "torch", "torchvision", "torchaudio",
    # Requisitos que el cuaderno instala para el flujo CodeFormer.
    "numpy", "Pillow", "opencv-python", "opencv-python-headless",
    "scipy", "scikit-image", "tqdm", "yapf", "lmdb", "pyyaml",
    "addict", "future", "requests", "tb-nightly", "lpips", "gdown",
    # Requisitos que el cuaderno instala para el flujo HYPIR.
    "accelerate", "diffusers", "transformers", "peft", "einops",
    "omegaconf", "timm", "huggingface_hub",
    # Interfaz del cuaderno y utilidades de Colab.
    "matplotlib", "ipywidgets",
]
# Nota: "basicsr", "facexlib", "gfpgan" y "realesrgan" NO se instalan como
# paquetes en este proyecto. "basicsr" y "facelib" forman parte del código
# fuente de CodeFormer y el cuaderno los importa desde esa carpeta.
print("\nVersiones de paquetes:")
for package in packages:
    try:
        print(f"{package}=={metadata.version(package)}")
    except metadata.PackageNotFoundError:
        print(f"{package}: no instalado (o nombre de distribución distinto)")
    except Exception as e:
        print(f"{package}: error al consultar ({e!r})")

print("\nRutas relevantes:")
from pathlib import Path
for p in [
    Path("/content/Mejorar_Imagenes_con_IA/CodeFormer"),
    Path("/content/CodeFormer"),
    Path("/content/drive/MyDrive/Mejorar_Imagenes_con_IA/CodeFormer"),
]:
    print(f"{p}: existe={p.exists()} ; inference_codeformer.py={(p / 'inference_codeformer.py').exists()}")
    print(
        "    módulos locales: "
        f"basicsr={(p / 'basicsr' / '__init__.py').exists()} ; "
        f"facelib={(p / 'facelib' / '__init__.py').exists()} ; "
        f"pesos/facelib={(p / 'weights' / 'facelib').is_dir()}"
    )

# Opcional: guardar el diagnóstico en un archivo descargable desde Colab.
salida = Path("/content/diagnostico_entorno_mejorar_imagenes.txt")
try:
    salida.write_text(
        "Python: " + sys.version.replace("\n", " ") + "\n"
        + "Plataforma: " + platform.platform() + "\n",
        encoding="utf-8"
    )
    print("\nResumen básico guardado en:", salida)
except Exception as e:
    print("No se pudo guardar el resumen:", repr(e))
# --- FIN DEL DIAGNÓSTICO ---
