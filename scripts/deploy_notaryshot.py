from brownie import NotaryShot, accounts, interface
from pathlib import Path

PUBLISH_SOURCE = True

# oracle contract address, job id without dashes
# 0x4244456D81DeFE91a00d735fA57A699FdaAd747e,766defa685f8407faeda40a3784932f5
ORACLE_CONTRACT = "0x4244456D81DeFE91a00d735fA57A699FdaAd747e"
JOB_ID = "766defa685f8407faeda40a3784932f5"


# export POLYGONSCAN_TOKEN=XXXXXXXXXXXXXXXXXXXXXXXXXX___FIXME
# brownie run scripts/deploy_notaryshot.py --network polygon-test
def main():
    deployer = accounts.load('polygon_deployer')

    notaryshot = NotaryShot.deploy(
        ORACLE_CONTRACT,
        JOB_ID,
        {'from': deployer},
        publish_source=PUBLISH_SOURCE,
    )

    link = interface.ERC20("0xb0897686c545045aFc77CF20eC7A532E3120E0F1")
    link.transferFrom(deployer, notaryshot, 10 ** 16, {'from': deployer})

    notaryshot.submitMint("https://i.kym-cdn.com/entries/icons/original/000/018/012/this_is_fine.jpeg",
                          "0xa899e6cd5d2be4dd502fa19684cc2fdcbf1d2826bc93de4f6a9420848eaf5c29",
                          {'from': deployer},
                          )
