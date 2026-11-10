$ErrorActionPreference = 'Stop'
$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $Root
if (-not $env:BONSAI_FAMILY) { $env:BONSAI_FAMILY = 'ternary' }
if (-not $env:BONSAI_MODEL) { $env:BONSAI_MODEL = '4B' }
$prompt = Read-Host 'Digite sua pergunta'
if ([string]::IsNullOrWhiteSpace($prompt)) { exit 0 }
& (Join-Path $Root 'scripts\run_llama.ps1') -p $prompt
Read-Host "`nPressione Enter para fechar"
