create extension if not exists pgcrypto;

drop table if exists respostas;
drop table if exists missionarios;

create table missionarios (
  id uuid primary key default gen_random_uuid(),
  nome text not null,
  telegram_chat_id bigint unique not null,
  campo text,
  criado_em timestamptz not null default now()
);

create table respostas (
  id uuid primary key default gen_random_uuid(),
  missionario_id uuid not null references missionarios(id) on delete cascade,
  pergunta_id int not null check (pergunta_id between 1 and 5),
  pergunta_texto text not null,
  resposta text not null,
  score int not null default 0 check (score in (0, 5, 10)),
  pilar text not null check (pilar in ('fisico', 'familiar', 'espiritual', 'social', 'geral')),
  criado_em timestamptz not null default now()
);

alter table missionarios disable row level security;
alter table respostas disable row level security;

alter publication supabase_realtime add table missionarios;
alter publication supabase_realtime add table respostas;

-- Substitua SEU_CHAT_ID_AQUI pelo chat_id real do Telegram do usuario de teste.
insert into missionarios (nome, telegram_chat_id, campo)
values ('Diego (Teste)', SEU_CHAT_ID_AQUI, 'Sao Paulo - Demo')
returning id;

-- Validacao
select * from missionarios;
select * from respostas;
select pubname, tablename
from pg_publication_tables
where pubname = 'supabase_realtime'
order by tablename;
