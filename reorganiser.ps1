# Script de réorganisation du dossier DXF_DWG
$Host.UI.RawUI.WindowTitle = "Réorganisation du projet"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " REORGANISATION DU PROJET" -ForegroundColor Green
Write-Host " Assembleur DXF -> DWG" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Set-Location $PSScriptRoot

# Créer la structure de dossiers
Write-Host "[1/5] Création de la structure..." -ForegroundColor Yellow

$folders = @("scripts", "config", "docs")
foreach ($folder in $folders) {
    if (-Not (Test-Path $folder)) {
        New-Item -ItemType Directory -Path $folder -Force | Out-Null
        Write-Host "   Créé : $folder\" -ForegroundColor Green
    }
}

# Déplacer les scripts
Write-Host ""
Write-Host "[2/5] Organisation des scripts..." -ForegroundColor Yellow
$scripts = @("Lancer_Assembleur_DXF_DWG.bat", "Lancer_Assembleur_DXF_DWG.ps1", "creer_executable.bat", "creer_executable.ps1")
foreach ($script in $scripts) {
    if (Test-Path $script) {
        Move-Item $script "scripts\" -Force
        Write-Host "   Déplacé : $script -> scripts\" -ForegroundColor Green
    }
}

# Déplacer les configurations
Write-Host ""
Write-Host "[3/5] Organisation des configurations..." -ForegroundColor Yellow
$configs = @("assembleur.spec", "file_version_info.txt")
foreach ($config in $configs) {
    if (Test-Path $config) {
        Move-Item $config "config\" -Force
        Write-Host "   Déplacé : $config -> config\" -ForegroundColor Green
    }
}

# Créer README
Write-Host ""
Write-Host "[4/5] Création de la documentation..." -ForegroundColor Yellow
$readme = "# Assembleur DXF  DWG`n`n"
$readme += "Outil professionnel pour fusionner et convertir des fichiers DXF/DWG.`n`n"
$readme += "## Description`n`n"
$readme += "Application Windows pour :`n"
$readme += "* Extraction automatique d'archives .tar.bz2`n"
$readme += "* Fusion intelligente de fichiers DXF`n"
$readme += "* Conversion optionnelle en DWG`n"
$readme += "* Ouverture automatique dans AutoCAD`n`n"
$readme += " 2025 C.L - Pour les amis de SPiE`n"
Set-Content -Path "README.md" -Value $readme -Encoding UTF8
Write-Host "   Créé : README.md" -ForegroundColor Green

# Créer guide
$guide = "# Guide d'utilisation`n`n"
$guide += "1. Lancer l'application : Double-cliquez sur scripts\Lancer_Assembleur_DXF_DWG.bat`n"
$guide += "2. Sélectionner le dossier source`n"
$guide += "3. Choisir la destination`n"
$guide += "4. Configuration optionnelle`n"
$guide += "5. Lancer le traitement`n`n"
$guide += " 2025 C.L`n"
Set-Content -Path "docs\GUIDE_UTILISATION.md" -Value $guide -Encoding UTF8
Write-Host "   Créé : docs\GUIDE_UTILISATION.md" -ForegroundColor Green

# Créer raccourcis
Write-Host ""
Write-Host "[5/5] Création des raccourcis..." -ForegroundColor Yellow
"`@echo off`ncd /d ""%~dp0""`ncall ""scripts\Lancer_Assembleur_DXF_DWG.bat""" | Set-Content -Path "LANCER.bat" -Encoding ASCII
Write-Host "   Créé : LANCER.bat" -ForegroundColor Green
"`@echo off`ncd /d ""%~dp0""`ncall ""scripts\creer_executable.bat""" | Set-Content -Path "CREER_EXE.bat" -Encoding ASCII
Write-Host "   Créé : CREER_EXE.bat" -ForegroundColor Green

Write-Host ""
Write-Host "======================================== " -ForegroundColor Green
Write-Host " REORGANISATION TERMINEE !" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Pour lancer : Double-cliquez LANCER.bat" -ForegroundColor Yellow
Write-Host "Pour compiler : Double-cliquez CREER_EXE.bat" -ForegroundColor Yellow
Write-Host ""
Read-Host "Appuyez sur Entrée pour terminer"
