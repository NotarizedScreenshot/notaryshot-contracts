[![High Level Architecture - Minting](http://www.plantuml.com/plantuml/png/VL3HJiCm37pFLvYzbo-Ofaq31DBOc3QU9wlrseZKcH8716Z_JcWowCf4NcfVxyu-JxsWaz0QTIKDjGJOwXgLQ344zxfkO46lP63coaOBbH8SGG6FcaLp3GXB6mtq1rMmAHqH-yQAKbYATJ2wvGgUFRaHe0SAIfN6XWgUh7clBSEdWlZs3bk2TK2EUwmSbeQAqhB4IdoavCUs8XYjL-1_va2BZ7Moxy6x3Fyd7KW6r7c3cXUQNs1r88TYqmYRccHyL4UbqkuTtKHwsZxbkhZmmOHQSsUMIdKy7UM1XHoJdAblbfkENB7leTitBP9ZIwf_VUQppPd5ycvxxSKwhAaJy5vskVyMKO2Yc4mkdUyl1EDnHyw7k4GPklKewHS5TP8d81yYVKuJOk01aeCEq7wQAN4LMlC5)](https://www.plantuml.com/plantuml/png/VL3HJiCm37pFLvYzbo-Ofaq31DBOc3QU9wlrseZKcH8716Z_JcWowCf4NcfVxyu-JxsWaz0QTIKDjGJOwXgLQ344zxfkO46lP63coaOBbH8SGG6FcaLp3GXB6mtq1rMmAHqH-yQAKbYATJ2wvGgUFRaHe0SAIfN6XWgUh7clBSEdWlZs3bk2TK2EUwmSbeQAqhB4IdoavCUs8XYjL-1_va2BZ7Moxy6x3Fyd7KW6r7c3cXUQNs1r88TYqmYRccHyL4UbqkuTtKHwsZxbkhZmmOHQSsUMIdKy7UM1XHoJdAblbfkENB7leTitBP9ZIwf_VUQppPd5ycvxxSKwhAaJy5vskVyMKO2Yc4mkdUyl1EDnHyw7k4GPklKewHS5TP8d81yYVKuJOk01aeCEq7wQAN4LMlC5)  

```puml
@startuml
!theme amiga
title High Level Architecture - Minting a Notarized Screenshot

actor "End User" as eu

cloud Polygon {
    frame QuantumOracle-contracts{
        node "QO screenshot manager" as screenshot_manager
        node "QO screenshot" as screenshot
        node "ChainLink Operator" as operator
    }
}

frame ChainlinkOracle {
    node "QO screenshot plugin" as plugin
}

cloud Internet {
    node "DNS" as dns
    node "Twitter" as twitter
}

cloud CAS {
    node "NFT.storage" as nft_storage
}

eu -->> screenshot_manager
screenshot_manager <<-->> operator
screenshot_manager -->> screenshot
screenshot -->> eu
operator -->> plugin
plugin <<-->> dns
plugin <<-->> twitter
plugin <<-->> nft_storage
@enduml
@enduml
```
