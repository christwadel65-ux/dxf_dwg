# Mode CLI - Assembleur DXF/DWG

## 📋 Description

Le mode CLI (Command Line Interface) permet d'automatiser le traitement des fichiers DXF/DWG sans interface graphique, idéal pour :
- Scripts d'automatisation
- Traitements par lots
- Tâches planifiées
- Intégration CI/CD

## 🚀 Utilisation

### Syntaxe de base

```bash
python assembleur_dxf_dwg.py --cli --archive-folder "CHEMIN" --output "SORTIE"
```

### Options disponibles

| Option | Description | Requis |
|--------|-------------|--------|
| `--cli` | Active le mode ligne de commande | ✅ Oui |
| `--archive-folder` | Dossier contenant les archives .tar.bz2 | ⚠️ Au moins l'un des deux |
| `--dxf-folders` | Dossiers DXF séparés par des virgules | ⚠️ Au moins l'un des deux |
| `--output` | Dossier de sortie | ✅ Oui |
| `--cleanup` | Nettoyer les DXF avant fusion | ❌ Non |
| `--convert-dwg` | Convertir en DWG (nécessite AutoCAD) | ❌ Non |

## 📝 Exemples

### Exemple 1 : Traitement simple d'archives

```bash
python assembleur_dxf_dwg.py --cli ^
    --archive-folder "C:\Archives\DXF" ^
    --output "C:\Output"
```

### Exemple 2 : Avec nettoyage et conversion DWG

```bash
python assembleur_dxf_dwg.py --cli ^
    --archive-folder "C:\Archives\DXF" ^
    --output "C:\Output" ^
    --cleanup ^
    --convert-dwg
```

### Exemple 3 : Depuis plusieurs dossiers DXF

```bash
python assembleur_dxf_dwg.py --cli ^
    --dxf-folders "C:\Plans\Zone1,C:\Plans\Zone2,C:\Plans\Zone3" ^
    --output "C:\Output\Assemblage"
```

### Exemple 4 : Combinaison archives + dossiers

```bash
python assembleur_dxf_dwg.py --cli ^
    --archive-folder "C:\Archives" ^
    --dxf-folders "C:\Plans\Additionnels" ^
    --output "C:\Output" ^
    --cleanup
```

## 🤖 Automatisation

### Script batch Windows

Créez un fichier `traiter_dxf.bat` :

```batch
@echo off
echo Traitement des fichiers DXF...

python assembleur_dxf_dwg.py --cli ^
    --archive-folder "C:\Archives\Daily" ^
    --output "C:\Output\%date:~-4,4%-%date:~-7,2%-%date:~-10,2%" ^
    --cleanup

if %ERRORLEVEL% EQU 0 (
    echo Traitement termine avec succes!
) else (
    echo Erreur lors du traitement!
)
pause
```

### Script PowerShell

Créez un fichier `traiter_dxf.ps1` :

```powershell
$date = Get-Date -Format "yyyy-MM-dd"
$outputFolder = "C:\Output\$date"

Write-Host "🚀 Démarrage du traitement DXF..." -ForegroundColor Green

python assembleur_dxf_dwg.py --cli `
    --archive-folder "C:\Archives\Daily" `
    --output $outputFolder `
    --cleanup `
    --convert-dwg

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Traitement terminé avec succès!" -ForegroundColor Green
    Write-Host "📂 Fichier créé: $outputFolder\assemblage.dxf" -ForegroundColor Cyan
} else {
    Write-Host "❌ Erreur lors du traitement!" -ForegroundColor Red
    exit 1
}
```

### Tâche planifiée Windows

Pour exécuter automatiquement tous les jours à 2h du matin :

```batch
schtasks /create /tn "Assembleur DXF Daily" ^
    /tr "C:\Path\To\traiter_dxf.bat" ^
    /sc daily /st 02:00 ^
    /ru SYSTEM
```

## 📊 Codes de sortie

| Code | Description |
|------|-------------|
| `0` | Succès |
| `1` | Erreur (vérifiez les logs) |

## 💡 Astuces

### 1. Traiter plusieurs archives en une fois

Placez toutes vos archives dans un même dossier et utilisez `--archive-folder`.

### 2. Logs détaillés

Redirigez la sortie vers un fichier de log :

```bash
python assembleur_dxf_dwg.py --cli --archive-folder "C:\Archives" --output "C:\Output" > traitement.log 2>&1
```

### 3. Vérification avant traitement

Utilisez d'abord le mode GUI avec le bouton "🔍 Prévisualiser" pour vérifier les fichiers, puis automatisez avec le CLI.

### 4. Performance

Pour de gros volumes, désactivez `--cleanup` si les fichiers sont déjà nettoyés.

## ⚠️ Prérequis

- **Python 3.8+** avec packages installés (`pip install -r requirements.txt`)
- **AutoCAD** (uniquement si `--convert-dwg` est utilisé)
- **Droits d'écriture** sur le dossier de sortie

## 🔧 Dépannage

### Erreur : "Module win32com non disponible"

Si vous utilisez `--convert-dwg` :

```bash
pip install pywin32
```

### Erreur : "Aucun fichier DXF à traiter"

Vérifiez que :
- Le dossier d'archives contient bien des fichiers `.tar.bz2`
- Les archives contiennent des fichiers `.dxf`
- Les chemins sont corrects (utilisez des guillemets pour les espaces)

### Erreur : "Impossible de créer le dossier de sortie"

Vérifiez les permissions d'écriture sur le dossier parent.

## 📞 Support

Pour toute question ou problème, consultez le [README.md](../README.md) ou le [GUIDE_UTILISATION.md](GUIDE_UTILISATION.md).
