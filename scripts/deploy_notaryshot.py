from brownie import NotaryShot, accounts, interface

PUBLISH_SOURCE = True

# oracle contract address, job id without dashes
# 0x4244456D81DeFE91a00d735fA57A699FdaAd747e,766defa685f8407faeda40a3784932f5
ORACLE_CONTRACT = "0x4244456D81DeFE91a00d735fA57A699FdaAd747e"
JOB_ID = "f1b0d529d91a49bc92c1b937a4b6f641"


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
