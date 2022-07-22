from brownie import NotaryShot, accounts, interface

PUBLISH_SOURCE = True

# oracle contract address, job id without dashes
# 0x4244456D81DeFE91a00d735fA57A699FdaAd747e,766defa685f8407faeda40a3784932f5
ORACLE_CONTRACT = "0x1B03eF834D2BC94598220de249486D5825642025"
JOB_ID = "3d2ecac9cdab47ba8ddb6e1b1a2dc210"


# export POLYGONSCAN_TOKEN=XXXXXXXXXXXXXXXXXXXXXXXXXX___FIXME
# brownie run scripts/deploy_notaryshot.py --network polygon-main
def main():
    deployer = accounts.load('polygon_deployer')

    notaryshot = NotaryShot.deploy(
        ORACLE_CONTRACT,
        JOB_ID,
        {'from': deployer},
        publish_source=PUBLISH_SOURCE,
    )
