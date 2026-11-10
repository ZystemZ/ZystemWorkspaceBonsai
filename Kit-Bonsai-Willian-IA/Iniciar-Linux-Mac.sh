#!/bin/bash
# Configuracoes sao dados: nunca executamos o conteudo de configuracoes.txt.
fail() { printf '\nNAO FOI POSSIVEL INICIAR\n%s\nCorrija configuracoes.txt e tente novamente.\n' "$1" >&2; exit 1; }
base=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd) || exit 1
config="$base/configuracoes.txt"
[[ -f "$config" ]] || fail 'configuracoes.txt ausente: extraia todos os arquivos juntos.'
trim() { local s="$1"; s="${s#"${s%%[![:space:]]*}"}"; s="${s%"${s##*[![:space:]]}"}"; REPLY="$s"; }
seen='|'
while IFS= read -r line || [[ -n "$line" ]]; do
    line="${line#$'\xef\xbb\xbf'}"
    trim "$line"; line="$REPLY"
    [[ -z "$line" || "$line" == \#* ]] && continue
    [[ "$line" == *=* ]] || fail 'Use NOME=valor no arquivo.'
    trim "${line%%=*}"; key="$REPLY"
    trim "${line#*=}"; value="$REPLY"
    [[ "$seen" != *"|$key|"* ]] || fail "Opcao repetida: $key"
    seen="$seen$key|"
    case "$key" in
        MODO) mode="$value";; CONTEXTO) context="$value";;
        CAMADAS_GPU) gpu="$value";; PROJETO) project="$value";; PORTA) port="$value";;
        *) fail "Opcao desconhecida: $key";;
    esac
done < "$config"
case "${mode:-}" in chat|arquivos|total) ;; *) fail 'MODO: escolha chat, arquivos ou total, sem aspas.';; esac
number() {
    [[ "$2" =~ ^[0-9]+$ && ${#2} -le 9 ]] || fail "$1: use numero inteiro sem pontos."
    REPLY=$((10#$2))
    (( REPLY >= $3 && REPLY <= $4 )) || fail "$1 fora de $3 a $4. Para CONTEXTO, comece com 4096."
}
number CONTEXTO "${context:-}" 1 262144; context="$REPLY"
number CAMADAS_GPU "${gpu:-}" 0 999; gpu="$REPLY"
number PORTA "${port:-}" 1 65535; port="$REPLY"
[[ -n "${project:-}" ]] || fail 'Preencha PROJETO=. para usar a pasta do programa.'
exe="$base/llama-server"
model="$base/Ternary-Bonsai-2-27B-PTQ1_0.gguf"
lora="$base/bonsai-abliterate-lora.gguf"
for file in "$exe" "$model" "$lora"; do [[ -f "$file" ]] || fail "Arquivo ausente: $file"; done
folder="$base"
if [[ "$mode" != chat ]]; then
    case "$project" in /*) folder="$project";; *) folder="$base/$project";; esac
    [[ -d "$folder" ]] || fail "Pasta PROJETO nao encontrada: $folder. Use caminho sem aspas e sem ~."
fi
options=(-m "$model" --lora "$lora" -ngl "$gpu" -c "$context" -np 1 -fa auto --jinja
    --temp 1.0 --top-p 0.95 --top-k 20 --host 127.0.0.1 --port "$port")
case "$mode" in
    arquivos) options+=(--tools read_file,file_glob_search,grep_search,write_file,edit_file);;
    total) options+=(--tools all);;
esac
if [[ "${1:-}" == --verificar ]]; then
    printf 'MODO=%s\nPASTA=%s\n' "$mode" "$folder"
    printf 'ARG=%s\n' "${options[@]}"
    exit 0
fi
[[ -x "$exe" ]] || fail 'llama-server sem permissao de execucao. Na pasta do programa, use: chmod +x llama-server'
printf 'Modo: %s | Contexto: %s | GPU: %s\nPasta: %s\n' "$mode" "$context" "$gpu" "$folder"
printf 'Aguarde carregar e abra http://127.0.0.1:%s\n' "$port"
[[ "$mode" == chat ]] || printf 'ATENCAO: ferramentas podem acessar outros caminhos permitidos a sua conta.\n'
cd -- "$folder" || fail 'Nao foi possivel acessar a pasta.'
"$exe" "${options[@]}"
result=$?
[[ "$result" == 0 ]] || fail "O programa terminou com codigo $result. Confira bibliotecas/driver e memoria; tente CONTEXTO=4096."
