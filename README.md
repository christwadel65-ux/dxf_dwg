# Assembleur DXF → DWG

Outil professionnel pour fusionner des fichiers DXF.

## 📋 Description

Application Windows pour :
- Extraction automatique d'archives .tar.bz2 contenant des fichiers DXF
- Fusion intelligente de multiples fichiers DXF en conservant les coordonnées géographiques
- Nettoyage automatique des fichiers DXF (suppression d'éléments inutilisés)
- Conversion DXF -> DWG directe via AutoCAD (option) ou ODA File Converter
- Ouverture automatique dans AutoCAD avec zoom étendu (instance courante ou seconde instance)
- Menu d'aide intégré avec guide d'utilisation

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
✅ Nettoyage des DXF (suppression des blocs/styles/calques inutilisés)
✅ Validation automatique des fichiers DXF
✅ Ouverture automatique dans AutoCAD
✅ Option pour forcer une seconde instance AutoCAD
✅ Conversion DXF -> DWG avant l'ouverture AutoCAD (SAVEAS)
✅ Zoom étendu automatique
✅ Menu d'aide intégré avec guide d'utilisation
✅ Interface graphique moderne
✅ Gestion d'erreurs robuste
✅ Bouton d'annulation
✅ Nettoyage automatique des fichiers temporaires

## 📝 Prérequis

- **Python 3.8+** (pour le développement)
- **AutoCAD** (optionnel, pour ouverture automatique)
- **pywin32** (automatiquement installé via requirements.txt)

## 🛠️ Technologies

- **Python 3.8+** - Langage principal
- **PyQt5** - Interface graphique
- **ezdxf** - Manipulation de fichiers DXF
- **pywin32** - Automation AutoCAD
- **PyInstaller** - Création d'exécutable

## 📖 Documentation

### Menu Aide (F1)
Menu "Aide" en haut de la fenêtre :
- **À propos (F1)** - Informations générales
- **Guide d'utilisation** - Guide rapide des étapes principales
- **Documentation** - Lien vers le guide complet

### Guide d'utilisation détaillé
Voir [docs/GUIDE_UTILISATION.md](docs/GUIDE_UTILISATION.md) pour des instructions complètes.

## 📄 Licence

© 2025 C.L - Pour les amis de SPiE

## 🤝 Auteur

**C.L** - Développé pour les équipes SPiE
