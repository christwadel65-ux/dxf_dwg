# 🎯 Nouvelles Fonctionnalités - Version 1.0.2

## ✨ Ce qui a été ajouté

### 1. 🖱️ **Drag & Drop (Glisser-Déposer)**

Vous pouvez maintenant **glisser-déposer** des dossiers directement dans l'interface :

- **Dossier avec archives .tar.bz2** → Se place automatiquement comme source
- **Autre dossier** → Se place automatiquement comme destination

**Avantages :**
- ⚡ Plus rapide que le bouton "Parcourir"
- 🎯 Intuitif et ergonomique
- ✅ Détection automatique du type de dossier

---

### 2. 👁️ **Prévisualisation DXF**

Nouveau bouton **"🔍 Prévisualiser"** dans l'interface !

**Fonctionnalités :**
- 📊 Affiche le nombre de fichiers DXF
- 📏 Taille de chaque fichier
- 🎨 Nombre d'entités et calques
- 📍 Coordonnées géographiques (X/Y min/max)

**Utilité :**
- Vérifier les fichiers **avant** de lancer le traitement
- Identifier rapidement les problèmes
- Valider les coordonnées géographiques

---

### 3. 💻 **Mode CLI (Ligne de Commande)**

Le programme supporte maintenant un **mode automatisé** sans interface graphique !

#### Utilisation de base

```bash
# Mode GUI (par défaut)
python assembleur_dxf_dwg.py

# Mode CLI
python assembleur_dxf_dwg.py --cli --archive-folder "C:\Archives" --output "C:\Output"
```

#### Options CLI disponibles

| Option | Description |
|--------|-------------|
| `--cli` | Active le mode ligne de commande |
| `--archive-folder` | Dossier d'archives .tar.bz2 |
| `--dxf-folders` | Dossiers DXF (séparés par virgules) |
| `--output` | Dossier de sortie (requis) |
| `--cleanup` | Nettoyer les DXF |
| `--convert-dwg` | Convertir en DWG |

#### Exemples pratiques

**Traitement simple :**
```bash
python assembleur_dxf_dwg.py --cli ^
    --archive-folder "C:\Archives\Plans" ^
    --output "C:\Output"
```

**Avec toutes les options :**
```bash
python assembleur_dxf_dwg.py --cli ^
    --archive-folder "C:\Archives" ^
    --dxf-folders "C:\DXF\Zone1,C:\DXF\Zone2" ^
    --output "C:\Output" ^
    --cleanup ^
    --convert-dwg
```

**Automatisation (script batch) :**
```batch
@echo off
python assembleur_dxf_dwg.py --cli ^
    --archive-folder "C:\Archives\Daily" ^
    --output "C:\Output\%date%" ^
    --cleanup
```

#### Cas d'usage

✅ **Tâches planifiées** (cron, Task Scheduler)  
✅ **Scripts d'automatisation**  
✅ **Intégration CI/CD**  
✅ **Traitement par lots**  
✅ **Serveurs sans interface graphique**

---

## 📚 Documentation complète

Pour plus de détails sur le mode CLI, consultez :
- [docs/MODE_CLI.md](docs/MODE_CLI.md) - Guide complet du mode CLI
- [README.md](README.md) - Documentation générale

---

## 🚀 Mise à jour

Pour utiliser les nouvelles fonctionnalités :

1. **Téléchargez** la dernière version du code
2. **Installez** les dépendances (si nécessaire) :
   ```bash
   pip install -r requirements.txt
   ```
3. **Lancez** l'application :
   ```bash
   python assembleur_dxf_dwg.py
   ```

---

## 🎬 Démonstration

### Drag & Drop
1. Ouvrez l'application
2. Glissez un dossier d'archives dans la fenêtre
3. Il s'ajoute automatiquement comme source ✅

### Prévisualisation
1. Sélectionnez un dossier d'archives
2. Cliquez sur **"🔍 Prévisualiser"**
3. Une fenêtre s'ouvre avec les détails des fichiers

### Mode CLI
1. Ouvrez un terminal / PowerShell
2. Exécutez : `python assembleur_dxf_dwg.py --help`
3. Suivez les exemples pour automatiser

---

## 💡 Conseils d'utilisation

### Workflow recommandé

1. **Prévisualisez** d'abord vos fichiers
2. **Vérifiez** les coordonnées et le nombre d'entités
3. **Lancez** le traitement en mode GUI
4. **Automatisez** avec le CLI une fois validé

### Performance

- Le mode CLI est **plus rapide** (pas de GUI)
- Utilisez `--cleanup` seulement si nécessaire
- Pour de gros volumes, désactivez la conversion DWG

---

## 🐛 Problèmes connus

### Drag & Drop ne fonctionne pas
- **Solution** : Vérifiez que vous glissez bien un **dossier** (pas des fichiers)

### Prévisualisation lente
- **Cause** : Nombreux fichiers DXF volumineux
- **Solution** : La prévisualisation limite à 3 archives et 5 fichiers par archive

### Mode CLI : "Module not found"
- **Solution** : Activez l'environnement virtuel :
  ```bash
  .venv\Scripts\activate
  ```

---

## 📞 Support

Pour toute question :
- 📧 Consultez le [README.md](README.md)
- 📖 Lisez le [GUIDE_UTILISATION.md](docs/GUIDE_UTILISATION.md)
- 🖥️ Testez avec le mode GUI avant d'automatiser

---

**Version 1.0.2** - © 2026 C.L (Skill Teams)
