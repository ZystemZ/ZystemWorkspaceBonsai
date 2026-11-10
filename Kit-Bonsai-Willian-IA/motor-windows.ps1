param([switch]$Verificar)
$ErrorActionPreference = 'Stop'
try {
    $base = $PSScriptRoot
    $config = @{}
    foreach ($line in [IO.File]::ReadAllLines((Join-Path $base 'configuracoes.txt'))) {
        $line = $line.Trim()
        if (!$line -or $line.StartsWith('#')) { continue }
        $parts = $line -split '=', 2
        if ($parts.Count -ne 2) { throw 'Use NOME=valor no arquivo configuracoes.txt.' }
        $key = $parts[0].Trim()
        if ($key -notin @('MODO','CONTEXTO','CAMADAS_GPU','PROJETO','PORTA')) { throw "Opcao desconhecida: $key" }
        if ($config.ContainsKey($key)) { throw "Opcao repetida: $key" }
        $config[$key] = $parts[1].Trim()
    }
    foreach ($key in @('MODO','CONTEXTO','CAMADAS_GPU','PROJETO','PORTA')) {
        if (!$config.ContainsKey($key) -or !$config[$key]) { throw "Preencha $key em configuracoes.txt." }
    }
    if ($config.MODO -notin @('chat','arquivos','total')) { throw 'MODO: escolha chat, arquivos ou total (sem aspas).' }
    foreach ($rule in @(@('CONTEXTO',1,262144),@('CAMADAS_GPU',0,999),@('PORTA',1,65535))) {
        $number = 0
        $key = $rule[0]
        if ($config[$key] -notmatch '^\d+$' -or ![int]::TryParse($config[$key], [ref]$number) -or $number -lt $rule[1] -or $number -gt $rule[2]) {
            throw "$key invalido: $($config[$key]). Use inteiro de $($rule[1]) a $($rule[2]), sem pontos. Para CONTEXTO, comece com 4096."
        }
        $config[$key] = "$number"
    }
    $exe = Join-Path $base 'llama-server.exe'
    $model = Join-Path $base 'Ternary-Bonsai-2-27B-PTQ1_0.gguf'
    $lora = Join-Path $base 'bonsai-abliterate-lora.gguf'
    foreach ($file in @($exe,$model,$lora)) {
        if (!(Test-Path -LiteralPath $file -PathType Leaf)) { throw "Arquivo ausente: $file. Extraia o kit na mesma pasta do programa e dos dois GGUF." }
    }
    $folder = $base
    if ($config.MODO -ne 'chat') {
        $folder = $config.PROJETO
        if (![IO.Path]::IsPathRooted($folder)) { $folder = Join-Path $base $folder }
        if (!(Test-Path -LiteralPath $folder -PathType Container)) { throw "Pasta PROJETO nao encontrada: $folder. Use o caminho sem aspas, sem `$env: e sem ~." }
    }
    $options = @('-m',$model,'--lora',$lora,'-ngl',$config.CAMADAS_GPU,
        '-c',$config.CONTEXTO,'-np','1','-fa','auto','--jinja',
        '--temp','1.0','--top-p','0.95','--top-k','20',
        '--host','127.0.0.1','--port',$config.PORTA)
    if ($config.MODO -eq 'arquivos') { $options += @('--tools','read_file,file_glob_search,grep_search,write_file,edit_file') }
    if ($config.MODO -eq 'total') { $options += @('--tools','all') }
    if ($Verificar) {
        @{mode=$config.MODO; folder=$folder; arguments=$options} | ConvertTo-Json -Depth 3
        exit 0
    }
    Write-Host "Modo: $($config.MODO) | Contexto: $($config.CONTEXTO) | GPU: $($config.CAMADAS_GPU)"
    Write-Host "Pasta: $folder"
    Write-Host "Aguarde carregar e abra http://127.0.0.1:$($config.PORTA)"
    if ($config.MODO -ne 'chat') { Write-Host 'ATENCAO: ferramentas podem acessar outros caminhos permitidos a sua conta.' -ForegroundColor Yellow }
    Push-Location -LiteralPath $folder
    try { & $exe @options; $result = $LASTEXITCODE } finally { Pop-Location }
    if ($result -ne 0) { throw "O programa terminou com codigo $result. Confira as mensagens acima, DLLs/driver e memoria; tente CONTEXTO=4096." }
} catch {
    Write-Host "`nNAO FOI POSSIVEL INICIAR" -ForegroundColor Yellow
    Write-Host $_.Exception.Message
    Write-Host 'Corrija configuracoes.txt, salve e abra Iniciar-Windows.bat novamente.'
    exit 1
}
