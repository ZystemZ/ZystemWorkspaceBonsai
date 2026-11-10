# ZystemWorkSpace + Bonsai Local — dois modos

Este pacote mantém o Bonsai original e adiciona o ZystemWorkSpace como interface completa. Os dois usam o mesmo `llama-server` e o mesmo modelo local.

## Modo recomendado: ZystemWorkSpace completo

Execute `2-INICIAR-TUDO.bat`. Ele inicia o Bonsai em segundo plano e abre o ZystemWorkSpace em `http://127.0.0.1:8090`.

Nesse modo, o modelo pode chamar ferramentas e receber resultados reais, incluindo leitura/pesquisa de arquivos, criação/edição com confirmação, projetos, histórico, busca web, data/hora e calculadora segura.

## Modo simples do Bonsai

Execute `Bonsai-demo-main\2-INICIAR-BONSAI.bat` ou os launchers originais dentro de `Bonsai-demo-main`. Isso abre a interface padrão do Bonsai em `http://localhost:8080` sem o workspace PHP. Esse modo não executa automaticamente as ferramentas do ZystemWorkSpace e continua disponível para conversa direta.

## Instalação

1. Extraia o ZIP em `W:\` para criar `W:\Zystem-Bonsai-Local-revisado`.
2. Execute `1-INSTALAR-BONSAI.bat` e escolha Ternary-Bonsai 4B para o Ryzen 5 5600GT.
3. Instale o XAMPP com Apache, PHP e MySQL.
4. Importe `ZystemWorkSpace\sql\schema.sql` no phpMyAdmin.
5. Execute `2-INICIAR-TUDO.bat` para usar o modo completo.

O endpoint interno do motor é `http://127.0.0.1:8080/v1`; a interface completa fica em `http://127.0.0.1:8090`.

## Configurar APIs dentro do sistema

Depois de entrar no ZystemWorkSpace, abra `Configurações`. O painel permite cadastrar REST, GraphQL, FTP, MySQL, PostgreSQL, busca web autenticada e automação. Cadastre somente o nome da variável de ambiente da credencial, como `GITHUB_TOKEN`; nunca coloque a chave diretamente no projeto.

Em `Habilidades`, o catálogo recomendado contém **24 habilidades**, organizadas em pesquisa e conteúdo, desenvolvimento, web e interface, dados e produtividade. A duplicidade de especialista SQL foi consolidada.

## Importar habilidades por ZIP

Abra `skills.php` e use **Instalar habilidade via ZIP**. O pacote deve conter exatamente um `SKILL.md` na raiz ou em uma pasta, com frontmatter `name` e `description`. Referências `.md`, `.txt` e `.json` são preservadas; scripts e executáveis não são executados. A habilidade começa desativada para você revisar e ativar manualmente.

## Arquivos e uso do workspace

`files.php` mostra quantidade de arquivos, tamanho usado e barra de ocupação. Uploads agora exibem progresso e mensagens de erro acionáveis. O menu lateral compartilhado permanece visível nas páginas autenticadas, pode ser recolhido e reaberto, e oferece acesso a Chat, Arquivos, Habilidades, Plugins, APIs, busca e histórico.

## LM Studio opcional

Em `settings.php`, use o painel **LM Studio — conexão opcional** para validar `http://127.0.0.1:1234/v1` e listar os modelos publicados. O teste não altera o provedor atual. Também existe `ZystemWorkSpace/scripts/Testar-LMStudio.bat` para validar pelo Windows. Para usar o LM Studio no launcher, defina `MANUZ_LLM_URL=http://127.0.0.1:1234/v1`; removendo essa variável, o sistema continua usando o provedor configurado anteriormente.

## Inicialização correta do PHP

O launcher serve a raiz de `ZystemWorkSpace`, não apenas `ZystemWorkSpace/public`. Isso é necessário porque as páginas ficam em `public/` e as APIs ficam em `api/`. Use `2-INICIAR-TUDO.bat` atualizado e acesse `http://127.0.0.1:8090/public/index.php`. Servir somente `public/` causa uma página HTML 404 em `../api/skills.php`, que aparece no navegador como `Unexpected token '<'`.

## Contas administrativas iniciais

No primeiro acesso ao banco, o sistema cria ou promove estas duas contas de forma idempotente:

- Usuário `Admin` — senha inicial `admin`;
- Usuário `Zelipe` — senha inicial `Isadora`.

O login aceita usuário ou e-mail. Depois de entrar, abra **Minha conta** para trocar a senha. Em modo local, a instalação de habilidades também funciona na sessão temporária; em ambiente compartilhado, somente administradores podem alterar habilidades.

## Nota sobre o kit do guia

O kit de Willian IA e os guias estão na pasta `Kit-Bonsai-Willian-IA`. Foram aproveitados os nomes de ferramentas compatíveis, validações e organização de configuração. O modo de terminal irrestrito não é habilitado por padrão.
