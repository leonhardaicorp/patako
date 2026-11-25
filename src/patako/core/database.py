"""Ponto de integração com a camada de persistência.

A implementação concreta do mecanismo de banco de dados será definida
quando o modelo de dados e a estratégia de persistência forem detalhados.
"""


def get_database():
    """Retorna o componente de acesso a dados configurado.

    TODO: implementar conexão, gerenciamento de sessão e ciclo de vida.
    """
    raise NotImplementedError("Camada de persistência ainda não configurada.")
