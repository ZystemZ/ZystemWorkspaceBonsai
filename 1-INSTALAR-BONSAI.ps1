$ErrorActionPreference='Stop'
$Root=Split-Path -Parent $MyInvocation.MyCommand.Path
$Bonsai=Join-Path $Root 'Bonsai-demo-main'
Set-Location $Bonsai
Write-Host 'Instalador completo: Bonsai + llama.cpp + modelo GGUF' -ForegroundColor Cyan
Write-Host 'Para seu Ryzen 5 5600GT, escolha a opcao 1.'
Write-Host '  1 - Ternary-Bonsai 4B (recomendado)'
Write-Host '  2 - Ternary-Bonsai 8B'
Write-Host '  3 - Bonsai 2 27B (pesado; nao recomendado sem GPU dedicada)'
$c=Read-Host 'Escolha 1, 2 ou 3 [Enter=1]'
if([string]::IsNullOrWhiteSpace($c)){$c='1'}
switch($c){'2'{$env:BONSAI_FAMILY='ternary';$env:BONSAI_MODEL='8B'};'3'{$env:BONSAI_FAMILY='bonsai2';$env:BONSAI_MODEL='27B'};default{$env:BONSAI_FAMILY='ternary';$env:BONSAI_MODEL='4B'}}
& (Join-Path $Bonsai 'setup.ps1')
if($LASTEXITCODE -ne 0){throw 'Falha no setup do Bonsai.'}
Write-Host 'Bonsai instalado. Para integrar a interface, use 2-INICIAR-TUDO.bat.' -ForegroundColor Green
Read-Host 'Pressione Enter para fechar'
