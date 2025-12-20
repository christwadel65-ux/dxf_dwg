# ============================================================
# Lanceur PowerShell - Assembleur DXF -> DWG
# Pour les amis de SPiE - © C.L
# ============================================================

# Définir le titre de la fenêtre
$Host.UI.RawUI.WindowTitle = "Assembleur DXF -> DWG"

Write-Host ""
Write-Host "========================================"  -ForegroundColor Cyan
Write-Host " ASSEMBLEUR DXF -> DWG"  -ForegroundColor Green
Write-Host " Chargement en cours..."  -ForegroundColor Yellow
Write-Host "========================================"  -ForegroundColor Cyan
Write-Host ""

# Se déplacer vers le dossier du script
Set-Location $PSScriptRoot

# Vérifier si l'environnement virtuel existe
if (-Not (Test-Path ".\.venv\Scripts\python.exe")) {
    Write-Host "[ERREUR] Environnement virtuel Python introuvable !" -ForegroundColor Red
    Write-Host ""
    Write-Host "Le dossier .venv\Scripts\python.exe n'existe pas." -ForegroundColor Yellow
    Write-Host "Veuillez installer l'environnement virtuel avant de continuer." -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Appuyez sur Entrée pour quitter"
    exit 1
}

# Lancer l'application Python
Write-Host "Lancement de l'application..." -ForegroundColor Green
Write-Host ""

& ".\.venv\Scripts\python.exe" ".\assembleur_dxf_dwg.py"

# Vérifier le code de sortie
if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Red
    Write-Host " ERREUR LORS DE L'EXECUTION" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Red
    Write-Host ""
    Read-Host "Appuyez sur Entrée pour quitter"
    exit 1
}

exit 0
