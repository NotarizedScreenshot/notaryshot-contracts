from brownie import QuantumOracleOperator, accounts

PUBLISH_SOURCE = True
LINK = "0xb0897686c545045aFc77CF20eC7A532E3120E0F1"
NODE = "0x216dB844024Dc1C8ef07d47f8E1D516bb79dE277"


# export POLYGONSCAN_TOKEN=XXXXXXXXXXXXXXXXXXXXXXXXXX___FIXME
# brownie run scripts/deploy_quantum_oracle_operator.py --network polygon-main
def main():
    deployer = accounts.load('hackfs_2022')

    operator = QuantumOracleOperator.deploy(
        LINK,
        {'from': deployer},
        publish_source=PUBLISH_SOURCE,
    )
    operator.setAuthorizedSenders([NODE], {'from': deployer})
