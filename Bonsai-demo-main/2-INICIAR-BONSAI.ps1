$ErrorActionPreference = 'Stop'
$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $Root
if (-not $env:BONSAI_FAMILY) { $env:BONSAI_FAMILY = 'ternary' }
if (-not $env:BONSAI_MODEL) { $env:BONSAI_MODEL = '4B' }
Write-Host 'Iniciando Bonsai em http://localhost:8080 ...' -ForegroundColor Cyan
Write-Host "Modelo padrao: Ternary-Bonsai $env:BONSAI_MODEL (CPU)" -ForegroundColor Green
Write-Host 'Para parar: Ctrl+C nesta janela.' -ForegroundColor Yellow
Start-Job -ScriptBlock { Start-Sleep -Seconds 4; Start-Process 'http://localhost:8080' } | Out-Null
& (Join-Path $Root 'scripts\start_llama_server.ps1') @args
exit $LASTEXITCODE
