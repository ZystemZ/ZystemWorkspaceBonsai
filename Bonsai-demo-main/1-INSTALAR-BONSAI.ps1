$ErrorActionPreference = 'Stop'
$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $Root

Write-Host ''
Write-Host '=============================================' -ForegroundColor Cyan
Write-Host ' Bonsai Windows - instalacao anti-burro' -ForegroundColor Cyan
Write-Host ' Perfil: Ryzen 5 5600GT / video integrado' -ForegroundColor Cyan
Write-Host '=============================================' -ForegroundColor Cyan
Write-Host ''
Write-Host 'Escolha o modelo:'
Write-Host '  1 - Ternary-Bonsai 4B (recomendado para este PC)'
Write-Host '  2 - Ternary-Bonsai 8B (mais capaz, mas mais lento)'
Write-Host '  3 - Bonsai 2 27B (nao recomendado sem GPU dedicada)'
$choice = Read-Host 'Digite 1, 2 ou 3 [Enter = 1]'
if ([string]::IsNullOrWhiteSpace($choice)) { $choice = '1' }
switch ($choice) {
  '2' { $env:BONSAI_FAMILY = 'ternary'; $env:BONSAI_MODEL = '8B' }
  '3' { $env:BONSAI_FAMILY = 'bonsai2'; $env:BONSAI_MODEL = '27B' }
  default { $env:BONSAI_FAMILY = 'ternary'; $env:BONSAI_MODEL = '4B' }
}

Write-Host "`nModelo selecionado: $env:BONSAI_FAMILY / $env:BONSAI_MODEL" -ForegroundColor Green
Write-Host 'O instalador vai usar CPU, a menos que voce ja tenha Vulkan/ROCm configurado.' -ForegroundColor Yellow
Write-Host 'Nao feche esta janela durante o download.`n'
& (Join-Path $Root 'setup.ps1')
$code = $LASTEXITCODE
if ($code -ne 0) { throw "A instalacao terminou com codigo $code." }
Write-Host "`nInstalacao concluida. Agora use 2-INICIAR-BONSAI.bat.`n" -ForegroundColor Green
Read-Host 'Pressione Enter para fechar'
