from brownie import NotaryShot, accounts
from pathlib import Path

PUBLISH_SOURCE = True


# export POLYGONSCAN_TOKEN=XXXXXXXXXXXXXXXXXXXXXXXXXX___FIXME
# brownie run scripts/deploy_notaryshot.py --network polygon-test
def main():
    deployer = accounts.load('polygon_deployer')

    notaryshot = NotaryShot.deploy({'from': deployer},
                                   publish_source=PUBLISH_SOURCE,
                                   )

    notaryshot.mint("https://i.kym-cdn.com/entries/icons/original/000/018/012/this_is_fine.jpeg",
                    "0xa899e6cd5d2be4dd502fa19684cc2fdcbf1d2826bc93de4f6a9420848eaf5c29",
                    "0xa899e6cd5d2be4dd502fa19684cc2fdcbf1d2826bc93de4f6a9420848eaf5c29",
                    )
