[CmdletBinding()]
param(
  [string]$Url = 'http://127.0.0.1:1234/v1',
  [string]$ApiKey = ''
)
$ErrorActionPreference = 'Stop'
$base = $Url.TrimEnd('/')
try {
  $headers = @{ Accept = 'application/json' }
  if ($ApiKey) { $headers.Authorization = "Bearer $ApiKey" }
  $response = Invoke-RestMethod -Uri "$base/models" -Headers $headers -Method Get -TimeoutSec 10
  $models = @($response.data)
  Write-Host "LM Studio conectado: $base" -ForegroundColor Green
  if ($models.Count -eq 0) { Write-Host 'Nenhum modelo publicado no servidor.' -ForegroundColor Yellow; exit 0 }
  Write-Host "Modelos publicados ($($models.Count)):`n"
  $models | ForEach-Object { Write-Host "- $($_.id)" }
  Write-Host "`nPara usar no ZystemWorkSpace nesta sessão:"
  Write-Host "$env:MANUZ_LLM_URL='$base'"
  Write-Host "$env:MANUZ_LLM_PROVIDER='lm-studio'"
} catch {
  Write-Error "Não foi possível conectar ao LM Studio em $base. Verifique se o servidor está iniciado e se a porta está correta. Detalhe: $($_.Exception.Message)"
  exit 1
}
