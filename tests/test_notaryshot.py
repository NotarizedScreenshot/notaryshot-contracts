import pytest, brownie

ORACLE_CONTRACT = "0x4244456D81DeFE91a00d735fA57A699FdaAd747e"
JOB_ID = "766defa685f8407faeda40a3784932f5"
LINK_TOKEN = "0xb0897686c545045aFc77CF20eC7A532E3120E0F1"


@pytest.fixture(scope='module')
def minter(accounts):
    return accounts[9]


@pytest.fixture
def notaryshot(NotaryShot, dev):
    return NotaryShot.deploy(
        LINK_TOKEN,
        ORACLE_CONTRACT,
        JOB_ID,
        "TestNotaryShot",
        "NS",
        {'from': dev}
    )


def test_symbol(notaryshot):
    assert notaryshot.symbol() == "NS"
