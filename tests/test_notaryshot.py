import pytest, brownie

ORACLE_CONTRACT = "0x4244456D81DeFE91a00d735fA57A699FdaAd747e"
JOB_ID     = "766defa685f8407faeda40a3784932f5"
LINK_TOKEN = "0xb0897686c545045aFc77CF20eC7A532E3120E0F1"

NEW_ORACLE_CONTRACT = "0x6661488C6E1D3DcC6dD4b9fB9E5e1dDc9E5EeB4b"
NEW_JOB_ID = "12345678901234567890123456789012"

@pytest.fixture(scope='module')
def minter(accounts):
    return accounts[9]


@pytest.fixture
def notaryshot(NotaryShot, dev):
    ns = NotaryShot.deploy(
        {'from': dev}
    )
    ns.initialize(
        LINK_TOKEN,
        ORACLE_CONTRACT,
        JOB_ID,
        "TestNotaryShot",
        "NS",
        {'from': dev}
    )
    return ns


def test_symbol(notaryshot, dev):
    assert notaryshot.symbol() == "NS"
    assert notaryshot.owner() == dev


def test_change_adminable_params(notaryshot, dev):
    assert notaryshot.oracleFee() == 10 ** 15
    notaryshot.setOracleFee(100, {'from': dev})
    assert notaryshot.oracleFee() == 100

    assert notaryshot.oracle() == ORACLE_CONTRACT
    notaryshot.setOracle(NEW_ORACLE_CONTRACT, {'from': dev})
    assert notaryshot.oracle() == NEW_ORACLE_CONTRACT

    assert notaryshot.jobId() == "0x3736366465666136383566383430376661656461343061333738343933326635"
    notaryshot.setJobId(NEW_JOB_ID, {'from': dev})
    assert notaryshot.jobId() == "0x3132333435363738393031323334353637383930313233343536373839303132" 


def test_change_owner(notaryshot, dev, accounts):
    assert notaryshot.owner() == dev
    notaryshot.transferOwnership(accounts[1], {'from': dev})
    assert notaryshot.owner() == accounts[1]

