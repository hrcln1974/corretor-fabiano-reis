# FABIANO REIS IMÓVEIS — RELEASE PREMIUM 2.0.0

## Objetivo

Entrega preparada para cliente e publicação em Hostinger Node.js, seguindo o fluxo:

**Auditar → Corrigir → Testar → Validar → Deploy → Testar em produção → Só então migrar o domínio.**

### O que foi validado nesta entrega

- Site público responsivo e com SEO técnico.
- Catálogo, busca e filtros de imóveis.
- Página de detalhes, galeria e vídeos.
- Área protegida do corretor.
- CRUD de imóveis e mídias.
- CRM/leads.
- WhatsApp e redes sociais.
- SQLite com persistência configurável.
- Storage de mídia separado da aplicação.
- Cookies HttpOnly/Secure em produção.
- Rate limiting para autenticação, recuperação, leads e uploads.
- CSP, HSTS, X-Content-Type-Options, X-Frame-Options e Permissions-Policy.
- Upload com validação de MIME, extensão e conteúdo real.
- Health check sem exposição de segredos.
- Smoke test automatizado.
- Pacote de release sem `.env`, banco local, `node_modules` ou `.git`.

## Auditoria executada

No ambiente de desenvolvimento:

- `npm run verify` → aprovado.
- `npm run test:smoke` → **38/38 verificações aprovadas**.
- `npm run build:release` → release limpo gerado.
- `npm run audit:release` → deve ser executado sobre o diretório `release/`.

## Regra crítica de segurança

O arquivo `.env` usado no desenvolvimento contém credenciais e **não deve ser enviado para a Hostinger, GitHub ou para o cliente**.

Na produção, gere um novo `JWT_SECRET` aleatório e configure uma nova senha administrativa forte.

## Hostinger — publicação

1. Criar a aplicação Node.js.
2. Usar Node.js 22.5+.
3. Fazer upload somente do conteúdo de `release/`.
4. Instalar dependências com `npm install --omit=dev`.
5. Configurar as variáveis de ambiente no painel da Hostinger.
6. Criar os diretórios persistentes do banco e das mídias.
7. Executar `npm run admin:create` uma única vez com as credenciais administrativas.
8. Iniciar com `npm start`.
9. Confirmar `GET /health`.
10. Testar o domínio temporário da Hostinger.
11. Somente depois apontar o domínio oficial.

## Variáveis mínimas

```text
NODE_ENV=production
PORT=3000
SITE_URL=https://fabianoreisimoveis.com.br
CORS_ORIGIN=https://fabianoreisimoveis.com.br
TRUST_PROXY=1
JWT_SECRET=<novo segredo aleatório>
WHATSAPP_NUMBER=5521991822134
CONTATO_EMAIL=<email real>
SQLITE_FILE=/home/SEU_USUARIO/fabiano-reis-data/database.db
MEDIA_ROOT=/home/SEU_USUARIO/fabiano-reis-media
ADMIN_EMAIL=<email administrativo>
ADMIN_PASSWORD=<senha forte>
ADMIN_NAME=Fabiano Reis
```

## Teste pós-deploy

### Público

- `/`
- `/imovel.html?id=...`
- `/privacidade.html`
- `/termos.html`
- `/robots.txt`
- `/sitemap.xml`
- `/health`

### Administração

- Login válido.
- Login inválido.
- Logout.
- Recuperação de senha.
- Alteração de senha.
- Criar imóvel.
- Editar imóvel.
- Desativar imóvel.
- Excluir imóvel.
- Adicionar/remover fotos.
- Definir foto principal.
- Adicionar vídeo.
- Receber lead.
- Excluir lead.

### Produção

- HTTPS ativo.
- Cookie de sessão com `Secure` e `HttpOnly`.
- Nenhum segredo visível no navegador.
- Banco persistindo após reinício.
- Mídias persistindo após reinício.
- WhatsApp funcionando.
- Links sociais funcionando.
- Layout mobile/desktop.
- Página 404 funcionando.
- SEO/canonical/robots/sitemap.
- Sem erros críticos no console.

## Migração do domínio

**Não migrar o domínio antes de concluir todos os testes no endereço temporário da Hostinger.**

A migração final deve ocorrer apenas quando:

`Deploy OK + Banco OK + Mídia OK + Login OK + CRUD OK + Leads OK + HTTPS OK + Smoke pós-produção OK`

## Rollback

Antes de qualquer atualização:

1. Backup do SQLite.
2. Backup do diretório de mídias.
3. Guardar a versão anterior do release.
4. Publicar a nova versão.
5. Se houver falha, restaurar o release anterior e os dados.

---

**HRCLN Dev Digital — Entrega Premium / Produção**
