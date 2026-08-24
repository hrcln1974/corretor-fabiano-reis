# Imobiliária Fabiano Reis

## Sistema imobiliário premium — Versão 2.0.0

Aplicação completa para divulgação e gestão de imóveis, desenvolvida para execução em ambiente Node.js com armazenamento local persistente.

## Funcionalidades

### Site público
- Página inicial e catálogo de imóveis
- Busca e filtros
- Página de detalhes do imóvel
- Galeria de fotos e vídeos
- Contato e integração com WhatsApp
- Links para Instagram, Facebook e YouTube
- Banner e apresentação do corretor
- Layout responsivo
- SEO técnico, sitemap e robots.txt

### Painel do corretor
- Login e logout protegidos
- Dashboard administrativo
- Cadastro, edição e exclusão de imóveis
- Upload e exclusão de fotos
- Definição de foto principal
- Vídeos por URL
- Gestão de leads e CRM
- Filtros e atualização de informações
- Exclusão de leads

## Requisitos
- Node.js 22.5 a 24
- npm
- Ambiente com armazenamento persistente para banco e mídias

## Instalação

```bash
npm install
cp .env.example .env
npm run admin:create
npm start
```

Acesse o site em `http://localhost:3000`.

## Validação antes do deploy

```bash
npm run verify
npm run test:smoke
npm run build:release
```

O comando `build:release` gera uma cópia limpa em `release/`, sem dependências instaladas, segredos, banco local, backups ou mídias privadas.

## Produção

Antes de atualizar um servidor em produção, faça backup do banco e da pasta de mídias. Não sobrescreva dados persistentes durante a publicação de uma nova versão.


## Release Premium

Antes da publicação:

```bash
npm run verify
npm run test:smoke
npm run build:release
cd release
node scripts/audit-release.js
```

A pasta `release/` é a entrega de produção. Ela não deve conter `.env`, banco local, `node_modules` ou `.git`. Esta edição é exclusiva para Hostinger, com SQLite nativo do Node.js e armazenamento local persistente; não utiliza Vercel, Neon ou Blob.

Consulte `RELEASE_PREMIUM_2.0.0.md` para o procedimento completo de Hostinger e validação pós-deploy.
