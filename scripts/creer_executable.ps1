# ============================================================
# Création d'un exécutable portable (PowerShell)
# Assembleur DXF -> DWG
# ============================================================

$Host.UI.RawUI.WindowTitle = "Création Exécutable Portable"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " CREATION EXECUTABLE PORTABLE" -ForegroundColor Green
Write-Host " Assembleur DXF -> DWG" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Set-Location $PSScriptRoot

# Vérifier l'environnement virtuel
if (-Not (Test-Path ".\.venv\Scripts\python.exe")) {
    Write-Host "[ERREUR] Environnement virtuel introuvable !" -ForegroundColor Red
    Read-Host "Appuyez sur Entrée pour quitter"
    exit 1
}

# Activer et installer PyInstaller
Write-Host "[1/4] Installation de PyInstaller..." -ForegroundColor Yellow
& ".\.venv\Scripts\pip.exe" install pyinstaller | Out-Null

# Compiler l'application
Write-Host ""
Write-Host "[2/4] Compilation de l'application..." -ForegroundColor Yellow
Write-Host "Cela peut prendre plusieurs minutes..." -ForegroundColor Gray
Write-Host ""

$process = Start-Process -FilePath ".\.venv\Scripts\pyinstaller.exe" `
    -ArgumentList @(
        "--name=Assembleur_DXF_DWG",
        "--onefile",
        "--windowed",
        "--noconfirm",
        "assembleur_dxf_dwg.py"
    ) `
    -NoNewWindow -Wait -PassThru

if ($process.ExitCode -ne 0) {
    Write-Host ""
    Write-Host "[ERREUR] La compilation a échoué !" -ForegroundColor Red
    Read-Host "Appuyez sur Entrée pour quitter"
    exit 1
}

# Créer le package portable
Write-Host ""
Write-Host "[3/4] Création du package portable..." -ForegroundColor Yellow

$portableDir = "Assembleur_DXF_DWG_Portable"
if (-Not (Test-Path $portableDir)) {
    New-Item -ItemType Directory -Path $portableDir | Out-Null
}

Copy-Item "dist\Assembleur_DXF_DWG.exe" -Destination $portableDir -Force

# Créer README
$readme = @"
Assembleur DXF -> DWG - Version Portable
================================================

Double-cliquez sur Assembleur_DXF_DWG.exe pour lancer

Aucune installation requise !

Pour la conversion DWG, ODA File Converter doit être installé.

© 2025 C.L - Pour les amis de SPiE
"@

Set-Content -Path "$portableDir\README.txt" -Value $readme -Encoding UTF8

# Afficher résumé
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host " CREATION TERMINEE !" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Exécutable créé dans : $portableDir\" -ForegroundColor Cyan

$exeSize = (Get-Item "$portableDir\Assembleur_DXF_DWG.exe").Length / 1MB
Write-Host "Taille : $([math]::Round($exeSize, 2)) MB" -ForegroundColor Cyan

Write-Host ""
Write-Host "Vous pouvez copier le dossier $portableDir" -ForegroundColor Yellow
Write-Host "sur n'importe quel PC Windows sans installation !" -ForegroundColor Yellow
Write-Host ""

$response = Read-Host "Ouvrir le dossier ? (O/N)"
if ($response -eq "O" -or $response -eq "o") {
    Start-Process $portableDir
}
