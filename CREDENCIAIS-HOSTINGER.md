# Credenciais — Hostinger Premium 2.0.0

Este pacote não possui credenciais administrativas pré-gravadas.

## Criar ou redefinir administrador

```bash
npm run admin:create
```

Informe o e-mail e a nova senha quando solicitado.

Requisitos da senha:
- mínimo 12 caracteres;
- pelo menos 1 letra maiúscula;
- pelo menos 1 número.

O comando cria ou atualiza o usuário como `corretor` e `ativo=1` no SQLite persistente configurado por `SQLITE_FILE`.

Após executar, reinicie a aplicação Node.js na Hostinger e faça login no formulário da página inicial.
