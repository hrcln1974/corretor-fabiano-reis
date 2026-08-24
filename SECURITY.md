# Segurança — Fabiano Reis Imóveis Premium 2.0.0

Esta release é **exclusiva para Hostinger** e usa:
- Node.js 22.5+
- SQLite nativo (`node:sqlite`)
- armazenamento local persistente
- cookies de sessão HttpOnly/Secure em produção
- CSP e headers de segurança
- validação de MIME, extensão e assinatura de arquivos
- proteção das rotas administrativas
- rate limiting nos fluxos sensíveis

## Segredos
Nunca publique `.env`, credenciais, banco de produção ou diretórios de mídia privados no ZIP.

## Produção
Defina um `JWT_SECRET` novo e aleatório, uma senha administrativa forte e os caminhos persistentes de SQLite e mídia.

## Uploads
Arquivos executáveis, scripts e conteúdo cuja assinatura não corresponda ao MIME declarado devem ser recusados.

## Operação
Faça backup do SQLite e da mídia antes de cada atualização e mantenha a release anterior disponível para rollback.
