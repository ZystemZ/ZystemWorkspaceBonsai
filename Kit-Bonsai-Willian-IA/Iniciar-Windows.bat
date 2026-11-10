@echo off
setlocal
title Bonsai - Willian IA
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0motor-windows.ps1" %*
echo.
echo A janela pode ser fechada. Para alterar, edite configuracoes.txt.
pause
