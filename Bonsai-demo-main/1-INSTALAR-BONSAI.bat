@echo off
cd /d "%~dp0"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp01-INSTALAR-BONSAI.ps1"
if errorlevel 1 (
  echo.
  echo A instalacao encontrou um erro. Copie a mensagem acima se precisar de ajuda.
  pause
)
