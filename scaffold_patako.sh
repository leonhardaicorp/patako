#!/usr/bin/env bash
#
# scaffold_patako.sh
# Cria a estrutura inicial do projeto PATAKO sem sobrescrever arquivos existentes.
#
# Uso:
#   chmod +x scaffold_patako.sh
#   ./scaffold_patako.sh [diretorio-raiz]
#
# Para permitir sobrescrita dos arquivos gerados:
#   FORCE=1 ./scaffold_patako.sh [diretorio-raiz]
#
# O diretório padrão é ./patako. Se executado dentro do repositório,
# informe "." como diretório-raiz.

set -Eeuo pipefail

ROOT="${1:-./patako}"
FORCE="${FORCE:-0}"

log()  { printf '\033[1;32m[ PATAKO ]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[ AVISO ]\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31m[ ERRO ]\033[0m %s\n' "$*" >&2; exit 1; }

command -v mkdir >/dev/null 2>&1 || die "mkdir não encontrado."
command -v cat >/dev/null 2>&1 || die "cat não encontrado."

mkdir -p "$ROOT"
ROOT="$(cd "$ROOT" && pwd)"
cd "$ROOT"

create_dir() {
  mkdir -p "$1"
}

create_file() {
  local path="$1"
  local content="$2"

  mkdir -p "$(dirname "$path")"

  if [[ -e "$path" && "$FORCE" != "1" ]]; then
    warn "Mantido (já existe): $path"
    return
  fi

  printf '%s\n' "$content" > "$path"
  log "Arquivo criado: $path"
}

# ---------------------------------------------------------------------------
# Diretórios
# ---------------------------------------------------------------------------

directories=(
  "src/patako/core"
  "src/patako/financial/accounts"
  "src/patako/financial/transactions"
  "src/patako/financial/categories"
  "src/patako/financial/cashflow"
  "src/patako/debt/creditors"
  "src/patako/debt/contracts"
  "src/patako/debt/obligations"
  "src/patako/debt/negotiations"
  "src/patako/intelligence/classification"
  "src/patako/intelligence/analytics"
  "src/patako/intelligence/rag"
  "src/patako/intelligence/agents"
  "src/patako/api/routes"
  "src/patako/api/schemas"
  "docs/01-product"
  "docs/02-architecture"
  "docs/03-functional"
  "docs/04-ai"
  "docs/05-operations"
  "tests"
  "scripts"
)

for dir in "${directories[@]}"; do
  create_dir "$dir"
done
log "Estrutura de diretórios criada."

# ---------------------------------------------------------------------------
# Pacotes Python: __init__.py
# ---------------------------------------------------------------------------

python_packages=(
  "src/patako"
  "src/patako/core"
  "src/patako/financial"
  "src/patako/financial/accounts"
  "src/patako/financial/transactions"
  "src/patako/financial/categories"
  "src/patako/financial/cashflow"
  "src/patako/debt"
  "src/patako/debt/creditors"
  "src/patako/debt/contracts"
  "src/patako/debt/obligations"
  "src/patako/debt/negotiations"
  "src/patako/intelligence"
  "src/patako/intelligence/classification"
  "src/patako/intelligence/analytics"
  "src/patako/intelligence/rag"
  "src/patako/intelligence/agents"
  "src/patako/api"
  "src/patako/api/routes"
  "src/patako/api/schemas"
)

for package in "${python_packages[@]}"; do
  create_file "$package/__init__.py" '"""Pacote do projeto PATAKO."""'
done

# ---------------------------------------------------------------------------
# Código-fonte principal
# ---------------------------------------------------------------------------

create_file "src/patako/core/config.py" "$(cat <<'EOF'
"""Configurações centrais da aplicação.

As configurações específicas por ambiente devem ser carregadas de variáveis
de ambiente. Não armazene senhas, tokens ou chaves neste arquivo.
"""

import os
from dataclasses import dataclass


@dataclass(frozen=True)
class Settings:
    app_name: str = os.getenv("PATAKO_APP_NAME", "PATAKO")
    environment: str = os.getenv("PATAKO_ENV", "development")
    log_level: str = os.getenv("PATAKO_LOG_LEVEL", "INFO")


settings = Settings()
EOF
)"

create_file "src/patako/core/database.py" "$(cat <<'EOF'
"""Ponto de integração com a camada de persistência.

A implementação concreta do mecanismo de banco de dados será definida
quando o modelo de dados e a estratégia de persistência forem detalhados.
"""


def get_database():
    """Retorna o componente de acesso a dados configurado.

    TODO: implementar conexão, gerenciamento de sessão e ciclo de vida.
    """
    raise NotImplementedError("Camada de persistência ainda não configurada.")
EOF
)"

create_file "src/patako/core/security.py" "$(cat <<'EOF'
"""Funções e políticas transversais de segurança.

TODO:
- definir autenticação e autorização;
- centralizar validações de entrada;
- estabelecer política de proteção de dados e segredos.
"""


def health_check() -> bool:
    """Verificação inicial da disponibilidade do módulo de segurança."""
    return True
EOF
)"

create_file "src/patako/main.py" "$(cat <<'EOF'
"""Ponto de entrada da aplicação PATAKO."""


def main() -> None:
    print("PATAKO - estrutura inicial preparada.")


if __name__ == "__main__":
    main()
EOF
)"

# ---------------------------------------------------------------------------
# Documentação do produto
# ---------------------------------------------------------------------------

create_file "docs/01-product/vision.md" "$(cat <<'EOF'
# Visão do Produto — PATAKO

## Propósito
Descrever o problema que o PATAKO pretende resolver, seus usuários e o valor
entregue pelo produto.

## Problema
TODO: detalhar as necessidades relacionadas à organização financeira,
ao acompanhamento de dívidas e ao apoio à tomada de decisão.

## Público-alvo
TODO: identificar personas, necessidades e contexto de uso.

## Proposta de valor
TODO: registrar os diferenciais e resultados esperados.

## Princípios do produto
- Clareza e transparência.
- Segurança e privacidade desde a concepção.
- Decisões explicáveis e centradas no usuário.
EOF
)"

create_file "docs/01-product/business-requirements.md" "$(cat <<'EOF'
# Requisitos de Negócio

## Objetivos
TODO: documentar objetivos de negócio mensuráveis.

## Stakeholders
TODO: identificar partes interessadas e responsabilidades.

## Requisitos funcionais
TODO: enumerar requisitos com identificadores (RF-001, RF-002...).

## Requisitos não funcionais
TODO: segurança, privacidade, desempenho, disponibilidade,
acessibilidade, auditoria e manutenibilidade.

## Restrições e premissas
TODO: registrar premissas, dependências e limites do projeto.

## Critérios de aceite
TODO: definir critérios verificáveis para cada requisito.
EOF
)"

create_file "docs/01-product/roadmap.md" "$(cat <<'EOF'
# Roadmap do Produto

## Fase 1 — Fundação
- Estrutura do repositório e ambiente de desenvolvimento.
- Modelo conceitual e requisitos prioritários.

## Fase 2 — Gestão financeira
- Contas, transações, categorias e fluxo de caixa.

## Fase 3 — Gestão de dívidas
- Credores, contratos, obrigações e negociações.

## Fase 4 — Inteligência
- Classificação, analytics, RAG e agentes.

## Fase 5 — Operação e evolução
- API, segurança, observabilidade, testes e implantação.

> Ajustar prioridades, escopo e marcos após validação dos requisitos.
EOF
)"

# ---------------------------------------------------------------------------
# Arquitetura
# ---------------------------------------------------------------------------

create_file "docs/02-architecture/architecture-overview.md" "$(cat <<'EOF'
# Visão Geral da Arquitetura

## Contexto
O PATAKO está organizado em domínios: financeiro, dívidas e inteligência,
com componentes centrais e uma camada de API.

## Componentes
- `core`: configuração, persistência e segurança.
- `financial`: contas, transações, categorias e fluxo de caixa.
- `debt`: credores, contratos, obrigações e negociações.
- `intelligence`: classificação, analytics, RAG e agentes.
- `api`: rotas e schemas de interface.

## Fluxos
TODO: incluir diagramas de contexto, componentes e fluxos principais.

## Requisitos arquiteturais
TODO: registrar escalabilidade, segurança, observabilidade e integração.
EOF
)"

create_file "docs/02-architecture/architecture-decisions.md" "$(cat <<'EOF'
# Registro de Decisões Arquiteturais (ADR)

Registre cada decisão relevante neste formato:

## ADR-000 — Modelo
- **Status:** Proposto
- **Contexto:** problema ou necessidade que motivou a decisão.
- **Decisão:** alternativa escolhida.
- **Consequências:** impactos positivos, negativos e trade-offs.
- **Data:** AAAA-MM-DD

TODO: adicionar decisões sobre framework, persistência, API, autenticação,
provedores de IA, estratégia RAG e implantação.
EOF
)"

create_file "docs/02-architecture/data-model.md" "$(cat <<'EOF'
# Modelo de Dados

## Domínio financeiro
TODO: definir entidades de contas, transações, categorias e fluxo de caixa.

## Domínio de dívidas
TODO: definir credores, contratos, obrigações e negociações.

## Relacionamentos e integridade
TODO: documentar cardinalidades, chaves, restrições e regras de negócio.

## Auditoria e histórico
TODO: definir rastreabilidade de alterações e eventos relevantes.

## Privacidade
TODO: classificar dados e definir retenção, acesso e proteção.
EOF
)"

create_file "docs/02-architecture/integrations.md" "$(cat <<'EOF'
# Integrações

## Integrações previstas
TODO: listar serviços externos, provedores de IA e fontes de dados.

## Contratos de integração
Para cada integração, documentar:
- finalidade e responsável;
- autenticação e gestão de segredos;
- formato de entrada e saída;
- limites, erros e retentativas;
- tratamento de dados pessoais;
- monitoramento e contingência.
EOF
)"

# ---------------------------------------------------------------------------
# Documentação funcional
# ---------------------------------------------------------------------------

create_file "docs/03-functional/financial-management.md" "$(cat <<'EOF'
# Gestão Financeira

## Contas
TODO: cadastro, tipos, saldos e situação.

## Transações
TODO: receitas, despesas, transferências, recorrência e conciliação.

## Categorias
TODO: hierarquia, classificação e regras de categorização.

## Fluxo de caixa
TODO: visão histórica, projeções e filtros.

## Regras e validações
TODO: documentar regras de negócio e critérios de aceite.
EOF
)"

create_file "docs/03-functional/debt-management.md" "$(cat <<'EOF'
# Gestão de Dívidas

## Credores
TODO: cadastro e identificação de credores.

## Contratos
TODO: condições, datas, taxas, documentos e histórico.

## Obrigações
TODO: parcelas, vencimentos, valores e status.

## Negociações
TODO: propostas, acordos, simulações e acompanhamento.

## Auditoria
TODO: histórico de alterações e origem das informações.
EOF
)"

create_file "docs/03-functional/recovery-strategy.md" "$(cat <<'EOF'
# Estratégia de Recuperação Financeira

## Objetivo
Apoiar a organização e a avaliação de alternativas de reorganização financeira.

## Diagnóstico
TODO: definir indicadores e informações necessárias.

## Cenários
TODO: documentar simulações e premissas, sem prometer resultados.

## Plano de acompanhamento
TODO: definir metas, marcos e indicadores de evolução.

## Limites e transparência
As análises devem explicitar premissas, incertezas e limitações.
O sistema não substitui orientação profissional individualizada.
EOF
)"

# ---------------------------------------------------------------------------
# Documentação de IA
# ---------------------------------------------------------------------------

create_file "docs/04-ai/ai-strategy.md" "$(cat <<'EOF'
# Estratégia de Inteligência Artificial

## Casos de uso
TODO: priorizar casos de uso por valor, risco e viabilidade.

## Abordagem
TODO: definir quando usar regras determinísticas, ML, LLMs ou agentes.

## Governança
TODO: documentar privacidade, segurança, avaliação, supervisão humana
e prevenção de respostas incorretas.

## Métricas
TODO: definir métricas de qualidade, custo, latência e utilidade.
EOF
)"

create_file "docs/04-ai/agents-architecture.md" "$(cat <<'EOF'
# Arquitetura de Agentes

## Responsabilidades
TODO: definir agentes, limites e responsabilidades.

## Ferramentas
TODO: especificar ferramentas permitidas, contratos e validações.

## Orquestração
TODO: documentar fluxo, estado, memória e tratamento de falhas.

## Supervisão
Ações relevantes devem ter validação e autorização apropriadas.

## Avaliação
TODO: criar cenários de teste, métricas e critérios de segurança.
EOF
)"

create_file "docs/04-ai/rag-architecture.md" "$(cat <<'EOF'
# Arquitetura RAG

## Fontes documentais
TODO: identificar fontes autorizadas e seus formatos.

## Ingestão e preparação
TODO: documentar extração, limpeza, chunking e metadados.

## Embeddings e índice
TODO: registrar modelo, armazenamento e estratégia de atualização.

## Recuperação e geração
TODO: definir busca, reranking, citações e tratamento de ausência de evidência.

## Avaliação e segurança
TODO: testar relevância, fidelidade, vazamento de dados e controle de acesso.
EOF
)"

# ---------------------------------------------------------------------------
# Operação
# ---------------------------------------------------------------------------

create_file "docs/05-operations/development-environment.md" "$(cat <<'EOF'
# Ambiente de Desenvolvimento

## Pré-requisitos
TODO: registrar versões suportadas de Python, sistema operacional,
gerenciador de pacotes, banco de dados e ferramentas auxiliares.

## Preparação
TODO: documentar criação do ambiente virtual e instalação de dependências.

## Variáveis de ambiente
Manter segredos fora do repositório. Usar arquivo de exemplo sem credenciais.

## Execução e testes
TODO: documentar comandos para executar a aplicação e a suíte de testes.
EOF
)"

create_file "docs/05-operations/installation.md" "$(cat <<'EOF'
# Instalação

## Clonar o repositório
```bash
git clone <URL_DO_REPOSITORIO>
cd patako
```

## Ambiente Python
```bash
python3 -m venv .venv
source .venv/bin/activate
```

## Dependências
TODO: definir o gerenciador e o arquivo oficial de dependências.

## Configuração
TODO: documentar variáveis de ambiente e configuração da persistência.

## Inicialização
TODO: registrar o comando oficial de execução.
EOF
)"

create_file "docs/05-operations/security.md" "$(cat <<'EOF'
# Segurança

## Princípios
- Menor privilégio.
- Segredos fora do controle de versão.
- Validação de entradas.
- Proteção de dados em trânsito e em repouso.
- Logs sem credenciais ou dados sensíveis desnecessários.

## Controles
TODO: autenticação, autorização, gestão de segredos, auditoria e backups.

## Dados pessoais
TODO: documentar classificação, finalidade, retenção, acesso e atendimento
aos requisitos legais aplicáveis.

## Resposta a incidentes
TODO: definir responsáveis, comunicação e procedimentos.
EOF
)"

# ---------------------------------------------------------------------------
# Arquivos de apoio
# ---------------------------------------------------------------------------

create_file ".gitignore" "$(cat <<'EOF'
# Python
__pycache__/
*.py[cod]
*.egg-info/
.pytest_cache/
.mypy_cache/
.ruff_cache/
.coverage
htmlcov/

# Ambientes virtuais
.venv/
venv/
ENV/

# Segredos e configurações locais
.env
.env.*
!.env.example

# IDE e sistema operacional
.vscode/
.idea/
.DS_Store
Thumbs.db

# Logs e saídas locais
*.log
logs/
output/
dist/
build/
EOF
)"

create_file ".env.example" "$(cat <<'EOF'
PATAKO_APP_NAME=PATAKO
PATAKO_ENV=development
PATAKO_LOG_LEVEL=INFO

# Preencher somente no ambiente local; nunca versionar credenciais reais.
# DATABASE_URL=
# LLM_API_KEY=
EOF
)"

create_file "requirements.txt" "$(cat <<'EOF'
# Dependências iniciais mínimas.
# Adicione bibliotecas conforme as decisões de arquitetura forem tomadas.
EOF
)"

create_file "pyproject.toml" "$(cat <<'EOF'
[build-system]
requires = ["setuptools>=68"]
build-backend = "setuptools.build_meta"

[project]
name = "patako"
version = "0.1.0"
description = "Plataforma de organização financeira e inteligência para gestão de dívidas."
readme = "README.md"
requires-python = ">=3.10"
dependencies = []

[project.optional-dependencies]
dev = [
  "pytest>=8.0",
  "ruff>=0.5",
]

[tool.setuptools.packages.find]
where = ["src"]

[tool.pytest.ini_options]
pythonpath = ["src"]
testpaths = ["tests"]

[tool.ruff]
line-length = 100
target-version = "py310"
EOF
)"

create_file "tests/test_smoke.py" "$(cat <<'EOF'
from patako.core.security import health_check


def test_security_health_check():
    assert health_check() is True
EOF
)"

create_file "README.md" "$(cat <<'EOF'
# PATAKO

Projeto em desenvolvimento.

## Estrutura
- `src/patako/core`: configuração, persistência e segurança.
- `src/patako/financial`: funcionalidades de gestão financeira.
- `src/patako/debt`: funcionalidades de gestão de dívidas.
- `src/patako/intelligence`: classificação, analytics, RAG e agentes.
- `src/patako/api`: interfaces e contratos da API.
- `docs`: documentação de produto, arquitetura, funcionalidades, IA e operação.

## Próximos passos
Consulte `docs/01-product/roadmap.md` e os documentos de arquitetura.
EOF
)"

log "Scaffold do PATAKO concluído em: $ROOT"
log "Arquivos existentes foram preservados (use FORCE=1 para sobrescrever)."
log "Próximo passo: revisar README.md e os documentos em docs/."
