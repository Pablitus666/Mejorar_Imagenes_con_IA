#Requires -Version 7.0
<#
.SYNOPSIS
    Validación estática del cuaderno Mejorar_Imagenes_con_IA.ipynb.

.DESCRIPTION
    Comprueba la estructura JSON del notebook, extrae las celdas de código y
    valida su sintaxis con Python (gramática actual y gramática compatible con
    la versión de Python usada en Colab). También detecta rutas de Colab
    hardcodeadas, operaciones destructivas, llamadas de red, salidas y estado
    de widgets obsoletos, y deriva de versiones en la documentación.

    No instala dependencias, no descarga nada y no ejecuta el cuaderno.
    Solo lee el .ipynb. Con -Backup crea una copia fechada antes de trabajar.

.PARAMETER Notebook
    Ruta del .ipynb. Por defecto, el cuaderno del proyecto.

.PARAMETER Python
    Ejecutable de Python para validar sintaxis (por defecto: python).

.PARAMETER ColabPython
    Versión de Python usada por Colab para comprobar gramática compatible
    (por defecto: 3.11). Solo comprueba sintaxis, no APIs ni paquetes.

.PARAMETER Backup
    Crea una copia "<notebook>.<fecha>.bak" antes de validar.

.PARAMETER ListCells
    Muestra el mapa de celdas (índice, tipo, líneas, primera línea).

.PARAMETER Search
    Expresión regular que se buscará en el texto de todas las celdas.

.PARAMETER Detailed
    Muestra el detalle de todos los hallazgos y la tabla de celdas.

.PARAMETER Strict
    Devuelve código de salida 1 también cuando solo hay advertencias.

.PARAMETER KeepTemp
    Conserva el directorio temporal con las celdas extraídas.

.EXAMPLE
    pwsh -NoProfile -File .opencode/tools/Validar-Notebook.ps1 -Backup -Detailed

.EXAMPLE
    pwsh -NoProfile -File .opencode/tools/Validar-Notebook.ps1 -ListCells

.EXAMPLE
    pwsh -NoProfile -File .opencode/tools/Validar-Notebook.ps1 -Search 'shutil\.rmtree'

.NOTES
    Salida: 0 = sin errores; 1 = errores (o advertencias con -Strict); 2 = uso incorrecto.
#>
[CmdletBinding()]
param(
    [string]$Notebook,
    [string]$Python = 'python',
    [string]$ColabPython = '3.11',
    [switch]$Backup,
    [switch]$ListCells,
    [string]$Search,
    [switch]$Detailed,
    [switch]$Strict,
    [switch]$KeepTemp
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# Consola en UTF-8 para que los acentos se muestren correctamente en Windows.
try {
    [Console]::OutputEncoding = [Text.UTF8Encoding]::new($false)
    $OutputEncoding = [Text.UTF8Encoding]::new($false)
}
catch {
    # Algunos hosts no permiten cambiar la codificación; no es un error.
}

$script:Errores = [Collections.Generic.List[string]]::new()
$script:Advertencias = [Collections.Generic.List[string]]::new()
$script:Infos = [Collections.Generic.List[string]]::new()

function Add-Error([string]$Message) { $script:Errores.Add($Message) }
function Add-Warning([string]$Message) { $script:Advertencias.Add($Message) }
function Add-Info([string]$Message) { $script:Infos.Add($Message) }

function Get-Prop {
    param(
        [Parameter(Mandatory = $false)] [object]$Object,
        [Parameter(Mandatory = $true)] [string]$Name
    )
    if ($null -eq $Object) { return $null }
    $property = $Object.PSObject.Properties[$Name]
    if ($null -eq $property) { return $null }
    return $property.Value
}

function Get-CellSource {
    param([Parameter(Mandatory = $true)] [object]$Cell)
    $source = Get-Prop -Object $Cell -Name 'source'
    if ($null -eq $source) { return '' }
    if ($source -is [string]) { return $source }
    return (@($source) -join '')
}

function Write-Section([string]$Title) {
    Write-Host ''
    Write-Host $Title -ForegroundColor Cyan
    Write-Host ('-' * $Title.Length) -ForegroundColor DarkCyan
}

# ---------------------------------------------------------------------------
# 0. Resolver el cuaderno y crear respaldo opcional
# ---------------------------------------------------------------------------
if ([string]::IsNullOrWhiteSpace($Notebook)) {
    $projectRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
    $Notebook = Join-Path $projectRoot 'Mejorar_Imagenes_con_IA.ipynb'
}

if (-not (Test-Path -LiteralPath $Notebook -PathType Leaf)) {
    Write-Host "ERROR: no existe el cuaderno: $Notebook" -ForegroundColor Red
    exit 2
}

$nbPath = (Resolve-Path -LiteralPath $Notebook).Path

if ($Backup) {
    $stamp = Get-Date -Format 'yyyyMMdd_HHmmss'
    $backupPath = "$nbPath.$stamp.bak"
    Copy-Item -LiteralPath $nbPath -Destination $backupPath -Force
    Write-Host "Respaldo creado: $backupPath" -ForegroundColor Cyan
}

$shaBefore = (Get-FileHash -LiteralPath $nbPath -Algorithm SHA256).Hash.ToLowerInvariant()
$bytes = [IO.File]::ReadAllBytes($nbPath)
$bom = if ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) { 'UTF-8 con BOM' } else { 'sin BOM' }

# ---------------------------------------------------------------------------
# 1. Leer y validar el JSON
# ---------------------------------------------------------------------------
$raw = [IO.File]::ReadAllText($nbPath, [Text.UTF8Encoding]::new($false))
try {
    $nb = $raw | ConvertFrom-Json -Depth 100
}
catch {
    Write-Host "ERROR: el archivo no es JSON válido: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

$topNames = @($nb.PSObject.Properties.Name)
if ($topNames -notcontains 'cells') {
    Write-Host "ERROR: el notebook no tiene la propiedad 'cells'." -ForegroundColor Red
    exit 1
}

$nbformat = Get-Prop -Object $nb -Name 'nbformat'
$nbformatMinor = Get-Prop -Object $nb -Name 'nbformat_minor'
$metadata = Get-Prop -Object $nb -Name 'metadata'
$cells = @(Get-Prop -Object $nb -Name 'cells')

if ($nbformat -ne 4) {
    Add-Warning "nbformat = $nbformat; se esperaba 4 (Jupyter Notebook actual)."
}
if ($cells.Count -eq 0) {
    Add-Error 'El notebook no contiene celdas.'
}

# ---------------------------------------------------------------------------
# 2. Recorrer celdas
# ---------------------------------------------------------------------------
$cellMap = [Collections.Generic.List[object]]::new()
$cellIds = @{}
$codeCount = 0
$markdownCount = 0
$rawCount = 0
$totalOutputs = 0

for ($index = 0; $index -lt $cells.Count; $index++) {
    $cell = $cells[$index]
    $type = [string](Get-Prop -Object $cell -Name 'cell_type')
    $source = Get-CellSource -Cell $cell
    $lineCount = if ($source.Length -eq 0) { 0 } else { ($source -split "\r?\n").Count }
    # No usar Get-Prop para 'outputs': una lista vacía se desenrolla a $null al
    # volver de una función y se confundiría con una propiedad ausente.
    $outputsProperty = $cell.PSObject.Properties['outputs']
    $outputs = if ($null -ne $outputsProperty) { @($outputsProperty.Value) } else { $null }
    $outputCount = if ($null -eq $outputs) { 0 } else { $outputs.Count }
    $totalOutputs += $outputCount

    $firstLine = ''
    if (-not [string]::IsNullOrWhiteSpace($source)) {
        $candidate = @($source -split "\r?\n" | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | Select-Object -First 1)
        if ($candidate.Count -gt 0) { $firstLine = ([string]$candidate[0]).Trim() }
    }
    if ($firstLine.Length -gt 88) { $firstLine = $firstLine.Substring(0, 85) + '...' }

    switch ($type) {
        'code' { $codeCount++ }
        'markdown' { $markdownCount++ }
        'raw' { $rawCount++ }
        default { Add-Error "Celda $index tiene un cell_type no válido: '$type'." }
    }

    if ($source.Length -eq 0) {
        Add-Warning "Celda $index ($type) está vacía."
    }

    if ($type -eq 'code') {
        if ($null -eq $outputsProperty) {
            Add-Error "Celda $index (code) no tiene la propiedad 'outputs'."
        }
        elseif ($outputCount -gt 0) {
            Add-Warning "Celda $index conserva $outputCount salida(s); límpialas antes de publicar para evitar datos personales y reducir tamaño."
        }

        $executionCount = Get-Prop -Object $cell -Name 'execution_count'
        if ($null -ne $executionCount) {
            Add-Info "Celda $index conserva execution_count=$executionCount."
        }
    }

    $cellId = [string](Get-Prop -Object $cell -Name 'id')
    if (-not [string]::IsNullOrWhiteSpace($cellId)) {
        if ($cellIds.ContainsKey($cellId)) {
            Add-Error "ID de celda duplicado '$cellId' en las celdas $($cellIds[$cellId]) y $index."
        }
        else {
            $cellIds[$cellId] = $index
        }
    }

    if ($type -eq 'code' -and $source -match '(?m)^\t') {
        Add-Warning "Celda $index contiene líneas que empiezan con tabulador; usa espacios."
    }

    $cellMap.Add([pscustomobject]@{
            Index      = $index
            Tipo       = $type
            Lineas     = $lineCount
            Caracteres = $source.Length
            Salidas    = $outputCount
            Primera    = $firstLine
            Source     = $source
        })
}

# Estado de widgets: pesa mucho y suele quedar obsoleto tras ejecutar el notebook.
$widgets = Get-Prop -Object $metadata -Name 'widgets'
$widgetState = Get-Prop -Object $widgets -Name 'application/vnd.jupyter.widget-state+json'
$state = Get-Prop -Object $widgetState -Name 'state'
if ($null -ne $state) {
    $widgetCount = @($state.PSObject.Properties).Count
    if ($widgetCount -gt 0) {
        Add-Warning "metadata.widgets conserva estado de $widgetCount widgets (incluye etiquetas y selecciones de una sesión anterior). Límpialo antes de publicar."
    }
}

# ---------------------------------------------------------------------------
# 3. Cabecera del informe
# ---------------------------------------------------------------------------
Write-Section 'Validación estática del cuaderno'
Write-Host "Archivo : $nbPath"
Write-Host "SHA-256 : $shaBefore"
Write-Host "Formato : nbformat $nbformat.$nbformatMinor; $bom"
Write-Host "Celdas  : $($cells.Count) ($codeCount código, $markdownCount markdown, $rawCount raw); $totalOutputs salida(s)"
Write-Host "Python  : $ColabPython (gramática objetivo); ejecutable '$Python'"

# ---------------------------------------------------------------------------
# 4. Validar sintaxis Python de las celdas de código
# ---------------------------------------------------------------------------
$tempRoot = Join-Path ([IO.Path]::GetTempPath()) ('validar_nb_' + [guid]::NewGuid().ToString('N'))
$cellsDir = Join-Path $tempRoot 'cells'
New-Item -ItemType Directory -Path $cellsDir -Force | Out-Null

$extracted = 0
foreach ($item in $cellMap) {
    if ($item.Tipo -ne 'code') { continue }
    if ($item.Source -match '(?m)^\s*(?:%|!)') {
        Add-Warning "Celda $($item.Index) contiene magics de IPython ('%' o '!'); se omite la comprobación de sintaxis."
        continue
    }
    $cellFile = Join-Path $cellsDir ('cell_{0:D3}.py' -f $item.Index)
    [IO.File]::WriteAllText($cellFile, $item.Source, [Text.UTF8Encoding]::new($false))
    $extracted++
}

$syntaxResults = @()
if ($extracted -gt 0) {
    if ($ColabPython -notmatch '^\d+\.\d+$') {
        Add-Warning "ColabPython='$ColabPython' no tiene el formato X.Y; se usará 3.11."
        $ColabPython = '3.11'
    }

    $pythonExe = $null
    try {
        $pythonExe = (Get-Command -Name $Python -ErrorAction Stop).Source
    }
    catch {
        Add-Warning "No se encontró el ejecutable Python '$Python'; se omite la comprobación de sintaxis."
    }

    if ($null -ne $pythonExe) {
        $helperCode = @'
import ast
import json
import sys
from pathlib import Path

root = Path(sys.argv[1])
version = sys.argv[2]
out_path = Path(sys.argv[3])
major, minor = (int(part) for part in version.split('.'))

results = []
for path in sorted(root.glob('cell_*.py')):
    source = path.read_text(encoding='utf-8')
    cell = int(path.stem.split('_')[-1])
    item = {'cell': cell, 'ok': True, 'stage': 'ok', 'line': None, 'message': ''}
    try:
        compile(source, str(path), 'exec')
    except SyntaxError as exc:
        item.update(ok=False, stage='python_actual', line=exc.lineno, message=exc.msg)
    except Exception as exc:
        item.update(ok=False, stage='python_actual', line=None, message=f'{type(exc).__name__}: {exc}')
    else:
        try:
            ast.parse(source, filename=str(path), feature_version=(major, minor))
        except SyntaxError as exc:
            item.update(ok=False, stage=f'python_{version}', line=exc.lineno, message=exc.msg)
        except Exception as exc:
            item.update(ok=False, stage=f'python_{version}', line=None, message=f'{type(exc).__name__}: {exc}')
    results.append(item)

out_path.write_text(json.dumps(results, ensure_ascii=False), encoding='utf-8')
'@
        $helperPath = Join-Path $tempRoot '_validar_sintaxis.py'
        $jsonPath = Join-Path $tempRoot 'sintaxis.json'
        $errPath = Join-Path $tempRoot 'python.err'
        [IO.File]::WriteAllText($helperPath, $helperCode, [Text.UTF8Encoding]::new($false))

        $previousEncoding = $env:PYTHONIOENCODING
        $env:PYTHONIOENCODING = 'utf-8'
        try {
            & $pythonExe $helperPath $cellsDir $ColabPython $jsonPath 2>$errPath
            $pythonExit = $LASTEXITCODE
        }
        finally {
            if ($null -eq $previousEncoding) {
                Remove-Item Env:PYTHONIOENCODING -ErrorAction SilentlyContinue
            }
            else {
                $env:PYTHONIOENCODING = $previousEncoding
            }
        }

        if ($pythonExit -ne 0) {
            $errorText = if (Test-Path -LiteralPath $errPath) { Get-Content -LiteralPath $errPath -Raw -Encoding UTF8 } else { '' }
            Add-Error "Python terminó con código $pythonExit al validar sintaxis. $errorText"
        }
        elseif (Test-Path -LiteralPath $jsonPath) {
            try {
                $syntaxResults = @(Get-Content -LiteralPath $jsonPath -Raw -Encoding UTF8 | ConvertFrom-Json)
            }
            catch {
                Add-Error "No se pudo leer el resultado de sintaxis: $($_.Exception.Message)"
            }
        }
        else {
            Add-Error 'Python no generó el archivo de resultados de sintaxis.'
        }

        foreach ($result in $syntaxResults) {
            if (-not $result.ok) {
                Add-Error "Celda $($result.cell): sintaxis incompatible o inválida ($($result.stage), línea $($result.line)): $($result.message)"
            }
        }
    }
}

# ---------------------------------------------------------------------------
# 5. Búsqueda solicitada por el usuario
# ---------------------------------------------------------------------------
$searchHits = 0
if (-not [string]::IsNullOrWhiteSpace($Search)) {
    try {
        $searchRegex = [regex]::new($Search, [Text.RegularExpressions.RegexOptions]::IgnoreCase)
    }
    catch {
        Write-Host "ERROR: expresión regular inválida: $($_.Exception.Message)" -ForegroundColor Red
        exit 2
    }

    Write-Section "Coincidencias de '$Search'"
    foreach ($item in $cellMap) {
        $lines = $item.Source -split "\r?\n"
        for ($n = 0; $n -lt $lines.Count; $n++) {
            if ($searchRegex.IsMatch($lines[$n])) {
                $searchHits++
                if ($searchHits -le 200) {
                    $text = $lines[$n].Trim()
                    if ($text.Length -gt 180) { $text = $text.Substring(0, 177) + '...' }
                    Write-Host ("  celda {0}, línea {1}: {2}" -f $item.Index, ($n + 1), $text)
                }
            }
        }
    }
    if ($searchHits -eq 0) {
        Write-Host '  (sin coincidencias)'
    }
    elseif ($searchHits -gt 200) {
        Add-Warning "La búsqueda '$Search' produjo $searchHits coincidencias; solo se muestran las primeras 200."
    }
}

# ---------------------------------------------------------------------------
# 6. Comprobaciones heurísticas del proyecto
# ---------------------------------------------------------------------------
Write-Section 'Indicios en el código'

$checks = @(
    [pscustomobject]@{ Patron = '/content/'; Nivel = 'Aviso'; Detalle = "Rutas de Colab hardcodeadas ('/content/')"; Max = 2 }
    [pscustomobject]@{ Patron = 'shutil\.rmtree\('; Nivel = 'Aviso'; Detalle = 'Borrados recursivos con shutil.rmtree'; Max = 2 }
    [pscustomobject]@{ Patron = 'except\s+Exception'; Nivel = 'Aviso'; Detalle = 'Capturas amplias de Exception'; Max = 2 }
    [pscustomobject]@{ Patron = '^\s*except\s*:'; Nivel = 'Aviso'; Detalle = 'except desnudo (oculta errores)'; Max = 2 }
    [pscustomobject]@{ Patron = 'TODO|FIXME|XXX|HACK'; Nivel = 'Info'; Detalle = 'Marcadores pendientes'; Max = 2 }
    [pscustomobject]@{ Patron = 'urlopen|hf_hub_download|snapshot_download|requests\.'; Nivel = 'Info'; Detalle = 'Llamadas de red'; Max = 1 }
    [pscustomobject]@{ Patron = '\.write_text\('; Nivel = 'Info'; Detalle = 'Escrituras de archivos de texto'; Max = 1 }
    [pscustomobject]@{ Patron = 'files\.(upload|download)'; Nivel = 'Info'; Detalle = 'Transferencia de archivos de Colab'; Max = 1 }
    [pscustomobject]@{ Patron = 'Image\.verify\(\)'; Nivel = 'Info'; Detalle = 'Uso de Image.verify() (debe reabrirse la imagen después)'; Max = 1 }
    [pscustomobject]@{ Patron = 'subprocess\.run\('; Nivel = 'Info'; Detalle = 'Subprocesos externos'; Max = 1 }
)

foreach ($check in $checks) {
    $regex = [regex]::new($check.Patron)
    $hits = 0
    $shown = 0
    foreach ($item in $cellMap) {
        if ($item.Tipo -notin @('code', 'markdown')) { continue }
        $lines = $item.Source -split "\r?\n"
        for ($n = 0; $n -lt $lines.Count; $n++) {
            if (-not $regex.IsMatch($lines[$n])) { continue }
            $hits++
            if ($Detailed -or $shown -lt $check.Max) {
                $text = $lines[$n].Trim()
                if ($text.Length -gt 160) { $text = $text.Substring(0, 157) + '...' }
                Write-Host ("  [celda {0}, línea {1}] {2}" -f $item.Index, ($n + 1), $text) -ForegroundColor DarkGray
                $shown++
            }
        }
    }

    if ($hits -eq 0) { continue }
    $message = "{0}: {1} coincidencia(s)." -f $check.Detalle, $hits
    switch ($check.Nivel) {
        'Aviso' { Add-Warning $message }
        'Error' { Add-Error $message }
        default { Add-Info $message }
    }
}

# subprocess.run sin timeout (heurística por celda)
foreach ($item in $cellMap) {
    if ($item.Tipo -ne 'code') { continue }
    if ($item.Source -match 'subprocess\.run\(' -and $item.Source -notmatch 'timeout\s*=') {
        Add-Warning "Celda $($item.Index) llama a subprocess.run sin 'timeout='; puede quedarse bloqueada."
    }
}

# Deriva de versiones en metadatos y documentación.
$metadataTitle = [string](Get-Prop -Object $metadata -Name 'title')
$mejorarIa = Get-Prop -Object $metadata -Name 'mejorar_ia'
$metadataVersion = [string](Get-Prop -Object $mejorarIa -Name 'version')
$titleMatch = [regex]::Match($metadataTitle, 'v(\d+)')
$versionMatch = [regex]::Match($metadataVersion, 'v(\d+)')
if ($titleMatch.Success -and $versionMatch.Success -and $titleMatch.Groups[1].Value -ne $versionMatch.Groups[1].Value) {
    Add-Warning "Deriva de versión: metadata.title='$metadataTitle' frente a metadata.mejorar_ia.version='$metadataVersion'."
}

$legacyNote = [string](Get-Prop -Object $metadata -Name 'v4_experimental_note')
if (-not [string]::IsNullOrWhiteSpace($legacyNote)) {
    Add-Info "metadata.v4_experimental_note sigue presente: '$legacyNote'."
}

$versionMentions = 0
foreach ($item in $cellMap) {
    if ($item.Tipo -ne 'markdown') { continue }
    $versionMentions += ([regex]::Matches($item.Source, 'Versi[oó]n\s+v\d+')).Count
}
if ($versionMentions -gt 0) {
    Add-Info "La documentación menciona 'Versión vN' $versionMentions vez/veces; contrástalo con metadata.mejorar_ia.version."
}

# ---------------------------------------------------------------------------
# 7. Informe
# ---------------------------------------------------------------------------
$shaAfter = (Get-FileHash -LiteralPath $nbPath -Algorithm SHA256).Hash.ToLowerInvariant()
if ($shaAfter -ne $shaBefore) {
    Add-Error 'El cuaderno cambió durante la validación; el validador no debe modificar el archivo.'
}

if ($ListCells -or $Detailed) {
    Write-Section 'Mapa de celdas'
    $cellMap |
        Select-Object Index, Tipo, Lineas, Caracteres, Salidas, Primera |
        Format-Table -AutoSize |
        Out-String -Width 220 |
        Write-Host
}

Write-Section 'Hallazgos'
if ($script:Errores.Count -eq 0 -and $script:Advertencias.Count -eq 0 -and $script:Infos.Count -eq 0) {
    Write-Host 'Sin hallazgos.' -ForegroundColor Green
}
else {
    foreach ($message in $script:Errores) { Write-Host "  ERROR   $message" -ForegroundColor Red }
    foreach ($message in $script:Advertencias) { Write-Host "  AVISO   $message" -ForegroundColor Yellow }
    foreach ($message in $script:Infos) { Write-Host "  INFO    $message" -ForegroundColor Gray }
}

Write-Host ''
Write-Host ("Resultado: {0} error(es), {1} advertencia(s), {2} información(es)." -f $script:Errores.Count, $script:Advertencias.Count, $script:Infos.Count)
if ($shaAfter -eq $shaBefore) {
    Write-Host 'El cuaderno no fue modificado.' -ForegroundColor Green
}

if ($KeepTemp) {
    Write-Host "Temporal conservado: $tempRoot" -ForegroundColor Cyan
}
else {
    Remove-Item -LiteralPath $tempRoot -Recurse -Force -ErrorAction SilentlyContinue
}

if ($script:Errores.Count -gt 0 -or ($Strict -and $script:Advertencias.Count -gt 0)) {
    exit 1
}
exit 0
