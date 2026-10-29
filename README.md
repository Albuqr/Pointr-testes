# Pointr

Captura de dados de treino esportivo a partir de câmeras (celular e notebook).
O Pointr detecta e rastreia as pessoas em quadra, registra cada sessão e gera relatórios de cobertura e falhas.

> Versão atual: **v0.2.0** · Esquema do banco: **1.0.0**
> Plano de gerenciamento de configuração: [`CONFIG_MANAGEMENT.md`](CONFIG_MANAGEMENT.md)

## O que o Pointr faz

- **Captura** vídeo de webcam, stream (http, https, rtsp) ou arquivo `.mp4`/`.mov`, com várias câmeras ao mesmo tempo
- **Detecta e rastreia** pessoas quadro a quadro (RF-DETR Nano, ByteTrack)
- **Registra cada sessão** localmente: arquivos de sessão, execução, quadro e trilha
- **Calibra** cada câmera para a quadra (homografia) e desenha o diagrama da quadra
- **Grava e reproduz** o vídeo bruto, e pontua sessões rotuladas à mão
- **Gera relatórios** de cobertura e falhas por execução
- **Studio:** aplicativo web local para rodar e conferir sessões

Planejado, ainda não construído: API na nuvem e sincronização (fases 07 e 08).

## Estrutura do repositório

```
.
├── services/
│   ├── edge/          roda no notebook: captura, detecção, rastreio, sessões,
│   │                  calibração, gravação, replay, relatórios, pontuação
│   ├── app/           Pointr Studio: app web local (FastAPI + interface React em ui/)
│   ├── api/           API na nuvem (planejada)
│   └── sync_agent/    sincronização com o servidor (planejada)
├── scripts/           run_cameras.py: lançador de várias câmeras
├── contracts/         JSON Schemas dos arquivos salvos
├── tests/             testes pytest
├── testkit/           testes de navegador e de API
├── db/
│   ├── pointr.sql         esquema do banco (baseline, versão 1.0.0)
│   ├── seed_exemplo.sql   dados sintéticos para teste
│   ├── migrations/        mudanças futuras do esquema
│   └── README.md
├── docs/              arquitetura, requisitos, ADRs, relatórios de revisão
├── .github/pull_request_template.md
├── CONFIG_MANAGEMENT.md
└── pyproject.toml
```

As sessões são gravadas em `C:/pointr_sessions`, fora do repositório.
Gravações e imagens reais nunca são versionadas.

## Como rodar

### Studio (aplicativo web local)

```bash
python -m services.app
```

Abre na porta **8765**: <http://localhost:8765>. As dependências estão em `pyproject.toml`.
[confirmar o comando de instalação, por exemplo `pip install -e .`]

### Banco de dados

Requisito: MySQL 8.0+.

```bash
mysql -u root -p < db/pointr.sql
mysql -u root -p pointr < db/seed_exemplo.sql   # opcional: dados de exemplo
```

Detalhes e regras de migração em [`db/README.md`](db/README.md) e
[`docs/banco_de_dados.md`](docs/banco_de_dados.md).

## Como contribuir

Resumo das regras (completas em [`CONFIG_MANAGEMENT.md`](CONFIG_MANAGEMENT.md)):

- Branch por tarefa: `tipo/descricao-curta` (`feat/`, `fix/`, `docs/`, `db/`, `chore/`)
- Commits no formato `tipo: descrição curta no imperativo`, com arquivos adicionados pelo nome
- Nada vai direto para a `main`: todo merge passa por Pull Request com 1 aprovação
- Ninguém aprova o próprio PR
- Senhas, tokens, dumps e dados reais não entram no repositório

## Versões

| Tag | Marco |
|---|---|
| `v0.1.0` | estrutura inicial, documentação e protótipo do frontend |
| `v0.2.0` | correções da revisão de código (25 apontamentos), banco de dados (esquema 1.0.0) e GCS revisto |

## Equipe

| Integrante | Papel |
|---|---|
| João Albuquerque | Desenvolvedor principal |
| Alejandra Gimenez | Revisora de código |
| Vinicius Bussolin | Gestor de Configuração |
