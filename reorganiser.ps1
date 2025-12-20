# ============================================================
# Script de réorganisation du dossier DXF_DWG
# Crée une structure claire et professionnelle
# ============================================================

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

$folders = @(
    "scripts",
    "config",
    "docs"
)

foreach ($folder in $folders) {
    if (-Not (Test-Path $folder)) {
        New-Item -ItemType Directory -Path $folder -Force | Out-Null
        Write-Host "  ✓ Créé : $folder\" -ForegroundColor Green
    }
}

# Déplacer les scripts de lancement
Write-Host ""
Write-Host "[2/5] Organisation des scripts..." -ForegroundColor Yellow

$scripts = @(
    "Lancer_Assembleur_DXF_DWG.bat",
    "Lancer_Assembleur_DXF_DWG.ps1",
    "creer_executable.bat",
    "creer_executable.ps1"
)

foreach ($script in $scripts) {
    if (Test-Path $script) {
        Move-Item $script "scripts\" -Force
        Write-Host "  ✓ Déplacé : $script -> scripts\" -ForegroundColor Green
    }
}

# Déplacer les fichiers de configuration
Write-Host ""
Write-Host "[3/5] Organisation des configurations..." -ForegroundColor Yellow

$configs = @(
    "assembleur.spec",
    "file_version_info.txt"
)

foreach ($config in $configs) {
    if (Test-Path $config) {
        Move-Item $config "config\" -Force
        Write-Host "  ✓ Déplacé : $config -> config\" -ForegroundColor Green
    }
}

# Créer la documentation
Write-Host ""
Write-Host "[4/5] Création de la documentation..." -ForegroundColor Yellow

$readme = @"
# Assembleur DXF → DWG

Outil professionnel pour fusionner et convertir des fichiers DXF/DWG.

## 📋 Description

Application Windows pour :
- Extraction automatique d'archives .tar.bz2 contenant des fichiers DXF
- Fusion intelligente de multiples fichiers DXF en conservant les coordonnées géographiques
- Conversion optionnelle en DWG via ODA File Converter
- Ouverture automatique dans AutoCAD avec zoom étendu

## 🚀 Utilisation

### Lancement rapide
Double-cliquez sur : `scripts\Lancer_Assembleur_DXF_DWG.bat`

### Créer un exécutable portable
Double-cliquez sur : `scripts\creer_executable.bat`

## 📦 Installation développeur

``````powershell
# Créer l'environnement virtuel
python -m venv .venv

# Activer l'environnement
.\.venv\Scripts\Activate.ps1

# Installer les dépendances
pip install -r requirements.txt
``````

## 📁 Structure du projet

``````
dxf_dwg/
├── assembleur_dxf_dwg.py      # Code source principal
├── requirements.txt            # Dépendances Python
├── README.md                   # Documentation
├── LICENSE                     # Licence
├── scripts/                    # Scripts de lancement
│   ├── Lancer_Assembleur_DXF_DWG.bat
│   ├── Lancer_Assembleur_DXF_DWG.ps1
│   ├── creer_executable.bat
│   └── creer_executable.ps1
├── config/                     # Configuration PyInstaller
│   ├── assembleur.spec
│   └── file_version_info.txt
├── docs/                       # Documentation
│   └── GUIDE_UTILISATION.md
└── .venv/                      # Environnement virtuel Python
``````

## 🔧 Fonctionnalités

✅ Extraction automatique d'archives .tar.bz2
✅ Fusion de fichiers DXF avec conservation des coordonnées
✅ Validation automatique des fichiers DXF
✅ Conversion DWG via ODA File Converter
✅ Ouverture automatique dans AutoCAD
✅ Interface graphique moderne
✅ Gestion d'erreurs robuste
✅ Bouton d'annulation
✅ Nettoyage automatique des fichiers temporaires

## 📝 Prérequis

- **Python 3.8+** (pour le développement)
- **ODA File Converter** (optionnel, pour conversion DWG)
- **AutoCAD** (optionnel, pour ouverture automatique)

## 🛠️ Technologies

- **Python** - Langage principal
- **PyQt5** - Interface graphique
- **ezdxf** - Manipulation de fichiers DXF
- **pywin32** - Automation AutoCAD
- **PyInstaller** - Création d'exécutable

## 📄 Licence

© 2025 C.L - Pour les amis de SPiE

## 🤝 Auteur

**C.L** - Développé pour les équipes SPiE
"@

Set-Content -Path "README.md" -Value $readme -Encoding UTF8
Write-Host "  ✓ Créé : README.md" -ForegroundColor Green

# Créer le guide utilisateur
$guide = @"
# Guide d'utilisation - Assembleur DXF → DWG

## 🎯 Démarrage rapide

1. **Lancer l'application**
   - Double-cliquez sur `scripts\Lancer_Assembleur_DXF_DWG.bat`

2. **Sélectionner le dossier source**
   - Cliquez sur "Parcourir..." à côté de "Dossier d'archives"
   - Choisissez le dossier contenant vos archives .tar.bz2

3. **Choisir la destination**
   - Le dossier par défaut est dans Mes Documents
   - Modifiez si nécessaire

4. **Configuration optionnelle**
   - Cochez "Convertir en DWG" si vous souhaitez un fichier DWG
   - Indiquez le chemin vers ODAFileConverter.exe
   - Choisissez la version DWG (ACAD2018 recommandé)

5. **Lancer le traitement**
   - Cliquez sur "▶ Lancer"
   - Suivez la progression dans le journal
   - Le fichier s'ouvrira automatiquement dans AutoCAD

## 📊 Détails des fonctionnalités

### Extraction des archives
- Supporte les archives .tar.bz2
- Extraction sécurisée avec validation des chemins
- Affichage de la progression

### Fusion des DXF
- Conservation des coordonnées géographiques d'origine
- Fusion intelligente des calques, blocs et styles
- Validation automatique des fichiers
- Comptage des entités importées

### Conversion DWG
- Nécessite ODA File Converter (gratuit)
- Versions supportées : ACAD2013, ACAD2018, ACAD2024, etc.
- Conversion automatique après fusion

### Ouverture AutoCAD
- Ouverture automatique du résultat
- Activation de l'espace objet (Model Space)
- Zoom étendu automatique pour voir tout le plan

## ⚠️ Résolution des problèmes

### L'application ne démarre pas
- Vérifiez que l'environnement Python est installé
- Lancez `scripts\Lancer_Assembleur_DXF_DWG.bat` qui vérifie tout

### Erreur "ODA File Converter invalide"
- Téléchargez ODA File Converter depuis : https://www.opendesign.com/guestfiles/oda_file_converter
- Installez-le et notez le chemin d'installation
- Chemin typique : `C:\Program Files\ODA\ODAFileConverter\ODAFileConverter.exe`

### Fichiers DXF ignorés
- Vérifiez que les fichiers ne sont pas corrompus
- Assurez-vous qu'ils ont l'extension .dxf (minuscules ou majuscules)
- Consultez le journal pour les messages d'erreur détaillés

### Conversion DWG échoue
- Vérifiez la version DWG sélectionnée
- Certaines versions d'ODA ne supportent pas toutes les versions DWG
- Essayez ACAD2018 qui est bien supporté

## 🎓 Conseils d'utilisation

### Performance
- Les gros fichiers peuvent prendre du temps
- La barre de progression vous tient informé
- Vous pouvez annuler à tout moment avec le bouton "⏹ Arrêter"

### Organisation
- Gardez vos archives .tar.bz2 dans un dossier dédié
- Créez un dossier de sortie séparé pour chaque projet
- Les fichiers temporaires sont automatiquement nettoyés

### AutoCAD
- Le fichier s'ouvre automatiquement en espace objet
- Le zoom étendu est appliqué automatiquement
- Si l'ouverture échoue, le fichier reste dans le dossier de sortie

## 📞 Support

Pour toute question ou problème, consultez le journal des opérations qui contient des informations détaillées sur chaque étape du traitement.

---
© 2025 C.L - Pour les amis de SPiE
"@

Set-Content -Path "docs\GUIDE_UTILISATION.md" -Value $guide -Encoding UTF8
Write-Host "  ✓ Créé : docs\GUIDE_UTILISATION.md" -ForegroundColor Green

# Créer des raccourcis dans la racine
Write-Host ""
Write-Host "[5/5] Création des raccourcis..." -ForegroundColor Yellow

$launchScript = @"
@echo off
:: Raccourci pour lancer l'application
cd /d "%~dp0"
call "scripts\Lancer_Assembleur_DXF_DWG.bat"
"@

Set-Content -Path "LANCER.bat" -Value $launchScript -Encoding ASCII
Write-Host "  ✓ Créé : LANCER.bat (raccourci)" -ForegroundColor Green

$buildScript = @"
@echo off
:: Raccourci pour créer l'exécutable
cd /d "%~dp0"
call "scripts\creer_executable.bat"
"@

Set-Content -Path "CREER_EXE.bat" -Value $buildScript -Encoding ASCII
Write-Host "  ✓ Créé : CREER_EXE.bat (raccourci)" -ForegroundColor Green

# Résumé
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host " REORGANISATION TERMINEE !" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Structure créée :" -ForegroundColor Cyan
Write-Host "  📁 scripts/         - Scripts de lancement et compilation" -ForegroundColor White
Write-Host "  📁 config/          - Configuration PyInstaller" -ForegroundColor White
Write-Host "  📁 docs/            - Documentation" -ForegroundColor White
Write-Host "  📄 README.md        - Documentation principale" -ForegroundColor White
Write-Host "  📄 LANCER.bat       - Raccourci lancement rapide" -ForegroundColor Yellow
Write-Host "  📄 CREER_EXE.bat    - Raccourci création exécutable" -ForegroundColor Yellow
Write-Host ""
Write-Host "Utilisation :" -ForegroundColor Cyan
Write-Host "  • Pour lancer : Double-cliquez LANCER.bat" -ForegroundColor Green
Write-Host "  • Pour compiler : Double-cliquez CREER_EXE.bat" -ForegroundColor Green
Write-Host ""

Read-Host "Appuyez sur Entrée pour terminer"
