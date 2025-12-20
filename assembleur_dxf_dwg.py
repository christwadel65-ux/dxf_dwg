# -*- coding: utf-8 -*-
"""
Assembleur DXF → DWG C.L For SPiE friends
- Sources : Dossier contenant des archives .tar.bz2 + N dossiers (récursif)
- Décompression automatique de toutes les archives .tar.bz2
- Fusion DXF fidèle (calques, blocs, styles…) via ezdxf.addons.Importer
- Conversion optionnelle en DWG via ODA File Converter (CLI)
"""

import os
import sys
import tarfile
import tempfile
import subprocess
import traceback
import time
import shutil
import logging
from datetime import datetime
from pathlib import Path
from typing import List, Optional, Tuple
from contextlib import contextmanager

import ezdxf
from ezdxf.addons import Importer
from ezdxf import bbox

from PyQt5.QtCore import Qt, QThread, pyqtSignal, QSize
from PyQt5.QtGui import QFont, QIcon, QPalette, QColor
from PyQt5.QtWidgets import (
    QApplication, QMainWindow, QWidget, QFileDialog, QMessageBox,
    QGridLayout, QLabel, QLineEdit, QPushButton, QCheckBox,
    QProgressBar, QTextEdit, QGroupBox, QHBoxLayout, QVBoxLayout,
    QListWidget, QStatusBar, QMenuBar, QAction, QSplitter, QFrame,
    QScrollArea, QSizePolicy, QSpacerItem
)


# ---------- Configuration logging ----------
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[logging.StreamHandler()]
)
logger = logging.getLogger(__name__)


# ---------- Utilitaires ----------
def safe_mkdir(path: str) -> str:
    """Crée un répertoire de manière sécurisée.
    
    Args:
        path: Chemin du répertoire à créer
        
    Returns:
        Le chemin créé
        
    Raises:
        OSError: Si la création échoue
    """
    try:
        os.makedirs(path, exist_ok=True)
        return path
    except OSError as e:
        logger.error(f"Impossible de créer le répertoire {path}: {e}")
        raise


def is_path_within_directory(base: str, target: str) -> bool:
    """Sécurise l'extraction (évite traversals: '../../' ou chemins absolus)."""
    base = os.path.abspath(base)
    target = os.path.abspath(target)
    return os.path.commonprefix([base, target]) == base


def list_dxfs_recursive(directories: List[str]) -> List[str]:
    """Parcours récursif des dossiers et collecte les .dxf (insensible à la casse).
    
    Args:
        directories: Liste des dossiers à parcourir
        
    Returns:
        Liste des chemins vers les fichiers DXF trouvés
    """
    paths = []
    for d in directories:
        if not d or not os.path.isdir(d):
            continue
        for root, _, files in os.walk(d):
            for f in files:
                if f.lower().endswith(".dxf"):
                    paths.append(os.path.join(root, f))
    return paths


def list_tarbz2_files(directory: str) -> List[str]:
    """Liste tous les fichiers .tar.bz2 dans un dossier (non récursif).
    
    Args:
        directory: Chemin du dossier à analyser
        
    Returns:
        Liste des chemins absolus vers les archives .tar.bz2
    """
    if not directory or not os.path.isdir(directory):
        return []
    archives = []
    for f in os.listdir(directory):
        if f.lower().endswith(".tar.bz2"):
            archives.append(os.path.join(directory, f))
    return archives


@contextmanager
def temp_directory(prefix: str = "dxf_temp_"):
    """Context manager pour créer et nettoyer automatiquement un dossier temporaire.
    
    Args:
        prefix: Préfixe pour le nom du dossier temporaire
        
    Yields:
        Chemin du dossier temporaire créé
    """
    tmp_dir = tempfile.mkdtemp(prefix=prefix)
    logger.info(f"Dossier temporaire créé : {tmp_dir}")
    try:
        yield tmp_dir
    finally:
        try:
            shutil.rmtree(tmp_dir, ignore_errors=True)
            logger.info(f"Dossier temporaire supprimé : {tmp_dir}")
        except Exception as e:
            logger.warning(f"Impossible de supprimer {tmp_dir}: {e}")


def validate_dxf_file(filepath: str) -> Tuple[bool, Optional[str]]:
    """Valide qu'un fichier DXF est lisible.
    
    Args:
        filepath: Chemin vers le fichier DXF
        
    Returns:
        Tuple (est_valide, message_erreur)
    """
    if not os.path.isfile(filepath):
        return False, f"Fichier introuvable : {filepath}"
    
    if os.path.getsize(filepath) == 0:
        return False, f"Fichier vide : {filepath}"
    
    try:
        doc = ezdxf.readfile(filepath)
        return True, None
    except Exception as e:
        return False, f"Fichier DXF invalide : {e}"


# ---------- Worker (thread) ----------
class Worker(QThread):
    log = pyqtSignal(str)
    progress = pyqtSignal(int)      # 0..100
    finished_ok = pyqtSignal(str)   # message
    finished_err = pyqtSignal(str)  # message

    def __init__(self, archive_folder, directories, output_folder, do_convert, oda_path, dwg_version):
        super().__init__()
        self.archive_folder = (archive_folder or "").strip()
        self.directories = directories or []
        self.output_folder = output_folder
        self.do_convert = do_convert
        self.oda_path = (oda_path or "").strip()
        self.dwg_version = (dwg_version or "ACAD2018").strip()
        self._stop_requested = False
    
    def stop(self):
        """Demande l'arrêt du traitement."""
        self._stop_requested = True
        self.log.emit("⏸️ Arrêt demandé...")
    
    def is_stopped(self) -> bool:
        """Vérifie si l'arrêt a été demandé."""
        return self._stop_requested

    def run(self):
        try:
            start_ts = datetime.now()
            self.log.emit(f"▶️ Début du traitement : {start_ts:%Y-%m-%d %H:%M:%S}")

            if not self.archive_folder and not self.directories:
                raise RuntimeError("Aucune source fournie. Sélectionnez un dossier d'archives .tar.bz2.")

            safe_mkdir(self.output_folder)

            # Utilisation du context manager pour gestion automatique des temporaires
            with temp_directory(prefix="dxf_merge_") as tmp_root:
                extract_dir = safe_mkdir(os.path.join(tmp_root, "extracted"))
                self.log.emit(f"📦 Dossier temporaire d'extraction : {extract_dir}")
                
                self._process_files(extract_dir, start_ts)

        except Exception as e:
            logger.error(f"Erreur dans le traitement: {e}", exc_info=True)
            self.finished_err.emit(f"❌ Erreur: {e}\n{traceback.format_exc()}")
    
    def _process_files(self, extract_dir: str, start_ts: datetime):
        """Traite les fichiers (extraction, fusion, conversion).
        
        Args:
            extract_dir: Dossier d'extraction temporaire
            start_ts: Timestamp de début
        """
        try:

            dxf_files = []

            # ---- 1) Extraction DXF depuis toutes les archives .tar.bz2 (si dossier fourni) ----
            if self.archive_folder:
                self.log.emit(f"📂 Dossier d'archives sélectionné : {self.archive_folder}")
                archive_files = list_tarbz2_files(self.archive_folder)
                self.log.emit(f"🔍 {len(archive_files)} archive(s) .tar.bz2 trouvée(s)")
                
                for idx, archive_path in enumerate(archive_files, start=1):
                    if self.is_stopped():
                        self.finished_err.emit("⏸️ Traitement annulé par l'utilisateur")
                        return
                    
                    self.log.emit(f"📦 Extraction de l'archive {idx}/{len(archive_files)}: {os.path.basename(archive_path)}")
                    from_archive = self.extract_dxf_only(archive_path, extract_dir)
                    self.log.emit(f"   ✅ {len(from_archive)} DXF extrait(s)")
                    dxf_files.extend(from_archive)
                
                self.log.emit(f"✅ Total DXF extraits depuis toutes les archives : {len(dxf_files)}")
            else:
                self.progress.emit(10)
            
            if self.is_stopped():
                self.finished_err.emit("⏸️ Traitement annulé par l'utilisateur")
                return

            # ---- 2) Récolte DXF depuis les dossiers sélectionnés ----
            if self.directories:
                self.log.emit("🔎 Recherche de DXF dans les dossiers sélectionnés…")
                self.log.emit("   " + " | ".join(self.directories))
                from_dirs = list_dxfs_recursive(self.directories)
                self.log.emit(f"✅ DXF trouvés dans les dossiers : {len(from_dirs)}")
                dxf_files.extend(from_dirs)
            else:
                self.progress.emit(20)

            # Déduplication tout en préservant l'ordre
            dxf_files = list(dict.fromkeys(dxf_files))

            self.log.emit(f"📊 Total DXF à fusionner : {len(dxf_files)}")
            if not dxf_files:
                raise RuntimeError("Aucun fichier DXF à traiter (archive/dossiers vides).")
            
            # Validation des fichiers DXF
            self.log.emit("🔍 Validation des fichiers DXF...")
            valid_dxf_files = []
            for dxf_path in dxf_files:
                if self.is_stopped():
                    self.finished_err.emit("⏸️ Traitement annulé par l'utilisateur")
                    return
                
                is_valid, error_msg = validate_dxf_file(dxf_path)
                if is_valid:
                    valid_dxf_files.append(dxf_path)
                else:
                    self.log.emit(f"⚠️ Fichier ignoré : {error_msg}")
            
            if not valid_dxf_files:
                raise RuntimeError("Aucun fichier DXF valide trouvé.")
            
            self.log.emit(f"✅ {len(valid_dxf_files)} fichier(s) DXF valide(s) sur {len(dxf_files)}")
            dxf_files = valid_dxf_files

            # ---- 3) Fusion DXF → assemblage.dxf ----
            if self.is_stopped():
                self.finished_err.emit("⏸️ Traitement annulé par l'utilisateur")
                return
            
            output_dxf = os.path.join(self.output_folder, "assemblage.dxf")
            self.merge_dxfs(dxf_files, output_dxf)
            
            if self.is_stopped():
                self.finished_err.emit("⏸️ Traitement annulé par l'utilisateur")
                return
            
            self.log.emit(f"🧩 Fusion terminée → {output_dxf}")
            final_file = output_dxf  # Fichier final à ouvrir

            # ---- 4) Conversion optionnelle en DWG via ODA File Converter ----
            if self.do_convert:
                if not self.oda_path or not os.path.isfile(self.oda_path):
                    raise FileNotFoundError(
                        "Chemin vers ODA File Converter invalide.\n"
                        "Désactivez la conversion DWG ou indiquez le bon exécutable."
                    )
                self.log.emit("🔁 Conversion DXF → DWG avec ODA File Converter…")
                self.convert_to_dwg(self.oda_path, output_dxf, self.output_folder, self.dwg_version)
                output_dwg = os.path.join(self.output_folder, "assemblage.dwg")
                if os.path.isfile(output_dwg):
                    self.log.emit(f"✅ DWG généré : {output_dwg}")
                    # S'assurer que le fichier DWG n'est pas en lecture seule
                    try:
                        os.chmod(output_dwg, 0o666)
                    except Exception:
                        pass
                    final_file = output_dwg  # Ouvrir le DWG plutôt que le DXF
                else:
                    self.log.emit("⚠️ Conversion exécutée, mais DWG introuvable. "
                                  "Vérifiez la version/syntaxe d'ODA.")
            else:
                self.log.emit("ℹ️ Conversion DWG désactivée (DXF uniquement).")

            # ---- 5) Ouverture automatique dans AutoCAD avec zoom ----
            try:
                self.log.emit(f"🚀 Ouverture du fichier dans AutoCAD : {final_file}")
                self.open_in_autocad_with_zoom(final_file)
            except Exception as e:
                self.log.emit(f"⚠️ Impossible d'ouvrir automatiquement : {e}")
                # Fallback: ouverture simple sans zoom
                try:
                    os.startfile(final_file)
                except Exception:
                    pass

            if self.is_stopped():
                self.finished_err.emit("⏸️ Traitement annulé par l'utilisateur")
                return
            
            self.progress.emit(100)
            end_ts = datetime.now()
            elapsed = (end_ts - start_ts).total_seconds()
            self.finished_ok.emit(f"Terminé en {elapsed:.1f} s.")

        except Exception as e:
            logger.error(f"Erreur finale: {e}", exc_info=True)
            self.finished_err.emit(f"❌ Erreur: {e}\n{traceback.format_exc()}")

    # ---------- Sous-étapes ----------
    def open_in_autocad_with_zoom(self, filepath):
        """Ouvre le fichier dans AutoCAD en espace objet (Model) et effectue un zoom étendu."""
        try:
            import win32com.client
            
            # Connexion à AutoCAD via COM
            try:
                acad = win32com.client.Dispatch("AutoCAD.Application")
            except Exception:
                # Si AutoCAD n'est pas en cours, on le démarre
                acad = win32com.client.Dispatch("AutoCAD.Application")
            
            acad.Visible = True
            self.log.emit("   📐 AutoCAD connecté")
            
            # Ouvrir le document
            doc = acad.Documents.Open(filepath)
            self.log.emit(f"   📂 Document ouvert : {os.path.basename(filepath)}")
            
            # Attendre que le document soit chargé
            time.sleep(1)
            
            # Basculer vers l'espace objet (Model Space)
            try:
                # Activer l'espace objet
                doc.ActiveSpace = 1  # 1 = Model Space, 0 = Paper Space
                doc.MSpace = True    # Activer Model Space dans la fenêtre
                self.log.emit("   📦 Espace objet (Model Space) activé")
            except Exception as e:
                self.log.emit(f"   ⚠️ Activation espace objet: {e}")
            
            # Effectuer un zoom étendu (ZOOM EXTENT)
            acad.ActiveDocument.SendCommand("_.ZOOM _E ")
            self.log.emit("   🔍 Zoom étendu appliqué")
            
        except ImportError:
            logger.warning("Module win32com non disponible")
            self.log.emit("   ⚠️ Module win32com non disponible, ouverture simple")
            os.startfile(filepath)
        except Exception as e:
            logger.warning(f"Erreur contrôle AutoCAD: {e}", exc_info=True)
            self.log.emit(f"   ⚠️ Erreur contrôle AutoCAD: {e}, ouverture simple")
            os.startfile(filepath)
    
    def extract_dxf_only(self, archive_path: str, extract_dir: str) -> List[str]:
        """Extrait uniquement les fichiers .dxf de l'archive .tar.bz2, de façon sécurisée.
        
        Args:
            archive_path: Chemin vers l'archive .tar.bz2
            extract_dir: Dossier de destination pour l'extraction
            
        Returns:
            Liste des chemins vers les fichiers DXF extraits
        """
        dxf_paths = []
        with tarfile.open(archive_path, "r:bz2") as tar:
            members = tar.getmembers()
            dxf_members = [m for m in members if m.name.lower().endswith(".dxf")]
            total = len(dxf_members)
            if total == 0:
                self.log.emit("ℹ️ Aucun DXF trouvé dans l'archive.")
                return dxf_paths

            for i, m in enumerate(dxf_members, start=1):
                # Chemin de sortie sécurisé
                out_path = os.path.join(extract_dir, os.path.normpath(m.name))
                if not is_path_within_directory(extract_dir, out_path):
                    self.log.emit(f"⛔ Chemin suspect ignoré: {m.name}")
                    continue

                # Créer le dossier cible
                os.makedirs(os.path.dirname(out_path), exist_ok=True)

                # Extraire le flux et écrire le fichier
                try:
                    f = tar.extractfile(m)
                    if f is None:
                        self.log.emit(f"⚠️ Impossible d'extraire: {m.name}")
                        continue
                    with open(out_path, "wb") as fout:
                        fout.write(f.read())
                except Exception as e:
                    logger.warning(f"Erreur extraction {m.name}: {e}")
                    self.log.emit(f"⚠️ Erreur extraction {m.name}: {e}")
                    continue
                
                # S'assurer que le fichier n'est pas en lecture seule
                os.chmod(out_path, 0o666)

                dxf_paths.append(out_path)
                # Progression ~ 5..40 % pendant extraction
                self.progress.emit(5 + int(35 * i / max(1, total)))
        return dxf_paths

    def merge_dxfs(self, dxf_paths: List[str], output_dxf: str) -> None:
        """Fusionne tous les DXF en conservant leurs coordonnées d'origine (pour plans cadastre géoréférencés).
        
        Args:
            dxf_paths: Liste des chemins vers les fichiers DXF à fusionner
            output_dxf: Chemin du fichier DXF de sortie
        """
        # Créer un DXF final (R2010 pour compatibilité large)
        doc_final = ezdxf.new("R2010")
        total = len(dxf_paths)
        imported_entities = 0

        self.log.emit(f"🗺️ Assemblage de {total} fichiers cadastre avec coordonnées géographiques d'origine")

        # Progression démarre à ~40% (après extraction/recherche)
        for idx, path in enumerate(dxf_paths, start=1):
            if self.is_stopped():
                return
            
            try:
                doc_src = ezdxf.readfile(path)
                msp_src = doc_src.modelspace()
                
                # Afficher les coordonnées du fichier pour info
                try:
                    box = bbox.extents(msp_src)
                    if box.has_data:
                        self.log.emit(f"   📍 {os.path.basename(path)} → "
                                    f"X:[{box.extmin.x:.2f} à {box.extmax.x:.2f}] "
                                    f"Y:[{box.extmin.y:.2f} à {box.extmax.y:.2f}]")
                except Exception:
                    pass
                
                # Importer directement SANS TRANSFORMATION - conservation des coordonnées géographiques
                importer = Importer(doc_src, doc_final)
                importer.import_modelspace()
                importer.finalize()

                entities_in = len(msp_src)
                imported_entities += entities_in
                self.log.emit(f"   ✅ {entities_in} entité(s) importée(s) aux coordonnées d'origine")
            except Exception as e:
                logger.warning(f"Erreur import {path}: {e}", exc_info=True)
                self.log.emit(f"⚠️ Erreur import {os.path.basename(path)}: {e}")

            # Progression 40..92 % pendant fusion
            self.progress.emit(40 + int(52 * idx / max(1, total)))

        # Sauvegarde finale
        doc_final.saveas(output_dxf)
        
        # S'assurer que le fichier n'est pas en lecture seule
        try:
            os.chmod(output_dxf, 0o666)
        except Exception:
            pass
        
        self.log.emit(f"📄 Total entités importées : {imported_entities}")
        self.log.emit(f"🗺️ Plan cadastre assemblé avec coordonnées géographiques conservées")

    def convert_to_dwg(self, oda_path, input_dxf, output_folder, dwg_version):
        """
        Appel ODA File Converter en ligne de commande.
        La plupart des versions attendent 'répertoire entrée' et 'répertoire sortie'.
        On place donc le DXF dans un dossier temporaire et on convertit le dossier.
        """
        tmp_in_dir = tempfile.mkdtemp(prefix="oda_in_")
        tmp_dxf = os.path.join(tmp_in_dir, os.path.basename(input_dxf))
        # Copie du DXF dans le dossier temp
        with open(input_dxf, "rb") as f_in, open(tmp_dxf, "wb") as f_out:
            f_out.write(f_in.read())

        # Commande standard ODA (peut varier selon version) :
        # ODAFileConverter.exe "inDir" "outDir" "ACAD2018" "DWG" /r
        cmd = f'"{oda_path}" "{tmp_in_dir}" "{output_folder}" "{dwg_version}" "DWG" /r'
        self.log.emit(f"CMD: {cmd}")
        subprocess.run(cmd, shell=True)
        self.progress.emit(95)


# ---------- Interface ----------
class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Assembleur DXF → DWG - © C.L Pour les amis @ SpieCitynetwork")
        self.resize(600, 400)
        
        self.worker = None

        self.worker = None

        # --- Widgets sources ---
        self.arch_line = QLineEdit()
        self.btn_arch = QPushButton("Parcourir…")
        self.btn_arch.clicked.connect(self.select_archive_folder)

        # Liste pour afficher les fichiers .tar.bz2 trouvés
        self.archives_list = QListWidget()

        # --- Destination ---
        default_output = os.path.join(os.path.expanduser("~"), "Documents", "DXF_DWG_Output")
        self.out_line = QLineEdit(default_output)
        self.btn_out = QPushButton("Parcourir…")
        self.btn_out.clicked.connect(self.select_output)

        # --- Conversion ODA ---
        self.convert_chk = QCheckBox("Convertir en DWG (ODA File Converter)")
        self.oda_line = QLineEdit()
        self.btn_oda = QPushButton("Parcourir…")
        self.btn_oda.clicked.connect(self.select_oda)
        self.version_line = QLineEdit("ACAD2018")

        # --- Progression & log ---
        self.progress = QProgressBar()
        self.progress.setRange(0, 100)
        self.log = QTextEdit()
        self.log.setReadOnly(True)

        self.btn_run = QPushButton("▶ Lancer")
        self.btn_run.clicked.connect(self.run_job)
        
        self.btn_stop = QPushButton("⏹ Arrêter")
        self.btn_stop.clicked.connect(self.stop_job)
        self.btn_stop.setEnabled(False)

        # --- Layout ---
        main_layout = QVBoxLayout()
        main_layout.setSpacing(10)
        main_layout.setContentsMargins(15, 15, 15, 15)

        # Groupe Source
        source_group = QGroupBox("📦 Source des fichiers")
        source_layout = QGridLayout()
        source_layout.addWidget(QLabel("Dossier d'archives .tar.bz2 :"), 0, 0)
        source_layout.addWidget(self.arch_line, 0, 1)
        source_layout.addWidget(self.btn_arch, 0, 2)
        source_layout.addWidget(QLabel("Archives détectées :"), 1, 0, Qt.AlignTop)
        source_layout.addWidget(self.archives_list, 1, 1, 1, 2)
        source_layout.setColumnStretch(1, 1)
        source_group.setLayout(source_layout)

        # Groupe Destination
        dest_group = QGroupBox("💾 Destination")
        dest_layout = QGridLayout()
        dest_layout.addWidget(QLabel("Dossier de sortie :"), 0, 0)
        dest_layout.addWidget(self.out_line, 0, 1)
        dest_layout.addWidget(self.btn_out, 0, 2)
        dest_layout.setColumnStretch(1, 1)
        dest_group.setLayout(dest_layout)

        # Groupe Conversion
        conv_group = QGroupBox("🔄 Conversion DWG (optionnel)")
        conv_layout = QGridLayout()
        conv_layout.addWidget(self.convert_chk, 0, 0, 1, 3)
        conv_layout.addWidget(QLabel("ODA File Converter :"), 1, 0)
        conv_layout.addWidget(self.oda_line, 1, 1)
        conv_layout.addWidget(self.btn_oda, 1, 2)
        conv_layout.addWidget(QLabel("Version DWG :"), 2, 0)
        conv_layout.addWidget(self.version_line, 2, 1)
        conv_layout.setColumnStretch(1, 1)
        conv_group.setLayout(conv_layout)

        # Groupe Progression
        progress_group = QGroupBox("📊 Progression")
        progress_layout = QVBoxLayout()
        progress_layout.addWidget(self.progress)
        progress_group.setLayout(progress_layout)

        # Groupe Journal
        log_group = QGroupBox("📝 Journal")
        log_layout = QVBoxLayout()
        log_layout.addWidget(self.log)
        log_group.setLayout(log_layout)

        # Boutons
        buttons_layout = QHBoxLayout()
        buttons_layout.addStretch()
        buttons_layout.addWidget(self.btn_run)
        buttons_layout.addWidget(self.btn_stop)
        buttons_layout.addStretch()

        # Assemblage
        main_layout.addWidget(source_group)
        main_layout.addWidget(dest_group)
        main_layout.addWidget(conv_group)
        main_layout.addWidget(progress_group)
        main_layout.addWidget(log_group, 1)
        main_layout.addLayout(buttons_layout)

        container = QWidget()
        container.setLayout(main_layout)
        self.setCentralWidget(container)

    # --- Callbacks UI ---
    def select_archive_folder(self):
        folder = QFileDialog.getExistingDirectory(self, "Choisir le dossier contenant les archives .tar.bz2", "")
        if folder:
            self.arch_line.setText(folder)
            self.archives_list.clear()
            archive_files = list_tarbz2_files(folder)
            if archive_files:
                for archive in archive_files:
                    self.archives_list.addItem(os.path.basename(archive))
            else:
                self.archives_list.addItem("(Aucune archive .tar.bz2 trouvée)")

    def select_output(self):
        folder = QFileDialog.getExistingDirectory(self, "Choisir le dossier de sortie", self.out_line.text() or "")
        if folder:
            self.out_line.setText(folder)

    def select_oda(self):
        # Sur Windows : *.exe ; ailleurs : tous fichiers
        path, _ = QFileDialog.getOpenFileName(
            self, "Choisir ODAFileConverter", "",
            "Exécutables (*.exe);;Tous les fichiers (*)"
        )
        if path:
            self.oda_line.setText(path)

    def append_log(self, txt: str):
        """Ajoute un message au journal."""
        self.log.append(txt)

    def run_job(self):
        archive_folder = self.arch_line.text().strip()
        output_folder = self.out_line.text().strip()
        do_convert = self.convert_chk.isChecked()
        oda_path = self.oda_line.text().strip()
        dwg_version = self.version_line.text().strip() or "ACAD2018"

        # Validation des entrées
        if not archive_folder:
            QMessageBox.warning(self, "Source manquante",
                                "Sélectionnez un dossier d'archives .tar.bz2.")
            return
        
        if not os.path.isdir(archive_folder):
            QMessageBox.warning(self, "Dossier invalide",
                                f"Le dossier source n'existe pas : {archive_folder}")
            return
        
        if not output_folder:
            QMessageBox.warning(self, "Dossier de sortie manquant",
                                "Sélectionnez un dossier de sortie.")
            return
        
        # Vérifier que le dossier de sortie est accessible en écriture
        try:
            safe_mkdir(output_folder)
        except OSError:
            QMessageBox.critical(self, "Erreur dossier sortie",
                                f"Impossible de créer/accéder au dossier : {output_folder}")
            return
        if do_convert and not oda_path:
            ret = QMessageBox.question(
                self, "ODA manquant",
                "Chemin vers ODA File Converter non indiqué.\n"
                "Voulez-vous lancer uniquement la fusion DXF ?",
                QMessageBox.Yes | QMessageBox.No
            )
            if ret == QMessageBox.No:
                return
            do_convert = False

        self.progress.setValue(0)
        self.log.clear()
        self.append_log("🔧 Lancement du traitement…")

        self.worker = Worker(archive_folder, [], output_folder, do_convert, oda_path, dwg_version)
        self.worker.log.connect(self.append_log)
        self.worker.progress.connect(self.progress.setValue)
        self.worker.finished_ok.connect(self.on_finished_ok)
        self.worker.finished_err.connect(self.on_finished_err)

        self.btn_run.setEnabled(False)
        self.btn_stop.setEnabled(True)
        self.worker.start()
    
    def stop_job(self):
        """Arrête le traitement en cours."""
        if self.worker and self.worker.isRunning():
            self.worker.stop()
            self.append_log("⏸️ Demande d'arrêt envoyée...")

    def on_finished_ok(self, msg: str):
        """Appelé quand le traitement se termine avec succès."""
        self.append_log(f"✅ {msg}")
        self.btn_run.setEnabled(True)
        self.btn_stop.setEnabled(False)
        QMessageBox.information(self, "Terminé", msg)

    def on_finished_err(self, msg: str):
        """Appelé quand le traitement se termine avec erreur."""
        self.append_log(msg)
        self.btn_run.setEnabled(True)
        self.btn_stop.setEnabled(False)
        if "annulé" not in msg.lower():
            QMessageBox.critical(self, "Erreur", msg)
        else:
            QMessageBox.warning(self, "Annulé", "Traitement arrêté par l'utilisateur.")


# ---------- Entrée ----------
def main():
    app = QApplication(sys.argv)
    w = MainWindow()
    w.show()
    sys.exit(app.exec_())


if __name__ == "__main__":
    main()
