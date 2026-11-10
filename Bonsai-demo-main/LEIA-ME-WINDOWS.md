# Bonsai no Windows — pacote anti-burro

Este pacote contém o demo Bonsai e os atalhos para instalar e rodar no Windows. O instalador baixa automaticamente Python/uv quando necessário, o binário correto do `llama.cpp` da PrismML e o modelo GGUF escolhido.

## Perfil deste computador: Ryzen 5 5600GT com vídeo integrado

O Ryzen 5 5600GT usa vídeo integrado Radeon Vega. Sem placa dedicada, a recomendação é começar pelo **Ternary-Bonsai 4B em CPU**. Ele deve ser muito mais realista do que o Bonsai 2 27B, que tem aproximadamente 8 GB só de modelo e pode ficar lento ou consumir muita RAM.

O instalador tenta detectar Vulkan/ROCm. Se não encontrar uma ferramenta de GPU configurada, usa automaticamente o binário CPU. Não é necessário instalar o `llama.cpp` manualmente.

## Instalação

1. Extraia esta pasta como `W:\Bonsai-demo-main`.
2. Dê duplo clique em `1-INSTALAR-BONSAI.bat`.
3. Pressione Enter para escolher o **Ternary-Bonsai 4B**.
4. Aguarde o download e não feche a janela.
5. Quando terminar, dê duplo clique em `2-INICIAR-BONSAI.bat`.
6. Acesse `http://localhost:8080` se o navegador não abrir sozinho.

Para testar uma pergunta sem abrir a interface web, use `3-PERGUNTAR.bat`.

## Modelos disponíveis no instalador

| Opção | Modelo | Recomendação |
|---|---|---|
| 1 | Ternary-Bonsai 4B | **Começar por este**; menor e mais viável em CPU |
| 2 | Ternary-Bonsai 8B | Mais capaz, porém mais lento e pesado |
| 3 | Bonsai 2 27B | Evitar sem GPU dedicada e bastante RAM |

## Requisitos

- Windows 10/11 de 64 bits.
- Internet durante a instalação.
- Idealmente 16 GB de RAM; com 8 GB, reduza expectativas e feche outros programas.
- Espaço livre para o modelo, ambiente Python e arquivos temporários.

## Solução de problemas

Se os scripts forem bloqueados, execute uma vez no PowerShell:

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

Se `winget` não existir, instale Python 3.11–3.13 manualmente e execute o instalador novamente. Para parar o servidor, volte à janela preta e pressione `Ctrl+C`.

O código é baseado em [PrismML-Eng/Bonsai-demo](https://github.com/PrismML-Eng/Bonsai-demo) e usa o fork [PrismML-Eng/llama.cpp](https://github.com/PrismML-Eng/llama.cpp). Consulte os arquivos de licença incluídos.
