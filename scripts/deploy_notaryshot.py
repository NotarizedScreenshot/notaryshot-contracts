from brownie import NotaryShot, accounts, interface

PUBLISH_SOURCE = True

# oracle contract address, job id without dashes
# 0x4244456D81DeFE91a00d735fA57A699FdaAd747e,766defa685f8407faeda40a3784932f5
ORACLE_CONTRACT = "0xea85b380B28FA3A95E46B6817e3CB6ae7F467F57"
JOB_ID = "5f26bf32451746158e11edb088eb3312"
POLYGON_LINK_TOKEN = "0xb0897686c545045aFc77CF20eC7A532E3120E0F1"


# export POLYGONSCAN_TOKEN=XXXXXXXXXXXXXXXXXXXXXXXXXX___FIXME
# brownie run scripts/deploy_notaryshot.py --network polygon-main
def main():
    deployer = accounts.load('polygon_deployer')

    notaryshot = NotaryShot.deploy(
        POLYGON_LINK_TOKEN,
        ORACLE_CONTRACT,
        JOB_ID,
        "TestNotaryShot",
        "TNS",
        {'from': deployer},
        publish_source=PUBLISH_SOURCE,
    )
    link = interface.IERC20(POLYGON_LINK_TOKEN)
    link.transfer(notaryshot, 10 ** 16, {'from': deployer})
