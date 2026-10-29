# Pull Request

## O que mudou

Revisao do codigo do programador Joao

-
-

## Por quê

O codigo apresentava erros estruturais para o programa

## Como testar

```bash
git fetch origin
git checkout NOME_DA_BRANCH
```

1.
2.

## Tipo de mudança

- [ ] `feat` — nova funcionalidade
- [ ] `fix` — correção de erro
- [ ] `docs` — documentação
- [ ] `db` — esquema ou migração de banco
- [ ] `chore` / `refactor` / `test`

## Impacto no banco de dados

- [ ] Não mexe no banco
- [ ] Altera o esquema — migração em `db/migrations/NNNN_*.sql`, com linha de **Reversão** no cabeçalho
- [ ] Versão do esquema atualizada no cabeçalho de `db/schema.sql`: `____`

## Checklist de convenções (seções 1.2 e 3.2 do CONFIG_MANAGEMENT.md)

- [ ] Nome da branch em `tipo/descricao-curta`, minúsculas, sem acento
- [ ] Mensagens de commit em `tipo: descrição curta no imperativo`
- [ ] Arquivos adicionados pelo nome (sem `git add .`)
- [ ] Nenhuma senha, token ou caminho absoluto de máquina pessoal no código
- [ ] Arquivos gerados, `.venv/`, dumps e dados reais fora do commit
- [ ] Documentação atualizada quando o comportamento mudou


