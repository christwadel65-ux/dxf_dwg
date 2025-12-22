# Assembleur DXF → DWG

Outil professionnel pour fusionner et convertir des fichiers DXF/DWG.

## 📋 Description

Application Windows pour :
- Extraction automatique d'archives .tar.bz2 contenant des fichiers DXF
- Fusion intelligente de multiples fichiers DXF en conservant les coordonnées géographiques
- Conversion optionnelle en DWG via autocad(doit etre installer)
- Ouverture automatique dans AutoCAD avec zoom étendu

## 🚀 Utilisation

### Lancement rapide
Double-cliquez sur : scripts\Lancer_Assembleur_DXF_DWG.bat

### Créer un exécutable portable
Double-cliquez sur : scripts\creer_executable.bat

## 📦 Installation développeur

```powershell
# Créer l'environnement virtuel
python -m venv .venv

# Activer l'environnement
.\.venv\Scripts\Activate.ps1

# Installer les dépendances
pip install -r requirements.txt
```

## 📁 Structure du projet

```
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
```

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

© 2025 MIT - 

## 🤝 Auteur

**C.L** - 
