from brownie import NotaryShot, accounts, interface

PUBLISH_SOURCE = True
PROXY_ADDRESS = '0xXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX__FIXME'

# export POLYGONSCAN_TOKEN=XXXXXXXXXXXXXXXXXXXXXXXXXX___FIXME
# brownie run scripts/deploy_notaryshot.py --network polygon-main
def main():
    deployer = accounts.load('polygon_deployer')

    notaryshot_new_logic = NotaryShot.deploy(
        {'from': deployer},
        publish_source=PUBLISH_SOURCE,
    )

    notaryshot_proxy = interface.IUpgradeable(PROXY_ADDRESS)
    notaryshot_proxy.upgradeTo(notaryshot_new_logic, {'from': deployer})
