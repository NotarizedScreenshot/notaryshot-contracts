from brownie import ERC1967Proxy, NotaryShot, accounts, interface

PUBLISH_SOURCE = True

# oracle contract address, job id without dashes
# 0x4244456D81DeFE91a00d735fA57A699FdaAd747e,766defa685f8407faeda40a3784932f5
ORACLE_CONTRACT = "0xea85b380B28FA3A95E46B6817e3CB6ae7F467F57"
JOB_ID = "5f26bf32451746158e11edb088eb3312"
POLYGON_LINK_TOKEN = "0xb0897686c545045aFc77CF20eC7A532E3120E0F1"


# export POLYGONSCAN_TOKEN=XXXXXXXXXXXXXXXXXXXXXXXXXX___FIXME
# brownie run scripts/deploy_notaryshot.py --network polygon-main
def main():
    deployer = accounts.load('ethrum_deployer')

    #notaryshot_logic = NotaryShot.deploy(
    #    {'from': deployer},
    #    publish_source=PUBLISH_SOURCE,
    #)
    notaryshot_logic = NotaryShot.at("0x5B1C7b6AD1abb65338cC1d56Bb9b4f84441bc3A5")

    notaryshot_init_data = notaryshot_logic.initialize.encode_input(
        POLYGON_LINK_TOKEN,
        ORACLE_CONTRACT,
        10 ** 15,
        JOB_ID,
        "TestNotaryShot",
        "TNS",
    )

    notaryshot = ERC1967Proxy.deploy(
        notaryshot_logic,
        notaryshot_init_data,
        {'from': deployer},
        publish_source=PUBLISH_SOURCE,
    )

    link = interface.IERC20(POLYGON_LINK_TOKEN)
    link.transfer(notaryshot, 10 ** 18, {'from': deployer})
