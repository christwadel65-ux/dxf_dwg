# Assembleur DXF → DWG

Outil professionnel pour fusionner et convertir des fichiers DXF/DWG.

<img width="350" height="700" alt="image" src="https://github.com/user-attachments/assets/64f23e3e-4249-43e0-937f-0e8e5283e9e0" />


## 📋 Description

Application Windows pour :
- Extraction automatique d'archives .tar.bz2 contenant des fichiers DXF
- Fusion intelligente de multiples fichiers DXF en conservant les coordonnées géographiques
- Conversion optionnelle en DWG (AutoCAD doit être installé)
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
✅ Conversion DWG (via AutoCAD)  
✅ Ouverture automatique dans AutoCAD  
✅ Interface graphique moderne  
✅ Gestion d'erreurs robuste  
✅ Bouton d'annulation  
✅ Nettoyage automatique des fichiers temporaires

## 📝 Prérequis

- **Python 3.8+** (pour le développement)
- **AutoCAD** (optionnel, pour conversion DWG et ouverture automatique)

## 🛠️ Technologies

- **Python** - Langage principal
- **PyQt5** - Interface graphique
- **ezdxf** - Manipulation de fichiers DXF
- **pywin32** - Automation AutoCAD
- **PyInstaller** - Création d'exécutable

📄 Licence
© 2025 Easycoding 

🤝 Auteur
easycoding.fr
