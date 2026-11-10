$ErrorActionPreference='Stop'
$Root=Split-Path -Parent $MyInvocation.MyCommand.Path
$Bonsai=Join-Path $Root 'Bonsai-demo-main'
$Zystem=Join-Path $Root 'ZystemWorkSpace'
if(-not $env:BONSAI_FAMILY){$env:BONSAI_FAMILY='ternary'}
if(-not $env:BONSAI_MODEL){$env:BONSAI_MODEL='4B'}
if(-not $env:MANUZ_LLM_URL){$env:MANUZ_LLM_URL='http://127.0.0.1:8080/v1';$env:MANUZ_LLM_PROVIDER='llama-server';Write-Host 'Usando Bonsai local em http://127.0.0.1:8080/v1' -ForegroundColor Cyan}else{Write-Host "Usando provedor configurado em $env:MANUZ_LLM_URL" -ForegroundColor Cyan}
Write-Host 'Iniciando servidor do Bonsai...' -ForegroundColor Cyan
Start-Process powershell.exe -ArgumentList '-NoProfile','-ExecutionPolicy','Bypass','-File',(Join-Path $Bonsai 'scripts\start_llama_server.ps1') -WorkingDirectory $Bonsai
Start-Sleep -Seconds 5
$php='C:\xampp\php\php.exe'
if(-not(Test-Path $php)){$php=(Get-Command php -ErrorAction SilentlyContinue).Source}
if(-not $php){Write-Host 'PHP nao encontrado. Instale XAMPP ou PHP e rode novamente.' -ForegroundColor Red;Read-Host 'Enter para fechar';exit 1}
Write-Host 'Iniciando ZystemWorkSpace em http://127.0.0.1:8090/public/index.php ...' -ForegroundColor Cyan
# O docroot precisa ser a raiz do projeto: as páginas ficam em public/ e as APIs em api/.
Start-Process powershell.exe -ArgumentList '-NoProfile','-ExecutionPolicy','Bypass','-Command',"& '$php' -S 127.0.0.1:8090 -t '$Zystem'" -WorkingDirectory $Zystem
Start-Sleep -Seconds 3
Start-Process 'http://127.0.0.1:8090/public/index.php'
Write-Host 'Tudo iniciado. Nao feche as duas janelas dos servidores.' -ForegroundColor Green
Read-Host 'Pressione Enter para fechar este launcher'
