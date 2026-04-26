# Demo SEPAL PAI

Entrega preparada para a demo do Portal PAI:

- Portal estatico: `index.html`
- SQL Supabase: `supabase_schema_demo.sql`
- Workflow criado no n8n: `PAI Demo SEPAL`
- ID do workflow n8n: `Dgf6hMN47ranHeE7`
- Path do webhook: `/webhook/pai-demo`

## 1. Supabase

No Supabase SQL Editor, execute `supabase_schema_demo.sql`.

Antes de executar, substitua:

```sql
SEU_CHAT_ID_AQUI
```

pelo `chat_id` real do usuario de teste no Telegram.

Depois do `insert`, anote o UUID retornado. Esse valor sera o `MISSIONARIO_ID` do n8n.

Valide:

```sql
select * from missionarios;
select * from respostas;
select pubname, tablename
from pg_publication_tables
where pubname = 'supabase_realtime'
order by tablename;
```

Resultado esperado:

- `missionarios` com 1 linha
- `respostas` vazia antes do teste
- `missionarios` e `respostas` na publication `supabase_realtime`

## 2. n8n

O workflow `PAI Demo SEPAL` ja foi criado no n8n e validado sem erros.

Configure estas variaveis no n8n:

```text
TELEGRAM_BOT_TOKEN=
SUPABASE_URL=
SUPABASE_ANON_KEY=
MISSIONARIO_ID=
```

Depois ative o workflow.

URL esperada do webhook:

```text
https://SEU_N8N/webhook/pai-demo
```

## 3. Telegram

No BotFather, configure os comandos:

```text
start - Iniciar questionario PAI
ajuda - Como funciona o questionario
```

Depois que o workflow estiver ativo, registre o webhook:

```bash
curl -X POST "https://api.telegram.org/bot<TOKEN>/setWebhook" \
  -H "Content-Type: application/json" \
  -d "{\"url\":\"https://SEU_N8N/webhook/pai-demo\"}"
```

Valide:

```bash
curl "https://api.telegram.org/bot<TOKEN>/getWebhookInfo"
```

## 4. Portal

No `index.html`, substitua:

```javascript
const SUPABASE_URL = 'SUA_SUPABASE_URL';
const SUPABASE_KEY = 'SUA_ANON_KEY';
```

pelos valores reais do Supabase.

Para publicar na Vercel, a pasta ja pode ser usada como projeto estatico, pois contem `index.html` na raiz.

## 5. Teste final

1. Execute o SQL no Supabase.
2. Configure variaveis do n8n.
3. Ative o workflow.
4. Configure o webhook do Telegram.
5. Abra o portal.
6. Envie `/start` no bot.
7. Responda as 4 perguntas com botoes.
8. Responda a pergunta 5 com texto livre.
9. Confirme 5 linhas em `respostas`.
10. Confirme o portal atualizando KPIs e tabela.

## Config para o portal

```text
=== CONFIG PARA O PORTAL ===
SUPABASE_URL=
SUPABASE_ANON_KEY=

MISSIONARIO_ID=

SCHEMA DAS TABELAS:

TABELA missionarios:
- id uuid
- nome text
- telegram_chat_id bigint
- campo text
- criado_em timestamptz

TABELA respostas:
- id uuid
- missionario_id uuid
- pergunta_id int
- pergunta_texto text
- resposta text
- score int
- pilar text
- criado_em timestamptz

REALTIME: habilitado nas duas tabelas
RLS: desabilitado somente para demo
=== FIM CONFIG ===
```
