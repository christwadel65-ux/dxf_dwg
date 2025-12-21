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
   - Cochez "Nettoyer les DXF" pour supprimer les éléments inutilisés (recommandé)
   - Cochez "Ouvrir dans une seconde instance AutoCAD" si vous voulez isoler l'ouverture (toujours en Model Space)
   - Cochez "Convertir en DWG avant ouverture AutoCAD" pour que l'appli fasse un SAVEAS DWG via AutoCAD avant le zoom

5. **Lancer le traitement**
   - Cliquez sur "▶ Lancer"
   - Suivez la progression dans le journal
   - Le fichier s'ouvrira automatiquement dans AutoCAD (si l'option est activée)

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

### Nettoyage des DXF
- Suppression automatique des blocs inutilisés
- Suppression des styles non utilisés
- Suppression des calques orphelins
- Réduit la taille finale du fichier

### Ouverture AutoCAD
- Ouverture automatique du résultat (option désactivable)
- Option seconde instance : ouvre le fichier dans une nouvelle session AutoCAD (Model Space)
- Option conversion avant ouverture : AutoCAD sauvegarde en DWG puis rouvre le DWG avant zoom
- Zoom étendu automatique pour voir tout le plan
- Si l'ouverture est désactivée, le fichier reste dans le dossier de sortie

## ⚠️ Résolution des problèmes

### L'application ne démarre pas
- Vérifiez que l'environnement Python est installé
- Lancez scripts\Lancer_Assembleur_DXF_DWG.bat qui vérifie tout

### Fichiers DXF ignorés
- Vérifiez que les fichiers ne sont pas corrompus
- Assurez-vous qu'ils ont l'extension .dxf (minuscules ou majuscules)
- Consultez le journal pour les messages d'erreur détaillés

### Le fichier généré est trop volumineux
- Cochez l'option "Nettoyer les DXF" pour supprimer les éléments inutilisés
- Cela réduira significativement la taille du fichier

### Le nettoyage échoue
- Certains fichiers DXF complexes peuvent ne pas être nettoyables
- Vous pouvez désactiver l'option nettoyage si cela pose problème
- Le fichier sera toujours fusionné, juste pas nettoyé

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

## 📞 Support et Aide

### Menu Aide intégré
L'application propose un menu "Aide" en haut de la fenêtre avec :
- **À propos (F1)** - Informations générales et version de l'application
- **Guide d'utilisation** - Guide rapide des étapes principales
- **Documentation** - Accès au guide complet en ligne

### Consultez le journal
Pour toute question ou problème, consultez le journal des opérations qui contient des informations détaillées sur chaque étape du traitement.

---
© 2025 C.L - (Skill Teams))
