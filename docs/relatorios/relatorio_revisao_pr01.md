# Relatório de revisão de código — PR #[1]

Projeto: **Pointr** · Entrega: **v0.2.0** · Data: [2026-10-29]

| Papel | Integrante |
|---|---|
| Autor do PR revisado | João Albuquerque |
| Revisora | Alejandra Gimenez |
| Gestor de Configuração (este relatório) | Vinicius Bussolin |

Regra do grupo: ninguém aprova o próprio PR.

---

## 1. Escopo revisado

Protótipo do frontend (wireframe): `src/index.html`, `src/style.css`, `src/app.js`,
mais as convenções de Git do PR (nome da branch, mensagens de commit, arquivos adicionados).

Resultado da primeira passada: **❌ Request changes** — 25 apontamentos.
Resultado da segunda passada: **✅ Approve** — 25 aprovados.

---

## 2. Apontamentos por gravidade

| Gravidade | Qtd. | Itens |
|---|---|---|
| Alta | 7 | 1, 4, 11, 15, 17, 19, 21 |
| Média | 13 | 2, 3, 5, 7, 8, 10, 12, 16, 18, 20, 23, 24, 25 |
| Baixa | 5 | 6, 9, 13, 14, 22 |
| **Total** | **25** | |

### Por categoria

| Categoria | Itens | Qtd. |
|---|---|---|
| HTML (estrutura e marcação) | 1, 2, 5, 7, 8, 11, 13, 14 | 8 |
| CSS (sintaxe e visual) | 9, 15, 16, 17, 18 | 5 |
| JavaScript (lógica) | 19, 20, 22 | 3 |
| Segurança | 21 | 1 |
| Acessibilidade | 3, 18 | 2 |
| Dados e regra de negócio | 4, 12 | 2 |
| Portabilidade | 10 | 1 |
| Convenções de Git (GCS) | 23, 24, 25 | 3 |

---

## 3. Tabela de apontamentos

| # | Arquivo | Gravidade | Problema | Correção | Commit | Situação |
|---|---|---|---|---|---|---|
| 1 | `src/index.html` | alta | aba "Câmeras" não abre: `data-tab="camera"` × `id="cameras"` | `data-tab="cameras"` | | ☐ |
| 2 | `src/index.html` | média | `<h2>Suas câmeras</h3>` — tag fechada errada | fechar com `</h2>` | | ☐ |
| 3 | `src/index.html` | média | campo de busca sem rótulo (acessibilidade) | envolver em `<label>` | | ☐ |
| 4 | `src/index.html` | alta | erro de calibração acima do limite e botão Salvar ativo | marcar "reprovada" e `disabled` | | ☐ |
| 5 | `src/index.html` | média | `id="status"` repetido (Gravar e tabela de Sessões) | remover o `id` da célula | | ☐ |
| 6 | `src/index.html` | baixa | erros de digitação: `Cmera 1`, `Calibraçao` | `Câmera 1`, `Calibração` | | ☐ |
| 7 | `src/index.html` | média | `<button></button>` sem texto | `<button>Remover</button>` | | ☐ |
| 8 | `src/index.html` | média | linha `92d46ca2` com 5 células para 6 colunas | acrescentar `<td>` final | | ☐ |
| 9 | `src/index.html` | baixa | estilo inline `style="color:red..."` | usar classe do `style.css` | | ☐ |
| 10 | `src/index.html` | média | caminho absoluto `C:/Users/joao/relatorio.pdf` | caminho relativo | | ☐ |
| 11 | `src/index.html` | alta | `<div class="card-head">` não fechada | fechar a div | | ☐ |
| 12 | `src/index.html` | média | comprimento da quadra `value="-28"` | `value="28"` e `min="1"` | | ☐ |
| 13 | `src/index.html` | baixa | falta `<meta name="viewport">` | acrescentar no `<head>` | | ☐ |
| 14 | `src/index.html` | baixa | `class="Primary"` com maiúscula | `class="primary"` | | ☐ |
| 15 | `src/style.css` | alta | `bakground` escrito errado em `.card` | `background: #fff;` | | ☐ |
| 16 | `src/style.css` | média | `height: 180;` sem unidade | `height: 180px;` | | ☐ |
| 17 | `src/style.css` | alta | `;` faltando em `.metrics` | separar as declarações | | ☐ |
| 18 | `src/style.css` | média | `.muted { color: #bbb }` — contraste baixo | `#666` | | ☐ |
| 19 | `src/app.js` | alta | `getElementById("estado")` não existe | `"status"` | | ☐ |
| 20 | `src/app.js` | média | botão Parar escreve "Gravando" | "Não gravando" | | ☐ |
| 21 | `src/app.js` | alta | senha no código (`console.log`) | apagar; segredo em variável de ambiente | | ☐ |
| 22 | `src/app.js` | baixa | `TODO` e função comentada sobrando | apagar | | ☐ |
| 23 | Git | média | nome da branch fora de `tipo/descricao-curta` | `feat/prototipo-frontend` | | ☐ |
| 24 | Git | média | uso de `git add .` | adicionar arquivos pelo nome | | ☐ |
| 25 | Git | média | mensagem de commit fora de Conventional Commits | `feat: adiciona protótipo...` | | ☐ |



---

## 4. Item de segurança (21) — registro obrigatório

A senha de teste foi commitada e, portanto, **permanece no histórico do Git** mesmo
depois de apagada do arquivo. Providências:

1. Remover a linha do código (feito no commit [hash]).
2. Tratar a credencial como comprometida e trocá-la, mesmo sendo de teste.
3. Acrescentar `.env` e `db.cnf` ao `.gitignore` (ver `docs/gcs_mudancas_v0.2.0.md`, seção 1).
4. Registrar no relatório final: reescrever histórico (`git filter-repo`) foi **descartado**
   porque quebraria os clones do grupo; a mitigação adotada foi a troca da credencial.

---

## 5. Dificuldades encontradas

| Dificuldade | Solução adotada |
|---|---|
| [ex.: revisora sem acesso ao repositório] | [convite em Settings → Collaborators] |
| [ex.: conflito ao atualizar a branch] | [merge de `main` e resolução manual] |
| | |

---

## 6. Evidências para o relatório final

- [ ] Link do PR
- [ ] Print dos 25 comentários na aba **Files changed**
- [ ] Print do **Request changes** (primeira passada)
- [ ] Print dos commits de correção (`git log --oneline`)
- [ ] Print do **Approve** (segunda passada)
- [ ] Print do histórico (`git log --graph --oneline --all`)
- [ ] Tag `v0.2.0` criada e visível em Releases
