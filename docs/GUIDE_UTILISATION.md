# Guide d'utilisation - Assembleur DXF → DWG

## 🎯 Démarrage rapide

1. **Lancer l'application**
   - Double-cliquez sur scripts\Lancer_Assembleur_DXF_DWG.bat

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
- Lancez scripts\Lancer_Assembleur_DXF_DWG.bat qui vérifie tout

### Erreur "ODA File Converter invalide"
- Téléchargez ODA File Converter depuis : https://www.opendesign.com/guestfiles/oda_file_converter
- Installez-le et notez le chemin d'installation
- Chemin typique : C:\Program Files\ODA\ODAFileConverter\ODAFileConverter.exe

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
