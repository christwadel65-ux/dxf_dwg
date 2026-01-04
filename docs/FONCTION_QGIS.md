# 🗺️ Fonction QGIS - Assembleur DXF/DWG v1.0.2

## 📋 Description

L'Assembleur DXF/DWG intègre maintenant le support de **QGIS** (Quantum GIS), le logiciel SIG open source de référence. Cette fonctionnalité permet d'ouvrir directement les fichiers DXF assemblés dans QGIS pour une analyse géospatiale avancée.

---

## ✨ Avantages de QGIS

### Pourquoi utiliser QGIS ?

- **🆓 100% Gratuit** : Contrairement à AutoCAD, QGIS est entièrement gratuit et open source
- **🌍 Géospatial** : Outils d'analyse spatiale avancés
- **🗺️ Cartes** : Création de cartes professionnelles avec légendes
- **📊 Analyse** : Calculs de surface, distances, zones tampons
- **🔄 Formats** : Export vers de nombreux formats GIS (GeoJSON, Shapefile, etc.)
- **🎨 Symbologie** : Personnalisation avancée des styles de calques

---

## 🚀 Utilisation

### Mode Interface Graphique (GUI)

1. **Lancez l'application**
2. **Sélectionnez vos archives** .tar.bz2
3. **Cochez l'option** : ☑️ "Ouvrir dans QGIS (SIG) au lieu d'AutoCAD"
4. **Cliquez sur "Lancer"**
5. Le fichier assemblé s'ouvrira automatiquement dans QGIS

> ⚠️ **Note** : Si QGIS n'est pas installé, l'option sera grisée avec un message d'erreur.

### Mode Ligne de Commande (CLI)

```bash
# Assembler et ouvrir dans QGIS
Assembleur_DXF_DWG.exe --cli ^
    --archive-folder "C:\Archives" ^
    --output "C:\Output" ^
    --open-qgis
```

```bash
# Avec nettoyage et ouverture QGIS
Assembleur_DXF_DWG.exe --cli ^
    --archive-folder "C:\Archives" ^
    --output "C:\Output" ^
    --cleanup ^
    --open-qgis
```

---

## 📥 Installation de QGIS

### Téléchargement

Téléchargez QGIS gratuitement : **https://qgis.org/download/**

### Chemins d'installation détectés

L'application détecte automatiquement QGIS aux emplacements suivants :

- `C:\Program Files\QGIS 3.38\bin\qgis-bin.exe`
- `C:\Program Files\QGIS 3.36\bin\qgis-bin.exe`
- `C:\Program Files\QGIS 3.34\bin\qgis-bin.exe`
- `C:\OSGeo4W\bin\qgis-bin.exe`
- `C:\OSGeo4W64\bin\qgis-bin.exe`
- Toute autre version QGIS dans `C:\Program Files\QGIS*\`

---

## 🎯 Cas d'usage

### 1. Analyse cadastrale

```
✓ Visualisation des parcelles
✓ Calcul de surfaces
✓ Identification des chevauchements
✓ Export vers formats cadastre
```

### 2. Réseaux et infrastructures

```
✓ Analyse de connectivité
✓ Calcul de longueurs de réseaux
✓ Zones tampons autour des infrastructures
✓ Superposition avec données OpenStreetMap
```

### 3. Cartographie

```
✓ Création de cartes professionnelles
✓ Ajout de fonds de carte (satellite, terrain)
✓ Légendes et annotations
✓ Export PDF/PNG haute résolution
```

### 4. Analyse spatiale

```
✓ Intersections entre couches
✓ Requêtes attributaires
✓ Statistiques spatiales
✓ Géoréférencement
```

---

## 🔄 QGIS vs AutoCAD

| Fonctionnalité | QGIS | AutoCAD |
|----------------|------|---------|
| **Prix** | Gratuit ✅ | Payant ❌ |
| **Analyse spatiale** | Avancée ✅ | Basique |
| **Cartes** | Excellent ✅ | Limité |
| **Formats GIS** | Nombreux ✅ | Peu |
| **CAO précise** | Basique | Excellent ✅ |
| **Conversion DWG** | Non | Oui ✅ |

**Recommandation** :
- **QGIS** pour l'analyse géospatiale, cartographie, SIG
- **AutoCAD** pour le dessin technique précis, conversion DWG

---

## 📝 Exemples pratiques

### Exemple 1 : Cartographie de réseaux

```bash
# Assembler les DXF de réseaux et ouvrir dans QGIS
Assembleur_DXF_DWG.exe --cli ^
    --archive-folder "C:\Reseaux\Archives" ^
    --output "C:\Reseaux\Assemblage" ^
    --cleanup ^
    --open-qgis
```

**Dans QGIS ensuite** :
1. Ouvrir un fond OpenStreetMap
2. Styliser les calques par type de réseau
3. Créer une carte avec légende
4. Exporter en PDF

### Exemple 2 : Analyse cadastrale

```bash
# Assembler les plans cadastre
Assembleur_DXF_DWG.exe --cli ^
    --archive-folder "C:\Cadastre\Plans" ^
    --output "C:\Cadastre\Assemblage" ^
    --open-qgis
```

**Dans QGIS ensuite** :
1. Utiliser l'outil "Calculateur de champs"
2. Calculer les surfaces de parcelles
3. Identifier les zones à problème
4. Export vers Shapefile pour traitement

---

## ⚙️ Configuration QGIS

### Optimiser QGIS pour les DXF

Après ouverture du fichier dans QGIS :

1. **Projection** : Vérifier le système de coordonnées (EPSG)
2. **Calques** : Organiser par type (lignes, polygones, points)
3. **Symbologie** : Appliquer des styles adaptés
4. **Attributs** : Ajouter des champs si nécessaire

### Styles recommandés

- **Parcelles** : Contour noir, remplissage transparent
- **Bâtiments** : Gris foncé avec ombre
- **Voirie** : Couleurs selon hiérarchie
- **Réseaux** : Couleurs normalisées (bleu eau, rouge électricité, etc.)

---

## 🐛 Dépannage

### QGIS ne s'ouvre pas

**Problème** : L'option QGIS est grisée

**Solutions** :
1. Vérifier que QGIS est installé
2. Installer depuis https://qgis.org/download/
3. Relancer l'application après installation

### Le fichier ne s'affiche pas correctement

**Problème** : Calques vides ou mal positionnés

**Solutions** :
1. Vérifier le système de coordonnées (clic droit → Propriétés)
2. Ajuster l'échelle et le zoom
3. Vérifier que les données sont bien dans le DXF source

### QGIS se lance mais sans le fichier

**Problème** : QGIS s'ouvre mais le DXF n'est pas chargé

**Solutions** :
1. Charger manuellement : Couche → Ajouter une couche → Vecteur
2. Sélectionner le fichier `assemblage.dxf`
3. Vérifier les permissions d'accès au fichier

---

## 💡 Astuces

### 1. Utiliser les fonds de carte

Dans QGIS, ajoutez des fonds de carte gratuits :
- **OpenStreetMap** : XYZ Tiles
- **Google Satellite** : QuickMapServices plugin
- **IGN France** : GéoPortail

### 2. Export multi-format

Après assemblage, exportez vers :
- **GeoJSON** : Données web
- **Shapefile** : Compatibilité maximale
- **GeoPackage** : Format moderne recommandé
- **KML** : Google Earth

### 3. Automatisation

Créez des scripts QGIS Python pour automatiser :
- Application de styles
- Calculs de surface
- Export vers formats spécifiques

---

## 📚 Ressources

### Documentation QGIS

- Site officiel : https://qgis.org
- Documentation : https://docs.qgis.org
- Tutoriels : https://www.qgistutorials.com

### Communauté

- Forum : https://gis.stackexchange.com
- Discord : Communauté QGIS francophone
- YouTube : Chaîne QGIS officielle

---

## 🎓 Formation QGIS

Pour maîtriser QGIS avec vos fichiers DXF :

1. **Débutant** : Tutoriels de base sur qgis.org
2. **Intermédiaire** : Formations gratuites sur YouTube
3. **Avancé** : Cours certification QGIS

**Durée estimée** : 2-3 jours pour être autonome sur l'essentiel

---

## ✅ Récapitulatif

**L'intégration QGIS vous permet de :**

✓ Analyser vos données DXF avec des outils SIG professionnels  
✓ Créer des cartes de qualité publication  
✓ Exporter vers de nombreux formats géospatiaux  
✓ Utiliser un logiciel 100% gratuit et open source  
✓ Bénéficier d'une communauté mondiale active  

**Combinez le meilleur des deux mondes :**
- **Assembleur DXF/DWG** pour la fusion rapide
- **QGIS** pour l'analyse et la cartographie

---

**Version 1.0.2** - © 2026 C.L (Skill Teams)
