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
