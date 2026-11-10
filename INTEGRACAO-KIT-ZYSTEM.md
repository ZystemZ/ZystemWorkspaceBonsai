# Integração do Kit Bonsai com o ZystemWorkSpace

O guia fornecido foi analisado e o kit foi incluído como material de referência em `Kit-Bonsai-Willian-IA`. As ideias úteis foram incorporadas ao ZystemWorkSpace sem copiar o modo de terminal irrestrito.

## O que foi aproveitado

O arquivo `configuracoes.txt` do kit usa uma configuração simples por campos, valida contexto, camadas GPU, projeto e porta, e exibe mensagens claras quando algum arquivo falta. O ZystemWorkSpace incorporou a mesma preocupação com endpoint local, limites e validação.

Os nomes de ferramentas do kit também foram mapeados:

| Nome do kit | Implementação no workspace |
|---|---|
| `read_file` | leitura segura dentro da workspace |
| `file_glob_search` | busca por nome |
| `grep_search` | busca por conteúdo |
| `write_file` | criação/substituição com confirmação |
| `edit_file` | edição com confirmação |

## O que não foi habilitado

O modo `total` do kit chama ferramentas internas do `llama-server`, inclusive terminal. Isso não foi habilitado por padrão, pois pode acessar caminhos permitidos pela conta do Windows e não constitui sandbox. O ZystemWorkSpace permanece com ferramentas PHP explícitas, backups, confirmação para alterações e bloqueio de caminhos sensíveis/link simbólico.

## Correções aplicadas

A configuração padrão agora aponta para `http://127.0.0.1:8080/v1`, o endpoint local do Bonsai. O cliente LLM tem timeout de conexão. O histórico enviado pelo navegador não pode mais forjar mensagens `tool`. O staging valida operações, expiração, hash original e tamanho. As sessões usam cookies HttpOnly/SameSite. O workspace resolve o diretório pai de caminhos novos e bloqueia escapes por links simbólicos.

A execução local do modelo ainda deve ser iniciada pelo launcher do Bonsai. O ZystemWorkSpace atua como interface e camada de ferramentas.
