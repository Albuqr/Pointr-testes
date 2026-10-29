# Gerenciamento de Configuração — Roteiro Básico

Projeto: **Pointr** (captura de dados de treino esportivo, com câmera de celular e notebook)
Ferramenta: GitHub (repositório Git compartilhado)

Este documento serve de base para o trabalho de Gerenciamento de Configuração (GCS). Preencha os campos entre colchetes `[ ]` com os dados do seu grupo.

---

## Visão geral do projeto

O Pointr captura dados de treino esportivo a partir de uma câmera ao vivo:

- **Captura** vídeo de webcam, stream (http, https, rtsp) ou arquivo `.mp4`/`.mov`, com várias câmeras ao mesmo tempo.
- **Detecta e rastreia** pessoas quadro a quadro (RF-DETR Nano, ByteTrack).
- **Registra cada sessão** localmente: arquivos de sessão, execução, quadro e trilha.
- **Calibra** cada câmera para a quadra (homografia) e desenha o diagrama da quadra.
- **Grava e reproduz** o vídeo bruto, e pontua sessões rotuladas à mão.
- **Gera relatórios** de cobertura e falhas por execução.
- **Studio:** aplicativo web local (`python -m services.app`, porta 8765) para rodar e conferir sessões.

Planejado, ainda não construído: API na nuvem e sincronização (fases 07 e 08).

### Estrutura de arquivos

```
pointr_vision/
├── services/
│   ├── edge/        # roda no notebook: captura, detecção, rastreio, sessões,
│   │                #   calibração, gravação, replay, relatórios, pontuação
│   ├── app/         # Pointr Studio: app web local (servidor FastAPI, interface React em ui/)
│   ├── api/         # API na nuvem (planejada, fase 07)
│   └── sync_agent/  # sincronização com o servidor (planejada, fase 08)
├── scripts/         # run_cameras.py: lançador de várias câmeras
├── contracts/       # JSON Schemas dos arquivos salvos
├── tests/           # testes pytest (não precisam de câmera, pesos ou rede por padrão)
├── testkit/         # suíte de testes de navegador e de API
├── docs/            # arquitetura, requisitos, fases, ADRs, runbooks
├── pyproject.toml   # dependências e configurações das ferramentas
├── CLAUDE.md        # regras para o agente de desenvolvimento
└── DECISIONS.md     # decisões tomadas, inclusive as erradas
```

As sessões são gravadas em `C:/pointr_sessions`, fora do repositório. Gravações e imagens reais nunca são versionadas.

---

## 0. Integrantes e papéis

| Integrante          | Papel principal | Responsabilidades |
|---------------------|---|---|
| [João Albuquerque]  | Desenvolvedor principal | Implementa a funcionalidade principal, abre PRs |
| [Alejandra Gimenez] | Revisor de código | Revisa e aprova PRs, pede mudanças |
| [Vinicius Bussolin] | Gestor de Configuração | Define convenções, cria tags, mantém a política de branches e backups |

Regra do grupo: ninguém aprova o próprio PR.

---

## 1. Planejamento da Configuração

### 1.1 Itens de configuração

Itens de configuração (IC) são os artefatos que são versionados e controlados:

| IC | Local no repositório | Exemplo |
|---|---|---|
| Código-fonte | `src/` | `src/tracker.py` |
| Testes | `tests/` | `tests/test_tracker.py` |
| Documentação | `docs/`, `README.md` | `docs/requisitos.md` |
| Configurações | `pyproject.toml`, `.gitignore` | dependências, regras de ignore |
| Dados de exemplo | `data/exemplo/` | somente dados sintéticos |
| Relatórios | `docs/relatorios/` | relatórios de cada entrega |
| Esquema do banco | `db/pointr.sql` | baseline do esquema, versão 1.0.0 |
| Migrações do banco | `db/migrations/` | `0001_adiciona_coluna_x.sql` |
| Dados de exemplo do banco | `db/seed_exemplo.sql` | somente dados sintéticos |
| Documentação do banco | `db/README.md`, `docs/banco_de_dados.md` | modelo de dados e regras de migração |
| Template de PR | `.github/pull_request_template.md` | modelo de descrição do PR |

Fora do controle de versão (no `.gitignore`): arquivos gerados, ambientes virtuais (`.venv/`), caches e dados pessoais ou brutos.
Também ficam fora do controle de versão: dumps do banco (`*.dump`, `*.sql.gz`), credenciais (`.env`, `db.cnf`) e qualquer dado real de atleta.

### 1.2 Convenções de nomenclatura

- **Arquivos e pastas:** `snake_case` em minúsculas (ex.: `calibracao_camera.md`). Sem espaços e sem acentos.
- **Branches:** `tipo/descricao-curta` (ex.: `feat/detecao-bola`, `fix/perda-de-frames`).
- **Tags:** `vMAJOR.MINOR.PATCH` (ex.: `v1.0.0`).
- **Commits:** Conventional Commits (ver seção 3.2).
- **Migrações do banco:** `db/migrations/NNNN_descricao.sql`, com número de 4 dígitos em sequência e descrição em `snake_case` (ex.: `0001_adiciona_coluna_lado.sql`). Cada migração começa com um cabeçalho com a versão do esquema e uma linha **Reversão** (o comando que desfaz a mudança). Migração já aplicada nunca é editada: corrige-se com outra migração.

### 1.3 Política de versionamento

Usamos **Versionamento Semântico (SemVer)**: `MAJOR.MINOR.PATCH`.

| Parte | Quando aumenta | Exemplo |
|---|---|---|
| MAJOR | Mudança incompatível (quebra o que já funcionava) | 1.x.x → 2.0.0 |
| MINOR | Nova funcionalidade compatível | 1.0.x → 1.1.0 |
| PATCH | Correção de erro compatível | 1.0.0 → 1.0.1 |

Cada entrega de marco recebe uma tag: `v1.0.0`, `v2.0.0` etc.

O **esquema do banco** tem versão própria, também em SemVer, independente da tag do repositório. A versão fica no cabeçalho de `db/pointr.sql` e no de cada migração.

| Parte | Quando aumenta | Exemplo |
|---|---|---|
| MAJOR | Remove ou renomeia tabela/coluna, ou muda o tipo de uma coluna | 1.x.x → 2.0.0 |
| MINOR | Nova tabela ou coluna compatível (opcional ou com valor padrão) | 1.0.x → 1.1.0 |
| PATCH | Índice, comentário ou ajuste que não muda a estrutura dos dados | 1.0.0 → 1.0.1 |

O esquema 1.0.0 corresponde à tag `v0.2.0`. Depois de uma tag publicada, `db/pointr.sql` não é mais editado: toda mudança vira uma migração.

### 1.4 Política de branching

Adotamos um fluxo simples, baseado em **GitHub Flow**:

- `main`: sempre estável. Não recebe commit direto; entra apenas por Pull Request (PR).
- `feat/*`, `fix/*`, `docs/*`: uma branch por tarefa, criada a partir de `main`.
- `db/*`: branch para mudança de banco (ex.: `db/esquema-inicial`, `db/adiciona-coluna-lado`). Segue as mesmas regras das demais e o PR precisa preencher a seção "Impacto no banco de dados" do template.
- Cada branch é removida após o merge.
- Todo merge em `main` passa por PR com **pelo menos 1 aprovação** do revisor.
- Proteção da `main` (Settings → Branches → Branch protection rule): exigir PR e aprovação antes do merge. Configuração completa:
  - exigir Pull Request antes do merge, com **1 aprovação**
  - descartar aprovações antigas quando entrarem novos commits
  - exigir que as conversas estejam resolvidas antes do merge
  - não permitir force push nem exclusão da branch


### 1.5 Estratégia de backup e recuperação

- **Backup principal:** o próprio GitHub guarda todo o histórico. Cada integrante também mantém um clone local (`git clone`).
- **Backup extra:** ao fim de cada entrega, o Gestor de Configuração gera um arquivo do repositório:
  `git bundle create pointr-v1.0.0.bundle --all` e guarda o arquivo fora do repositório (ex.: pendrive ou nuvem pessoal).
- **Backup do banco:** junto com o bundle, o Gestor gera um dump só da estrutura (sem dados, para não levar dado real de atleta):
  `mysqldump -u root -p --no-data pointr > pointr-schema-v0.2.0.sql`
  Os dois arquivos ficam fora do repositório.
- **Recuperar o banco:** `git checkout v0.2.0` e `mysql -u root -p < db/pointr.sql`, depois aplicar em ordem as migrações de `db/migrations/` posteriores a essa versão.
- **Recuperação:**
  - Voltar a uma versão marcada: `git checkout v1.0.0` (ou criar uma branch a partir dela).
  - Desfazer um merge ruim em `main`: `git revert -m 1 <hash>` (sem reescrever o histórico).
  - Restaurar o repositório a partir do bundle: `git clone pointr-v1.0.0.bundle pointr-restaurado`.

---

## 2. Criação do repositório e setup

1. Criar o repositório no GitHub (público ou privado), com o nome `[nome-do-projeto]`.
2. Adicionar colaboradores: Settings → Collaborators → Add people.
3. Criar o `README.md` com:
   - Nome e descrição do projeto
   - Integrantes e papéis
   - Como clonar e executar
   - Link para este documento de GCS
4. Criar a estrutura inicial:

```
pointr_vision/
├── README.md
├── CONFIG_MANAGEMENT.md
├── .gitignore
├── pyproject.toml
├── src/
├── tests/
└── docs/
    ├── relatorios/
    └── adr/          (decisões de projeto, uma por arquivo)
```

5. Criar o `.gitignore` (ex.: `.venv/`, `__pycache__/`, `*.log`, `data/brutos/`).
6. Primeiro commit direto em `main`, feito pelo Gestor de Configuração:
   `chore: estrutura inicial do repositório`
7. Ativar a proteção da branch `main` (ver 1.4).

---

## 3. Controle de versão e colaboração

### 3.1 Fluxo de trabalho de cada aluno

```bash
git checkout main
git pull
git checkout -b feat/nome-da-tarefa
git add arquivo.py            
git commit -m "feat: descreve a mudança"
git push -u origin feat/nome-da-tarefa
```

Depois, abra um **Pull Request** no GitHub, de `feat/nome-da-tarefa` para `main`, com o modelo de descrição do PR (o que mudou, por quê, como testar). O revisor comenta, pede ajustes ou aprova. Após aprovação, faça o merge (com "Squash and merge" ou "Create a merge commit", conforme combinado) e apague a branch.

Todo PR usa o **template de PR** (`.github/pull_request_template.md`), que o GitHub carrega sozinho na descrição. Ele pede: o que mudou, por quê, como testar, tipo de mudança, impacto no banco e o checklist de convenções. O template só passa a valer depois de estar na `main`.

### 3.2 Convenção de commits (Conventional Commits)

Formato: `tipo: descrição curta no imperativo`

| Tipo | Uso | Exemplo |
|---|---|---|
| `feat` | nova funcionalidade | `feat: adiciona leitura de vídeo` |
| `fix` | correção de erro | `fix: corrige perda de quadros` |
| `docs` | documentação | `docs: descreve branching no README` |
| `test` | testes | `test: cobre detecção sem objetos` |
| `refactor` | reestruturação sem mudar comportamento | `refactor: separa gravação e leitura` |
| `chore` | tarefas de manutenção | `chore: adiciona .gitignore` |
| `db` | esquema ou migração de banco | `db: adiciona coluna lado em Rastreamento` |

Regras: escreva em português ou inglês, mas de forma consistente; uma mudança lógica por commit; sem `git add .` (adicione os arquivos pelo nome).

### 3.3 Simulação de conflito (intencional)

Para treinar a resolução de conflitos, o grupo faz o seguinte:

1. **Preparação:** dois integrantes (A e B) criam branches diferentes a partir de `main`: `feat/cabecalho-a` e `feat/cabecalho-b`.
2. **Conflito:** ambos alteram **a mesma linha** do `README.md` (ex.: a linha de descrição do projeto), cada um com um texto diferente.
3. **Primeiro merge:** A abre PR e faz o merge normalmente.
4. **Segundo merge:** B abre PR. O GitHub mostra "This branch has conflicts that must be resolved".
5. **Resolução:** B atualiza a branch localmente:
   ```bash
   git checkout feat/cabecalho-b
   git pull origin main      # ou: git fetch && git merge origin/main
   # Git marca o conflito em README.md com <<<<<<<, =======, >>>>>>>
   # edite o arquivo, deixando o texto final desejado, e remova os marcadores
   git add README.md
   git commit -m "fix: resolve conflito na descrição do README"
   git push
   ```
   O PR é atualizado automaticamente e pode ser aprovado e mesclado.
6. **Registro:** guarde o trecho do conflito (antes/depois) para o relatório final.

### 3.4 Tags de versão

Após o merge de cada entrega fechada, o Gestor de Configuração cria uma tag anotada:

```bash
git checkout main
git pull
git tag -a v1.0.0 -m "Versão 1.0: primeira entrega funcional"
git push origin v1.0.0
```

Sugestão de marcos para o grupo:

| Tag | Marco |
|---|---|
| `v0.1.0` | estrutura inicial, documentação e protótipo do frontend |
| `v0.2.0` | correções da revisão de código (25 apontamentos), banco de dados (esquema 1.0.0) e GCS revisto |
| `v1.0.0` | primeira funcionalidade completa |
| `v1.1.0` | nova funcionalidade compatível |
| `v2.0.0` | mudança incompatível (ex.: novo formato de dados) |

No GitHub, as tags aparecem em **Releases** (crie uma release a partir da tag, se quiser).

---

## 4. Checklist do relatório final

- [ ] Estrutura do repositório (árvore de pastas) e política de branching (seção 1.4)
- [ ] Papéis de cada integrante e divisão de tarefas (seção 0)
- [ ] Dificuldades encontradas e soluções adotadas
- [ ] Exemplo de conflito real: trecho antes/depois e como foi resolvido (seção 3.3)
- [ ] Print do histórico de commits (`git log --graph --oneline --all` ou aba Insights → Network no GitHub)
- [ ] Lista de tags criadas e o que cada uma representa (seção 3.4)
- [ ] Banco de dados: esquema, versão do esquema e regra de migração (seções 1.1 a 1.3)
- [ ] Template de PR em uso e print de um PR preenchido (seção 3.1)
- [ ] Print da proteção da branch `main` (seção 1.4)
- [ ] Link para o repositório
- [ ] Conclusões sobre a importância do GCS (controle de mudanças, rastreabilidade, recuperação, trabalho em equipe)
