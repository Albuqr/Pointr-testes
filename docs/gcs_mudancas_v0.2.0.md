# Mudanças de GCS — v0.2.0

Projeto: **Pointr** · Data: 2026-10-29 · Responsável: Gestor de Configuração
Versão anterior: v0.1.0 · PR do banco: #[2] · PR desta mudança: #[5]

## Resumo

| O que mudou | Por quê |
|---|---|
| O banco de dados virou item de configuração | o esquema estava num `.txt` solto, fora do Git |
| Regra de migração `NNNN_descricao.sql` | saber qual versão do banco acompanha qual versão do código |
| Versão própria do esquema (1.0.0) | o banco muda em ritmo diferente do código |
| Branch `db/*` e tipo de commit `db` | separar mudança de banco no histórico |
| Backup com dump só da estrutura | recuperar o banco sem guardar dado real de atleta |
| Template de PR obrigatório | padronizar a descrição e lembrar das convenções |
| Credenciais e dumps no `.gitignore` | consequência do item 21 da revisão (senha no código) |

Cada bloco abaixo foi colado na seção indicada do `CONFIG_MANAGEMENT.md`.

## Bloco 1: seção 1.1 Itens de configuração (acrescentar 5 linhas na tabela, e a frase sobre arquivos fora do controle de versão)

| Esquema do banco | `db/pointr.sql` | baseline do esquema, versão 1.0.0 |
| Migrações do banco | `db/migrations/` | `0001_adiciona_coluna_x.sql` |
| Dados de exemplo do banco | `db/seed_exemplo.sql` | somente dados sintéticos |
| Documentação do banco | `db/README.md`, `docs/banco_de_dados.md` | modelo de dados e regras de migração |
| Template de PR | `.github/pull_request_template.md` | modelo de descrição do PR |

Também ficam fora do controle de versão: dumps do banco (`*.dump`, `*.sql.gz`), credenciais (`.env`, `db.cnf`) e qualquer dado real de atleta.

## Bloco 2: seção 1.2 Convenções de nomenclatura (acrescentar 1 item)

- **Migrações do banco:** `db/migrations/NNNN_descricao.sql`, com número de 4 dígitos em sequência e descrição em `snake_case` (ex.: `0001_adiciona_coluna_lado.sql`). Cada migração começa com um cabeçalho com a versão do esquema e uma linha **Reversão** (o comando que desfaz a mudança). Migração já aplicada nunca é editada: corrige-se com outra migração.

## Bloco 3: seção 1.3 Política de versionamento (acrescentar depois da tabela existente)

O **esquema do banco** tem versão própria, também em SemVer, independente da tag do repositório. A versão fica no cabeçalho de `db/pointr.sql` e no de cada migração.

| Parte | Quando aumenta | Exemplo |
|---|---|---|
| MAJOR | Remove ou renomeia tabela/coluna, ou muda o tipo de uma coluna | 1.x.x → 2.0.0 |
| MINOR | Nova tabela ou coluna compatível (opcional ou com valor padrão) | 1.0.x → 1.1.0 |
| PATCH | Índice, comentário ou ajuste que não muda a estrutura dos dados | 1.0.0 → 1.0.1 |

O esquema 1.0.0 corresponde à tag `v0.2.0`. Depois de uma tag publicada, `db/pointr.sql` não é mais editado: toda mudança vira uma migração.

## Bloco 4: seção 1.4 Política de branching (acrescentar o item `db/*` e a configuração de proteção)

- `db/*`: branch para mudança de banco (ex.: `db/esquema-inicial`, `db/adiciona-coluna-lado`). Segue as mesmas regras das demais e o PR precisa preencher a seção "Impacto no banco de dados" do template.

Regras de proteção da `main` (Settings → Branches → Branch protection rule):

- exigir Pull Request antes do merge, com **1 aprovação**
- descartar aprovações antigas quando entrarem novos commits
- exigir que as conversas estejam resolvidas antes do merge
- não permitir force push nem exclusão da branch

## Bloco 5: seção 1.5 Backup e recuperação (acrescentar)

- **Backup do banco:** junto com o bundle, o Gestor gera um dump só da estrutura (sem dados, para não levar dado real de atleta):
  `mysqldump -u root -p --no-data pointr > pointr-schema-v0.2.0.sql`
  Os dois arquivos ficam fora do repositório.
- **Recuperar o banco:** `git checkout v0.2.0` e `mysql -u root -p < db/pointr.sql`, depois aplicar em ordem as migrações de `db/migrations/` posteriores a essa versão.

## Bloco 6: seção 3.1 Fluxo de trabalho (parágrafo no fim)


Todo PR usa o **template de PR** (`.github/pull_request_template.md`), que o GitHub carrega sozinho na descrição. Ele pede: o que mudou, por quê, como testar, tipo de mudança, impacto no banco e o checklist de convenções. O template só passa a valer depois de estar na `main`.

## Bloco 7: seção 3.2 Convenção de commits (1 linha na tabela)

| `db` | esquema ou migração de banco | `db: adiciona coluna lado em Rastreamento` |

## Bloco 8: seção 3.4 Tags de versão (substitui a tabela de marcos)

| Tag | Marco |
|---|---|
| `v0.1.0` | estrutura inicial, documentação e protótipo do frontend |
| `v0.2.0` | correções da revisão de código (25 apontamentos), banco de dados (esquema 1.0.0) e GCS revisto |
| `v1.0.0` | primeira funcionalidade completa |
| `v1.1.0` | nova funcionalidade compatível |
| `v2.0.0` | mudança incompatível (ex.: novo formato de dados) |

