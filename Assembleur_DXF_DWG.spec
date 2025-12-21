# -*- mode: python ; coding: utf-8 -*-


a = Analysis(
    ['assembleur_dxf_dwg.py'],
    pathex=[],
    binaries=[],
    datas=[('assembleur_dxf_dwg.py', '.'), ('config/icon.ico', 'config')],
    hiddenimports=['ezdxf', 'ezdxf.addons', 'ezdxf.addons.dxf2code', 'ezdxf.lldxf', 'ezdxf.entities', 'PyQt5.QtCore', 'PyQt5.QtGui', 'PyQt5.QtWidgets', 'win32com.client', 'win32com'],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[],
    noarchive=False,
    optimize=0,
)
pyz = PYZ(a.pure)

exe = EXE(
    pyz,
    a.scripts,
    a.binaries,
    a.datas,
    [],
    name='Assembleur_DXF_DWG',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    upx_exclude=[],
    runtime_tmpdir=None,
    console=False,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
    icon=['config\\icon.ico'],
)
