# ZystemWorkSpace Web — Bonsai local

Interface PHP/MySQL para conversar com o Bonsai via API OpenAI-compatible e trabalhar com arquivos, projetos, histórico e ferramentas autorizadas.

## XAMPP

1. Copie a pasta para `C:\xampp\htdocs\ZystemWorkSpace`.
2. Inicie Apache e MySQL.
3. Crie o banco `manuz_workspace` e importe `sql/schema.sql` no phpMyAdmin.
4. Ative `json`, `fileinfo`, `pdo_mysql` e, preferencialmente, `curl` e `zip` no `php.ini`. O sistema possui fallback HTTP sem cURL; `ZipArchive` é recomendado para importar habilidades no Windows.
5. Inicie o `llama-server` do Bonsai na porta 8080 ou defina `MANUZ_LLM_URL`.
6. Abra `http://localhost/ZystemWorkSpace/` ou `http://localhost/ZystemWorkSpace/public/login.php`.

O Apache deve servir a raiz `ZystemWorkSpace`, não somente a pasta `public`, porque as páginas ficam em `public/` e as APIs ficam em `api/`. As pastas internas possuem regras `.htaccess` para impedir acesso direto.

Por padrão, o cliente usa `http://127.0.0.1:8080/v1` e detecta o primeiro modelo disponível. Para LM Studio, defina `LM_STUDIO_URL=http://127.0.0.1:1234/v1`.

## Ferramentas compatíveis com o kit Bonsai

O guia enviado usa nomes como `read_file`, `file_glob_search`, `grep_search`, `write_file` e `edit_file`. Esta versão fornece aliases para esses nomes, direcionando-os para as ferramentas PHP seguras do workspace. Não foi habilitado o modo de terminal arbitrário do kit: execução de PowerShell, CMD, DLLs e compiladores continua bloqueada.

## InfinityFree

Use uma URL HTTPS de API compatível com OpenAI e configure `MANUZ_LLM_URL`, `MANUZ_LLM_API_KEY` e `MANUZ_MODEL` no mecanismo de configuração disponível na hospedagem. Não use LM Studio em `127.0.0.1` no servidor público.

## APIs e integrações

Acesse `public/settings.php` depois de entrar no sistema para cadastrar REST, GraphQL, FTP, MySQL, PostgreSQL, busca web autenticada e automação. O cadastro guarda apenas a referência da credencial, como `GITHUB_TOKEN`; o valor deve existir como variável de ambiente no servidor. O painel não grava chaves no código nem no ZIP.

A versão hospedada não executa comandos, compiladores ou DLLs. O workspace é limitado à pasta de armazenamento da aplicação. Em ambiente local, use o XAMPP e mantenha cópias de teste.

## Habilidades

Acesse `public/skills.php` como administrador para instalar o catálogo recomendado e ativar habilidades como UI Design, desenvolvimento de jogos, code review, acessibilidade, SQL, Excel, pesquisa de YouTube e direção audiovisual. Habilidades alteram as instruções do agente; não concedem acesso a serviços externos sem uma integração cadastrada.

## Estado atual

Implementado: layout responsivo, chat AJAX, cliente OpenAI-compatible/Bonsai, loop de tools, aliases do kit, autenticação, sessões protegidas, listagem e leitura segura de arquivos, isolamento por usuário, staging com expiração/validação, upload e esquema MySQL.

Contas iniciais de teste: usuário `Admin` com senha `admin`, e usuário `Zelipe` com senha `Isadora`. Troque as senhas em `public/account.php` depois do primeiro login; elas são armazenadas somente como hashes.

Ainda opcional: streaming SSE, MCP externo e execução local explicitamente allowlisted.
