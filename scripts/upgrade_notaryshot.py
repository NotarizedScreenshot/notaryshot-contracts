from brownie import NotaryShot, accounts, interface

PUBLISH_SOURCE = True
PROXY_ADDRESS = '0xb95355174E434Cc7503F4F08B096EDf390007868'

DEPLOYER_ADDRESS = '0xXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX___FIXME'


# export POLYGONSCAN_TOKEN=XXXXXXXXXXXXXXXXXXXXXXXXXX___FIXME
# brownie run scripts/deploy_notaryshot.py --network polygon-main
def main():
    # deployer = accounts.load('polygon_deployer')
    accounts.connect_to_clef()
    deployer = [a for a in accounts if a.address == DEPLOYER_ADDRESS][0]

    notaryshot_new_logic = NotaryShot.deploy(
        {'from': deployer},
        publish_source=PUBLISH_SOURCE,
    )

    notaryshot_proxy = interface.IUpgradeable(PROXY_ADDRESS)
    notaryshot_proxy.upgradeTo(notaryshot_new_logic, {'from': deployer})
