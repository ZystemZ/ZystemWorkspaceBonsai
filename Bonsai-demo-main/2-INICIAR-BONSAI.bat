@echo off
cd /d "%~dp0"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp02-INICIAR-BONSAI.ps1"
pause
