# notaryshot-contracts
Contracts of the QuantumOracle, a.k.a. NotarizedScreenshot  project

### Polygon Addesses
[NotaryShot](https://polygonscan.com/address/0x893ed521b4ae3ed0fbc1cdc6112dcd341fae8c07#code)  
[Operator](https://polygonscan.com/address/0xea85b380B28FA3A95E46B6817e3CB6ae7F467F57)

### Setup
```shell
brownie networks add Polygon polygon-main-alchemy host=https://polygon-mainnet.g.alchemy.com/v2/XXXXXXXX_XXXXXFIXMEXXXXXX-XXXXXX chainid=137 explorer=https://api.polygonscan.com/api
```

### Deploy
```shell
brownie run ./scripts/deploy_notaryshot.py  --network=polygon-main-alchemy 
# Transaction sent: 0xa264306e32e6bf3270740b078dee39c10f6fc3609c2a15afad9d27f293eefb3c
# Gas price: 459.460608255 gwei   Gas limit: 2538902   Nonce: 95
# NotaryShot.constructor confirmed   Block: 41872324   Gas used: 2308093 (90.91%)
# NotaryShot deployed at: 0x649d6016547Ca881D276E09c1cE1011756aCa217
# Verification complete. Result: Pass - Verified
```

### Minting diagram  
[![High Level Architecture - Minting](http://www.plantuml.com/plantuml/png/VL3HJiCm37pFLvYzbo-Ofaq31DBOc3QU9wlrseZKcH8716Z_JcWowCf4NcfVxyu-JxsWaz0QTIKDjGJOwXgLQ344zxfkO46lP63coaOBbH8SGG6FcaLp3GXB6mtq1rMmAHqH-yQAKbYATJ2wvGgUFRaHe0SAIfN6XWgUh7clBSEdWlZs3bk2TK2EUwmSbeQAqhB4IdoavCUs8XYjL-1_va2BZ7Moxy6x3Fyd7KW6r7c3cXUQNs1r88TYqmYRccHyL4UbqkuTtKHwsZxbkhZmmOHQSsUMIdKy7UM1XHoJdAblbfkENB7leTitBP9ZIwf_VUQppPd5ycvxxSKwhAaJy5vskVyMKO2Yc4mkdUyl1EDnHyw7k4GPklKewHS5TP8d81yYVKuJOk01aeCEq7wQAN4LMlC5)](https://www.plantuml.com/plantuml/png/VL3HJiCm37pFLvYzbo-Ofaq31DBOc3QU9wlrseZKcH8716Z_JcWowCf4NcfVxyu-JxsWaz0QTIKDjGJOwXgLQ344zxfkO46lP63coaOBbH8SGG6FcaLp3GXB6mtq1rMmAHqH-yQAKbYATJ2wvGgUFRaHe0SAIfN6XWgUh7clBSEdWlZs3bk2TK2EUwmSbeQAqhB4IdoavCUs8XYjL-1_va2BZ7Moxy6x3Fyd7KW6r7c3cXUQNs1r88TYqmYRccHyL4UbqkuTtKHwsZxbkhZmmOHQSsUMIdKy7UM1XHoJdAblbfkENB7leTitBP9ZIwf_VUQppPd5ycvxxSKwhAaJy5vskVyMKO2Yc4mkdUyl1EDnHyw7k4GPklKewHS5TP8d81yYVKuJOk01aeCEq7wQAN4LMlC5)  
