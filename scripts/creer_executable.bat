@echo off
:: ============================================================
:: Création d'un exécutable portable
:: Assembleur DXF -> DWG (v1.3)
:: ============================================================

title Création Exécutable Portable - Assembleur DXF
color 0B

echo.
echo ========================================
echo  CREATION EXECUTABLE PORTABLE v1.3
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
    echo Solution :
    echo   python -m venv .venv
    echo   .venv\Scripts\pip install -r requirements.txt
    echo.
    pause
    exit /b 1
)

:: Activer l'environnement virtuel
echo [1/5] Activation environnement virtuel...
call .venv\Scripts\activate.bat

:: Vérifier que les dépendances sont installées
echo.
echo [2/5] Vérification des dépendances...
.venv\Scripts\python.exe -m pip show ezdxf >nul 2>&1
if errorlevel 1 (
    echo Dépendances manquantes. Installation en cours...
    .venv\Scripts\python.exe -m pip install -r requirements.txt
    if errorlevel 1 (
        color 0C
        echo [ERREUR] Impossible d'installer les dépendances !
        pause
        exit /b 1
    )
) else (
    echo Dépendances OK.
)

:: Installer PyInstaller si nécessaire
echo.
echo [3/5] Vérification de PyInstaller...
.venv\Scripts\python.exe -m pip show pyinstaller >nul 2>&1
if errorlevel 1 (
    echo PyInstaller non installe. Installation en cours...
    .venv\Scripts\python.exe -m pip install pyinstaller
    if errorlevel 1 (
        color 0C
        echo [ERREUR] Impossible d'installer PyInstaller !
        pause
        exit /b 1
    )
) else (
    echo PyInstaller deja installe.
)

:: Créer le dossier de sortie
if not exist "dist" mkdir dist
if not exist "build" mkdir build

:: Nettoyer les builds précédentes
echo Nettoyage des builds précédentes...
for /d %%i in ("build\*") do (
    rmdir /s /q "%%i" >nul 2>&1
)
del /q "dist\Assembleur_DXF_DWG.exe" >nul 2>&1

:: Compiler l'application
echo.
echo [4/5] Compilation de l'application (cela peut prendre 2-5 minutes)...
echo.

.venv\Scripts\pyinstaller.exe --name="Assembleur_DXF_DWG" ^
    --onefile ^
    --windowed ^
    --add-data="assembleur_dxf_dwg.py;." ^
    --add-data="config/icon.ico;config" ^
    --icon=config/icon.ico ^
    --hidden-import=ezdxf ^
    --hidden-import=ezdxf.addons ^
    --hidden-import=ezdxf.addons.dxf2code ^
    --hidden-import=ezdxf.lldxf ^
    --hidden-import=ezdxf.entities ^
    --hidden-import=PyQt5.QtCore ^
    --hidden-import=PyQt5.QtGui ^
    --hidden-import=PyQt5.QtWidgets ^
    --hidden-import=win32com.client ^
    --hidden-import=win32com ^
    --noconfirm ^
    --clean ^
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

if not exist "dist\Assembleur_DXF_DWG.exe" (
    color 0C
    echo.
    echo [ERREUR] Le fichier exe n'a pas été créé !
    echo.
    pause
    exit /b 1
)

:: Créer un dossier portable
echo.
echo [5/5] Création du package portable...

if exist "Assembleur_DXF_DWG_Portable" (
    echo Suppression de la version précédente...
    rmdir /s /q "Assembleur_DXF_DWG_Portable"
)

mkdir Assembleur_DXF_DWG_Portable
mkdir Assembleur_DXF_DWG_Portable\docs

:: Copier l'exécutable
copy "dist\Assembleur_DXF_DWG.exe" "Assembleur_DXF_DWG_Portable\" >nul
if errorlevel 1 (
    color 0C
    echo [ERREUR] Impossible de copier l'exécutable !
    pause
    exit /b 1
)

:: Copier les scripts de diagnostic (optionnel)
if exist "diagnostic_zoom.py" (
    copy "diagnostic_zoom.py" "Assembleur_DXF_DWG_Portable\" >nul
)
if exist "nettoyer_dxf.py" (
    copy "nettoyer_dxf.py" "Assembleur_DXF_DWG_Portable\" >nul
)
if exist "analyse_dxf.py" (
    copy "analyse_dxf.py" "Assembleur_DXF_DWG_Portable\" >nul
)
if exist "debug_dwg_conversion.py" (
    copy "debug_dwg_conversion.py" "Assembleur_DXF_DWG_Portable\" >nul
)

:: Copier le script utilitaires
if exist "Utilitaires.bat" (
    copy "Utilitaires.bat" "Assembleur_DXF_DWG_Portable\" >nul
)

:: Copier la documentation
if exist "README.md" (
    copy "README.md" "Assembleur_DXF_DWG_Portable\docs\" >nul
)
if exist "DEMARRAGE_RAPIDE.md" (
    copy "DEMARRAGE_RAPIDE.md" "Assembleur_DXF_DWG_Portable\docs\" >nul
)
if exist "DERNIER_RECOURS.md" (
    copy "DERNIER_RECOURS.md" "Assembleur_DXF_DWG_Portable\docs\" >nul
)
if exist "PROCEDURE_DIAGNOSTIC_FINAL.md" (
    copy "PROCEDURE_DIAGNOSTIC_FINAL.md" "Assembleur_DXF_DWG_Portable\docs\" >nul
)
if exist "SOLUTION_ZOOM_FINAL.md" (
    copy "SOLUTION_ZOOM_FINAL.md" "Assembleur_DXF_DWG_Portable\docs\" >nul
)
if exist "DIAGNOSTIC_ZOOM.md" (
    copy "DIAGNOSTIC_ZOOM.md" "Assembleur_DXF_DWG_Portable\docs\" >nul
)
if exist "AIDE_RAPIDE_ZOOM.md" (
    copy "AIDE_RAPIDE_ZOOM.md" "Assembleur_DXF_DWG_Portable\docs\" >nul
)
if exist "GUIDE_PACKAGE_PORTABLE.md" (
    copy "GUIDE_PACKAGE_PORTABLE.md" "Assembleur_DXF_DWG_Portable\docs\" >nul
)

:: Créer un README principal
(
    echo Assembleur DXF -^> DWG - Version Portable
    echo ================================================
    echo.
    echo VERSION: 1.3
    echo DATE: %date%
    echo.
    echo LANCEMENT RAPIDE
    echo ================================================
    echo Double-cliquez sur Assembleur_DXF_DWG.exe pour lancer l'application
    echo.
    echo CONTENU
    echo ================================================
    echo - Assembleur_DXF_DWG.exe : Application principale
    echo - diagnostic_zoom.py : Diagnostic du problème de zoom
    echo - nettoyer_dxf.py : Nettoyeur de fichiers DXF
    echo - analyse_dxf.py : Analyseur de DXF
    echo - debug_dwg_conversion.py : Diagnostic conversion DWG
    echo - docs/ : Documentation complète
    echo.
    echo PREREQUIS
    echo ================================================
    echo - Windows 7 ou plus recent
    echo - ^(Optionnel^) ODA File Converter pour conversion DWG
    echo - ^(Optionnel^) AutoCAD pour ouverture automatique
    echo.
    echo UTILISATION
    echo ================================================
    echo 1. Double-cliquez sur Assembleur_DXF_DWG.exe
    echo 2. Selectionnez le dossier source avec les archives
    echo 3. Choisissez la destination
    echo 4. Cliquez "Lancer"
    echo.
    echo DEPANNAGE
    echo ================================================
    echo CONSULTEZ LES GUIDES:
    echo - docs/DERNIER_RECOURS.md : Solution rapide pour tous les problemes
    echo - docs/DIAGNOSTIC_ZOOM.md : Resolution du probleme de zoom
    echo - docs/PROCEDURE_DIAGNOSTIC_FINAL.md : Procedure complete de diagnostic
    echo - docs/SOLUTION_ZOOM_FINAL.md : Guide technique complet
    echo.
    echo SCRIPTS PYTHON INCLUS:
    echo - diagnostic_zoom.py : Analyse complete d'un fichier DXF
    echo - nettoyer_dxf.py : Nettoyeur de fichiers DXF
    echo - analyse_dxf.py : Analyseur de fichiers DXF
    echo - debug_dwg_conversion.py : Diagnostic conversion DWG
    echo.
    echo INSTALLATION
    echo ================================================
    echo - Aucune installation requise !
    echo - Copiez le dossier complet sur n'importe quel PC Windows
    echo.
    echo AUTEUR
    echo ================================================
    echo ^(c^) 2025 C.L - Pour les amis de SPiE
    echo Version: 1.3 ^(Stable avec diagnostic avance^)
) > "Assembleur_DXF_DWG_Portable\README.txt"

:: Obtenir la taille du fichier
for %%A in ("Assembleur_DXF_DWG_Portable\Assembleur_DXF_DWG.exe") do set "EXE_SIZE=%%~zA"

color 0A
echo.
echo ========================================
echo  CREATION TERMINEE AVEC SUCCES !
echo ========================================
echo.
echo Exécutable créé dans : Assembleur_DXF_DWG_Portable\
echo Fichier : Assembleur_DXF_DWG.exe
echo Taille : %EXE_SIZE% octets
echo.
echo CONTENU DU PACKAGE PORTABLE:
echo  - Assembleur_DXF_DWG.exe (application principale)
echo  - Utilitaires.bat (menu d'outils)
echo  - diagnostic_zoom.py (diagnostic)
echo  - nettoyer_dxf.py (nettoyeur)
echo  - analyse_dxf.py (analyseur)
echo  - debug_dwg_conversion.py (diagnostic DWG)
echo  - docs/ (documentation)
echo  - README.txt (guide de démarrage)
echo.
echo Vous pouvez copier le dossier Assembleur_DXF_DWG_Portable
echo sur n'importe quel PC Windows sans installation requise !
echo.
echo Ouvrir le dossier ? (O/N)
set /p choix=
if /i "%choix%"=="O" (
    start "" "Assembleur_DXF_DWG_Portable"
) else if /i "%choix%"=="N" (
    echo Dossier créé dans: %CD%\Assembleur_DXF_DWG_Portable\
)

echo.
pause
