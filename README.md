# Assembleur DXF → DWG

**Version 1.0.2** - Outil professionnel pour fusionner et convertir des fichiers DXF/DWG.

<img width="582" height="830" alt="image" src="https://github.com/user-attachments/assets/935309b5-86cc-4db7-93fc-50dae7b8cad7" />


## 📋 Description

Application Windows pour :
- 📦 Extraction automatique d'archives .tar.bz2 contenant des fichiers DXF
- 🧩 Fusion intelligente de multiples fichiers DXF en conservant les coordonnées géographiques
- 🔄 Conversion optionnelle en DWG via AutoCAD
- 🗺️ **NOUVEAU** : Ouverture dans QGIS pour analyse géospatiale
- 🚀 Ouverture automatique dans AutoCAD avec zoom étendu
- 👁️ **NOUVEAU** : Prévisualisation des fichiers avant traitement
- 🖱️ **NOUVEAU** : Drag & Drop pour les dossiers
- 💻 **NOUVEAU** : Mode CLI pour automatisation

## ✨ Nouveautés v1.0.2

### 🗺️ Support QGIS
- Ouverture directe dans QGIS (logiciel SIG gratuit)
- Analyse géospatiale avancée
- Cartographie professionnelle
- Export multi-formats GIS

### 👁️ Prévisualisation
- Aperçu complet de tous les fichiers DXF
- Informations détaillées (taille, entités, calques, coordonnées)
- Validation avant traitement

### 🖱️ Drag & Drop
- Glissez-déposez vos dossiers directement
- Détection automatique du type (archives/sortie)

### 💻 Mode CLI
- Automatisation complète sans interface
- Intégration scripts batch et tâches planifiées
- Options : `--cli`, `--open-qgis`, `--cleanup`, etc.

## 🚀 Utilisation

### Lancement rapide (GUI)
```bash
# Double-cliquez sur :
scripts\Lancer_Assembleur_DXF_DWG.bat

# Ou lancez directement :
python assembleur_dxf_dwg.py
```

### Mode ligne de commande (CLI)
```bash
# Assemblage simple
python assembleur_dxf_dwg.py --cli --archive-folder "C:\Archives" --output "C:\Output"

# Avec ouverture QGIS
python assembleur_dxf_dwg.py --cli --archive-folder "C:\Archives" --output "C:\Output" --open-qgis

# Avec nettoyage et conversion DWG
python assembleur_dxf_dwg.py --cli --archive-folder "C:\Archives" --output "C:\Output" --cleanup --convert-dwg
```

### Créer un exécutable portable
```bash
scripts\creer_executable.bat
```

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

### Traitement des fichiers
✅ Extraction automatique d'archives .tar.bz2  
✅ Fusion de fichiers DXF avec conservation des coordonnées  
✅ Validation automatique des fichiers DXF  
✅ Nettoyage optionnel (suppression éléments inutilisés)  
✅ Conversion DWG via AutoCAD  
✅ Nettoyage automatique des fichiers temporaires

### Interface et ergonomie
✅ **Drag & Drop** : Glissez-déposez vos dossiers  
✅ **Prévisualisation** : Voir tous les fichiers avant traitement  
✅ Interface graphique moderne (PyQt5)  
✅ Bouton d'annulation pendant traitement  
✅ Journal détaillé en temps réel

### Ouverture et export
✅ **QGIS** : Ouverture pour analyse géospatiale (gratuit)  
✅ **AutoCAD** : Ouverture avec zoom étendu automatique  
✅ **Seconde instance** : Option multi-fenêtres AutoCAD  
✅ Gestion d'erreurs robuste

### Automatisation
✅ **Mode CLI** : Ligne de commande complète  
✅ **Scripts batch** : Intégration facile  
✅ **Tâches planifiées** : Traitement automatique  
✅ **Options avancées** : --cleanup, --convert-dwg, --open-qgis

## 📝 Prérequis

### Obligatoires
- **Windows 10/11** (64-bit)
- **Python 3.8+** (pour le développement)

### Optionnels
- **AutoCAD** (pour conversion DWG et ouverture automatique)
- **QGIS 3.x** (pour analyse géospatiale, 100% gratuit)

## 🛠️ Technologies

- **Python** - Langage principal
- **PyQt5** - Interface graphique
- **ezdxf** - Manipulation de fichiers DXF
- **pywin32** - Automation AutoCAD
- **PyInstaller** - Création d'exécutable

## 📚 Documentation

- 📖 [Guide d'utilisation complet](docs/GUIDE_UTILISATION.md)
- 💻 [Mode CLI](docs/MODE_CLI.md)
- 🗺️ [Fonction QGIS](docs/FONCTION_QGIS.md)
- ✨ [Nouvelles fonctionnalités](docs/NOUVELLES_FONCTIONNALITES.md)

## 🎯 Cas d'usage

### 1. Cartographie cadastrale
- Assemblage de plans cadastre
- Conservation coordonnées géographiques
- Analyse dans QGIS (surfaces, parcelles)

### 2. Réseaux et infrastructures
- Fusion de plans de réseaux
- Visualisation globale
- Export vers formats GIS

### 3. Automatisation
- Traitement nocturne par script
- Intégration CI/CD
- Tâches planifiées Windows

## 🆚 QGIS vs AutoCAD

| Critère | QGIS | AutoCAD |
|---------|------|---------|
| **Prix** | Gratuit ✅ | Payant |
| **Analyse spatiale** | Excellente ✅ | Basique |
| **Cartographie** | Professionnelle ✅ | Limitée |
| **Formats GIS** | Nombreux ✅ | Peu |
| **CAO précise** | Basique | Excellente ✅ |
| **Conversion DWG** | Non | Oui ✅ |

**💡 Conseil** : Utilisez QGIS pour l'analyse géospatiale et AutoCAD pour le dessin technique précis.

## 📄 Licence

© 2026 easycoding.fr

## 🤝 Auteur

C.L - easycoding.fr

## 📋 Changelog

### Version 1.0.2 (4 janvier 2026)
- ✨ **NOUVEAU** : Support QGIS avec détection automatique
- ✨ **NOUVEAU** : Prévisualisation complète de tous les fichiers DXF
- ✨ **NOUVEAU** : Drag & Drop pour les dossiers
- ✨ **NOUVEAU** : Mode CLI avec --open-qgis
- 📚 Documentation complète QGIS ajoutée
- 🐛 Corrections mineures

### Version 1.0.1
- ✨ Mode CLI initial
- ✨ Prévisualisation basique
- ✨ Drag & Drop

### Version 1.0.0
- 🎉 Version initiale
- Fusion DXF basique
- Ouverture AutoCAD

