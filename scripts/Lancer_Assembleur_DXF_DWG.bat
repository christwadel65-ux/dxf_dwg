@echo off
:: ============================================================
:: Lanceur Assembleur DXF -> DWG
:: Pour les amis de SPiE - © C.L
:: ============================================================

title Assembleur DXF - DWG
color 0A

echo.
echo ========================================
echo  ASSEMBLEUR DXF ^-^> DWG
echo  Chargement en cours...
echo ========================================
echo.

:: Changer vers le dossier du script
cd /d "%~dp0"

:: Vérifier si l'environnement virtuel existe
if not exist ".venv\Scripts\python.exe" (
    color 0C
    echo [ERREUR] Environnement virtuel Python introuvable !
    echo.
    echo Le dossier .venv\Scripts\python.exe n'existe pas.
    echo Veuillez installer l'environnement virtuel avant de continuer.
    echo.
    pause
    exit /b 1
)

:: Lancer l'application Python
echo Lancement de l'application...
echo.

".venv\Scripts\python.exe" "assembleur_dxf_dwg.py"

:: Si le programme se termine avec une erreur, afficher le message
if errorlevel 1 (
    color 0C
    echo.
    echo ========================================
    echo  ERREUR LORS DE L'EXECUTION
    echo ========================================
    echo.
    pause
    exit /b 1
)

exit /b 0
