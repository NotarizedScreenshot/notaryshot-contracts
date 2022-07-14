import pytest, brownie


@pytest.fixture(scope='module')
def minter(accounts):
    return accounts[9]


@pytest.fixture
def notaryshot(NotaryShot, dev):
    return dev.deploy(NotaryShot)


def test_symbol(notaryshot):
    assert notaryshot.symbol() == "NS"
