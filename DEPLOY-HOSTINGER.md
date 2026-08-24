# Deploy na Hostinger

## Preparação
1. Execute `npm install` e valide com `npm run verify`.
2. Gere a entrega com `npm run build:release`.
3. Faça backup do banco e das mídias existentes no servidor.

## Configuração
- Configure a aplicação Node.js no painel da hospedagem.
- Defina as variáveis do arquivo `.env` no ambiente de produção.
- Garanta que o diretório configurado para banco e mídias seja persistente e gravável.
- Instale as dependências no diretório da aplicação com `npm install --omit=dev`.
- Use `npm start` como comando de inicialização.

## Após publicar
Teste site público, login, painel, imóveis, fotos, vídeos, leads, WhatsApp e links sociais antes de considerar a publicação concluída.

## CORREÇÃO DE CREDENCIAIS — PREMIUM 2.0.0

O pacote **não contém senha administrativa padrão**. Para evitar a mensagem “Credenciais inválidas”, crie/atualize o administrador no próprio servidor Hostinger antes do primeiro login.

Na pasta da aplicação, execute:

```bash
npm install --omit=dev
npm run admin:create
```

O comando solicitará:

1. e-mail do administrador;
2. nome;
3. senha.

A senha precisa ter **12 ou mais caracteres, pelo menos uma letra maiúscula e um número**.

Depois reinicie a aplicação e entre no site usando **exatamente o e-mail informado no `admin:create`** e a senha criada nesse comando.

Se o administrador já existir, o comando **atualiza a senha e reativa a conta**.

### Diagnóstico rápido

Se ainda aparecer “Credenciais inválidas”, execute novamente:

```bash
npm run admin:reset
```

Depois reinicie o Node.js pela interface da Hostinger.

**Não use `ADMIN_EMAIL=SEU_EMAIL_ADMIN` ou `ADMIN_PASSWORD=COLOQUE...` como credenciais reais. Esses valores no `.env.example` são apenas placeholders.**
