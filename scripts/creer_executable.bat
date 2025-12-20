@echo off
:: ============================================================
:: Création d'un exécutable portable
:: Assembleur DXF -> DWG
:: ============================================================

title Création Exécutable Portable
color 0B

echo.
echo ========================================
echo  CREATION EXECUTABLE PORTABLE
echo  Assembleur DXF -^> DWG
echo ========================================
echo.

cd /d "%~dp0"
cd ..

:: Vérifier l'environnement virtuel
if not exist ".venv\Scripts\python.exe" (
    color 0C
    echo [ERREUR] Environnement virtuel introuvable !
    echo.
    echo Dossier courant : %CD%
    echo Le dossier .venv\Scripts\python.exe n'existe pas.
    echo.
    pause
    exit /b 1
)

:: Activer l'environnement virtuel
echo [1/4] Activation environnement virtuel...
call .venv\Scripts\activate.bat

:: Installer PyInstaller si nécessaire
echo.
echo [2/4] Vérification de PyInstaller...
.venv\Scripts\python.exe -m pip show pyinstaller >nul 2>&1
if errorlevel 1 (
    echo PyInstaller non installe. Installation en cours...
    .venv\Scripts\python.exe -m pip install pyinstaller
) else (
    echo PyInstaller deja installe.
)

:: Créer le dossier de sortie
if not exist "dist" mkdir dist
if not exist "build" mkdir build

:: Compiler l'application
echo.
echo [3/4] Compilation de l'application...
echo Cela peut prendre plusieurs minutes...
echo.

.venv\Scripts\pyinstaller.exe --name="Assembleur_DXF_DWG" ^
    --onefile ^
    --windowed ^
    --add-data="assembleur_dxf_dwg.py;." ^
    --hidden-import=ezdxf ^
    --hidden-import=ezdxf.addons ^
    --hidden-import=PyQt5 ^
    --hidden-import=win32com.client ^
    --noconfirm ^
    assembleur_dxf_dwg.py

if errorlevel 1 (
    color 0C
    echo.
    echo [ERREUR] La compilation a echoue !
    echo.
    echo Verifiez que tous les modules sont installes :
    echo   pip install -r requirements.txt
    echo.
    pause
    exit /b 1
)

:: Créer un dossier portable
echo.
echo [4/4] Création du package portable...

if not exist "Assembleur_DXF_DWG_Portable" mkdir Assembleur_DXF_DWG_Portable

copy "dist\Assembleur_DXF_DWG.exe" "Assembleur_DXF_DWG_Portable\" >nul

:: Créer un README
echo Assembleur DXF -^> DWG - Version Portable > "Assembleur_DXF_DWG_Portable\README.txt"
echo ================================================ >> "Assembleur_DXF_DWG_Portable\README.txt"
echo. >> "Assembleur_DXF_DWG_Portable\README.txt"
echo Double-cliquez sur Assembleur_DXF_DWG.exe pour lancer >> "Assembleur_DXF_DWG_Portable\README.txt"
echo. >> "Assembleur_DXF_DWG_Portable\README.txt"
echo Aucune installation requise ! >> "Assembleur_DXF_DWG_Portable\README.txt"
echo. >> "Assembleur_DXF_DWG_Portable\README.txt"
echo Pour la conversion DWG, ODA File Converter doit être installé. >> "Assembleur_DXF_DWG_Portable\README.txt"
echo. >> "Assembleur_DXF_DWG_Portable\README.txt"
echo (c) 2025 C.L - Pour les amis de SPiE >> "Assembleur_DXF_DWG_Portable\README.txt"

color 0A
echo.
echo ========================================
echo  CREATION TERMINEE !
echo ========================================
echo.
echo Exécutable créé dans : Assembleur_DXF_DWG_Portable\
echo Taille : 
dir "Assembleur_DXF_DWG_Portable\Assembleur_DXF_DWG.exe" | find "Assembleur"
echo.
echo Vous pouvez copier le dossier Assembleur_DXF_DWG_Portable
echo sur n'importe quel PC Windows sans installation !
echo.
echo Ouvrir le dossier ? (O/N)
set /p choix=
if /i "%choix%"=="O" start "" "Assembleur_DXF_DWG_Portable"

pause
