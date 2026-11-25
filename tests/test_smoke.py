from patako.core.security import health_check


def test_security_health_check():
    assert health_check() is True
